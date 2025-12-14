# GroupTrip Mobile - Screens & Authentication Map

## 📊 Summary
- **Total Screens**: 24
- **Authentication Types**: 2 (Public, Authenticated)
- **User Roles**: 2 (Traveller, Staff)

---

## 🔓 Public Screens (No Authentication Required)

| # | Screen Name | Route | Module | Description |
|---|---|---|---|---|
| 1 | Login Screen | `/` | auth | User login page with email/password |
| 2 | Register Screen | `/signup` | auth | New user registration page |

**Redirect Logic**: 
- Not logged in + accessing protected route → `/` (Login)
- Logged in + accessing `/` or `/signup` → Redirect to role-based home:
  - Staff → `/staff`
  - Traveller → `/blog`

---

## 🔒 Authenticated Screens - Traveller Role

### Main Navigation (Shell Routes - MainLayout)
| # | Screen Name | Route | Module | Description | Auth Required |
|---|---|---|---|---|---|
| 3 | Blog/Home Screen | `/blog` | blog | Browse available tours and trips | ✅ Traveller |
| 4 | Profile Screen | `/profile` | profile | View traveller profile summary | ✅ Traveller |
| 5 | Chat Screen | `/chat` | chat | List of conversations/groups | ✅ Traveller |

### Trip Management
| # | Screen Name | Route | Module | Description | Auth Required |
|---|---|---|---|---|---|
| 6 | My Trips Screen | `/mytrip` | mytrip | View all user trips with status | ✅ Traveller |
| 7 | Deposit Process | `/deposit_process/:departureId` | trip | Payment deposit for trip booking | ✅ Traveller |
| 8 | Pending Process | `/pending-process/:departureId` | trip | View trip in pending status | ✅ Traveller |
| 9 | In Progress Process | `/inprogress_process/:departureId` | trip | View ongoing trip | ✅ Traveller |
| 10 | Complete Process | `/complete_process/:departureId` | trip | View completed trip | ✅ Traveller |
| 11 | Cancel Process | `/canceled_process/:departureId` | trip | View cancelled trip | ✅ Traveller |

### Tour/Provider Browsing
| # | Screen Name | Route | Module | Description | Auth Required |
|---|---|---|---|---|---|
| 12 | Representative/Tour List | `/representative` | account/representative | List of tour operators/providers | ✅ Traveller |
| 13 | Representative Detail | `/representative/detail` | account/representative | Detailed provider information & tours | ✅ Traveller |

### Profile & Settings
| # | Screen Name | Route | Module | Description | Auth Required |
|---|---|---|---|---|---|
| 14 | Profile Detail | `/profile/detail` | profile | Edit traveller profile information | ✅ Traveller |
| 15 | My Wallet | `/profile/wallet` | wallet | View wallet balance & transactions | ✅ Traveller |
| 16 | Help Center | `/profile/help` | report | FAQ and support documentation | ✅ Traveller |
| 17 | Submit Ticket/Complaint | `/profile/help/submit` | report | Create support ticket | ✅ Traveller |

### Chat & Communication
| # | Screen Name | Route | Module | Description | Auth Required |
|---|---|---|---|---|---|
| 18 | Group Info | `/chat/info` | chat | View chat group information | ✅ Traveller |
| 19 | Chat Detail | `/chat/:chatId` | chat | Individual chat conversation | ✅ Traveller |

### Notifications
| # | Screen Name | Route | Module | Description | Auth Required |
|---|---|---|---|---|---|
| 20 | Notification | `/notification` | notifications | View system notifications & alerts | ✅ Traveller |

---

## 👨‍💼 Authenticated Screens - Staff Role

| # | Screen Name | Route | Module | Description | Auth Required |
|---|---|---|---|---|---|
| 21 | Staff Dashboard/Layout | `/staff` | staff | Main staff management interface | ✅ Staff |
| 22 | Staff Trip Detail | `/staff/trip-detail` | staff | Manage specific trip details | ✅ Staff |
| 23 | Staff Checkout | `/staff/checkout` | staff | Process payments for trips | ✅ Staff |
| 24 | Staff Trip Tracking | `/staff/tracking` | staff | Track trip progress & participants | ✅ Staff |

---

## 🔐 Authentication Implementation Details

### Authentication Mechanism
- **Framework**: Riverpod (StateNotifier)
- **Provider**: `authNotifierProvider`
- **Storage**: Persistent token storage (flutter_secure_storage)

### Role-Based Access Control (RBAC)
```dart
User Model:
  - id: String
  - email: String
  - role: "traveller" | "staff"  // Case-insensitive
  - profile: UserProfile
  - token: String (JWT)
```

### Available Roles
1. **Traveller**: Browse tours, book trips, manage bookings, chat
2. **Staff**: Create tours, manage bookings, process payments, track trips

### Guard Logic (in `app_router.dart`)
```dart
redirectLogin(GoRouterState state):
  - If NOT logged in + NOT at login/signup → Redirect to '/' (login)
  - If logged in + at login/signup → Redirect based on role:
    - role == 'staff' → '/staff'
    - else (traveller) → '/blog'
```

---

## 📱 Screen Flow Diagram

```
┌─────────────────────────────────────────┐
│          NOT AUTHENTICATED              │
│  ┌──────────────────────────────────┐  │
│  │  1. Login Screen (/)             │  │
│  │  2. Register Screen (/signup)    │  │
│  └───────┬──────────────────────────┘  │
└──────────┼──────────────────────────────┘
           │ (on successful login)
           ▼
    ┌──────────────────┐
    │  Check User Role │
    └────┬─────────┬───┘
         │         │
      STAFF     TRAVELLER
         │         │
         ▼         ▼
    ┌────────┐  ┌──────────────────┐
    │ /staff │  │ MainLayout Shell  │
    │ (21)   │  │ ┌────────────────┐│
    └────────┘  │ │ 3. Blog (/blog)││
                │ │ 4. Profile     ││
                │ │ 5. Chat        ││
                │ └────────────────┘│
                │  + 6-20: Subpages │
                └──────────────────┘
```

---

## 📋 Module to Screens Mapping

| Module | Screens | Count |
|---|---|---|
| **auth** | Login, Register | 2 |
| **blog** | Blog/Home | 1 |
| **profile** | Profile, Profile Detail | 2 |
| **chat** | Chat, Group Info, Chat Detail | 3 |
| **mytrip** | My Trips | 1 |
| **trip** | Deposit, Pending, InProgress, Complete, Cancel | 5 |
| **account/representative** | Tour List, Representative Detail | 2 |
| **wallet** | My Wallet | 1 |
| **report** | Help Center, Submit Ticket | 2 |
| **notifications** | Notification | 1 |
| **staff** | Staff Layout, Trip Detail, Checkout, Tracking | 4 |
| **core/router** | Route handling (not a screen) | - |

---

## 🔄 Trip Lifecycle Screens

Trip statuses and their corresponding screens:

| Status | Screen | Route | Permission |
|---|---|---|---|
| **DEPOSIT_PENDING** | Deposit Process | `/deposit_process/:id` | Traveller |
| **PENDING** | Pending Process | `/pending-process/:id` | Traveller |
| **IN_PROGRESS** | In Progress Process | `/inprogress_process/:id` | Traveller |
| **COMPLETED** | Complete Process | `/complete_process/:id` | Traveller |
| **CANCELLED** | Cancel Process | `/canceled_process/:id` | Traveller |

---

## 🛡️ Security Notes

✅ **Implemented**:
- Login/Register gating at route level
- Role-based navigation (Staff vs Traveller)
- Protected routes via `redirectLogin()`
- Token-based authentication
- Secure token storage

⚠️ **Considerations**:
- No per-screen permission validation visible in router
- Role check is basic (string comparison)
- Staff routes may need additional permission checks
- Trip-specific access control (ownership/participation) likely in business logic

---

## 📝 Notes

1. **MainLayout Shell**: Routes 3, 4, 5 use MainLayout as parent (SharedRoute pattern)
2. **Dynamic Routes**: Trip process screens use path parameters (`:departureId`)
3. **Extra Data**: Some routes accept extra data via `state.extra` (trip details, etc.)
4. **Redirect Listener**: Uses `authNotifierProvider.notifier.listenable` for reactive navigation

---

**Last Updated**: December 15, 2025  
**Framework**: Flutter + go_router + Riverpod  
**Scope**: GroupTrip Mobile Application v1.0
