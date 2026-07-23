# Tourism Guidance App - API Documentation

## Base URL
```
http://localhost:8000/api/v1
Admin API: http://localhost:8000/api/admin
```

## Authentication
The API uses Laravel Sanctum for authentication. Users must include the bearer token in the Authorization header:
```
Authorization: Bearer {access_token}
```

---

## Public Endpoints

### Authentication

#### Register
```
POST /register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "+1234567890",
  "role": "user" // optional: user, guide
}

Response: 201
{
  "message": "User registered successfully",
  "user": {...},
  "access_token": "token...",
  "token_type": "Bearer"
}
```

#### Login
```
POST /login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}

Response: 200
{
  "message": "Login successful",
  "user": {...},
  "access_token": "token...",
  "token_type": "Bearer"
}
```

### Destinations

#### Get All Destinations
```
GET /destinations?per_page=15&page=1&search=Paris&country=France

Response: 200
{
  "data": [
    {
      "id": 1,
      "name": "Eiffel Tower",
      "city": "Paris",
      "country": "France",
      "latitude": 48.8584,
      "longitude": 2.2945,
      "image_url": "...",
      "entry_fee": 25.00,
      "best_time_to_visit": "April-June",
      "featured": true,
      "status": "active"
    }
  ],
  "pagination": {...}
}
```

#### Get Single Destination
```
GET /destinations/{id}

Response: 200
{
  "id": 1,
  "name": "Eiffel Tower",
  "tours": [...],
  "reviews": [...]
}
```

#### Get Featured Destinations
```
GET /destinations/featured/list?limit=10

Response: 200
[...]
```

#### Get Destination Reviews
```
GET /destinations/{id}/reviews?page=1

Response: 200
{
  "data": [
    {
      "id": 1,
      "user": {"id": 1, "name": "John Doe"},
      "rating": 5,
      "comment": "Amazing place!",
      "created_at": "..."
    }
  ]
}
```

### Tours

#### Get All Tours
```
GET /tours?destination_id=1&search=Paris Tour&per_page=15

Response: 200
{
  "data": [
    {
      "id": 1,
      "name": "Paris City Tour",
      "destination": {...},
      "guide": {...},
      "price": 150.00,
      "duration_days": 3,
      "max_participants": 20,
      "start_date": "2026-05-01",
      "itineraryItems": [...]
    }
  ]
}
```

#### Get Single Tour
```
GET /tours/{id}

Response: 200
{...}
```

### Guides

#### Get All Guides
```
GET /guides?search=John&per_page=15

Response: 200
{
  "data": [
    {
      "id": 1,
      "user": {"id": 1, "name": "John Guide"},
      "bio": "...",
      "experience_years": 5,
      "languages": ["English", "French"],
      "rating": 4.5,
      "status": "active",
      "verification_status": "verified",
      "tours_count": 10,
      "reviews_avg_rating": 4.5
    }
  ]
}
```

#### Get Single Guide
```
GET /guides/{id}

Response: 200
{
  "id": 1,
  "tours": [...],
  "reviews": [...]
}
```

#### Get Guide Reviews
```
GET /guides/{id}/reviews?page=1

Response: 200
[...]
```

---

## Protected Endpoints (Require Authentication)

### Authentication

#### Logout
```
POST /logout
Authorization: Bearer {token}

Response: 200
{
  "message": "Logout successful"
}
```

#### Get Profile
```
GET /profile
Authorization: Bearer {token}

Response: 200
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "bookings": [...],
  "guide": {...}
}
```

#### Update Profile
```
PUT /profile
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Jane Doe",
  "phone": "+1234567890"
}

Response: 200
{
  "message": "Profile updated",
  "user": {...}
}
```

### Bookings

#### Create Booking
```
POST /bookings
Authorization: Bearer {token}
Content-Type: application/json

{
  "tour_id": 1,
  "number_of_participants": 2,
  "payment_method": "card" // card, wallet, cod
}

Response: 201
{
  "id": 1,
  "tour_id": 1,
  "user_id": 1,
  "number_of_participants": 2,
  "total_price": 300.00,
  "status": "pending",
  "payment_status": "pending",
  "booking_date": "..."
}
```

#### Get My Bookings
```
GET /bookings?per_page=15

Response: 200
{
  "data": [...]
}
```

#### Get Booking Details
```
GET /bookings/{id}

Response: 200
{...}
```

#### Cancel Booking
```
POST /bookings/{id}/cancel
Authorization: Bearer {token}

Response: 200
{
  "message": "Booking cancelled",
  "booking": {...}
}
```

### Reviews

#### Create Review
```
POST /reviews
Authorization: Bearer {token}
Content-Type: application/json

{
  "destination_id": 1,
  "rating": 5, // 1-5
  "comment": "Amazing place!"
}

Response: 201
{
  "id": 1,
  "destination_id": 1,
  "user_id": 1,
  "rating": 5,
  "comment": "Amazing place!",
  "status": "pending"
}
```

### Guide Management

#### Apply as Guide
```
POST /guides/apply
Authorization: Bearer {token}
Content-Type: application/json

{
  "bio": "I have 10 years of tour guiding experience...",
  "experience_years": 10,
  "languages": ["English", "French", "Spanish"],
  "phone": "+1234567890"
}

Response: 201
{
  "id": 1,
  "user_id": 1,
  "bio": "...",
  "verification_status": "pending"
}
```

#### Create Tour (Guide Only)
```
POST /tours
Authorization: Bearer {token}
Content-Type: application/json

{
  "destination_id": 1,
  "name": "Paris City Tour",
  "description": "...",
  "duration_days": 3,
  "price": 150.00,
  "max_participants": 20,
  "start_date": "2026-05-01T08:00:00Z",
  "end_date": "2026-05-03T18:00:00Z"
}

Response: 201
{...}
```

---

## Admin Endpoints

All admin endpoints require `Authorization: Bearer {admin_token}` header and admin role.

### Dashboard

#### Get Statistics
```
GET /admin/dashboard/statistics

Response: 200
{
  "total_users": 150,
  "total_guides": 25,
  "total_destinations": 100,
  "total_tours": 200,
  "total_bookings": 500,
  "pending_reviews": 10,
  "active_users": 145,
  "verified_guides": 20
}
```

#### Get Revenue Analytics
```
GET /admin/dashboard/revenue?period=month // day, week, month, year

Response: 200
[
  {
    "period": "2026-04",
    "revenue": 15000.00,
    "bookings": 100
  }
]
```

#### Get Top Destinations
```
GET /admin/dashboard/top-destinations

Response: 200
[...]
```

#### Get Recent Bookings
```
GET /admin/dashboard/recent-bookings

Response: 200
[...]
```

#### Get Top Guides
```
GET /admin/dashboard/top-guides

Response: 200
[...]
```

### Destinations

#### Get All Destinations
```
GET /admin/destinations?per_page=15

Response: 200
[...]
```

#### Create Destination
```
POST /admin/destinations
Content-Type: application/json

{
  "name": "Eiffel Tower",
  "description": "...",
  "city": "Paris",
  "country": "France",
  "latitude": 48.8584,
  "longitude": 2.2945,
  "image_url": "...",
  "entry_fee": 25.00,
  "best_time_to_visit": "April-June"
}

Response: 201
{...}
```

#### Update Destination
```
PUT /admin/destinations/{id}
Content-Type: application/json

{
  "status": "active", // active, inactive, archived
  "featured": true
}

Response: 200
{...}
```

#### Delete Destination
```
DELETE /admin/destinations/{id}

Response: 200
{
  "message": "Destination deleted"
}
```

### Users

#### Get All Users
```
GET /admin/users?role=guide&status=active&per_page=15

Response: 200
[...]
```

#### Get User Details
```
GET /admin/users/{id}

Response: 200
{...}
```

#### Update User Status
```
PUT /admin/users/{id}/status
Content-Type: application/json

{
  "status": "active" // active, inactive, suspended
}

Response: 200
{...}
```

#### Update User Role
```
PUT /admin/users/{id}/role
Content-Type: application/json

{
  "role": "admin" // user, guide, admin
}

Response: 200
{...}
```

#### Delete User
```
DELETE /admin/users/{id}

Response: 200
{
  "message": "User deleted"
}
```

### Guides

#### Get All Guides
```
GET /admin/guides?verification_status=pending&per_page=15

Response: 200
[...]
```

#### Get Guide Details
```
GET /admin/guides/{id}

Response: 200
{...}
```

#### Verify Guide
```
POST /admin/guides/{id}/verify

Response: 200
{
  "message": "Guide verified",
  "guide": {...}
}
```

#### Reject Guide Application
```
POST /admin/guides/{id}/reject
Content-Type: application/json

{
  "reason": "Missing required documents"
}

Response: 200
{
  "message": "Guide application rejected",
  "guide": {...}
}
```

#### Update Guide Status
```
PUT /admin/guides/{id}/status
Content-Type: application/json

{
  "status": "suspended" // active, inactive, suspended
}

Response: 200
{...}
```

### Bookings

#### Get All Bookings
```
GET /admin/bookings?status=pending&payment_status=completed&per_page=15

Response: 200
[...]
```

#### Get Booking Details
```
GET /admin/bookings/{id}

Response: 200
{...}
```

#### Update Booking Status
```
PUT /admin/bookings/{id}/status
Content-Type: application/json

{
  "status": "confirmed" // pending, confirmed, completed, cancelled
}

Response: 200
{...}
```

#### Update Payment Status
```
PUT /admin/bookings/{id}/payment-status
Content-Type: application/json

{
  "payment_status": "completed" // pending, completed, failed, refunded
}

Response: 200
{...}
```

### Reviews

#### Get Destination Reviews
```
GET /admin/reviews/destinations?status=pending&per_page=15

Response: 200
[...]
```

#### Get Guide Reviews
```
GET /admin/reviews/guides?status=pending&per_page=15

Response: 200
[...]
```

#### Approve Destination Review
```
POST /admin/reviews/destinations/{id}/approve

Response: 200
{
  "message": "Review approved",
  "review": {...}
}
```

#### Reject Destination Review
```
POST /admin/reviews/destinations/{id}/reject

Response: 200
{
  "message": "Review rejected",
  "review": {...}
}
```

#### Approve Guide Review
```
POST /admin/reviews/guides/{id}/approve

Response: 200
{...}
```

#### Reject Guide Review
```
POST /admin/reviews/guides/{id}/reject

Response: 200
{...}
```

---

## Error Responses

### 400 Bad Request
```json
{
  "message": "Validation error",
  "errors": {
    "email": ["The email field is required."]
  }
}
```

### 401 Unauthorized
```json
{
  "message": "Unauthenticated"
}
```

### 403 Forbidden
```json
{
  "message": "Unauthorized. Admin access required."
}
```

### 404 Not Found
```json
{
  "message": "Resource not found"
}
```

### 422 Unprocessable Entity
```json
{
  "message": "The given data was invalid.",
  "errors": {...}
}
```

### 500 Server Error
```json
{
  "message": "Server error"
}
```

---

## Setup Instructions

### 1. Install Dependencies
```bash
composer install
npm install
```

### 2. Environment Setup
```bash
cp .env.example .env
php artisan key:generate
```

### 3. Database Setup
```bash
php artisan migrate
```

### 4. Run the Application
```bash
php artisan serve
```

The API will be available at `http://localhost:8000`

---

## API Rate Limiting

To add, configure rate limiting in `routes/api.php` middleware.

---

## Security Notes

- Always use HTTPS in production
- Keep your API keys secure
- Validate and sanitize all inputs
- Use strong password requirements
- Implement CORS appropriately for your frontend
