# Tourism Guidance App - Backend Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                          MOBILE APP                                  │
│                      (Frontend Consumer)                             │
└──────────────────────────┬──────────────────────────────────────────┘
                           │
                    HTTP/HTTPS Requests
                           │
┌──────────────────────────▼──────────────────────────────────────────┐
│                      REST API SERVER                                 │
│                    (Laravel 11 + Sanctum)                            │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                    API Routes Layer                          │  │
│  ├──────────────────────────────────────────────────────────────┤  │
│  │                                                              │  │
│  │  ┌─────────────────┐  ┌──────────────────┐   PUBLIC        │  │
│  │  │ Auth Routes     │  │ Destination      │   ENDPOINTS     │  │
│  │  │ - register      │  │ - list           │   No Auth       │  │
│  │  │ - login         │  │ - show           │   Required      │  │
│  │  │ - logout        │  │ - featured       │                 │  │
│  │  └─────────────────┘  └──────────────────┘                 │  │
│  │                                                              │  │
│  │  ┌─────────────────┐  ┌──────────────────┐   PROTECTED     │  │
│  │  │ Booking Routes  │  │ Review Routes    │   ENDPOINTS     │  │
│  │  │ - create        │  │ - submit         │   Auth Required │  │
│  │  │ - list          │  │                  │                 │  │
│  │  │ - show          │  └──────────────────┘                 │  │
│  │  │ - cancel        │                                       │  │
│  │  └─────────────────┘                                       │  │
│  │                                                              │  │
│  │  ┌──────────────────────────────────────────────────────┐  │  │
│  │  │        ADMIN Routes (Auth + Admin Middleware)        │  │  │
│  │  │  - Dashboard routes   - Booking management           │  │  │
│  │  │  - User management    - Review moderation            │  │  │
│  │  │  - Destination CRUD   - Guide verification           │  │  │
│  │  └──────────────────────────────────────────────────────┘  │  │
│  │                                                              │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │              Controller Layer (API Logic)                    │  │
│  ├──────────────────────────────────────────────────────────────┤  │
│  │                                                              │  │
│  │  API Controllers:                Admin Controllers:          │  │
│  │  • AuthController               • AdminDashboardController  │  │
│  │  • DestinationController        • AdminUserController       │  │
│  │  • TourController               • AdminGuideController      │  │
│  │  • BookingController            • AdminBookingController    │  │
│  │  • ReviewController             • AdminReviewController     │  │
│  │  • GuideController              • AdminDestinationCtrl      │  │
│  │                                                              │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │           Model/Eloquent Layer (Business Logic)             │  │
│  ├──────────────────────────────────────────────────────────────┤  │
│  │                                                              │  │
│  │  User ◄──── hasOne/hasMany ──────► Guide                    │  │
│  │   ▲                                  │                      │  │
│  │   │                            hasMany                      │  │
│  │   │                                  ▼                      │  │
│  │   │                              Tour ◄───┐                 │  │
│  │   │                               │        │                │  │
│  │   │                         hasMany│        │hasOne          │  │
│  │   │                               ▼        │                │  │
│  │  Booking ◄─── hasMany ────► Destination   │                │  │
│  │   │                              │        │                │  │
│  │   ├─ hasOne ─► Review            │        │                │  │
│  │   └─ hasOne ─► GuideReview       ▼        │                │  │
│  │                            hasMany        │                │  │
│  │                         ItineraryItem     │                │  │
│  │                               ◄───────────┘                │  │
│  │                                                              │  │
│  │  • 8 Models total                                           │  │
│  │  • Full relationship mapping                                │  │
│  │  • Resource counting and aggregation                        │  │
│  │                                                              │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │         Middleware Layer (Security & Validation)            │  │
│  ├──────────────────────────────────────────────────────────────┤  │
│  │                                                              │  │
│  │  • Sanctum Authentication  (Token validation)               │  │
│  │  • AdminMiddleware         (Role checking)                  │  │
│  │  • Validation              (Input sanitization)             │  │
│  │  • CORS                    (Cross-origin requests)          │  │
│  │                                                              │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
                           │
                   Database Connection
                           │
┌──────────────────────────▼──────────────────────────────────────────┐
│                      DATABASE (MySQL)                               │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐      │
│  │ Users        │  │ Destinations │  │ Tours                │      │
│  ├──────────────┤  ├──────────────┤  ├──────────────────────┤      │
│  │ id (PK)      │  │ id (PK)      │  │ id (PK)              │      │
│  │ name         │  │ name         │  │ destination_id (FK)  │      │
│  │ email (UQ)   │  │ city         │  │ guide_id (FK)        │      │
│  │ password     │  │ country      │  │ name                 │      │
│  │ phone        │  │ latitude     │  │ price                │      │
│  │ role         │  │ longitude    │  │ duration_days        │      │
│  │ status       │  │ image_url    │  │ start_date           │      │
│  │              │  │ entry_fee    │  │ end_date             │      │
│  │              │  │ status       │  │ status               │      │
│  │              │  │ featured     │  │                      │      │
│  │              │  │              │  │                      │      │
│  └──────────────┘  └──────────────┘  └──────────────────────┘      │
│                                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐      │
│  │ Guides       │  │ Bookings     │  │ Reviews              │      │
│  ├──────────────┤  ├──────────────┤  ├──────────────────────┤      │
│  │ id (PK)      │  │ id (PK)      │  │ id (PK)              │      │
│  │ user_id (FK) │  │ tour_id (FK) │  │ destination_id (FK)  │      │
│  │ bio          │  │ user_id (FK) │  │ user_id (FK)         │      │
│  │ experience   │  │ guide_id (FK)│  │ rating               │      │
│  │ languages    │  │ participants │  │ comment              │      │
│  │ phone        │  │ total_price  │  │ status               │      │
│  │ rating       │  │ status       │  │ created_at           │      │
│  │ verification │  │ payment_stat.│  │                      │      │
│  │ status       │  │              │  │                      │      │
│  └──────────────┘  └──────────────┘  └──────────────────────┘      │
│                                                                      │
│  ┌──────────────┐  ┌──────────────────────────────────────────┐    │
│  │ Itinerary    │  │ GuideReviews                             │    │
│  │ Items        │  ├──────────────────────────────────────────┤    │
│  ├──────────────┤  │ id (PK)                                  │    │
│  │ id (PK)      │  │ guide_id (FK)                            │    │
│  │ tour_id (FK) │  │ user_id (FK)                             │    │
│  │ day          │  │ booking_id (FK)                          │    │
│  │ title        │  │ rating                                   │    │
│  │ description  │  │ comment                                  │    │
│  │ location     │  │ status                                   │    │
│  │ duration     │  │                                          │    │
│  │ activities   │  │                                          │    │
│  └──────────────┘  └──────────────────────────────────────────┘    │
│                                                                      │
│  • 8 Tables total                                                    │
│  • Foreign key relationships                                         │
│  • Status tracking fields                                            │
│  • Timestamps on all tables                                          │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

## API Request Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    Mobile App Request                           │
│         GET /api/v1/tours?destination_id=1                     │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│              Router (routes/api.php)                            │
│    Matches route and dispatches to TourController@index        │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│           TourController::index()                               │
│  • Validates request parameters                                │
│  • Builds query with filters                                   │
│  • Includes relationships                                      │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│              Tour Model (Eloquent Query)                        │
│  Tour::where('status', 'active')                              │
│       ->where('destination_id', $destinationId)               │
│       ->with(['destination', 'guide', 'itineraryItems'])      │
│       ->paginate(15)                                          │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│         Database Query (SQL)                                    │
│  SELECT * FROM tours WHERE status='active'                    │
│  AND destination_id=1 ...                                      │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│         Response Formatting                                     │
│  Convert models to JSON with relationships                     │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│         HTTP Response (200)                                     │
│  {                                                             │
│    "data": [Tour objects with nested data],                  │
│    "pagination": {...}                                       │
│  }                                                            │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│              Mobile App (Parsed JSON)                          │
│         Display tours to user in list view                     │
└─────────────────────────────────────────────────────────────────┘
```

## Admin Dashboard Flow

```
Admin User
    │
    ▼
GET /api/admin/dashboard/statistics
(Authorization: Bearer admin_token)
    │
    ▼
AdminMiddleware
(Check: user is authenticated AND role='admin')
    │
    ├─ Yes ─▶ Continue to controller
    │
    └─ No ──▶ Return 403 Forbidden
              └─ User not logged in or not admin
```

## User Roles & Access Control

```
┌──────────────────────────────────────────────────┐
│              User Roles & Permissions             │
├──────────────────────────────────────────────────┤
│                                                  │
│  GUEST USER (Not Authenticated)                 │
│  ├─ Browse destinations ✓                       │
│  ├─ Browse tours ✓                              │
│  ├─ Browse guides ✓                             │
│  └─ Register/Login ✓                            │
│                                                  │
│  TOURIST USER (Authenticated)                   │
│  ├─ Can do everything guest can do              │
│  ├─ Create bookings ✓                           │
│  ├─ View own bookings ✓                         │
│  ├─ Submit destination reviews ✓                │
│  ├─ Cancel bookings ✓                           │
│  └─ Apply as guide ✓                            │
│                                                  │
│  GUIDE USER (Authenticated + Verified)          │
│  ├─ Can do everything tourist can do            │
│  ├─ Create tours ✓                              │
│  ├─ Manage created tours ✓                      │
│  ├─ View bookings for own tours ✓               │
│  ├─ Receive tour reviews ✓                      │
│  └─ Edit guide profile ✓                        │
│                                                  │
│  ADMIN USER (Authenticated + role='admin')      │
│  ├─ Access admin endpoints ✓                    │
│  ├─ View dashboard/stats ✓                      │
│  ├─ CRUD all destinations ✓                     │
│  ├─ Manage all users ✓                          │
│  ├─ Verify/reject guides ✓                      │
│  ├─ Moderate all reviews ✓                      │
│  ├─ Manage all bookings ✓                       │
│  ├─ View revenue analytics ✓                    │
│  └─ Manage tour guides ✓                        │
│                                                  │
└──────────────────────────────────────────────────┘
```

## Authentication & Token Flow

```
┌─────────────────────────────────────────────────┐
│              Sanctum Token Flow                  │
├─────────────────────────────────────────────────┤
│                                                 │
│  1. User POST /register                         │
│     {email, password, name, ...}                │
│           │                                     │
│           ▼                                     │
│  2. Create User in Database                     │
│           │                                     │
│           ▼                                     │
│  3. Generate Token                              │
│     $token = $user->createToken('auth_token')  │
│           │                                     │
│           ▼                                     │
│  4. Return Response                             │
│     {user, access_token, token_type: 'Bearer'} │
│           │                                     │
│           ▼                                     │
│  5. Mobile App Stores Token                     │
│     localStorage.setItem('token', access_token)│
│           │                                     │
│           ▼                                     │
│  6. Subsequent Requests Include Token           │
│     Authorization: Bearer {access_token}       │
│           │                                     │
│           ▼                                     │
│  7. Sanctum Validates Token                     │
│     Check personal_access_tokens table          │
│           │                                     │
│           ├─ Valid ──▶ Allow access             │
│           └─ Invalid ▶ Return 401 Unauthorized  │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Data Validation Pipeline

```
API Request
    │
    ▼
Input Validation (Controller)
    ├─ Check required fields
    ├─ Check data types
    ├─ Check enum values
    ├─ Check relationships exist
    │
    ├─ Valid ──▶ Continue
    │
    └─ Invalid ─▶ Return 422 Unprocessable Entity
                  {errors: {...}}
    │
    ▼
Business Logic (Model)
    ├─ Apply relationships
    ├─ Perform calculations
    ├─ Aggregate data
    │
    ▼
Database Operation
    ├─ Create/Read/Update/Delete
    │
    ▼
Response Formatting
    ├─ Convert to JSON
    ├─ Include relationships
    ├─ Paginate if needed
    │
    ▼
HTTP Response (200/201)
```

## File Organization

```
d:\tourist_guide\
│
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── Api/                    (6 controllers)
│   │   │   │   ├── AuthController
│   │   │   │   ├── DestinationController
│   │   │   │   ├── TourController
│   │   │   │   ├── BookingController
│   │   │   │   ├── ReviewController
│   │   │   │   └── GuideController
│   │   │   │
│   │   │   └── Admin/                  (6 controllers)
│   │   │       ├── DashboardController
│   │   │       ├── DestinationController
│   │   │       ├── UserController
│   │   │       ├── GuideController
│   │   │       ├── BookingController
│   │   │       └── ReviewController
│   │   │
│   │   └── Middleware/
│   │       └── AdminMiddleware
│   │
│   └── Models/                         (8 models)
│       ├── User
│       ├── Destination
│       ├── Tour
│       ├── Guide
│       ├── Booking
│       ├── Review
│       ├── GuideReview
│       └── ItineraryItem
│
├── database/
│   ├── migrations/                     (8 migrations)
│   ├── seeders/
│   └── factory/
│
├── routes/
│   ├── api.php                         (All API routes)
│   └── web.php
│
├── config/
│   ├── app.php
│   ├── database.php
│   └── sanctum.php
│
├── API_DOCUMENTATION.md                (60+ endpoints)
├── SETUP_GUIDE.md                      (Installation guide)
├── Tourism_API_Postman_Collection.json (Import into Postman)
└── test_api.sh                         (Bash testing script)
```

---

**Total Components:**
- 8 Models
- 12 Controllers
- 8 Migrations
- 1 Middleware
- 60+ API Endpoints
- 8 Database Tables
- 4 Documentation Files
