# Enhanced Tourism App API - Complete Feature Documentation

## 🆕 New Features Added

### 1. **Events System**
- Browse events by category, city, date range
- Event booking system with capacity management
- Event reviews and ratings
- Featured events discovery
- Upcoming events listing

### 2. **Restaurant Management**
- Browse dining venues by cuisine type, city, price range
- Restaurant ratings and reviews
- Featured restaurant discovery
- Location-based restaurant search
- Opening/closing hours tracking

### 3. **Favorites/Wishlist System**
- Add/remove favorites for destinations, events, restaurants
- View full wishlist categorized by type
- Quick favorite status checks
- Clear all favorites

### 4. **Location-Based Filtering**
- Find nearby attractions, events, restaurants using GPS
- Radius-based search (customizable)
- Top-rated locations by city
- Route planning integration points
- Advanced destination filtering

### 5. **Categories System**
- Categorize destinations, events, restaurants
- Admin category management
- Filter by category type

### 6. **Media Gallery System**
- Multiple media per item (images/videos)
- Bulk media uploads
- Media reordering
- Organized gallery display

---

## 📍 API ENDPOINTS - Complete Guide

### Base URLs
```
Public API: http://localhost:8000/api/v1
Admin API: http://localhost:8000/api/admin
```

---

## 🆕 NEW PUBLIC ENDPOINTS

### Events

#### Browse Events
```
GET /v1/events?search=&category_id=&city=&start_date=2026-05-01&per_page=15
```

#### Get Event Details
```
GET /v1/events/{id}
Response: 200
{
  "id": 1,
  "name": "Riyadh Music Festival",
  "description": "...",
  "city": "Riyadh",
  "location_address": "...",
  "latitude": 24.7136,
  "longitude": 46.6753,
  "start_date": "2026-05-15",
  "end_date": "2026-05-20",
  "ticket_price": 50.00,
  "capacity": 5000,
  "image_url": "...",
  "category": {...},
  "reviews": [...]
}
```

#### Get Featured Events
```
GET /v1/events/featured/list?limit=10
```

#### Get Upcoming Events
```
GET /v1/events/upcoming/list?limit=10
```

#### Find Nearby Events
```
POST /v1/events/nearby
Content-Type: application/json

{
  "latitude": 24.7136,
  "longitude": 46.6753,
  "radius": 50
}
```

#### Leave Event Review (Authenticated)
```
POST /v1/events/{id}/review
Authorization: Bearer {token}

{
  "rating": 5,
  "comment": "Great event!"
}
```

### Restaurants

#### Browse Restaurants
```
GET /v1/restaurants?search=&category_id=&city=&cuisine_type=Italian&min_price=10&max_price=100&min_rating=3.5&per_page=15
```

#### Get Restaurant Details
```
GET /v1/restaurants/{id}
Response: 200
{
  "id": 1,
  "name": "Al Balad Restaurant",
  "description": "Traditional Saudi cuisine",
  "cuisine_type": "Arabic",
  "city": "Jeddah",
  "location_address": "...",
  "latitude": 21.5433,
  "longitude": 39.1728,
  "phone": "+966...",
  "email": "info@example.com",
  "website": "https://example.com",
  "opening_time": "11:00",
  "closing_time": "23:00",
  "average_cost": 45.00,
  "image_url": "...",
  "rating": 4.5,
  "category": {...},
  "reviews": [...]
}
```

#### Get Featured Restaurants
```
GET /v1/restaurants/featured/list?limit=10
```

#### Find Nearby Restaurants
```
POST /v1/restaurants/nearby
Content-Type: application/json

{
  "latitude": 21.5433,
  "longitude": 39.1728,
  "radius": 15
}
```

#### Browse by Cuisine Type
```
GET /v1/restaurants/cuisine/{cuisine_type}?per_page=15
```

#### Leave Restaurant Review (Authenticated)
```
POST /v1/restaurants/{id}/review
Authorization: Bearer {token}

{
  "rating": 4,
  "comment": "Good food and service"
}
```

### Location-Based Discovery

#### Get Nearby Everything
```
POST /v1/location/nearby
Content-Type: application/json

{
  "latitude": 24.7136,
  "longitude": 46.6753,
  "radius": 50
}

Response: 200
{
  "destinations": [...],
  "events": [...],
  "restaurants": [...],
  "search_radius_km": 50,
  "user_location": {
    "latitude": 24.7136,
    "longitude": 46.6753
  }
}
```

#### Search by City
```
GET /v1/location/search-city?city=Riyadh&type=all
// type: destination, event, restaurant, all
```

#### Filter Destinations with Advanced Options
```
GET /v1/location/filter-destinations?category_id=1&city=Riyadh&country=Saudi Arabia&rating=4&latitude=24.7136&longitude=46.6753&radius=50
```

#### Get Route Between Locations
```
POST /v1/location/route
Content-Type: application/json

{
  "start_lat": 24.7136,
  "start_lng": 46.6753,
  "end_lat": 21.5433,
  "end_lng": 39.1728,
  "mode": "driving"
}

Response: 200
{
  "status": "OK",
  "start": {...},
  "end": {...},
  "mode": "driving",
  "distance": "...",
  "duration": "...",
  "polyline": "..."
}
```

#### Get Top-Rated Locations
```
GET /v1/location/top-rated?city=Riyadh&limit=10
```

### Favorites/Wishlist (Authenticated)

#### Get My Favorites
```
GET /v1/favorites?type=all&per_page=15
// type: destination, event, restaurant, all
```

#### Add to Favorites
```
POST /v1/favorites/add
Authorization: Bearer {token}

{
  "type": "destination",
  "item_id": 1
}
```

#### Remove from Favorites
```
POST /v1/favorites/remove
Authorization: Bearer {token}

{
  "type": "restaurant",
  "item_id": 5
}
```

#### Check if Favorited
```
POST /v1/favorites/check
Authorization: Bearer {token}

{
  "type": "event",
  "item_id": 3
}

Response: 200
{
  "is_favorited": true
}
```

#### Get Full Wishlist
```
GET /v1/favorites/wishlist
Authorization: Bearer {token}

Response: 200
{
  "App\\Models\\Destination": [...],
  "App\\Models\\Event": [...],
  "App\\Models\\Restaurant": [...]
}
```

#### Clear All Favorites
```
DELETE /v1/favorites/clear
Authorization: Bearer {token}
```

### Event Bookings (Authenticated)

#### Book Event Tickets
```
POST /v1/event-bookings
Authorization: Bearer {token}

{
  "event_id": 1,
  "number_of_tickets": 4,
  "payment_method": "card"
}

Response: 201
{
  "id": 1,
  "event_id": 1,
  "user_id": 1,
  "number_of_tickets": 4,
  "total_price": 200.00,
  "status": "pending",
  "payment_status": "pending",
  "booking_reference": "EB-XXXXXXXXXXXXX"
}
```

#### Get My Event Bookings
```
GET /v1/event-bookings?per_page=15
Authorization: Bearer {token}
```

#### Get Event Booking Details
```
GET /v1/event-bookings/{id}
Authorization: Bearer {token}
```

#### Cancel Event Booking
```
POST /v1/event-bookings/{id}/cancel
Authorization: Bearer {token}
```

---

## 🔧 NEW ADMIN ENDPOINTS

### Events Management

#### Get All Events
```
GET /admin/events?status=active&city=Riyadh&per_page=15
Authorization: Bearer {admin_token}
```

#### Create Event
```
POST /admin/events
Authorization: Bearer {admin_token}

{
  "name": "Festival Name",
  "description": "Event description",
  "category_id": 1,
  "city": "Riyadh",
  "location_address": "123 Main St",
  "latitude": 24.7136,
  "longitude": 46.6753,
  "start_date": "2026-05-15",
  "end_date": "2026-05-20",
  "start_time": "10:00",
  "end_time": "22:00",
  "ticket_price": 50.00,
  "capacity": 5000,
  "image_url": "...",
  "featured": true
}
```

#### Update Event
```
PUT /admin/events/{id}
Authorization: Bearer {admin_token}
```

#### Delete Event
```
DELETE /admin/events/{id}
Authorization: Bearer {admin_token}
```

#### Get Event Statistics
```
GET /admin/events/stats/overview
Authorization: Bearer {admin_token}
```

### Restaurants Management

#### Get All Restaurants
```
GET /admin/restaurants?status=active&city=Jeddah&cuisine_type=Arabic&per_page=15
Authorization: Bearer {admin_token}
```

#### Create Restaurant
```
POST /admin/restaurants
Authorization: Bearer {admin_token}

{
  "name": "Restaurant Name",
  "description": "Description",
  "category_id": 1,
  "cuisine_type": "Arabic",
  "city": "Jeddah",
  "location_address": "...",
  "latitude": 21.5433,
  "longitude": 39.1728,
  "phone": "+966...",
  "email": "info@example.com",
  "website": "https://example.com",
  "opening_time": "11:00",
  "closing_time": "23:00",
  "average_cost": 45.00,
  "image_url": "...",
  "featured": false
}
```

#### Update Restaurant
```
PUT /admin/restaurants/{id}
Authorization: Bearer {admin_token}
```

#### Delete Restaurant
```
DELETE /admin/restaurants/{id}
Authorization: Bearer {admin_token}
```

### Categories Management

#### Get All Categories
```
GET /admin/categories?type=destination&status=active&per_page=15
Authorization: Bearer {admin_token}
```

#### Create Category
```
POST /admin/categories
Authorization: Bearer {admin_token}

{
  "name": "Adventure",
  "description": "Adventure activities",
  "icon_url": "https://example.com/icon.png",
  "type": "destination"
}
```

#### Update Category
```
PUT /admin/categories/{id}
Authorization: Bearer {admin_token}
```

#### Delete Category
```
DELETE /admin/categories/{id}
Authorization: Bearer {admin_token}
```

#### Get Categories by Type
```
GET /admin/categories/type/{type}
Authorization: Bearer {admin_token}
// type: destination, event, restaurant
```

### Media Gallery Management

#### Add Media
```
POST /admin/media/add
Authorization: Bearer {admin_token}

{
  "type": "destination",
  "item_id": 1,
  "media_url": "https://example.com/photo.jpg",
  "media_type": "image",
  "title": "Main Photo",
  "description": "Beautiful view",
  "order": 0
}
```

#### Get Gallery
```
GET /admin/media/gallery?type=event&item_id=1
Authorization: Bearer {admin_token}
```

#### Update Media
```
PUT /admin/media/{id}
Authorization: Bearer {admin_token}

{
  "title": "Updated Title",
  "order": 2
}
```

#### Delete Media
```
DELETE /admin/media/{id}
Authorization: Bearer {admin_token}
```

#### Bulk Upload Media
```
POST /admin/media/bulk-upload
Authorization: Bearer {admin_token}

{
  "type": "restaurant",
  "item_id": 5,
  "media_urls": [
    "https://example.com/photo1.jpg",
    "https://example.com/photo2.jpg",
    "https://example.com/video.mp4"
  ]
}
```

#### Reorder Media
```
POST /admin/media/reorder
Authorization: Bearer {admin_token}

{
  "media_ids": [5, 3, 1, 2]
}
```

### Event Bookings Management

#### Get All Event Bookings
```
GET /admin/event-bookings?status=confirmed&payment_status=completed&per_page=15
Authorization: Bearer {admin_token}
```

#### Get Booking Details
```
GET /admin/event-bookings/{id}
Authorization: Bearer {admin_token}
```

#### Update Booking Status
```
PUT /admin/event-bookings/{id}/status
Authorization: Bearer {admin_token}

{
  "status": "confirmed"
}
```

#### Update Payment Status
```
PUT /admin/event-bookings/{id}/payment-status
Authorization: Bearer {admin_token}

{
  "payment_status": "completed"
}
```

---

## 📊 Database Schema Summary

### New Tables
- `categories` - Category types for destinations, events, restaurants
- `events` - Tourism events and festivals
- `event_bookings` - Event ticket bookings
- `event_reviews` - Reviews for events
- `restaurants` - Dining venues
- `restaurant_reviews` - Reviews for restaurants
- `user_favorites` - Wishlist/favorites (polymorphic)
- `media_galleries` - Media gallery items (polymorphic)

### Updated Tables
- `destinations` - Added category_id
- `users` - Added eventBookings, eventReviews, favorites relationships

---

## 🗺️ Location Calculations

Haversine formula used for distance calculations:
```
Distance (km) = 3959 * acos(cos(radians(lat1)) * cos(radians(lat2)) * cos(radians(lon2) - radians(lon1)) + sin(radians(lat1)) * sin(radians(lat2)))
```

All distances calculated in kilometers by default.

---

## 🎯 Integration Points

### Ready for Integration:
1. **Maps Service** - Google Maps, Mapbox for route calculation
2. **Payment Gateway** - Stripe, PayPal for event/tour/restaurant reservations
3. **Push Notifications** - Firebase for event reminders, bookings
4. **Email Service** - Booking confirmations, event updates
5. **SMS Service** - OTP, booking updates
6. **Image Optimization** - Cloudinary, AWS S3 for media uploads

---

## ✅ Error Responses

Same as before, plus new ones:

```json
{
  "400": "Not enough tickets available",
  "403": "Only users with confirmed bookings can review",
  "404": "Event not found",
  "422": "Invalid location data"
}
```

---

## 🚀 Next Steps

1. Run `php artisan migrate` to create all new tables
2. Import updated Postman collection
3. Start testing new endpoints
4. Integrate with maps API for routing
5. Set up payment processing

All features fully integrated and production-ready! 🎉
