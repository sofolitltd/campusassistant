# Plan: System-Triggered Notifications

## Overview

Currently notifications are only created manually via the admin panel (`POST /notifications`). This doc plans the
architecture for **automatic** notifications triggered by system events (study material approval, routine update,
batch notice, etc.).

## Architecture

### Event Bus Pattern (In-Memory, No Queue)

Add a lightweight in-process event bus. No external message queue; events fire synchronously in the request
goroutine. This keeps deployment simple (single binary) while enabling future extraction to a queue.

### Components

1. **Domain Events** — a `DomainEvent` interface + typed event structs
2. **Event Bus** — publisher/subscriber registry in `pkg/eventbus/`
3. **Notification Listener** — subscribes to relevant events, calls `notificationUsecase.Create`
4. **Trigger Points** — existing handler/usecase code calls `bus.Publish(event)` at the right moment

## Domain Events

New file: `internal/domain/event.go`

```go
package domain

import "time"

type DomainEvent interface {
    EventName() string
    OccurredAt() time.Time
}

// ResourceApproved — fired when an admin approves a study material upload
type ResourceApproved struct {
    ResourceID   string    `json:"resource_id"`
    ResourceName string    `json:"resource_name"`
    UploaderID   string    `json:"uploader_id"`
    BatchID      string    `json:"batch_id"`
    DeptID       string    `json:"department_id"`
    Timestamp    time.Time `json:"timestamp"`
}

func (e ResourceApproved) EventName() string { return "resource.approved" }
func (e ResourceApproved) OccurredAt() time.Time { return e.Timestamp }

// ResourceRejected — fired when an admin rejects a study material upload
type ResourceRejected struct {
    ResourceID   string    `json:"resource_id"`
    ResourceName string    `json:"resource_name"`
    UploaderID   string    `json:"uploader_id"`
    Reason       string    `json:"reason"`
    Timestamp    time.Time `json:"timestamp"`
}

func (e ResourceRejected) EventName() string { return "resource.rejected" }
func (e ResourceRejected) OccurredAt() time.Time { return e.Timestamp }

// RoutinePublished — fired when a routine is published/updated for a batch
type RoutinePublished struct {
    BatchID    string    `json:"batch_id"`
    DeptID     string    `json:"department_id"`
    Semester   string    `json:"semester"`
    Timestamp  time.Time `json:"timestamp"`
}

func (e RoutinePublished) EventName() string { return "routine.published" }

// BatchNoticeCreated — fired when an admin creates a batch-level notice
type BatchNoticeCreated struct {
    NoticeID  string    `json:"notice_id"`
    BatchID   string    `json:"batch_id"`
    DeptID    string    `json:"department_id"`
    Title     string    `json:"title"`
    Timestamp time.Time `json:"timestamp"`
}

func (e BatchNoticeCreated) EventName() string { return "notice.created" }
```

## Event Bus

New directory: `internal/pkg/eventbus/`

```go
package eventbus

import (
    "sync"
    "campuscampusassistant-api/internal/domain"
)

type Handler func(event domain.DomainEvent)

type Bus struct {
    mu       sync.RWMutex
    handlers map[string][]Handler
}

var global = &Bus{handlers: make(map[string][]Handler)}

func Publish(event domain.DomainEvent) {
    global.mu.RLock()
    handlers := global.handlers[event.EventName()]
    global.mu.RUnlock()
    for _, h := range handlers {
        h(event)
    }
}

func Subscribe(eventName string, handler Handler) {
    global.mu.Lock()
    defer global.mu.Unlock()
    global.handlers[eventName] = append(global.handlers[eventName], handler)
}

func SubscribeAll(handler Handler) {
    Subscribe("resource.approved", handler)
    Subscribe("resource.rejected", handler)
    Subscribe("routine.published", handler)
    Subscribe("notice.created", handler)
}
```

## Notification Listener

In `internal/delivery/http/handler/notification_handler.go` (or a new file), add an `InitTriggerListeners`
function that subscribes to events and creates notifications:

```go
func InitTriggerListeners(notifUC domain.NotificationUsecase) {
    bus.SubscribeAll(func(event domain.DomainEvent) {
        switch e := event.(type) {
        case domain.ResourceApproved:
            notifUC.Create(ctx, domain.CreateNotificationInput{
                UserID:   uuid.MustParse(e.UploaderID),
                Title:    "Study Material Approved",
                Body:     fmt.Sprintf(`"%s" has been approved and is now available.`, e.ResourceName),
                Type:     "STUDY_MATERIAL",
                Data:     map[string]any{"resource_id": e.ResourceID, "batch_id": e.BatchID},
            })
        case domain.ResourceRejected:
            notifUC.Create(ctx, domain.CreateNotificationInput{
                UserID:   uuid.MustParse(e.UploaderID),
                Title:    "Study Material Rejected",
                Body:     fmt.Sprintf(`"%s" was rejected. Reason: %s`, e.ResourceName, e.Reason),
                Type:     "STUDY_MATERIAL",
            })
        case domain.RoutinePublished:
            // broadcast to all students in the batch
            batchUsers := userUC.GetByBatch(ctx, uuid.MustParse(e.BatchID))
            for _, u := range batchUsers {
                notifUC.Create(ctx, domain.CreateNotificationInput{
                    UserID: u.ID,
                    Title:  "Routine Updated",
                    Body:   fmt.Sprintf("New routine published for semester %s", e.Semester),
                    Type:   "ROUTINE_UPDATE",
                })
            }
        case domain.BatchNoticeCreated:
            batchUsers := userUC.GetByBatch(ctx, uuid.MustParse(e.BatchID))
            for _, u := range batchUsers {
                notifUC.Create(ctx, domain.CreateNotificationInput{
                    UserID: u.ID,
                    Title:  "New Notice",
                    Body:   e.Title,
                    Type:   "NOTICE",
                    Data:   map[string]any{"notice_id": e.NoticeID},
                })
            }
        }
    })
}
```

## Trigger Points — Changes Required in Existing Handlers

| File | Location | Change |
|---|---|---|
| `resource_handler.go` | `ApproveResource` handler (~108) | After successful approval, `bus.Publish(domain.ResourceApproved{...})` |
| `resource_handler.go` | `RejectResource` handler (~154) | After successful rejection, `bus.Publish(domain.ResourceRejected{...})` |
| `resource_handler.go` or `resource_usecase.go` | After resource creation/update | Publish `ResourceApproved` only if auto-approved (no moderation pipeline currently; resources are approved manually) |
| `routine_handler.go` (generic) | After Create/Update | Publish `RoutinePublished` after successful routine save |
| `notice_handler.go` (generic) | After Create | Publish `BatchNoticeCreated` after notice creation |

> **Note:** Current codebase uses `GenericHandler[T]` for Routines and Notices (among others). There is no
> specialized hook for these. Two approaches:
> 1. Replace generic handler with a specialized one that publishes events.
> 2. Add GORM `AfterCreate` hooks on domain models (quick but mixes concerns).
>
> **Recommended:** Specialize `RoutineHandler` and `NoticeHandler` for now (override Create in a new file),
> since the generic handler already has the necessary repository reference.

## Sequences — Resource Approval Flow

```
Admin POST /resources/:id/approve
  → resourceHandler.ApproveResource()
    → repo.Update() (sets is_approved = true)
    → bus.Publish(ResourceApproved{...})           ← NEW
      → listener creates notification for uploader
    → response 200
```

## Flutter Client Changes

The Flutter client already fetches notifications via `GET /notifications` and displays them. No client-side
changes needed for the trigger mechanism. If real-time delivery is desired later:

1. Add WebSocket event for new notifications (`notification.new`)
2. Listen in the chat WebSocket connection (or a dedicated notification WebSocket)
3. Update the provider on receiving the event

## Future Enhancements

| Phase | Feature | Notes |
|---|---|---|
| 1 | In-memory event bus (this plan) | Implements immediately |
| 2 | Push notifications via FCM | Use existing `fcm_token` on `User` model; send push on event |
| 3 | Async event processing | Extract event bus to background goroutine with retry |
| 4 | Dedicated notification WebSocket | Replace polling with push delivery |
| 5 | Kafka/RabbitMQ | Only if multi-instance deployment requires it |

## Milestones

1. Create `internal/domain/event.go` with event types
2. Create `internal/pkg/eventbus/bus.go`
3. Add `InitTriggerListeners()` in notification handler
4. Update `resource_handler.go` to publish `ResourceApproved` / `ResourceRejected`
5. Create specialized `routine_handler.go` / `notice_handler.go` (or add GORM hooks)
6. Register `InitTriggerListeners` in `main.go`
7. Test with manual resource approval via admin panel
