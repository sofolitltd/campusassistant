# Chat — WhatsApp-like architecture

## Goal

Make the chat feel instant: open any conversation and see messages immediately, no spinner. All messaging operations (send, edit, delete, reply) work offline-first, synced in the background.

---

## Current architecture (simplified)

```
User opens chat
    → HTTP GET /conversations/:id/messages (network wait, spinner)
    → store in ConversationMessagesState (in-memory List)
    → render

User sends message
    → optimistic add to in-memory List
    → HTTP POST /conversations/:id/messages
    → replace temp ID with server ID

WebSocket event arrives
    → update in-memory List
```

**Problems:**
- Every chat open = network request + spinner
- State lost when widget is disposed
- No offline support
- Messages can disappear on dispose/reopen

---

## Target architecture

```
┌─────────────────────────────────────┐
│             UI (Riverpod)           │
│  ConversationMessagesState          │
│  (reactive, reads from DB + WS)     │
└──────────┬──────────────────────────┘
           │ reads / writes
┌──────────▼──────────────────────────┐
│        Local Database (drift)       │
│  ┌──────────┐  ┌──────────────────┐ │
│  │conversatns│  │   messages       │ │
│  │  table    │  │   table          │ │
│  ├──────────┤  ├──────────────────┤ │
│  │id        │  │id                │ │
│  │lastMsg   │  │conversationId    │ │
│  │lastTime  │  │senderId          │ │
│  │lastSender│  │text              │ │
│  │unreadCnt │  │timestamp         │ │
│  │status    │  │read              │ │
│  │...       │  │repliedToId       │ │
│  └──────────┘  │messageStatus     │ │
│                │createdAt         │ │
│                │updatedAt         │ │
│                └──────────────────┘ │
└──────────┬──────────────────────────┘
           │ background sync
┌──────────▼──────────────────────────┐
│       Network Layer                 │
│  ┌────────────┐  ┌───────────────┐  │
│  │ HTTP REST  │  │  WebSocket    │  │
│  │ (backfill, │  │  (real-time)  │  │
│  │  send)     │  │              │  │
│  └────────────┘  └───────────────┘  │
└─────────────────────────────────────┘
```

### Data flow

**Opening a chat:**
1. Read messages from local SQLite (instant)
2. Render immediately
3. Fire background HTTP fetch for any newer messages
4. Merge into SQLite → UI auto-updates via Riverpod

**Sending a message:**
1. Insert into SQLite with `status = sending`
2. UI shows it instantly
3. HTTP POST to server
4. On success → update status to `sent`, replace temp ID
5. On failure → keep in DB as `failed`, show retry

**Receiving a message (WebSocket):**
1. Insert into SQLite
2. UI auto-updates via reactive query
3. Update conversation `lastMessage` in local DB
4. No HTTP needed

---

## Tech choices

| Layer | Choice | Why |
|---|---|---|
| Local DB | `sqflite` | No codegen, works with Dart 3.12 |
| State | Riverpod `Notifier` + manual refresh | Simple, predictable |
| Offline queue | `outgoing_messages` table in sqflite | Survive app restarts |
| Image cache | `cached_network_image` | Already in project |

---

## Phased implementation

### ✅ Phase 1 — Local cache (sqflite)

`lib/core/database/app_database.dart` with `conversations` and `messages` tables.  
Providers read from local DB first (instant), then background-sync from network.  
All mutations (send/edit/delete) write to DB.  
WS events written directly to DB.

**Files:** `app_database.dart`, `chat_providers.dart`, `inbox_page.dart`, `chat_page.dart`

### ✅ Phase 2 — Outgoing message queue

`outgoing_messages` table in sqflite + `MessageQueueService`.  
Messages are enqueued with status `pending`, attempted immediately.  
On network failure, status becomes `failed` — shown with a red retry icon.  
Tapping retry re-sends via `attemptSend`.  
`retryAll()` flushes the queue on inbox load.

**Files:** `message_queue_service.dart`, `message_bubble.dart`, `chat_page.dart`, `inbox_page.dart`

### ✅ Phase 3 — Message status flow

Backend: Added `delivered` → `message_delivered` relay in WebSocket readPump.  
Frontend: Sends `delivered` ack on receiving `new_message` from others.  
Handles `message_delivered` event → updates message status to `delivered` in DB + UI.  
`mark_read` handler now persists `read: true` to DB (via `updateMessage`).  
Status chain: `sending` (spinner) → `sent` (single ✓) → `delivered` (grey ✓✓) → `read` (teal ✓✓).

**Files:** `chat_ws.go`, `chat_websocket.dart`, `chat_page.dart`, `message_queue_service.dart`

### Phase 4 — Polish

- Background sync on app resume
- Typing indicator persists across navigations
- Scroll position restoration
- Local search of messages
- Batch delete from local DB

---

## Schema (sqflite)

```sql
CREATE TABLE conversations (
  id TEXT PRIMARY KEY,
  last_message TEXT NOT NULL DEFAULT '',
  last_message_time TEXT,
  last_message_sender TEXT,
  unread_count INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'accepted',
  initiator_id TEXT,
  participant_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  sender_id TEXT NOT NULL,
  text TEXT NOT NULL,
  timestamp TEXT NOT NULL,
  read INTEGER NOT NULL DEFAULT 0,
  replied_to_id TEXT,
  replied_to_text TEXT,
  message_status TEXT NOT NULL DEFAULT 'sent',
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  sender_name TEXT
);
CREATE INDEX idx_messages_conv ON messages(conversation_id, created_at DESC);

CREATE TABLE outgoing_messages (
  temp_id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  sender_id TEXT NOT NULL,
  text TEXT NOT NULL,
  replied_to_id TEXT,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL
);
```

---

## Migration strategy

Steps are small and independently deployable. After each phase, the app works — just gets progressively better.

1. ✅ Phase 1: opens instantly from local cache, background sync + WS keep it fresh
2. ✅ Phase 2: messages never lost — queued in SQLite even offline, retry on reconnect
3. ✅ Phase 3: full message lifecycle visible (sending → sent → delivered → read)
4. ⬜ Phase 4: production polish (Background sync on app resume, typing indicator persists across navigations, scroll position restoration, local search, batch delete)

No backend schema changes needed at any phase.
