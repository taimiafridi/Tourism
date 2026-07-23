# Saudi Tourism 2030 - API Documentation & App Specification

---

## 1. APP FEATURES

### Authentication
- User registration (name, email, password, phone)
- Login with email & password (Bearer token via Sanctum)
- Profile view & update
- Role-based access: User, Guide, Admin

### Destinations
- Browse all destinations with search, country filter, pagination
- View destination details with tours & reviews
- Featured destinations list
- Location-based filtering (nearby, city, top-rated)

### Tours
- Browse active tours with destination filter & search
- View tour details with guide info & itinerary
- Book a tour (select participants, payment method)
- Auto price calculation (price × participants)
- Capacity validation (checks available spots)

### Events
- Browse events with search, category, city, date filters
- Featured & upcoming events lists
- View event details with reviews
- Book event tickets (select ticket count, payment method)
- Auto booking reference generation
- Nearby events (location-based)
- Leave reviews (must have confirmed booking)

### Restaurants
- Browse with search, cuisine, city, price range, rating filters
- Featured restaurants list
- View details with reviews
- Nearby restaurants (location-based)
- Filter by cuisine type
- Leave reviews

### Guides
- Browse verified active guides with search
- View guide profile, tours, reviews
- Guide application (for users with guide role)
- Guide info: hourly rate, hourly rate with car, languages, experience, specialization, city

### Bookings
- Tour bookings: create, view list, view detail, cancel
- Event bookings: create, view list, view detail, cancel
- Booking statuses: pending → confirmed → completed / cancelled
- Payment statuses: pending → completed / failed / refunded
- Payment methods: card, wallet, cod

### Favorites / Wishlist
- Add destinations, events, restaurants to favorites
- Remove from favorites
- Check if item is favorited
- View all favorites (filter by type)
- View wishlist grouped by type
- Clear all favorites

### Reviews
- Destination reviews: submit (rating 1-5, comment)
- Guide reviews: view approved reviews
- Event reviews: submit (must have confirmed booking)
- Restaurant reviews: submit
- Review moderation: pending → approved / rejected

### Location Services
- Nearby search: destinations + events + restaurants in radius
- City search: find items by city name
- Advanced destination filter: category, city, country, rating, featured, location
- Route calculation: start/end coordinates (placeholder for Maps API)
- Top-rated destinations by city

---

## 2. SCREEN LIST

### Auth Screens
1. **Splash Screen** — App logo, auto-login check
2. **Login Screen** — Email, password, login button, register link
3. **Register Screen** — Name, email, password, phone, role selector

### Main Screens (Bottom Navigation)
4. **Home Screen** — Featured destinations, upcoming events, featured restaurants, quick search
5. **Explore Screen** — Search all (destinations, events, restaurants), city filter, nearby toggle
6. **My Bookings Screen** — 3 tabs: Tour Bookings, Event Bookings, Guide Bookings
7. **Favorites Screen** — Tabs: All, Destinations, Events, Restaurants
8. **Profile Screen** — User info, edit profile, logout

### Destination Screens
9. **Destinations List Screen** — Cards with search, country filter, pagination
10. **Destination Detail Screen** — Info, entry fee, best time, available tours, reviews, favorite button

### Tour Screens
11. **Tours List Screen** — Cards with destination filter, search
12. **Tour Detail Screen** — Description, duration, price, guide info, itinerary, book button

### Event Screens
13. **Events List Screen** — Cards with category, city, date filters
14. **Event Detail Screen** — Info, date/time, location, ticket price, capacity, reviews, book button

### Restaurant Screens
15. **Restaurants List Screen** — Cards with cuisine, city, price, rating filters
16. **Restaurant Detail Screen** — Info, hours, cuisine, avg cost, rating, reviews, location

### Guide Screens
19. **Guides List Screen** — Cards with search, rating, languages
20. **Guide Detail Screen** — Bio, experience, languages, hourly rates, tours, reviews
21. **Hire Guide Screen** — Service type, date, time, duration, group size, price calculator
22. **Guide Application Screen** — Bio, experience, languages, submit (guide role users)

### AI & Map Screens
23. **AI Tourism Chatbot Screen** — Chat interface, quick suggestions, Groq-powered responses
24. **Nearby Map Screen** — Google Maps with markers, radius slider, filter chips

### Booking & Review Screens
25. **Book Tour Screen** — Select participants, payment method, price summary, confirm
26. **Book Event Screen** — Select tickets, payment method, price summary, confirm
27. **Booking Confirmation Screen** — Success icon, booking summary, reference number, status
28. **Booking Detail Screen** — Full booking info, status, cancel/review actions
29. **Review Submit Screen** — Star rating picker, comment field, submit

### Other Screens
30. **Edit Profile Screen** — Edit name, phone, save changes
31. **Search Results Screen** — Multi-type results with tabs (all/destinations/tours/events/restaurants/guides)
32. **Onboarding Screen** — 3-4 swipeable intro pages, shown once on first install
33. **Notifications Screen** — Booking updates, review approvals, system alerts
34. **Settings Screen** — Language, theme, notifications, cache, about
35. **Create Tour Screen** — Guide-only: create new tour with itinerary builder

---

## 3. API DOCUMENTATION

### Base URL

```
http://YOUR_SERVER_IP:8000/api/v1
```

- Android emulator: `http://10.0.2.2:8000/api/v1`
- iOS simulator: `http://127.0.0.1:8000/api/v1`
- Physical device: `http://192.168.1.x:8000/api/v1` (your PC local IP)

### Headers

```
Authorization: Bearer {access_token}    (required for 🔒 endpoints)
Content-Type: application/json
Accept: application/json
```

---

### Authentication

| Method | Endpoint    | Auth | Description              |
|--------|-------------|------|--------------------------|
| POST   | /register   | No   | Create account           |
| POST   | /login      | No   | Login, get token         |
| POST   | /logout     | 🔒   | Revoke token             |
| GET    | /profile    | 🔒   | Get user profile         |
| PUT    | /profile    | 🔒   | Update name/phone        |

**POST /register**
```json
Request:  { "name": "Ahmed", "email": "ahmed@example.com", "password": "password123", "phone": "+966501234567", "role": "user" }
Response: { "message": "User registered successfully", "user": {...}, "access_token": "1|abc...", "token_type": "Bearer" }
```
- role: "user" (default) or "guide"
- password: min 8 characters

**POST /login**
```json
Request:  { "email": "ahmed@example.com", "password": "password123" }
Response: { "message": "Login successful", "user": {...}, "access_token": "2|xyz...", "token_type": "Bearer" }
```
- 401: Invalid credentials
- 403: Account inactive

---

### Destinations

| Method | Endpoint                    | Auth | Description                   |
|--------|-----------------------------|------|-------------------------------|
| GET    | /destinations               | No   | List (search, country filter) |
| GET    | /destinations/{id}          | No   | Detail with tours & reviews   |
| GET    | /destinations/featured/list | No   | Featured only (?limit=10)     |
| GET    | /destinations/{id}/reviews  | No   | Approved reviews (paginated)  |

**GET /destinations** query params: `search`, `country`, `per_page`, `page`

**Response fields per destination:**
```
id, category_id, name, description, city, country, latitude, longitude,
image_url, best_time_to_visit, entry_fee, status, featured, reviews[]
```

---

### Tours

| Method | Endpoint    | Auth | Description                         |
|--------|-------------|------|-------------------------------------|
| GET    | /tours      | No   | List (destination_id, search)       |
| GET    | /tours/{id} | No   | Detail with destination/guide/itinerary |
| POST   | /tours      | 🔒   | Create tour (guides only)           |

**GET /tours** query params: `destination_id`, `search`, `per_page`, `page`

**Response fields per tour:**
```
id, destination_id, guide_id, name, description, duration_days, price,
max_participants, start_date, end_date, status, destination{}, guide{}, itinerary_items[]
```

---

### Bookings (Tour Bookings)

| Method | Endpoint              | Auth | Description         |
|--------|-----------------------|------|---------------------|
| POST   | /bookings             | 🔒   | Book a tour         |
| GET    | /bookings             | 🔒   | My tour bookings    |
| GET    | /bookings/{id}        | 🔒   | Booking detail      |
| POST   | /bookings/{id}/cancel | 🔒   | Cancel booking      |

**POST /bookings**
```json
Request:  { "tour_id": 1, "number_of_participants": 2, "payment_method": "card" }
Response: { "id": 1, "tour_id": 1, "user_id": 1, "total_price": "900.00", "status": "pending", ... }
```
- payment_method: "card", "wallet", "cod"
- total_price auto-calculated: tour.price × number_of_participants
- 400 if not enough spots

---

### Guides

| Method | Endpoint             | Auth | Description                |
|--------|----------------------|------|----------------------------|
| GET    | /guides              | No   | List verified active guides|
| GET    | /guides/{id}         | No   | Guide detail + tours       |
| GET    | /guides/{id}/reviews | No   | Approved guide reviews     |
| POST   | /guides/apply        | 🔒   | Apply as guide             |

**GET /guides** query params: `search`, `per_page`

**Response fields per guide:**
```
id, user_id, bio, experience_years, languages[], phone, hourly_rate,
hourly_rate_with_car, specialization, city, profile_photo, has_car,
total_tours_completed, rating, status, verification_status,
user{id, name}, tours_count, reviews_avg_rating
```

**POST /guides/apply** (must have role="guide")
```json
Request: { "bio": "...", "experience_years": 5, "languages": ["Arabic","English"], "phone": "+966..." }
```

---

### Events

| Method | Endpoint                | Auth | Description                    |
|--------|-------------------------|------|--------------------------------|
| GET    | /events                 | No   | List with filters              |
| GET    | /events/{id}            | No   | Detail with category & reviews |
| GET    | /events/featured/list   | No   | Featured events (?limit=10)    |
| GET    | /events/upcoming/list   | No   | Upcoming events (?limit=10)    |
| POST   | /events/nearby          | No   | Nearby events by location      |
| POST   | /events/{id}/review     | 🔒   | Leave review (needs booking)   |

**GET /events** query params: `search`, `category_id`, `city`, `start_date`, `per_page`

**Response fields per event:**
```
id, name, description, category_id, city, location_address, latitude, longitude,
start_date, end_date, start_time, end_time, ticket_price, capacity,
image_url, status, featured, category{}, reviews[]
```

**POST /events/nearby**
```json
Request: { "latitude": 24.7136, "longitude": 46.6753, "radius": 50 }
```

---

### Event Bookings

| Method | Endpoint                    | Auth | Description           |
|--------|------------------------------|------|----------------------|
| POST   | /event-bookings              | 🔒   | Book event tickets   |
| GET    | /event-bookings              | 🔒   | My event bookings    |
| GET    | /event-bookings/{id}         | 🔒   | Booking detail       |
| POST   | /event-bookings/{id}/cancel  | 🔒   | Cancel booking       |

**POST /event-bookings**
```json
Request:  { "event_id": 1, "number_of_tickets": 3, "payment_method": "card" }
Response: { "id": 1, "booking_reference": "EB-aBcD12xYz...", "total_price": "150.00", ... }
```
- total_price auto-calculated: ticket_price × number_of_tickets
- booking_reference auto-generated
- 400 if event started or no tickets left

---

### Restaurants

| Method | Endpoint                          | Auth | Description              |
|--------|-----------------------------------|------|--------------------------|
| GET    | /restaurants                      | No   | List with filters        |
| GET    | /restaurants/{id}                 | No   | Detail with reviews      |
| GET    | /restaurants/featured/list        | No   | Featured (?limit=10)     |
| POST   | /restaurants/nearby               | No   | Nearby by location       |
| GET    | /restaurants/cuisine/{cuisine}    | No   | Filter by cuisine type   |
| POST   | /restaurants/{id}/review          | 🔒   | Leave review             |

**GET /restaurants** query params: `search`, `category_id`, `city`, `cuisine_type`, `min_price`, `max_price`, `min_rating`, `per_page`

**Response fields per restaurant:**
```
id, name, description, category_id, cuisine_type, city, location_address,
latitude, longitude, phone, email, website, opening_time, closing_time,
average_cost, image_url, rating, status, featured, category{}, reviews[]
```

---

### Favorites / Wishlist

| Method | Endpoint         | Auth | Description                  |
|--------|------------------|------|------------------------------|
| GET    | /favorites       | 🔒   | List favorites (?type=all)   |
| POST   | /favorites/add   | 🔒   | Add to favorites             |
| POST   | /favorites/remove| 🔒   | Remove from favorites        |
| POST   | /favorites/check | 🔒   | Check if item is favorited   |
| GET    | /favorites/wishlist | 🔒 | Wishlist grouped by type     |
| DELETE | /favorites/clear | 🔒   | Clear all favorites          |

**POST /favorites/add**
```json
Request:  { "type": "destination", "item_id": 1 }
```
- type: "destination", "event", "restaurant"

**POST /favorites/check**
```json
Response: { "is_favorited": true }
```

---

### Reviews

| Method | Endpoint | Auth | Description             |
|--------|----------|------|-------------------------|
| POST   | /reviews | 🔒   | Submit destination review |

```json
Request: { "destination_id": 1, "rating": 5, "comment": "Beautiful!" }
```

---

### Location Services

| Method | Endpoint                    | Auth | Description                  |
|--------|-----------------------------|------|------------------------------|
| POST   | /location/nearby            | No   | Nearby destinations/events/restaurants |
| GET    | /location/search-city       | No   | Search by city (?city=Riyadh&type=all) |
| GET    | /location/filter-destinations | No | Advanced destination filter   |
| POST   | /location/route             | No   | Route between 2 points       |
| GET    | /location/top-rated         | No   | Top rated (?city=Riyadh&limit=10) |

---

### AI Tourism Chatbot

| Method | Endpoint             | Auth | Description                    |
|--------|----------------------|------|--------------------------------|
| POST   | /ai-assistant/chat   | No   | Send message, get AI response  |

**POST /ai-assistant/chat**
```json
Request:  { "message": "What are the best places to visit in Riyadh?" }
Response: { "reply": "Riyadh offers amazing attractions! Here are the top places to visit:\n\n1. **Al-Masmak Fortress** — Historical clay fortress...\n2. **Kingdom Centre Tower** — Iconic skyscraper with sky bridge...\n3. **Diriyah** — UNESCO World Heritage Site..." }
```
- message: required, max 1000 characters
- AI is scoped to Saudi Arabia tourism topics only
- Powered by Groq LLaMA 3.3-70b-versatile model
- No authentication required (accessible to all users)
- Response time: 2-5 seconds typically

**Suggested Quick Prompts (for UI chips):**
- "Best places in Riyadh"
- "Traditional Saudi food"
- "Top events this month"
- "Budget travel tips"
- "Best time to visit Jeddah"
- "Family-friendly activities"

---

### Guide Bookings (Hire a Guide)

| Method | Endpoint                      | Auth | Description            |
|--------|-------------------------------|------|------------------------|
| POST   | /guide-bookings               | 🔒   | Hire a guide           |
| GET    | /guide-bookings               | 🔒   | My guide bookings      |
| GET    | /guide-bookings/{id}          | 🔒   | Booking detail         |
| POST   | /guide-bookings/{id}/cancel   | 🔒   | Cancel guide booking   |

**POST /guide-bookings**
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
Response: {
  "id": 1,
  "guide_id": 1,
  "user_id": 3,
  "booking_date": "2026-05-01",
  "start_time": "09:00",
  "duration_hours": 4,
  "service_type": "with_car",
  "group_size": 3,
  "total_price": "800.00",
  "meeting_point": "Hotel lobby",
  "special_requests": "Arabic-speaking guide preferred",
  "status": "pending",
  "payment_status": "pending"
}
```
- service_type: "walking" or "with_car"
- total_price auto-calculated:
  - Walking: `guide.hourly_rate × duration_hours`
  - With Car: `guide.hourly_rate_with_car × duration_hours`
- booking_date must be in the future
- 400 if guide not available or not verified

---

## 4. DATA MODELS

### User
```
id, name, email, phone, role (user/guide/admin), status (active/inactive/suspended)
```

### Destination
```
id, category_id, name, description, city, country, latitude, longitude,
image_url, best_time_to_visit, entry_fee, status (active/inactive/archived), featured
```

### Tour
```
id, destination_id, guide_id, name, description, duration_days, price,
max_participants, start_date, end_date, status (active/inactive/completed/cancelled)
```

### Booking (Tour)
```
id, tour_id, user_id, guide_id, number_of_participants, total_price,
status (pending/confirmed/completed/cancelled), booking_date,
payment_status (pending/completed/failed/refunded), payment_method
```

### Guide
```
id, user_id, bio, experience_years, languages (json array), phone,
hourly_rate, hourly_rate_with_car, specialization, city, profile_photo,
has_car, total_tours_completed, rating,
status (active/inactive/suspended), verification_status (pending/verified/rejected)
```

### Event
```
id, category_id, name, description, city, location_address, latitude, longitude,
start_date, end_date, start_time, end_time, ticket_price, capacity,
image_url, status (active/inactive/archived), featured
```

### Event Booking
```
id, event_id, user_id, number_of_tickets, total_price, booking_date,
status (pending/confirmed/cancelled),
payment_status (pending/completed/failed/refunded), payment_method, booking_reference
```

### Restaurant
```
id, category_id, name, description, cuisine_type, city, location_address,
latitude, longitude, phone, email, website, opening_time, closing_time,
average_cost, image_url, rating, status (active/inactive/closed), featured
```

### Review (Destination)
```
id, destination_id, user_id, rating (1-5), comment, status (pending/approved/rejected)
```

### Guide Review
```
id, guide_id, user_id, booking_id, rating (1-5), comment, status (pending/approved/rejected)
```

### Event Review
```
id, event_id, user_id, rating (1-5), comment, status (pending/approved/rejected)
```

### Restaurant Review
```
id, restaurant_id, user_id, rating (1-5), comment, status (pending/approved/rejected)
```

### Category
```
id, name, slug, description, icon_url, type (destination/event/restaurant), status (active/inactive)
```

### User Favorite
```
id, user_id, favoritable_type (Destination/Event/Restaurant), favoritable_id
```

### Itinerary Item
```
id, tour_id, day, title, description, location, duration_hours, activities (json array)
```

### Media Gallery
```
id, galleryable_type, galleryable_id, media_url, media_type (image/video), title, description, order
```

### Guide Booking
```
id, guide_id, user_id, booking_date, start_time, duration_hours,
service_type (walking/with_car), group_size, total_price,
special_requests, meeting_point,
status (pending/confirmed/completed/cancelled),
payment_status (pending/completed/failed/refunded)
```

---

## 5. PAGINATION FORMAT

All list endpoints return paginated responses:
```json
{
  "data": [...],
  "current_page": 1,
  "last_page": 3,
  "per_page": 15,
  "total": 42,
  "next_page_url": "...?page=2",
  "prev_page_url": null
}
```

---

## 6. ERROR CODES

| Code | Meaning              | Example Message                      |
|------|----------------------|--------------------------------------|
| 400  | Bad Request          | "Not enough spots available"         |
| 401  | Unauthenticated      | "Unauthenticated." / "Invalid credentials" |
| 403  | Forbidden            | "Unauthorized" / "Account inactive"  |
| 404  | Not Found            | Resource not found                   |
| 422  | Validation Error     | { "errors": { "field": ["..."] } }   |

---

## 7. TEST CREDENTIALS

| Role  | Email                  | Password |
|-------|------------------------|----------|
| Admin | admin@sauditourism.sa  | password |
| User  | user@sauditourism.sa   | password |
| User  | sara@sauditourism.sa   | password |

---

## 8. RECOMMENDED FLUTTER PACKAGES

```yaml
http: ^1.2.1                # HTTP client
provider: ^6.1.2            # State management
shared_preferences: ^2.3.3  # Token storage
cached_network_image: ^3.4.1 # Image caching
intl: ^0.19.0               # Date formatting
flutter_rating_bar: ^4.0.1  # Star rating widget
google_maps_flutter: ^2.9.0 # Maps (optional)
```

---

## 9. AI CHATBOT — FLUTTER IMPLEMENTATION GUIDE

### API Endpoint

```
POST /api/v1/ai-assistant/chat
```

- **No authentication required** — any user (guest or logged in) can use it
- **Content-Type:** `application/json`
- **Accept:** `application/json`

### Request

```json
{
  "message": "What are the best places to visit in Riyadh?"
}
```

| Field   | Type   | Required | Max Length | Description                |
|---------|--------|----------|------------|----------------------------|
| message | string | Yes      | 1000 chars | User's tourism question    |

### Response (Success — 200)

```json
{
  "reply": "Riyadh offers amazing attractions! Here are the top places to visit:\n\n1. **Al-Masmak Fortress** — Historic clay fortress...\n2. **Kingdom Centre Tower** — Iconic skyscraper...\n3. **Diriyah** — UNESCO World Heritage Site..."
}
```

### Response (Errors)

```json
// 422 — Validation error (message too long or missing)
{ "errors": { "message": ["The message field is required."] } }

// 502 — AI service error
{ "error": "AI service returned an error. Please try again." }

// 503 — AI service not configured or unreachable
{ "error": "AI service is not configured." }
{ "error": "Could not reach the AI service: Connection timed out" }
```

### What the AI Will Answer

The chatbot ONLY answers Saudi Arabia tourism questions:
- Destinations, attractions, landmarks
- Best times to visit, weather, travel tips
- Saudi culture, customs, heritage, history
- Events, festivals, seasons (Riyadh Season, Jeddah Season, etc.)
- Restaurants, food, cuisine recommendations
- Prices in SAR, entry fees, ticket info
- Vision 2030 projects (NEOM, The Red Sea, AlUla, Diriyah Gate)

**Non-tourism questions** get this response:
> "I'm sorry, I can only assist with Saudi Arabia tourism guidance, travel tips, and area history. Please ask me about destinations, best times to visit, cultural heritage, or travel safety in the Kingdom! 🕌"

---

### Step 1: Chat Message Model

```dart
// lib/models/chat_message.dart

class ChatMessage {
  final String text;
  final bool isUser; // true = user message, false = AI response
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
```

---

### Step 2: Chatbot API Service

```dart
// lib/services/chatbot_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  // Change this to your server IP
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1'; // Android emulator
  // static const String baseUrl = 'http://127.0.0.1:8000/api/v1'; // iOS simulator
  // static const String baseUrl = 'http://192.168.1.x:8000/api/v1'; // Physical device

  /// Send a message to AI and get a reply
  /// Returns the AI reply text on success
  /// Throws exception on error
  static Future<String> sendMessage(String message) async {
    final url = Uri.parse('$baseUrl/ai-assistant/chat');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'message': message}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['reply'] ?? 'Sorry, I could not generate a response.';
      } else if (response.statusCode == 422) {
        // Validation error
        final errors = data['errors'] as Map<String, dynamic>?;
        if (errors != null && errors.containsKey('message')) {
          throw Exception(errors['message'][0]);
        }
        throw Exception('Invalid message. Please try again.');
      } else if (response.statusCode == 502) {
        throw Exception('AI service is temporarily unavailable. Please try again.');
      } else if (response.statusCode == 503) {
        throw Exception(data['error'] ?? 'AI service is not available.');
      } else {
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error. Check your internet connection.');
    }
  }
}
```

---

### Step 3: Chat Provider (State Management)

```dart
// lib/providers/chat_provider.dart

import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chatbot_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;

  /// Quick suggestion prompts shown as chips
  List<String> get suggestions => [
    'Best places in Riyadh',
    'Traditional Saudi food',
    'Top events this month',
    'Budget travel tips',
    'Best time to visit Jeddah',
    'Family-friendly activities',
    'AlUla attractions',
    'NEOM project details',
  ];

  /// Send a message and get AI response
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    // Add user message
    _messages.add(ChatMessage(text: text.trim(), isUser: true));
    _isLoading = true;
    notifyListeners();

    try {
      final reply = await ChatbotService.sendMessage(text.trim());
      _messages.add(ChatMessage(text: reply, isUser: false));
    } catch (e) {
      _messages.add(ChatMessage(
        text: 'Sorry, something went wrong: ${e.toString().replaceAll('Exception: ', '')}',
        isUser: false,
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear chat history
  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}
```

---

### Step 4: Chat Screen UI

```dart
// lib/screens/chatbot_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/chat_message.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Saudi Vision 2030 Colors
  static const Color saudiGreen = Color(0xFF006C35);
  static const Color gold = Color(0xFFD4AF37);

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    context.read<ChatProvider>().sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: Colors.white),
            SizedBox(width: 8),
            Text('AI Tourism Guide', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: saudiGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () => context.read<ChatProvider>().clearChat(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chat, _) {
                if (chat.messages.isEmpty) {
                  return _buildWelcomeView(chat);
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chat.messages.length + (chat.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == chat.messages.length && chat.isLoading) {
                      return _buildTypingIndicator();
                    }
                    return _buildMessageBubble(chat.messages[index]);
                  },
                );
              },
            ),
          ),

          // Suggestion Chips (shown when few messages)
          Consumer<ChatProvider>(
            builder: (context, chat, _) {
              if (chat.messages.length > 4) return const SizedBox.shrink();
              return SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: chat.suggestions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(chat.suggestions[index]),
                        backgroundColor: saudiGreen.withOpacity(0.1),
                        labelStyle: TextStyle(color: saudiGreen, fontSize: 13),
                        onPressed: () => _sendMessage(chat.suggestions[index]),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Message Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLength: 1000,
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Ask about Saudi tourism...',
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: saudiGreen),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                Consumer<ChatProvider>(
                  builder: (context, chat, _) {
                    return CircleAvatar(
                      backgroundColor: chat.isLoading ? Colors.grey : saudiGreen,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 20),
                        onPressed: chat.isLoading
                            ? null
                            : () => _sendMessage(_controller.text),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Welcome view shown when no messages yet
  Widget _buildWelcomeView(ChatProvider chat) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.smart_toy, size: 80, color: saudiGreen.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text(
              'Saudi Tourism AI Guide',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask me anything about Saudi Arabia tourism,\ndestinations, culture, events & travel tips!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: chat.suggestions.map((s) {
                return ActionChip(
                  label: Text(s),
                  backgroundColor: saudiGreen.withOpacity(0.1),
                  labelStyle: TextStyle(color: saudiGreen),
                  onPressed: () => _sendMessage(s),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Chat message bubble
  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: message.isUser ? saudiGreen : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.smart_toy, size: 14, color: saudiGreen),
                    const SizedBox(width: 4),
                    Text('AI Guide', style: TextStyle(fontSize: 11, color: saudiGreen, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Typing indicator (3 animated dots)
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy, size: 14, color: saudiGreen),
            const SizedBox(width: 8),
            SizedBox(
              width: 40,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(saudiGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Step 5: Register Provider & Add to Navigation

**In `main.dart`:**
```dart
import 'package:provider/provider.dart';
import 'providers/chat_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        // ... other providers
      ],
      child: const MyApp(),
    ),
  );
}
```

**In your Bottom Navigation Bar (e.g., `home_shell.dart`):**
```dart
final List<Widget> _screens = [
  HomeScreen(),
  ExploreScreen(),
  ChatbotScreen(),    // Tab 3 — AI Guide
  MyBookingsScreen(),
  FavoritesScreen(),
  ProfileScreen(),
];

BottomNavigationBarItem(
  icon: Icon(Icons.smart_toy),
  label: 'AI Guide',
),
```

---

### Step 6: Test the Chatbot

**Test messages to try:**
```
"What are the best places to visit in Riyadh?"
"Tell me about AlUla"
"Best time to visit Saudi Arabia?"
"Traditional Saudi food recommendations"
"What is NEOM?"
"Family activities in Jeddah"
```

**Expected non-tourism response (test this too):**
```
"What is 2 + 2?"
→ AI replies: "I'm sorry, I can only assist with Saudi Arabia tourism guidance..."
```

---

### Chatbot API — Quick Reference

| Item | Value |
|------|-------|
| **Endpoint** | `POST /api/v1/ai-assistant/chat` |
| **Auth** | Not required |
| **Request** | `{ "message": "your question" }` |
| **Success Response** | `{ "reply": "AI answer text..." }` |
| **Error 422** | `{ "errors": { "message": [...] } }` |
| **Error 502** | `{ "error": "AI service returned an error" }` |
| **Error 503** | `{ "error": "AI service is not configured" }` |
| **Max message length** | 1000 characters |
| **AI model** | Groq LLaMA 3.3-70b-versatile |
| **Response time** | 2-5 seconds |
| **Topics** | Saudi tourism only |
