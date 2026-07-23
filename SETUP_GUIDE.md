# Tourism Guidance App - Backend Setup Guide

## Project Overview

This is a comprehensive Laravel-based REST API backend for a tourism guidance mobile app with:
- User authentication and authorization
- Destination and tour management
- Tour booking system
- Review and rating system
- Admin panel for managing content and users
- Guide verification system

## Project Structure

```
app/
├── Http/
│   ├── Controllers/
│   │   ├── Api/              # API Controllers for mobile app
│   │   │   ├── AuthController.php
│   │   │   ├── DestinationController.php
│   │   │   ├── TourController.php
│   │   │   ├── BookingController.php
│   │   │   ├── ReviewController.php
│   │   │   └── GuideController.php
│   │   └── Admin/            # Admin API Controllers
│   │       ├── DestinationController.php
│   │       ├── UserController.php
│   │       ├── GuideController.php
│   │       ├── BookingController.php
│   │       ├── ReviewController.php
│   │       └── DashboardController.php
│   └── Middleware/
│       └── AdminMiddleware.php
├── Models/
│   ├── Destination.php
│   ├── Tour.php
│   ├── Guide.php
│   ├── Booking.php
│   ├── Review.php
│   ├── GuideReview.php
│   ├── ItineraryItem.php
│   └── User.php
database/
├── migrations/
│   ├── xxx_create_destinations_table.php
│   ├── xxx_create_guides_table.php
│   ├── xxx_create_tours_table.php
│   ├── xxx_create_bookings_table.php
│   ├── xxx_create_reviews_table.php
│   ├── xxx_create_guide_reviews_table.php
│   ├── xxx_create_itinerary_items_table.php
│   └── xxx_modify_users_table.php
└── seeders/
    └── DatabaseSeeder.php
routes/
├── api.php                   # All API routes
└── web.php
```

## Database Schema

### Users Table
- Enhanced with `role` (user, guide, admin), `phone`, and `status` fields
- Uses Laravel Sanctum for API authentication

### Destinations Table
- Core tourism destinations/attractions
- Fields: name, description, location, image, entry fee, best time to visit, status

### Tours Table
- Curated tours for destinations
- Linked to destinations and guides
- Fields: name, description, price, duration, max participants, dates

### Guides Table
- Professional tour guides
- Verification system (pending, verified, rejected)
- Fields: bio, experience, languages, rating, phone

### Bookings Table
- User bookings for tours
- Tracking: status, payment status, number of participants

### Reviews Tables
- **reviews**: For destination reviews
- **guide_reviews**: For guide/tour reviews
- Fields: rating (1-5), comment, approval status

### Itinerary Items
- Day-by-day breakdown of tours
- Linked to specific tours

## Installation & Setup

### 1. Prerequisites
- PHP >= 8.2
- MySQL/MariaDB 5.7+
- Composer
- Node.js & npm (optional, for frontend assets)

### 2. Clone & Install
```bash
# Navigate to project directory
cd d:/tourist_guide

# Install PHP dependencies
composer install

# Install Node dependencies (optional)
npm install
```

### 3. Environment Configuration
```bash
# Copy example env file
cp .env.example .env

# Generate application key
php artisan key:generate

# Update .env with your database credentials
# DB_DATABASE=tourism_guide
# DB_USERNAME=root
# DB_PASSWORD=your_password
```

### 4. Database Setup
```bash
# Run migrations
php artisan migrate

# (Optional) Seed dummy data
php artisan db:seed
```

### 5. Sanctum Setup (Already configured)
```bash
# Publish Sanctum configuration (if needed)
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

### 6. Run the Application
```bash
# Start development server
php artisan serve

# In another terminal, run Vite (if building frontend assets)
npm run dev
```

The API will be available at: `http://localhost:8000/api/v1`

## API Authentication

The API uses **Laravel Sanctum** for token-based authentication (mobile app friendly).

### Getting a Token
1. User registers or logs in
2. Receives an access token in response
3. Includes token in `Authorization: Bearer {token}` header for protected routes

### Token Management
- Tokens are stored in `personal_access_tokens` table
- Revoke tokens by calling `/api/v1/logout`
- Tokens automatically expire based on your guard configuration

## Key Features

### 1. Public Endpoints (No Authentication)
- Browse destinations
- View tours
- View guides and reviews
- User registration and login

### 2. User Endpoints (Authenticated)
- Profile management
- Book tours
- Submit reviews
- Apply as guide
- View booking history

### 3. Guide Features
- Create tours
- Receive bookings
- Get guide reviews
- Pending verification system

### 4. Admin Features
- Dashboard with statistics
- Manage destinations and tours
- Manage users (role, status)
- Verify/reject guide applications
- Moderate reviews
- Manage bookings
- Revenue analytics

## Development Workflow

### Adding New Features
1. Create model: `php artisan make:model ModelName -m`
2. Create migration with `-m` flag (see above)
3. Create controller: `php artisan make:controller ControllerName`
4. Add routes to `routes/api.php`
5. Update models with relationships

### Testing the API
- Use **Postman** or **Insomnia** for manual testing
- Import the API_DOCUMENTATION.md for reference
- Example Postman collection format:
  ```json
  {
    "info": { "name": "Tourism API" },
    "item": [
      {
        "name": "Register",
        "request": {
          "method": "POST",
          "url": { "raw": "http://localhost:8000/api/v1/register" }
        }
      }
    ]
  }
  ```

## Configuration Tips

### CORS (for frontend development)
Enable CORS in `config/cors.php`:
```php
'allowed_origins' => ['*'], // Adjust for production
```

### API Rate Limiting
Add to route group in `routes/api.php`:
```php
Route::middleware('throttle:60,1')->group(function () {
    // Your routes
});
```

### Database Connection
For **SQLite** (testing):
```bash
touch database/database.sqlite
# Update .env:
DB_CONNECTION=sqlite
DB_DATABASE=/path/to/database.sqlite
```

## Common Commands

```bash
# Create model with migration
php artisan make:model Tour -m

# Create seeder
php artisan make:seeder TourSeeder

# Run migrations
php artisan migrate

# Rollback migrations
php artisan migrate:rollback

# Fresh database (⚠️ destructive)
php artisan migrate:fresh

# Clear all caches
php artisan cache:clear
php artisan config:clear
php artisan route:clear

# Run tests
php artisan test

# Generate API documentation
php artisan scribe:generate
```

## Security Considerations

1. **Input Validation**: All controller inputs are validated
2. **Authorization**: Admin endpoints protected by `AdminMiddleware`
3. **Rate Limiting**: Implement `throttle` middleware for production
4. **HTTPS**: Always use HTTPS in production
5. **CORS**: Configure allowed origins appropriately
6. **Token Expiration**: Configure in `config/sanctum.php`
7. **Password Hashing**: Passwords stored using `Hash::make()`

## Troubleshooting

### "SQLSTATE[HY000]: General error"
- Run `php artisan cache:clear`
- Check database connection in `.env`

### Token not working
- Verify token sent with `Authorization: Bearer {token}`
- Check token in `personal_access_tokens` table
- Ensure user is not suspended

### Migrations failed
- Check database exists and credentials are correct
- Run `php artisan migrate:refresh` to reset

### Admin middleware error
- Verify user has `role = 'admin'`
- Token included in Authorization header

## Resources

- [Laravel Documentation](https://laravel.com/docs)
- [Laravel Sanctum](https://laravel.com/docs/sanctum)
- [REST API Best Practices](https://restfulapi.net/)
- API_DOCUMENTATION.md in project root

## Next Steps

1. **Create Admin Dashboard Frontend** (Vue/React)
2. **Implement Payment Gateway** (Stripe, PayPal)
3. **Add Email Notifications** (Laravel Mail)
4. **Set up Testing** (PHPUnit, Feature Tests)
5. **Deploy to Production** (AWS, Heroku, DigitalOcean)
6. **Add API Documentation** (Laravel Scribe, Swagger)

## Support

For issues or questions:
1. Check API_DOCUMENTATION.md
2. Review Laravel documentation
3. Check controller comments for method descriptions
4. Review model relationships in `app/Models/`
