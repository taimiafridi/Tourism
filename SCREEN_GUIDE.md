# Saudi Tourism 2030 - Screen Guide

---

## NAVIGATION FLOW MAP

### App Entry Flow
```
App Launch
  └→ Splash Screen
       ├→ [Has saved token + valid] → Home Screen
       ├→ [Has saved token + expired] → Login Screen
       ├→ [No token + first install] → Onboarding Screen → Login Screen
       └→ [No token + returning] → Login Screen
```

### Auth Flow
```
Login Screen
  ├→ [Success] → Home Screen
  ├→ [Error 401] → Stay (show "Invalid credentials")
  ├→ [Error 403] → Stay (show "Account inactive")
  └→ [Tap "Register"] → Register Screen

Register Screen
  ├→ [Success] → Home Screen (auto-login)
  ├→ [Error 422] → Stay (show field errors)
  └→ [Tap "Login"] → Login Screen
```

### Main Navigation (Bottom Tab Bar)
```
Bottom Navigation Bar (visible on all main screens)
  ├→ Tab 1: Home Screen
  ├→ Tab 2: Explore Screen
  ├→ Tab 3: AI Chatbot Screen
  ├→ Tab 4: My Bookings Screen (🔒 auth required)
  ├→ Tab 5: Favorites Screen (🔒 auth required)
  └→ Tab 6: Profile Screen (🔒 auth required)
```

### Home Screen Flow
```
Home Screen
  ├→ [Search bar] → Search Results Screen
  ├→ [Featured destination card] → Destination Detail Screen
  ├→ [Upcoming event card] → Event Detail Screen
  ├→ [Featured restaurant card] → Restaurant Detail Screen
  ├→ [Top guide card] → Guide Detail Screen
  ├→ [AI Guide FAB / icon] → AI Chatbot Screen
  ├→ ["See All" destinations] → Destinations List Screen
  ├→ ["See All" events] → Events List Screen
  ├→ ["See All" restaurants] → Restaurants List Screen
  ├→ ["See All" guides] → Guides List Screen
  └→ [Notification bell] → Notifications Screen
```

### Destination Flow
```
Destinations List Screen
  └→ [Tap card] → Destination Detail Screen
                    ├→ [♡ Favorite] → Toggle favorite (API call, stay)
                    ├→ [Tour "Book Now"] → Book Tour Screen (🔒)
                    │                       ├→ [Confirm] → Booking Confirmation Screen
                    │                       │               ├→ ["View My Bookings"] → My Bookings Screen
                    │                       │               └→ ["Back to Home"] → Home Screen
                    │                       └→ [Not logged in] → Login Screen → back here
                    ├→ ["Write Review"] → Review Submit Screen (🔒)
                    │                     └→ [Submit] → Back to Destination Detail
                    └→ ["Browse All Tours"] → Tours List Screen (if no tours)
```

### Tour Flow
```
Tours List Screen
  └→ [Tap card] → Tour Detail Screen
                    ├→ [Guide section tap] → Guide Detail Screen
                    └→ ["Book This Tour"] → Book Tour Screen (🔒)
                                            ├→ [Select participants + payment]
                                            ├→ ["Confirm Booking"] → POST /bookings
                                            │   ├→ [Success] → Booking Confirmation Screen
                                            │   └→ [Error 400 "No spots"] → Show error dialog
                                            └→ [Not logged in] → Login Screen
```

### Event Flow
```
Events List Screen
  ├→ [Tab: All] → GET /events
  ├→ [Tab: Featured] → GET /events/featured/list
  ├→ [Tab: Upcoming] → GET /events/upcoming/list
  └→ [Tap card] → Event Detail Screen
                    ├→ [♡ Favorite] → Toggle favorite (API call, stay)
                    ├→ ["Book Tickets"] → Book Event Screen (🔒)
                    │                     ├→ [Select tickets + payment]
                    │                     ├→ ["Confirm Booking"] → POST /event-bookings
                    │                     │   ├→ [Success] → Booking Confirmation Screen
                    │                     │   └→ [Error 400] → Show error dialog
                    │                     └→ [Not logged in] → Login Screen
                    └→ ["Write Review"] → Review Submit Screen (🔒, needs confirmed booking)
                                          └→ [Submit] → Back to Event Detail
```

### Restaurant Flow
```
Restaurants List Screen
  └→ [Tap card] → Restaurant Detail Screen
                    ├→ [♡ Favorite] → Toggle favorite (API call, stay)
                    ├→ [Phone tap] → Open phone dialer
                    ├→ [Email tap] → Open email app
                    ├→ [Website tap] → Open browser
                    └→ ["Write Review"] → Review Submit Screen (🔒)
                                          └→ [Submit] → Back to Restaurant Detail
```

### Guide Flow
```
Guides List Screen
  ├→ [Tap "View Profile"] → Guide Detail Screen
  │                          ├→ [Tour card tap] → Tour Detail Screen
  │                          ├→ ["Hire This Guide"] → Hire Guide Screen (🔒)
  │                          ├→ ["Book Walking Tour"] → Hire Guide Screen (?type=walking) (🔒)
  │                          └→ ["Book With Car"] → Hire Guide Screen (?type=with_car) (🔒)
  └→ [Tap "Hire"] → Hire Guide Screen (🔒)

Hire Guide Screen (🔒 auth required)
  ├→ [Select service type + date + time + duration + group size]
  ├→ ["Confirm Booking"] → POST /guide-bookings
  │   ├→ [Success] → Booking Confirmation Screen
  │   └→ [Error] → Show error dialog
  └→ [Not logged in] → Login Screen
```

### AI Chatbot Flow
```
AI Chatbot Screen (no auth required)
  ├→ [Type message + send] → POST /ai-assistant/chat → Show AI reply
  ├→ [Tap suggestion chip] → Auto-send prompt → Show AI reply
  └→ [Back button] → Previous screen
  (Self-contained — no outbound navigation)
```

### Bookings Flow
```
My Bookings Screen (🔒)
  ├→ [Tab: Tour Bookings] → List from GET /bookings
  │   ├→ [Tap booking card] → Booking Detail Screen
  │   ├→ ["Cancel"] → Confirm dialog → POST /bookings/{id}/cancel → Refresh
  │   └→ [Empty state "Browse Tours"] → Tours List Screen
  ├→ [Tab: Event Bookings] → List from GET /event-bookings
  │   ├→ [Tap booking card] → Booking Detail Screen
  │   ├→ ["Cancel"] → Confirm dialog → POST /event-bookings/{id}/cancel → Refresh
  │   └→ [Empty state "Browse Events"] → Events List Screen
  └→ [Tab: Guide Bookings] → List from GET /guide-bookings
      ├→ [Tap booking card] → Booking Detail Screen
      ├→ ["Cancel"] → Confirm dialog → POST /guide-bookings/{id}/cancel → Refresh
      └→ [Empty state "Browse Guides"] → Guides List Screen

Booking Detail Screen (🔒)
  ├→ ["Cancel Booking"] → Confirm dialog → Cancel API → Refresh
  ├→ ["Leave Review"] → Review Submit Screen (only if completed)
  └→ ["Contact Guide"] → Open phone dialer (tour bookings)
```

### Favorites Flow
```
Favorites Screen (🔒)
  ├→ [Tab: All / Destinations / Events / Restaurants]
  ├→ [Tap destination card] → Destination Detail Screen
  ├→ [Tap event card] → Event Detail Screen
  ├→ [Tap restaurant card] → Restaurant Detail Screen
  ├→ [Swipe / tap ♡ to remove] → POST /favorites/remove → Refresh
  └→ [Empty state "Explore"] → Explore Screen
```

### Profile Flow
```
Profile Screen (🔒)
  ├→ ["Edit Profile"] → Edit Profile Screen
  │                      ├→ ["Save Changes"] → PUT /profile → Back to Profile
  │                      └→ ["Cancel"] → Back to Profile
  ├→ [⚙ Settings icon] → Settings Screen
  │                       └→ [All local — no navigation]
  ├→ ["Become a Guide" (if role=guide, not verified)] → Guide Application Screen
  │                                                      └→ ["Submit"] → Back to Profile
  ├→ ["Create Tour" (if verified guide)] → Create Tour Screen
  │                                        └→ ["Create"] → Tour Detail Screen
  ├→ [🔔 Notifications] → Notifications Screen
  │                        └→ [Tap notification] → Relevant screen
  └→ ["Logout"] → Confirm dialog → Clear token → Login Screen
```

### Explore Flow
```
Explore Screen
  ├→ [Search] → Results update in-place (or → Search Results Screen)
  ├→ [Tab: Destinations] → Destination cards → Destination Detail Screen
  ├→ [Tab: Events] → Event cards → Event Detail Screen
  ├→ [Tab: Restaurants] → Restaurant cards → Restaurant Detail Screen
  ├→ [Tab: Guides] → Guide cards → Guide Detail Screen
  ├→ [Nearby toggle ON] → Request location → Nearby Map Screen
  └→ [City filter] → Filter results in-place
```

### Nearby Map Flow
```
Nearby Map Screen
  ├→ [Tap green marker (destination)] → Bottom sheet → Destination Detail Screen
  ├→ [Tap blue marker (event)] → Bottom sheet → Event Detail Screen
  ├→ [Tap orange marker (restaurant)] → Bottom sheet → Restaurant Detail Screen
  ├→ [Filter chips] → Toggle marker types
  ├→ [Radius slider] → Reload nearby items
  └→ [Back] → Explore Screen
```

### Search Flow
```
Search Results Screen
  ├→ [Tab: All / Destinations / Tours / Events / Restaurants / Guides]
  ├→ [Tap destination] → Destination Detail Screen
  ├→ [Tap tour] → Tour Detail Screen
  ├→ [Tap event] → Event Detail Screen
  ├→ [Tap restaurant] → Restaurant Detail Screen
  ├→ [Tap guide] → Guide Detail Screen
  └→ [Clear search] → Show recent searches (local)
```

### Auth Guard Flow (🔒 Protected Screens)
```
Any Protected Screen (user not logged in)
  └→ Redirect to Login Screen
       └→ [Login success] → Redirect BACK to originally intended screen
```

---

---

## 1. Splash Screen

**Purpose:** App entry point, brand display, auto-login check.

**UI Elements:**
- Saudi Vision 2030 logo (centered)
- App name: "Saudi Tourism 2030"
- Loading spinner
- Saudi green (#006C35) background with gold (#D4AF37) accent

**Behavior:**
- Check if saved token exists in local storage
- If token valid → navigate to Home Screen
- If no token → navigate to Login Screen
- Display for 2-3 seconds minimum

**API Used:** `GET /profile` (to validate saved token)

---

## 2. Login Screen

**Purpose:** User authentication.

**UI Elements:**
- App logo (top center)
- Email text field (with email keyboard)
- Password text field (with show/hide toggle)
- "Login" button (full width, Saudi green)
- "Don't have an account? Register" link (bottom)
- Error message display area

**Validation:**
- Email: required, valid email format
- Password: required, min 8 characters

**API Used:** `POST /login`

**On Success:** Save `access_token` to local storage → navigate to Home Screen

**On Error:**
- 401 → "Invalid email or password"
- 403 → "Your account is inactive"

---

## 3. Register Screen

**Purpose:** New user account creation.

**UI Elements:**
- App logo (top center)
- Name text field
- Email text field
- Password text field (with show/hide toggle)
- Phone text field (with phone keyboard, optional)
- Role selector: "Tourist" (default) / "Guide" (radio buttons or toggle)
- "Register" button (full width, Saudi green)
- "Already have an account? Login" link (bottom)
- Error message display area

**Validation:**
- Name: required, max 255
- Email: required, valid format, unique
- Password: required, min 8 characters
- Phone: optional

**API Used:** `POST /register`

**On Success:** Save `access_token` → navigate to Home Screen

**On Error:** 422 → Show field-specific errors (e.g., "Email already taken")

---

## 4. Home Screen

**Purpose:** Main landing page, showcase featured content.

**Layout:** Scrollable vertical list with horizontal carousels.

**UI Elements:**
- **Top Bar:** "Saudi Tourism 2030" title + user avatar/profile icon
- **Search Bar:** Quick search field → navigates to Explore Screen with query
- **Featured Destinations Carousel:** Horizontal scroll of destination cards (image, name, city, rating)
  - "See All" link → Destinations List Screen
- **Upcoming Events Section:** Horizontal scroll of event cards (name, date, city, price)
  - "See All" link → Events List Screen
- **Featured Restaurants Section:** Horizontal scroll of restaurant cards (name, cuisine, rating, avg cost)
  - "See All" link → Restaurants List Screen
- **Top Guides Section:** Horizontal scroll of guide cards (photo, name, rating, languages)
  - "See All" link → Guides List Screen

**API Used:**
- `GET /destinations/featured/list?limit=6`
- `GET /events/upcoming/list?limit=6`
- `GET /restaurants/featured/list?limit=6`
- `GET /guides?per_page=6`

**Navigation:** Bottom Navigation Bar (Home, Explore, Bookings, Favorites, Profile)

---

## 5. Explore Screen

**Purpose:** Search and discover all content types.

**UI Elements:**
- **Search Bar:** Text input with search icon (searches across all types)
- **Category Tabs:** All | Destinations | Events | Restaurants | Guides
- **City Filter Dropdown:** Filter results by Saudi city
- **Nearby Toggle:** Switch to show only nearby items (requires location permission)
- **Results Grid:** Cards matching search/filter, changes based on active tab
- **Pull-to-refresh**
- **Infinite scroll pagination**

**Each Card Shows:**
- Destinations: name, city, entry fee, featured badge, rating stars
- Events: name, date range, city, ticket price, featured badge
- Restaurants: name, cuisine type, rating, avg cost
- Guides: name, photo, rating, experience years, languages

**API Used (depending on active tab):**
- `GET /destinations?search=...&country=...`
- `GET /events?search=...&city=...`
- `GET /restaurants?search=...&city=...`
- `GET /guides?search=...`
- `POST /location/nearby` (when nearby toggle is on)

**Card Tap:** Navigate to respective Detail Screen

---

## 6. My Bookings Screen

**Purpose:** View all user bookings across types.

**UI Elements:**
- **3 Tabs:** Tour Bookings | Event Bookings | Guide Bookings
- **Each Tab:** List of booking cards sorted by date (newest first)
- **Empty State:** "No bookings yet" with illustration + "Explore" button
- **Pull-to-refresh**

**Tour Booking Card:**
- Tour name, destination name
- Booking date, number of participants
- Total price
- Status badge (color-coded): Pending (yellow), Confirmed (green), Completed (blue), Cancelled (red)
- Payment status badge
- "Cancel" button (only if pending/confirmed)

**Event Booking Card:**
- Event name, event date
- Booking reference code
- Number of tickets, total price
- Status badge, payment status
- "Cancel" button (only if pending/confirmed)

**Guide Booking Card:**
- Guide name, service type (Walking / With Car)
- Booking date, start time, duration
- Group size, total price
- Meeting point
- Status badge

**API Used:**
- `GET /bookings` (tour bookings)
- `GET /event-bookings` (event bookings)
- Cancel: `POST /bookings/{id}/cancel` or `POST /event-bookings/{id}/cancel`

**Cancel Flow:** Confirmation dialog → API call → refresh list

---

## 7. Favorites Screen

**Purpose:** View saved/wishlisted items.

**UI Elements:**
- **4 Tabs:** All | Destinations | Events | Restaurants
- **Cards:** Same style as Explore Screen cards with a heart/remove icon
- **Empty State:** "No favorites yet" with "Explore" button
- **Swipe-to-remove** or tap heart icon to unfavorite

**API Used:**
- `GET /favorites?type=all` (or `destination`, `event`, `restaurant`)
- `POST /favorites/remove` (to unfavorite)

**Card Tap:** Navigate to respective Detail Screen

---

## 8. Profile Screen

**Purpose:** View and manage user profile.

**UI Elements:**
- **User Avatar** (placeholder icon or photo)
- **User Name** (editable)
- **Email** (read-only)
- **Phone** (editable)
- **Role Badge:** Tourist / Guide / Admin
- **Stats Row:** Total Bookings | Total Reviews | Favorites Count
- **"Edit Profile" Button** → inline edit mode or edit dialog
- **"Logout" Button** (red, with confirmation dialog)
- **App Version** (bottom)

**API Used:**
- `GET /profile`
- `PUT /profile` (update name/phone)
- `POST /logout`

**Logout Flow:** Confirmation dialog → clear saved token → navigate to Login Screen

---

## 9. Destinations List Screen

**Purpose:** Browse all destinations with filters.

**UI Elements:**
- **Search Bar:** Search by name/city
- **Country Filter Dropdown:** "All Countries" / "Saudi Arabia" / etc.
- **Sort Options:** Name A-Z, Rating, Entry Fee (low-high)
- **Destination Cards Grid (2 columns):**
  - Gradient background or image
  - Destination name (bold)
  - City + country
  - Entry fee or "Free"
  - Featured star badge (if featured)
  - Rating stars
- **Pagination:** Infinite scroll or page numbers
- **Pull-to-refresh**

**API Used:** `GET /destinations?search=...&country=...&per_page=15&page=1`

**Card Tap:** Navigate to Destination Detail Screen

---

## 10. Destination Detail Screen

**Purpose:** Full destination info with tours and reviews.

**Layout:** Scrollable with hero section.

**UI Elements:**
- **Hero Section:**
  - Destination image or gradient with icon
  - Back button (top left)
  - Favorite heart button (top right, toggle)
  - Destination name (large, bold)
  - City, Country badges
  - Featured badge (if applicable)
- **Info Grid (4 boxes):**
  - Entry Fee (or "Free")
  - City
  - Best Time to Visit
  - Available Tours Count
- **About Section:** Full description text
- **Available Tours Section:**
  - List of tour cards for this destination
  - Each card: tour name, duration, price, guide name, start date, "Book Now" button
  - Empty state: "No tours available"
- **Reviews Section:**
  - Average rating with stars
  - List of review cards (user name, rating stars, comment, date)
  - "Write a Review" button (if logged in)

**API Used:**
- `GET /destinations/{id}` (returns tours + reviews)
- `POST /favorites/add` / `POST /favorites/remove`
- `POST /favorites/check`

**"Book Now" Tap:** Navigate to Book Tour Screen
**"Write a Review" Tap:** Navigate to Review Submit Screen

---

## 11. Tours List Screen

**Purpose:** Browse all active tours.

**UI Elements:**
- **Search Bar:** Search by tour name
- **Destination Filter Dropdown:** Filter by destination
- **Tour Cards (list style):**
  - Tour name (bold)
  - Description (2-line truncated)
  - Duration (days), Price (SAR)
  - Start date, Max participants
  - Guide name + rating
  - Destination name badge
  - "Book Now" button
- **Pagination:** Infinite scroll

**API Used:** `GET /tours?search=...&destination_id=...&per_page=15`

**Card Tap:** Navigate to Tour Detail Screen

---

## 12. Tour Detail Screen

**Purpose:** Full tour information before booking.

**UI Elements:**
- **Hero Section:** Tour name, destination badge
- **Info Row:** Duration (days) | Price (SAR) | Max Participants | Start Date
- **Description:** Full tour description
- **Guide Section:**
  - Guide photo/avatar, name, rating
  - Experience years, languages
  - Tap → Guide Detail Screen
- **Itinerary Section (if available):**
  - Expandable day-by-day list
  - Each day: title, description, location, duration, activities
- **"Book This Tour" Button** (full width, bottom fixed)
  - If not logged in → "Login to Book" → Login Screen

**API Used:** `GET /tours/{id}`

**"Book" Tap:** Navigate to Book Tour Screen

---

## 13. Book Tour Screen

**Purpose:** Complete a tour booking.

**UI Elements:**
- **Tour Summary Card:** Tour name, destination, dates, price per person
- **Participants Selector:** +/- counter (min 1, max = remaining spots)
- **Price Calculator:** Updates live (price × participants)
- **Payment Method Selector:** Radio buttons — Credit Card / Wallet / Cash on Delivery
- **Price Breakdown:**
  - Price per person: XXX SAR
  - Participants: X
  - Total: XXX SAR
- **"Confirm Booking" Button** (Saudi green)
- **Terms note:** "Booking will be in pending status until confirmed"

**API Used:** `POST /bookings`

**On Success:** Navigate to Booking Confirmation Screen

**On Error:** 
- 400 "Not enough spots" → show error dialog
- 401 → redirect to Login

---

## 14. Events List Screen

**Purpose:** Browse all active events.

**UI Elements:**
- **Search Bar:** Search by event name
- **Filter Row:**
  - Category dropdown
  - City dropdown
  - Date picker (from date)
- **Event Cards:**
  - Event name (bold)
  - Date range (formatted)
  - Time range
  - City + location address
  - Ticket price (SAR) or "Free"
  - Capacity + remaining tickets
  - Featured badge
  - "Get Tickets" button
- **Tabs:** All | Featured | Upcoming
- **Pagination:** Infinite scroll

**API Used:**
- `GET /events?search=...&category_id=...&city=...&start_date=...`
- `GET /events/featured/list`
- `GET /events/upcoming/list`

**Card Tap:** Navigate to Event Detail Screen

---

## 15. Event Detail Screen

**Purpose:** Full event info before booking.

**UI Elements:**
- **Hero:** Event image/gradient, event name, featured badge
- **Info Grid:**
  - Date range
  - Time (start - end)
  - Location (city + address)
  - Ticket price
  - Capacity / Remaining
- **Description:** Full event description
- **Location Section:** City, address, map placeholder (lat/lng)
- **Reviews Section:**
  - Average rating
  - Review cards
  - "Write Review" button (only if user has confirmed booking)
- **"Book Tickets" Button** (fixed bottom)

**API Used:**
- `GET /events/{id}`
- `POST /favorites/add` / `POST /favorites/check`

**"Book Tickets" Tap:** Navigate to Book Event Screen
**"Write Review" Tap:** Navigate to Review Submit Screen

---

## 16. Book Event Screen

**Purpose:** Complete an event ticket booking.

**UI Elements:**
- **Event Summary:** Event name, date, location, price per ticket
- **Tickets Selector:** +/- counter (min 1, max = remaining capacity)
- **Price Calculator:** Updates live (ticket_price × tickets)
- **Payment Method:** Radio buttons — Credit Card / Wallet / Cash
- **Price Breakdown:**
  - Price per ticket: XXX SAR
  - Tickets: X
  - Total: XXX SAR
- **"Confirm Booking" Button**

**API Used:** `POST /event-bookings`

**On Success:** Navigate to Booking Confirmation Screen (shows booking_reference)

---

## 17. Restaurants List Screen

**Purpose:** Browse all restaurants.

**UI Elements:**
- **Search Bar:** Search by name or cuisine
- **Filter Row:**
  - Cuisine type dropdown (Traditional Saudi, International, etc.)
  - City dropdown
  - Price range slider (min - max)
  - Minimum rating selector (1-5 stars)
- **Restaurant Cards:**
  - Restaurant name (bold)
  - Cuisine type badge
  - City + address
  - Rating stars + numeric rating
  - Average cost (SAR)
  - Opening hours
  - Featured badge
- **Pagination:** Infinite scroll

**API Used:** `GET /restaurants?search=...&cuisine_type=...&city=...&min_price=...&max_price=...&min_rating=...`

**Card Tap:** Navigate to Restaurant Detail Screen

---

## 18. Restaurant Detail Screen

**Purpose:** Full restaurant info.

**UI Elements:**
- **Hero:** Restaurant image/gradient, name, cuisine badge
- **Info Grid:**
  - Cuisine type
  - Average cost (SAR)
  - Rating (stars + number)
  - Hours (opening - closing)
- **Contact Info:** Phone, email, website (tappable)
- **Description:** Full description
- **Location:** City, address, map placeholder
- **Reviews Section:**
  - Average rating
  - Review cards (user, rating, comment)
  - "Write Review" button
- **Favorite Button** (heart icon)

**API Used:**
- `GET /restaurants/{id}`
- `POST /favorites/add` / `POST /favorites/check`

---

## 19. Guides List Screen

**Purpose:** Browse verified guides.

**UI Elements:**
- **Search Bar:** Search by guide name
- **Guide Cards:**
  - Profile photo (or avatar placeholder)
  - Guide name (bold)
  - Specialization badge
  - City
  - Rating stars + count
  - Experience (X years)
  - Languages list
  - Hourly rate: XXX SAR (Walking) / XXX SAR (With Car)
  - "Has Car" badge (if applicable)
  - Tours count
- **Pagination:** Infinite scroll

**API Used:** `GET /guides?search=...&per_page=15`

**Card Tap:** Navigate to Guide Detail Screen

---

## 20. Guide Detail Screen

**Purpose:** Full guide profile.

**UI Elements:**
- **Profile Header:**
  - Large profile photo/avatar
  - Guide name, verification badge
  - City, specialization
  - Rating (stars + reviews count)
- **Info Grid:**
  - Experience (years)
  - Languages (list)
  - Hourly Rate (Walking)
  - Hourly Rate (With Car)
  - Total Tours Completed
  - Has Car (Yes/No)
- **Bio Section:** Full bio text
- **Tours Section:**
  - List of tours offered by this guide
  - Each: tour name, destination, duration, price
  - Tap → Tour Detail Screen
- **Reviews Section:**
  - Review cards from verified users
  - Rating + comment + date

**API Used:**
- `GET /guides/{id}` (includes user, tours, reviews)
- `GET /guides/{id}/reviews`

---

## 21. Review Submit Screen

**Purpose:** Submit a review for destination, event, or restaurant.

**UI Elements:**
- **Item Name** (what is being reviewed)
- **Star Rating Picker:** 5 tappable stars (required)
- **Comment Text Field:** Multi-line, optional, placeholder: "Share your experience..."
- **"Submit Review" Button**
- **Note:** "Your review will be visible after approval"

**API Used (based on type):**
- `POST /reviews` (destination)
- `POST /events/{id}/review` (event)
- `POST /restaurants/{id}/review` (restaurant)

**On Success:** Show success message → navigate back

---

## 22. Booking Confirmation Screen

**Purpose:** Show booking success details.

**UI Elements:**
- **Success Icon** (green checkmark, animated)
- **"Booking Confirmed!" Title**
- **Booking Details Card:**
  - Booking ID
  - Booking Reference (for events)
  - Item name (tour/event)
  - Date
  - Participants/Tickets count
  - Total price
  - Payment method
  - Status: "Pending"
- **"View My Bookings" Button** → My Bookings Screen
- **"Back to Home" Button** → Home Screen

---

## 23. AI Tourism Chatbot Screen

**Purpose:** AI-powered tourism assistant for travel recommendations, info, and tips.

**UI Elements:**
- **Top Bar:** "AI Tourism Guide" title + back button
- **Chat Messages Area:** Scrollable list of messages (WhatsApp-style bubbles)
  - User messages: right-aligned, Saudi green background, white text
  - AI messages: left-aligned, white/light grey background, dark text
  - AI avatar icon (robot/compass icon) on AI messages
- **Typing Indicator:** Animated dots when AI is thinking
- **Message Input Bar (bottom):**
  - Text field: placeholder "Ask about Saudi tourism..."
  - Send button (Saudi green, arrow icon)
- **Quick Suggestion Chips (above input):** Pre-made questions:
  - "Best places in Riyadh"
  - "Traditional Saudi food"
  - "Top events this month"
  - "Budget travel tips"
- **Empty State:** Welcome message + suggested topics

**Behavior:**
- User types message → sends to API → shows typing indicator → displays AI reply
- Chat history stored locally (session-based)
- AI only answers tourism-related questions (Saudi Arabia focused)
- Max message length: 1000 characters

**API Used:** `POST /ai-assistant/chat`
```json
Request:  { "message": "What are the best places to visit in Riyadh?" }
Response: { "reply": "Riyadh offers amazing attractions! Here are the top places..." }
```

**Access:** Available from Home Screen (floating action button or top bar icon) — no auth required

---

## 24. Hire Guide Screen

**Purpose:** Book a guide for a personalized tour experience.

**Navigation:** Accessed from Guide Detail Screen → "Hire This Guide" button

**UI Elements:**
- **Guide Summary Card:** Photo, name, rating, city, specialization
- **Service Type Selector:** Radio buttons
  - Walking Tour — XXX SAR/hour
  - With Car — XXX SAR/hour (only if guide `has_car = true`)
- **Date Picker:** Select booking date (min: tomorrow)
- **Start Time Picker:** Select start time
- **Duration Selector:** +/- counter (min 1 hour, max 12 hours)
- **Group Size Selector:** +/- counter (min 1, max 10)
- **Meeting Point Field:** Text input, placeholder "e.g., Hotel lobby, Airport..."
- **Special Requests Field:** Multi-line text input (optional)
- **Price Calculator (live update):**
  - Rate: XXX SAR/hour
  - Duration: X hours
  - Total: XXX SAR
- **"Confirm Booking" Button** (Saudi green, full width)

**Price Calculation:**
- Walking: `hourly_rate × duration_hours`
- With Car: `hourly_rate_with_car × duration_hours`

**API Used:** `POST /guide-bookings` (needs API endpoint)
```json
Request: {
  "guide_id": 1,
  "booking_date": "2026-05-01",
  "start_time": "09:00",
  "duration_hours": 4,
  "service_type": "with_car",
  "group_size": 3,
  "meeting_point": "Hotel lobby",
  "special_requests": "Arabic-speaking guide preferred"
}
Response: { "id": 1, "total_price": "800.00", "status": "pending", ... }
```

**On Success:** Navigate to Booking Confirmation Screen

---

## 25. Guide Application Screen

**Purpose:** Allow users with guide role to apply as a verified guide.

**Navigation:** Accessed from Profile Screen (if user role = "guide" and not yet verified)

**UI Elements:**
- **Header:** "Become a Verified Guide"
- **Bio Text Field:** Multi-line, placeholder "Tell tourists about yourself..."
- **Experience Field:** Number input (years)
- **Languages Selector:** Multi-select chips (Arabic, English, French, Spanish, Chinese, etc.)
- **Phone Field:** Phone number input
- **City Field:** Dropdown of Saudi cities
- **Specialization Field:** Text input (e.g., "Historical sites", "Adventure tours")
- **Hourly Rate Field:** Number input (SAR)
- **Has Car Toggle:** Yes/No switch
- **Hourly Rate With Car Field:** Number input (shown if has_car = true)
- **"Submit Application" Button**
- **Note:** "Your application will be reviewed by admin"

**API Used:** `POST /guides/apply`
```json
Request: {
  "bio": "Experienced guide...",
  "experience_years": 5,
  "languages": ["Arabic", "English"],
  "phone": "+966501234567"
}
```

**On Success:** Show success message → navigate to Profile Screen

---

## 26. Create Tour Screen (Guide Only)

**Purpose:** Allow verified guides to create new tour listings.

**Navigation:** Accessed from Profile Screen or Guide Dashboard (if user is verified guide)

**UI Elements:**
- **Tour Name Field:** Text input
- **Destination Selector:** Dropdown of active destinations
- **Description Field:** Multi-line text area
- **Duration Field:** Number input (days)
- **Price Field:** Number input (SAR per person)
- **Max Participants Field:** Number input
- **Date Range Picker:** Start date + End date
- **Itinerary Builder (optional):**
  - "Add Day" button
  - Per day: title, description, location, duration (hours), activities list
- **"Create Tour" Button**

**API Used:** `POST /tours`
```json
Request: {
  "destination_id": 1,
  "name": "Riyadh Heritage Walk",
  "description": "...",
  "duration_days": 2,
  "price": 450,
  "max_participants": 10,
  "start_date": "2026-06-01",
  "end_date": "2026-06-02"
}
```

**On Success:** Show success message → navigate to Tour Detail Screen

---

## 27. Nearby Map Screen

**Purpose:** Discover nearby destinations, events, and restaurants on a map.

**Navigation:** Accessed from Explore Screen (nearby toggle) or Home Screen (map icon)

**UI Elements:**
- **Map View (full screen):** Google Maps / Apple Maps with markers
  - Green markers: Destinations
  - Blue markers: Events
  - Orange markers: Restaurants
- **Filter Chips (top):** Destinations | Events | Restaurants (toggle each on/off)
- **Radius Slider:** 5km - 100km (default 50km)
- **Bottom Sheet (half screen, draggable):**
  - List of nearby items sorted by distance
  - Each item: name, type badge, distance (km), rating
  - Tap → respective Detail Screen
- **Current Location Button:** Re-center map on user location
- **Search This Area Button:** Appears after panning map

**Behavior:**
- Request location permission on first load
- Auto-load nearby items based on user's GPS coordinates
- Update results when radius changes or map is panned

**API Used:**
- `POST /location/nearby` (unified: destinations + events + restaurants)
- `POST /events/nearby`
- `POST /restaurants/nearby`
```json
Request: { "latitude": 24.7136, "longitude": 46.6753, "radius": 50 }
```

---

## 28. Edit Profile Screen

**Purpose:** Edit user profile information.

**Navigation:** Accessed from Profile Screen → "Edit Profile" button

**UI Elements:**
- **Avatar/Photo** (placeholder, tap to change — future feature)
- **Name Field:** Pre-filled text input
- **Email Field:** Read-only (greyed out)
- **Phone Field:** Pre-filled text input
- **"Save Changes" Button** (Saudi green)
- **"Cancel" Button** (grey, returns to Profile)

**API Used:** `PUT /profile`
```json
Request: { "name": "Ahmed Updated", "phone": "+966509876543" }
Response: { "message": "Profile updated successfully", "user": {...} }
```

**On Success:** Show success toast → navigate back to Profile Screen

---

## 29. Onboarding Screen

**Purpose:** First-time user walkthrough introducing app features.

**Navigation:** Shown once after first install, before Login Screen.

**UI Elements (3-4 swipeable pages):**
- **Page 1:** "Discover Saudi Arabia" — map/landscape illustration, text about exploring destinations
- **Page 2:** "Book Amazing Tours" — booking illustration, text about tours & events
- **Page 3:** "AI-Powered Guide" — chatbot illustration, text about AI assistant
- **Page 4:** "Your Journey Starts Now" — Saudi Vision 2030 logo
- **Page Indicator Dots:** Bottom center
- **"Skip" Button:** Top right (all pages)
- **"Next" Button:** Bottom right (pages 1-3)
- **"Get Started" Button:** Bottom center (last page) → Login Screen

**Behavior:**
- Store `onboarding_seen = true` in local storage
- Never show again after first viewing

**API Used:** None (local only)

---

## 30. Booking Detail Screen

**Purpose:** View full details of a specific booking (tour or event).

**Navigation:** Accessed from My Bookings Screen → tap a booking card

**UI Elements:**
- **Status Banner:** Full-width colored bar showing booking status
- **Booking Info Card:**
  - Booking ID / Reference
  - Item name (tour/event name)
  - Date booked
  - Participants/Tickets count
  - Total price (SAR)
  - Payment method icon + label
  - Payment status badge
- **Tour/Event Details Section:**
  - Destination/venue name
  - Date range
  - Guide name (for tours)
  - Location address
- **Action Buttons:**
  - "Cancel Booking" (red, only if status = pending/confirmed)
  - "Leave Review" (only if status = completed)
  - "Contact Guide" (for tour bookings, if guide has phone)
- **Timeline/History:** Booking status changes with timestamps

**API Used:**
- `GET /bookings/{id}` (tour booking detail)
- `GET /event-bookings/{id}` (event booking detail)

**Cancel Flow:** Confirmation dialog → `POST /bookings/{id}/cancel` or `POST /event-bookings/{id}/cancel` → refresh

---

## 31. Search Results Screen

**Purpose:** Display search results across all content types.

**Navigation:** Accessed from Home Screen search bar or Explore search

**UI Elements:**
- **Search Bar (top):** Pre-filled with search query, auto-focus
- **Result Tabs:** All | Destinations | Tours | Events | Restaurants | Guides
- **Result Count:** "X results found"
- **Result Cards:** Mixed list, each card shows:
  - Type badge (Destination/Tour/Event/Restaurant/Guide)
  - Name, brief info, rating
  - Tap → respective Detail Screen
- **No Results State:** "No results for 'query'" with suggestions
- **Recent Searches:** Shown when search field is empty (stored locally)

**API Used (parallel calls):**
- `GET /destinations?search=...`
- `GET /tours?search=...`
- `GET /events?search=...`
- `GET /restaurants?search=...`
- `GET /guides?search=...`

---

## 32. Notifications Screen

**Purpose:** View booking updates, review approvals, and system notifications.

**Navigation:** Accessed from top bar bell icon (any screen)

**UI Elements:**
- **Notification Cards (chronological list):**
  - Icon (type-based: booking, review, system)
  - Title (bold)
  - Description
  - Timestamp ("2 hours ago")
  - Read/unread indicator (dot)
- **Filter Tabs:** All | Bookings | Reviews | System
- **"Mark All Read" Button** (top right)
- **Empty State:** "No notifications yet"

**Behavior:**
- Tap notification → navigate to relevant screen (booking detail, review, etc.)
- Badge count on bell icon (unread count)
- Local notifications for booking status changes

**API Used:** Local push notifications (no API endpoint currently — future feature)

---

## 33. Settings Screen

**Purpose:** App preferences and configuration.

**Navigation:** Accessed from Profile Screen → gear icon

**UI Elements:**
- **Language Selector:** Arabic / English
- **Theme Toggle:** Light / Dark mode
- **Notifications Toggle:** Enable/disable push notifications
- **Location Toggle:** Allow location services
- **Cache Section:**
  - "Clear Cache" button
  - Cache size display
- **About Section:**
  - App version
  - Terms of Service link
  - Privacy Policy link
  - Contact Support (email)
- **"Delete Account" Button** (red, bottom — with double confirmation)

**API Used:** None (all local preferences stored via SharedPreferences)

---

## BOTTOM NAVIGATION BAR

| Tab       | Icon           | Screen          |
|-----------|----------------|-----------------|
| Home      | house icon     | Home Screen     |
| Explore   | compass icon   | Explore Screen  |
| AI Guide  | robot icon     | AI Chatbot      |
| Bookings  | calendar icon  | My Bookings     |
| Favorites | heart icon     | Favorites       |
| Profile   | person icon    | Profile Screen  |

**Active color:** Saudi green (#006C35)
**Inactive color:** Grey (#94A3B8)

---

## COLOR SCHEME

| Name          | Hex       | Usage                              |
|---------------|-----------|------------------------------------|
| Saudi Green   | #006C35   | Primary, buttons, active states    |
| Gold          | #D4AF37   | Featured badges, accents           |
| Dark          | #1A1A2E   | Dark backgrounds, text             |
| Light BG      | #F8FAFC   | Screen backgrounds                 |
| Card BG       | #FFFFFF   | Card surfaces                      |
| Text Primary  | #1E293B   | Headings, main text                |
| Text Secondary| #64748B   | Descriptions, subtitles            |
| Text Muted    | #94A3B8   | Hints, inactive items              |
| Success       | #10B981   | Confirmed status, success messages |
| Warning       | #F59E0B   | Pending status                     |
| Error         | #EF4444   | Cancelled status, errors           |
| Info          | #3B82F6   | Completed status, info messages    |

---

## STATUS BADGE COLORS

| Status     | Background | Text    |
|------------|------------|---------|
| Pending    | #FEF3C7   | #92400E |
| Confirmed  | #D1FAE5   | #065F46 |
| Completed  | #DBEAFE   | #1E40AF |
| Cancelled  | #FEE2E2   | #991B1B |
| Active     | #D1FAE5   | #065F46 |
| Inactive   | #F3F4F6   | #6B7280 |
| Verified   | #D1FAE5   | #065F46 |
| Rejected   | #FEE2E2   | #991B1B |
