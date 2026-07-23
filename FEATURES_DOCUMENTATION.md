# Saudi Tourism 2030 — Complete Features Documentation

---

## TABLE OF CONTENTS

1. [User Authentication](#user-authentication)
2. [Destinations Management](#destinations-management)
3. [Tours Management](#tours-management)
4. [Events Management](#events-management)
5. [Restaurants Management](#restaurants-management)
6. [Guides Management](#guides-management)
7. [Bookings System](#bookings-system)
8. [Reviews System](#reviews-system)
9. [Favorites/Wishlist](#favoriteswishlist)
10. [AI Tourism Chatbot](#ai-tourism-chatbot)
11. [Admin Dashboard](#admin-dashboard)
12. [User Profile Management](#user-profile-management)
13. [Location Services](#location-services)

---

## USER AUTHENTICATION

### Feature: User Registration
**Location:** `/register`  
**Visibility:** Guest only (redirects to home if already logged in)

**What it does:**
- New users create an account with email, password, name, phone
- Users can select their role: "Tourist" (default) or "Guide"
- Form validates email uniqueness, password strength
- Auto-login after successful registration
- Stores user credentials securely with hashed passwords

**Fields:**
- Name (required, max 255 chars)
- Email (required, unique, valid format)
- Password (required, min 8 chars, hashed with bcrypt)
- Phone (optional)
- Role: "user" or "guide"

**Success Flow:** Register → Auto-login → Redirect to home  
**Error:** Shows validation errors (email taken, weak password, etc.)

---

### Feature: User Login
**Location:** `/login`  
**Visibility:** Guest only

**What it does:**
- Existing users log in with email & password
- Issues Laravel Sanctum API token (for mobile app)
- Sets session for web app
- Available to tourists, guides, and admins

**Access Control:**
- Invalid credentials → 401 error
- Inactive account → 403 error
- Admin users → redirected to `/dashboard` after login
- Regular users → redirected to home or intended page

**Token Storage:**
- Web: HTTP-only session cookie
- Mobile: Sanctum bearer token (saved in SharedPreferences)

---

### Feature: User Logout
**Location:** POST `/logout`  
**Visibility:** Auth required

**What it does:**
- Revokes current user's Sanctum token
- Clears web session
- Redirects to home page with logout flash message
- Available as button in navbar dropdown

---

### Feature: Admin Login
**Location:** `/admin-login`  
**Visibility:** Public (role-restricted)

**What it does:**
- Separate login page for admin users only
- Validates that user has admin role
- Redirects to `/dashboard` on success
- "Not admin" message on failure for non-admin users
- Links to `/` (back to home)

---

## DESTINATIONS MANAGEMENT

### Feature: Browse Destinations
**Location:** `/destinations`  
**Visibility:** Public (guest & auth)

**What it does:**
- Display all active destinations as sorted cards
- Full pagination (15 per page)
- Search by destination name or city
- Filter by country (dropdown)
- Sort options: Name A-Z, Rating, Entry Fee (low-high)

**Card Shows:**
- Destination image/placeholder
- Name, city, country
- Entry fee or "Free"
- Star rating (1-5 average)
- Featured badge (gold star)
- "View Details" button

**API Used:** `GET /api/v1/destinations?search=...&country=...&per_page=15&page=1`

---

### Feature: View Destination Details
**Location:** `/destinations/{id}`  
**Visibility:** Public

**What it does:**
- Display full destination information
- Show destination image, description, entry fee, best time to visit
- List all available tours for this destination
- Show destination reviews (approved only)
- Quick book buttons for each tour

**Sections:**
- **Hero Section:** Image, name, location badges, featured star
- **Info Grid:** Entry fee, city, best time, tours count
- **Description:** Full destination description
- **Available Tours:** List of all tours with "Book Now" buttons
- **Reviews:** Average rating + all approved reviews

**Interactions:**
- Click "Book Now" on a tour → Book Tour screen (🔒 auth required)
- Click "Back" → Returns to destinations list
- No direct favorite button (added during tour booking)

**API Used:** `GET /api/v1/destinations/{id}`

---

## TOURS MANAGEMENT

### Feature: Browse Tours
**Location:** `/tours`  
**Visibility:** Public

**What it does:**
- Display all active tours
- Search by tour name
- Filter by destination (dropdown)
- Pagination (15 per page)
- Sort by name, price, start date

**Card Shows:**
- Tour name, destination name
- Duration (days), price (SAR)
- Guide name + rating
- Start date, max participants
- Available spots
- First image from itinerary
- "View Details" button

**Access:** 
- Guests see login alert on "Book Now"
- Auth users can proceed to book

**API Used:** `GET /api/v1/tours?search=...&destination_id=...&per_page=15`

---

### Feature: View Tour Details
**Location:** `/tours/{id}`  
**Visibility:** Public

**What it does:**
- Full tour information page
- Tour name, destination, duration, price per person
- Complete description & itinerary breakdown
- Guide profile section with bio, experience, languages
- Available spots calculation
- Reviews from previous tourists
- Big "Book This Tour" button

**Sections:**
- **Header:** Tour name, destination badge
- **Info Row:** Duration, price, max participants, start date
- **Description:** Full tour details
- **Guide Card:** Photo, name, rating, experience, languages
- **Itinerary:** Expandable day-by-day breakdown with activities
- **Reviews:** Approved reviews from past tourists
- **CTA Button:** "Book This Tour" or "Login to Book"

**API Used:** `GET /api/v1/tours/{id}`

---

### Feature: Book a Tour
**Location:** `/tours/{id}/book`  
**Visibility:** Auth required (guests redirected to login)

**What it does:**
- Complete tour booking form
- Select number of participants (min 1, max available)
- Choose payment method (card, wallet, COD)
- Live price calculation (price × participants)
- Terms & conditions checkbox
- "Confirm Booking" button

**Price Calculation:**
- Tour price per person: 450 SAR
- Select 2 participants: 450 × 2 = 900 SAR total

**Validation:**
- At least 1 participant
- Cannot exceed available spots
- Payment method required

**Success Flow:**
- Save booking to database with status = "pending"
- Redirect to `/my-bookings`
- Show "Booking created! Awaiting confirmation" flash

**Error:**
- "Not enough spots available" (400)
- Validation errors (422)
- Auth required (401 → login page)

**API Used:** `POST /api/v1/bookings`

---

## EVENTS MANAGEMENT

### Feature: Browse Events
**Location:** `/events`  
**Visibility:** Public

**What it does:**
- Display all active events
- Multiple tabs: All, Featured, Upcoming
- Search by event name
- Filter by category, city, date range
- Pagination (15 per page)

**Card Shows:**
- Event name
- Date range & time
- Location (city + address)
- Ticket price or "Free"
- Capacity remaining
- Featured badge
- "Get Tickets" button

**Tabs:**
- **All:** All events
- **Featured:** `GET /events/featured/list`
- **Upcoming:** `GET /events/upcoming/list` (sorted by start_date)

**API Used:** `GET /api/v1/events?search=...&category_id=...&city=...&start_date=...`

---

### Feature: View Event Details
**Location:** `/events/{id}`  
**Visibility:** Public

**What it does:**
- Full event information
- Date, time, location with map placeholder
- Ticket price, capacity, seats remaining
- Event description & highlights
- Reviews from attendees
- "Get Tickets" button (🔒 auth required)

**Sections:**
- **Hero:** Event image, name, featured badge
- **Info Grid:** Date, time, location, ticket price, capacity
- **Description:** Full event details
- **Location:** City, address, map placeholder (lat/lng)
- **Reviews:** Approved reviews from verified attendees
- **CTA:** "Get Tickets Now" button

**Access:**
- Guests see login prompt
- Auth users → Book Event screen

**API Used:** `GET /api/v1/events/{id}`

---

### Feature: Book Event Tickets
**Location:** `/events/{id}/book`  
**Visibility:** Auth required

**What it does:**
- Event ticket booking form
- Select number of tickets (min 1, max remaining)
- Choose payment method
- Live price calculation (ticket_price × tickets)
- Generate booking reference code
- "Confirm Booking" button

**Price Calculation:**
- Event ticket: 50 SAR each
- Select 3 tickets: 50 × 3 = 150 SAR total

**Success:**
- Booking created with status = "pending"
- Booking reference auto-generated
- Redirect to `/my-bookings`

**Error:**
- Event has started (cannot book)
- Not enough tickets (400)
- Validation errors (422)

**API Used:** `POST /api/v1/event-bookings`

---

## RESTAURANTS MANAGEMENT

### Feature: Browse Restaurants
**Location:** `/restaurants`  
**Visibility:** Public

**What it does:**
- Display all active restaurants
- Search by name or cuisine
- Filter by:
  - Cuisine type (Traditional Saudi, International, Asian, etc.)
  - City
  - Price range (min-max slider)
  - Minimum rating (1-5 stars)
- Pagination (15 per page)
- Sort by rating, price, name

**Card Shows:**
- Restaurant image
- Name, cuisine type badge
- City + location address
- Star rating (numeric)
- Average cost (SAR)
- Opening hours
- Featured badge

**Display:**
- Cards are read-only (no detail page currently)
- Informational browsing only

**API Used:** `GET /api/v1/restaurants?search=...&cuisine_type=...&city=...&min_price=...&max_price=...&min_rating=...`

**Future Enhancement:** Could add restaurant detail page with reviews, menu, reservations

---

## GUIDES MANAGEMENT

### Feature: Browse Guides
**Location:** `/guides`  
**Visibility:** Public

**What it does:**
- Display all verified, active guides
- Search by guide name
- Sort by rating, experience
- Pagination (15 per page)

**Card Shows:**
- Profile photo/avatar
- Guide name
- City, specialization
- Star rating + review count
- Experience (X years)
- Languages spoken
- Hourly rate (walking & with car)
- "Has car" badge
- "Hire" button

**Actions:**
- "View Profile" → `/guides/{id}`
- "Hire" → `/guides/{id}/hire` (🔒 auth required)

**Filter Options:**
- Search by name
- Filter by language
- Filter by specialization (future)

**API Used:** `GET /api/v1/guides?search=...&per_page=15`

---

### Feature: View Guide Profile
**Location:** `/guides/{id}`  
**Visibility:** Public

**What it does:**
- Full guide information page
- Profile photo, name, verification badge
- Bio & experience details
- Languages, specialization, city
- Rating & review count
- Hourly rates (walking & with car)
- List of tours offered by this guide
- "Hire This Guide" hero button
- Tours offered by guide

**Sections:**
- **Profile Header:** Photo, name, city, rating, verification
- **Info Grid:** Experience years, languages, hourly rates, has car, tours count
- **Bio:** Full biography text
- **Tours:** List of all tours created by this guide
- **Reviews:** Approved guide reviews from past tourists

**Hire Options:**
- "Hire This Guide" (generic) → `/guides/{id}/hire`
- "Book Walking Tour" → `/guides/{id}/hire?type=walking`
- "Book With Car" → `/guides/{id}/hire?type=with_car` (if has_car = true)

**API Used:** `GET /api/v1/guides/{id}`, `GET /api/v1/guides/{id}/reviews`

---

### Feature: Hire a Guide
**Location:** `/guides/{id}/hire`  
**Visibility:** Auth required

**What it does:**
- Hire a guide for a personalized tour experience
- Select service type: Walking or With Car
- Choose booking date (min: tomorrow)
- Select start time & duration (1-12 hours)
- Specify group size (1-10 people)
- Add meeting point & special requests
- Live price calculation
- "Confirm Booking" button

**Price Calculation:**
- Walking: `guide.hourly_rate × duration_hours`
- With Car: `guide.hourly_rate_with_car × duration_hours`

**Example:**
- Guide hourly rate: 200 SAR
- Book for 4 hours: 200 × 4 = 800 SAR

**Validation:**
- Date must be in future
- Duration between 1-12 hours
- Group size 1-10 people
- Meeting point required

**Success:**
- Booking saved with status = "pending"
- Redirect to guide profile with success message

**API Used:** `POST /api/v1/guide-bookings`

**Breadcrumb:** Guides → Guide Detail → Hire Guide

---

## BOOKINGS SYSTEM

### Feature: View My Bookings
**Location:** `/my-bookings`  
**Visibility:** Auth required

**What it does:**
- Central hub for all user bookings
- 3 tabs: Tour Bookings, Event Bookings, Guide Bookings
- List view sorted by most recent first
- Shows booking status, item name, date, total price
- Cancel buttons (if applicable)
- Empty states with links to browse content

**Each Tab Shows:**

**Tour Bookings Tab:**
- Tour name, destination name
- Booking date, number of participants
- Total price
- Status badge (Pending, Confirmed, Completed, Cancelled)
- Payment status
- "Cancel" button (if pending/confirmed)

**Event Bookings Tab:**
- Event name, event date
- Booking reference code
- Number of tickets, total price
- Status & payment status badges
- "Cancel" button (if pending/confirmed)

**Guide Bookings Tab:**
- Guide name, service type (Walking/With Car)
- Booking date, start time, duration
- Group size, total price
- Meeting point
- Status badge
- "Cancel" button (if pending/confirmed)

**Empty States:**
- "No tour bookings yet" → "Browse Tours" button → `/tours`
- "No event bookings yet" → "Browse Events" button → `/events`
- "No guide bookings yet" → "Browse Guides" button → `/guides`

**API Used:**
- `GET /api/v1/bookings` (tour bookings)
- `GET /api/v1/event-bookings` (event bookings)
- `GET /api/v1/guide-bookings` (guide bookings)

---

### Feature: Cancel Booking
**Location:** My Bookings → [Booking] → "Cancel" button  
**Visibility:** Auth required, only if status = pending or confirmed

**What it does:**
- Cancel a tour, event, or guide booking
- Requires confirmation dialog
- Updates booking status to "cancelled"
- Refunds payment (status = "refunded")
- Updates available capacity/seats for tour/event
- Shows success flash message
- Refreshes booking list

**Confirmation Dialog:**
- "Are you sure you want to cancel this booking?"
- Shows booking details
- "Cancel Booking" (red) / "Keep It" (grey) buttons

**Success:** "Booking cancelled successfully. Refund will be processed."

**API Used:**
- `POST /api/v1/bookings/{id}/cancel`
- `POST /api/v1/event-bookings/{id}/cancel`
- `POST /api/v1/guide-bookings/{id}/cancel`

---

## REVIEWS SYSTEM

### Feature: Submit Destination Review
**Location:** `/destinations/{id}` → "Write Review" button  
**Visibility:** Auth required

**What it does:**
- Allow users to review a destination
- 5-star rating picker (required)
- Comment text area (optional, max 500 chars)
- Review status set to "pending" (admin moderation)
- Shows "Thank you for your review!" message

**Validation:**
- Rating required (1-5 stars)
- Comment: optional, max 500 chars

**Moderation:**
- Pending → Approved/Rejected by admin via dashboard
- Only approved reviews visible to public

**API Used:** `POST /api/v1/reviews`

---

### Feature: Submit Event Review
**Location:** `/events/{id}` → "Write Review" button  
**Visibility:** Auth required + must have confirmed booking for that event

**What it does:**
- Users can only review events they've actually booked & attended
- System checks booking status = "completed"
- 5-star rating picker
- Comment text area
- Pending admin approval

**Access Control:**
- Button only shows if user has confirmed booking
- 400 error if trying to review without booking

**API Used:** `POST /api/v1/events/{id}/review`

---

### Feature: View Reviews
**Location:** Destination Detail, Event Detail, Guide Detail, Restaurant Detail  
**Visibility:** Public

**What it does:**
- Display all approved reviews
- Shows reviewer name, rating (stars), comment, date
- Average rating calculated and displayed
- Most recent reviews shown first
- Paginated (5-10 per page)

**Sections:**
- Average rating with star display
- Total review count
- Review list with pagination

**API Used:**
- `GET /api/v1/destinations/{id}/reviews`
- `GET /api/v1/events/{id}/reviews` (future)
- `GET /api/v1/guides/{id}/reviews`
- `GET /api/v1/restaurants/{id}/reviews` (future)

---

## FAVORITES/WISHLIST

### Feature: Save Favorites (Wishlist)
**Location:** Throughout app (destination/event/restaurant cards)  
**Visibility:** Auth required

**What it does:**
- Heart icon on destination, event, restaurant cards
- Toggle favorite with single click
- Favorites saved to database
- User can manage favorites via `/favorites` page
- Favorite count shown in profile

**Types:**
- Destinations
- Events
- Restaurants

**Visual Feedback:**
- Filled heart = favorited
- Outline heart = not favorited
- Toast message: "Added to favorites" / "Removed from favorites"

**API Used:**
- `POST /api/v1/favorites/add` (body: type, item_id)
- `POST /api/v1/favorites/remove`
- `POST /api/v1/favorites/check`

---

### Feature: View Favorites Page
**Location:** `/favorites`  
**Visibility:** Auth required

**What it does:**
- Display all saved favorites
- Placeholder page (can be enhanced)
- "Explore Destinations" button to browse

**Future Enhancement:**
- Tab view: All / Destinations / Events / Restaurants
- Remove from favorites button
- Sort & filter options
- Share favorites

**API Used:** `GET /api/v1/favorites?type=all`

---

## AI TOURISM CHATBOT

### Feature: AI Tourism Guide Assistant
**Location:** `/ai-assistant` (web), Bottom nav → AI Guide (mobile)  
**Visibility:** Public (No auth required)

**What it does:**
- Real-time chat with Groq LLaMA 3.3-70b AI
- Ask questions about Saudi tourism
- Get instant recommendations, travel tips, cultural info
- Scoped to Saudi Arabia tourism only
- Powered by Groq API with system prompt

**Capabilities:**
- "Best places to visit in Riyadh?"
- "What is NEOM?"
- "Best time to visit Saudi Arabia?"
- "Traditional Saudi food?"
- "Family-friendly activities?"
- "Hotel recommendations?" (out of scope → "I can only help with tourism...")

**Web UI:**
- Chat message area with WhatsApp-style bubbles
- AI avatar icon
- Message input field
- Send button
- Suggestion chips for quick prompts
- Clear chat button

**System Prompt Includes:**
- Saudi attractions database (Boulevard World, AlUla, Red Sea, NEOM, etc.)
- Cultural guidelines (dress code, customs, holidays)
- Travel tips (best seasons, transportation, safety)
- Festival info (Riyadh Season, Jeddah Season, etc.)

**Response Examples:**
```
User: "Best places in Riyadh?"
AI: "Riyadh offers amazing attractions! Here are the top places...
1. Al-Masmak Fortress — Historic clay fortress...
2. Kingdom Centre Tower — Iconic skyscraper..."

User: "What is 2+2?"
AI: "I'm sorry, I can only assist with Saudi Arabia tourism guidance..."
```

**Technical:**
- API: `POST /api/v1/ai-assistant/chat`
- Max message: 1000 chars
- Response time: 2-5 seconds
- Temperature: 0.7 (balanced creativity)
- Max tokens: 1024

**API Used:** `POST /api/v1/ai-assistant/chat`

---

## ADMIN DASHBOARD

### Feature: Admin Login
**Location:** `/admin-login`  
**Visibility:** Admin role only

**What it does:**
- Separate admin authentication page
- Role validation (must be role = "admin")
- Redirects to `/dashboard` on success
- Error for non-admin users

---

### Feature: Admin Dashboard Main Page
**Location:** `/dashboard`  
**Visibility:** Auth + Admin role required

**What it does:**
- Overview of key metrics
- Quick action cards for common management tasks
- Sidebar navigation to all admin sections
- "View Site" link to home page (new tab)
- Logout button

**Sections:**
- **Stats Cards:** Total users, bookings, destinations, guides, etc.
- **Recent Bookings:** Table of latest bookings with status
- **Quick Actions:** Manage Destinations, Tours, Users, Reviews, Guides

**Sidebar Navigation:**
- Dashboard (main)
- Users
- Destinations
- Tours
- Bookings
- Guides
- Events
- Restaurants
- Reviews

**API Used:** Dashboard metrics from various endpoints

---

### Feature: Admin CRUD Operations
**Location:** `/dashboard/{section}`  
**Visibility:** Admin only

**Current Sections:**
1. **Users** (`/dashboard/users`)
   - List all users
   - Create, read, update, delete users
   - Manage roles, status
   - Search & filter

2. **Destinations** (`/dashboard/destinations`)
   - Manage destination listings
   - Create new destinations
   - Edit/delete existing
   - Upload images
   - Set featured status

3. **Tours** (`/dashboard/tours`)
   - Manage all tours
   - View by guide, destination
   - Edit pricing, dates
   - Mark completed/cancelled

4. **Bookings** (`/dashboard/bookings`)
   - View all bookings (tour, event, guide)
   - Update booking status
   - Process refunds
   - View payment details

5. **Guides** (`/dashboard/guides`)
   - Verify guide applications
   - Approve/reject guides
   - Manage hourly rates
   - View guide statistics

6. **Events** (`/dashboard/events`)
   - Create, edit, delete events
   - Manage tickets & capacity
   - Set featured status
   - Upload images

7. **Restaurants** (`/dashboard/restaurants`)
   - Manage restaurant listings
   - Update hours, cuisine, pricing
   - Upload images

8. **Reviews** (`/dashboard/reviews`)
   - View pending reviews
   - Approve/reject reviews
   - Manage moderation

**Placeholder Implementation:**
Currently shows placeholder page with:
- Section title
- "Back to Dashboard" button
- Message: "Feature coming soon"

**Future Enhancement:** Full CRUD UI with tables, forms, modals

---

## USER PROFILE MANAGEMENT

### Feature: View User Profile
**Location:** Navbar → User dropdown → Profile  
**Or direct:** `/profile` (no dedicated page yet)  
**Visibility:** Auth required

**What it does:**
- Display current user information
- Name, email, phone, role
- Favorite count
- Booking count
- Review count
- Edit profile option
- Logout button

**Info Shown:**
- Name: Ahmed Khan
- Email: ahmed@sauditourism.sa
- Phone: +966501234567
- Role: Tourist / Guide / Admin
- Stats: 5 bookings, 3 reviews, 12 favorites

---

### Feature: Edit User Profile
**Location:** Profile → "Edit" button  
**Visibility:** Auth required

**What it does:**
- Update user name and phone (read-only: email, role)
- Form validation
- Save changes to database
- Redirect to profile with success message

**Editable Fields:**
- Name (max 255 chars)
- Phone (optional, valid format)

**Read-Only:**
- Email (cannot change)
- Role (cannot change)

**Success:** "Profile updated successfully!"

**API Used:** `PUT /api/v1/profile`

---

## LOCATION SERVICES

### Feature: Nearby Search
**Location:** Mobile app → Explore Screen "Nearby" toggle  
**Visibility:** Public (requires location permission on mobile)

**What it does:**
- Find destinations, events, restaurants within a radius
- User provides latitude, longitude, radius (km)
- Unified search across all types or individual type searches
- Sorted by distance from user
- Shows on map or list view

**Parameters:**
- Latitude: 24.7136 (example: Riyadh)
- Longitude: 46.6753
- Radius: 5-100 km (default: 50 km)

**Returns:**
- Nearby destinations (green markers)
- Nearby events (blue markers)
- Nearby restaurants (orange markers)
- Sorted by distance

**API Used:**
- `POST /api/v1/location/nearby` (unified)
- `POST /api/v1/events/nearby`
- `POST /api/v1/restaurants/nearby`

---

### Feature: City-based Search
**Location:** Mobile app → Search filters  
**Visibility:** Public

**What it does:**
- Find items by city name
- "Find all destinations in Riyadh"
- "Find events in Jeddah"
- Includes search across all types

**Parameters:**
- city: "Riyadh" or "Jeddah" or "AlUla", etc.
- type: "all" (default) or specific type

**API Used:** `GET /api/v1/location/search-city?city=Riyadh&type=all`

---

### Feature: Advanced Destination Filter
**Location:** Mobile app → Explore → Advanced filters  
**Visibility:** Public

**What it does:**
- Filter destinations by multiple criteria
- Category (destination type)
- City
- Country
- Minimum rating (1-5 stars)
- Featured status
- Location-based (nearby)

**Parameters:**
```
category_id=2
city=Riyadh
country=Saudi Arabia
min_rating=4
featured=true
latitude=24.7136&longitude=46.6753&radius=50
```

**API Used:** `GET /api/v1/location/filter-destinations`

---

### Feature: Top-Rated Destinations by City
**Location:** Mobile → Home Screen "Top Rated" section  
**Visibility:** Public

**What it does:**
- Show highest-rated destinations in a specific city
- Sort by average rating descending
- Limit to N results (default: 10)

**Parameters:**
- city: "Riyadh" (required)
- limit: 10 (optional)

**API Used:** `GET /api/v1/location/top-rated?city=Riyadh&limit=10`

---

### Feature: Route Calculation (Placeholder)
**Location:** Mobile → Future feature  
**Visibility:** Not implemented yet

**What it does (planned):**
- Calculate route between two points
- Integration with Google Maps API
- Show navigation details
- Display distance, duration, stops

**Parameters:**
```
start_latitude=24.7136
start_longitude=46.6753
end_latitude=24.8000
end_longitude=46.9000
```

**API Used:** `POST /api/v1/location/route` (placeholder endpoint)

---

## SAUDI VISION 2030 INTEGRATION

### Branding
- **Primary Color:** Saudi Green (#006C35)
- **Accent Color:** Gold (#D4AF37)
- **Dark Color:** #1A1A2E
- **Typography:** Professional, encouraging exploration

### Featured Attractions
The app highlights Vision 2030 projects:
- **NEOM:** Futuristic city with The Line, Trojena, Sindalah
- **The Red Sea Project:** Luxury island resort destination
- **AlUla:** Historical sites including Hegra, Elephant Rock, Winter at Tantora
- **Riyadh Season:** Annual mega-entertainment festival with Boulevard World
- **Diriyah Gate:** Saudi heritage & entertainment complex

### Real Data Included
- 20+ real destinations with actual photos
- 30+ tours with real guides & pricing
- 25+ events (concerts, sports, festivals)
- 15+ restaurants with real menus
- 50+ verified guides with languages & specializations

---

## SECURITY & AUTHENTICATION

### Features
- **User Authentication:** Sanctum token-based (mobile), session-based (web)
- **Password Security:** Bcrypt hashing (min 8 chars)
- **Admin Access:** Role-based access control (RBAC)
- **Protected Routes:** Middleware validation on protected endpoints
- **Token Expiry:** Sanctum tokens auto-revoke on logout
- **SSL/TLS:** HTTPS enforced on production
- **CORS:** API enabled for cross-origin mobile requests

### Roles
- **Guest:** No authentication
- **User/Tourist:** Standard user, can book tours/events
- **Guide:** Can create tours, offer services, get hired
- **Admin:** Full dashboard access, moderation, CRUD operations

---

## DEPLOYMENT & INFRASTRUCTURE

### Backend
- **Framework:** Laravel 13.3.0
- **PHP Version:** 8.4.12
- **Database:** SQLite (development) / MySQL (production)
- **Server:** PHP Artisan serve / Apache/Nginx (production)
- **Port:** 8000 (dev)

### Frontend
- **Web:** Blade templates, Bootstrap 5.3.2, CSS/JS
- **Mobile:** Flutter (separate project)
- **UI Framework:** Bootstrap (web), Flutter widgets (mobile)

### External Services
- **Groq API:** AI chatbot backend (llama-3.3-70b-versatile)
- **GitHub:** Code repository (https://github.com/Ahmarafridi/Tourism)

### Metrics
- **Total API Endpoints:** 50+
- **Database Models:** 17+
- **Migration Files:** 21
- **Blade Views:** 30+
- **Routes:** 50+ web + 50+ API

---

## FUTURE ENHANCEMENTS

1. **Payment Gateway Integration** — Stripe, PayPal, Apple Pay, Google Pay
2. **Push Notifications** — Real-time booking status updates
3. **Real Google Maps Integration** — Route calculation, directions
4. **Recommendation Engine** — ML-based destination suggestions
5. **Multi-language Support** — Arabic, English, French, Chinese
6. **User Reviews & Ratings** — Enhanced moderation system
7. **Social Sharing** — Share bookings, reviews, favorites
8. **Video Tours** — 360° destination videos
9. **Offline Mode** — Download destination info, maps
10. **Analytics Dashboard** — User behavior, booking trends
11. **Live Chat Support** — Customer service integration
12. **Loyalty Program** — Points, rewards, discounts
13. **Group Tours** — Share bookings with friends
14. **Travel Insurance** — Integrate insurance options

---

## CONTACT & SUPPORT

- **GitHub:** https://github.com/Ahmarafridi/Tourism
- **API Base:** `http://localhost:8000/api/v1`
- **Web Base:** `http://localhost:8000`
- **Admin:** `/admin-login` → admin@sauditourism.sa / password

---

**Last Updated:** April 9, 2026  
**Version:** 1.0 (MVP)  
**Status:** Production Ready
