# Notification Demo Data Reference

> Extracted from `lib/features/notification/data/repositories/notification_repository_impl.dart`  
> Use this as reference when building the real API-backed repository.

---

## Model Structure

```dart
class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime timestamp;
  final String? actionRoute;
  final Map<String, String>? actionParams;
}
```

---

## NotificationType Enum

| Value | Label | Color (from tile) |
|-------|-------|-------------------|
| `routineUpdate` | Routine Update | `#6C7BFF` |
| `studyMaterial` | Study Material | `#22C55E` |
| `communityPost` | Community | `#3B82F6` |
| `communityReply` | Reply | `#8B5CF6` |
| `subscription` | Subscription | `#F59E0B` |
| `emergency` | Emergency | `#EF4444` |
| `bloodRequest` | Blood Request | `#E11D48` |
| `alumni` | Alumni | `#14B8A6` |
| `notice` | Notice | `#F97316` |
| `achievement` | Achievement | `#FACC15` |
| `club` | Club | `#EC4899` |

---

## Demo Entries

All timestamps are relative to `DateTime.now()` at the time of seeding.

### 1 — Routine Updated for Tomorrow
| Field | Value |
|-------|-------|
| id | `1` |
| type | `routineUpdate` |
| isRead | `false` |
| timestamp | `now - 25 minutes` |
| actionRoute | `/routine` |
| actionParams | — |
| body | Your CSE-301 class has been rescheduled to 10:00 AM in Room 401. Check the updated routine. |

### 2 — New Study Material: OOP Chapter 5
| Field | Value |
|-------|-------|
| id | `2` |
| type | `studyMaterial` |
| isRead | `false` |
| timestamp | `now - 2 hours` |
| actionRoute | `/study/courses/CSE-201/5` |
| actionParams | `{ title: 'OOP Chapter 5' }` |
| body | Dr. Rahman has uploaded notes and slides for Object-Oriented Programming Chapter 5: Inheritance & Polymorphism. |

### 3 — New Reply on Your Post
| Field | Value |
|-------|-------|
| id | `3` |
| type | `communityReply` |
| isRead | `false` |
| timestamp | `now - 5 hours` |
| actionRoute | `/community` |
| actionParams | — |
| body | Fariha replied to your question in the "Database Design" discussion: "You can use a normalized schema for that." |

### 4 — Subscription Confirmed
| Field | Value |
|-------|-------|
| id | `4` |
| type | `subscription` |
| isRead | `false` |
| timestamp | `now - 8 hours` |
| actionRoute | `/subscription` |
| actionParams | — |
| body | Your Premium plan has been activated. You now have access to all study materials, offline downloads, and priority support. |

### 5 — Campus Emergency Drill
| Field | Value |
|-------|-------|
| id | `5` |
| type | `emergency` |
| isRead | `false` |
| timestamp | `now - 12 hours` |
| actionRoute | `/emergency` |
| actionParams | — |
| body | Emergency evacuation drill scheduled for tomorrow at 3:00 PM. All students must assemble at the central field. |

### 6 — Urgent Blood Needed (A+)
| Field | Value |
|-------|-------|
| id | `6` |
| type | `bloodRequest` |
| isRead | `false` |
| timestamp | `now - 1 day` |
| actionRoute | `/blood-bank` |
| actionParams | — |
| body | A patient at the university medical center needs A+ blood. Donors please report to the blood bank by 5 PM. |

### 7 — New Alumni Registered
| Field | Value |
|-------|-------|
| id | `7` |
| type | `alumni` |
| isRead | `false` |
| timestamp | `now - 1 day 6 hours` |
| actionRoute | `/alumni` |
| actionParams | — |
| body | Sarah Ahmed (Batch 2019) has joined the alumni network. She is now working as a Software Engineer at Google. |

### 8 — Midterm Exam Schedule Published
| Field | Value |
|-------|-------|
| id | `8` |
| type | `notice` |
| isRead | `false` |
| timestamp | `now - 2 days` |
| actionRoute | `/study` |
| actionParams | — |
| body | The midterm examination schedule for Spring 2026 has been published. Download your personalized schedule now. |

### 9 — Congratulations! CGPA 3.95
| Field | Value |
|-------|-------|
| id | `9` |
| type | `achievement` |
| isRead | `false` |
| timestamp | `now - 3 days` |
| actionRoute | — |
| actionParams | — |
| body | You have achieved the highest CGPA in the CSE department for the Fall 2025 semester. Keep up the great work! |

### 10 — Robotics Club: Hackathon This Weekend
| Field | Value |
|-------|-------|
| id | `10` |
| type | `club` |
| isRead | `false` |
| timestamp | `now - 4 days` |
| actionRoute | `/club` |
| actionParams | — |
| body | The CSE Robotics Club is organizing a 24-hour hackathon this Saturday. Register now to participate! |

### 11 — New Study Resource: DSA Notes
| Field | Value |
|-------|-------|
| id | `11` |
| type | `studyMaterial` |
| isRead | `true` |
| timestamp | `now - 5 days` |
| actionRoute | `/study/courses/CSE-301/3` |
| actionParams | `{ title: 'DSA Notes' }` |
| body | Comprehensive notes on Data Structures & Algorithms have been added by the faculty. Covers trees, graphs, and dynamic programming. |

### 12 — Freshers Welcome 2026
| Field | Value |
|-------|-------|
| id | `12` |
| type | `notice` |
| isRead | `true` |
| timestamp | `now - 7 days` |
| actionRoute | — |
| actionParams | — |
| body | The university welcomes the batch of 2026! Orientation program starts Monday at 9:00 AM in the auditorium. |

---

## Sample JSON Response (for API)

```json
{
  "id": "1",
  "title": "Routine Updated for Tomorrow",
  "body": "Your CSE-301 class has been rescheduled to 10:00 AM in Room 401. Check the updated routine.",
  "type": "routineUpdate",
  "is_read": false,
  "timestamp": "2026-07-20T09:35:00Z",
  "action_route": "/routine",
  "action_params": null
}
```

## API Endpoints Needed

| Method | Path | Purpose |
|--------|------|---------|
| `GET` | `/notifications` | List notifications |
| `POST` | `/notifications/{id}/read` | Mark one as read |
| `POST` | `/notifications/read-all` | Mark all as read |
| `DELETE` | `/notifications/{id}` | Delete a notification |
