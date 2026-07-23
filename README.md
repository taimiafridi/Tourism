# Tourism Guidance App - Backend API

A comprehensive REST API backend for a mobile tourism guidance application built with **Laravel 11** and **Laravel Sanctum**.

## Features

### 🌍 Core Features
- **Destinations Management**: Browse and explore tourism destinations
- **Tours & Itineraries**: Create and manage guided tours with daily itineraries
- **Booking System**: Easy-to-use tour booking with real-time availability
- **Review System**: Community reviews for destinations and guides
- **Guide System**: Professional guide profiles with verification system
- **User Profiles**: User account management and booking history

### 👨‍💼 Admin Panel Features
- Complete dashboard with statistics and analytics
- Destination CRUD operations
- User management (roles, status, permissions)
- Guide application verification
- Booking management and payment status tracking
- Review moderation
- Revenue analytics

### 🔐 Security & Authentication
- **Laravel Sanctum** for API authentication (mobile-friendly)
- Role-based access control (User, Guide, Admin)
- Secure password hashing
- Admin middleware authorization
- Input validation and sanitization

## Quick Start

### Prerequisites
- PHP >= 8.2
- MySQL/MariaDB 5.7+
- Composer

### Installation

```bash
# 1. Clone repository
cd d:/tourist_guide

# 2. Install dependencies
composer install

# 3. Setup environment
cp .env.example .env
php artisan key:generate

# 4. Configure database in .env
DB_DATABASE=tourism_guide
DB_USERNAME=root
DB_PASSWORD=

# 5. Run migrations
php artisan migrate

# 6. Start server
php artisan serve
```

**API Available at:** `http://localhost:8000/api/v1`

## API Documentation

Comprehensive API documentation with all endpoints, request/response examples, and authentication details:

📖 **[Full API Documentation](./API_DOCUMENTATION.md)**
📚 **[Setup & Development Guide](./SETUP_GUIDE.md)**

### Quick API Examples

#### Register User
```bash
POST /api/v1/register
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "+1234567890"
}
```

#### Login
```bash
POST /api/v1/login
{
  "email": "john@example.com",
  "password": "password123"
}
```

#### Get Destinations
```bash
GET /api/v1/destinations?search=Paris&country=France
```

#### Create Booking (Authenticated)
```bash
POST /api/v1/bookings
Authorization: Bearer {token}
{
  "tour_id": 1,
  "number_of_participants": 2,
  "payment_method": "card"
}
```

#### Admin: Get Dashboard Stats
```bash
GET /api/admin/dashboard/statistics
Authorization: Bearer {admin_token}
```

## Project Structure

```
app/Models/
├── User.php                 # Enhanced with role, phone, status
├── Destination.php
├── Tour.php
├── Guide.php
├── Booking.php
├── Review.php
├── GuideReview.php
└── ItineraryItem.php

app/Http/Controllers/
├── Api/                     # Mobile API Controllers
│   ├── AuthController.php
│   ├── DestinationController.php
│   ├── TourController.php
│   ├── BookingController.php
│   ├── ReviewController.php
│   └── GuideController.php
└── Admin/                   # Admin API Controllers
    ├── DestinationController.php
    ├── UserController.php
    ├── GuideController.php
    ├── BookingController.php
    ├── ReviewController.php
    └── DashboardController.php

database/migrations/
├── create_destinations_table.php
├── create_guides_table.php
├── create_tours_table.php
├── create_bookings_table.php
├── create_reviews_table.php
├── create_guide_reviews_table.php
├── create_itinerary_items_table.php
└── modify_users_table.php

routes/
├── api.php                  # All API routes
└── web.php
```

## Database Schema

### Core Tables
- **users**: User accounts (tourists, guides, admins)
- **destinations**: Tourism attractions and locations
- **tours**: Guided tours linked to destinations
- **guides**: Professional tour guides with verification
- **bookings**: Tour bookings with payment tracking
- **reviews**: Destination reviews
- **guide_reviews**: Guide/experience reviews
- **itinerary_items**: Daily tour itinerary details

## Authentication

Uses **Laravel Sanctum** for stateless API authentication:

1. User registers/logs in → receives `access_token`
2. Include token in requests: `Authorization: Bearer {token}`
3. Token tied to `personal_access_tokens` table
4. User can logout to revoke token

### User Roles
- **user**: Regular tourist user
- **guide**: Professional tour guide
- **admin**: Administrator with full access

## API Endpoints Overview

### Public (No Auth Required)
- `GET /destinations` - List destinations
- `GET /tours` - Browse tours
- `GET /guides` - Find guides
- `POST /register` - User registration
- `POST /login` - User login

### Authenticated (Token Required)
- `GET /profile` - User profile
- `POST /bookings` - Create booking
- `GET /bookings` - My bookings
- `POST /reviews` - Submit review
- `POST /guides/apply` - Apply as guide

### Admin (Admin Token Required)
- `GET /admin/dashboard/statistics` - Dashboard stats
- `GET /admin/destinations` - Manage destinations
- `GET /admin/users` - Manage users
- `GET /admin/guides` - Verify guides
- `GET /admin/bookings` - View bookings
- `GET /admin/reviews` - Moderate reviews

## Development

### Running Tests
```bash
php artisan test
```

### Clearing Cache
```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

### Database Commands
```bash
php artisan migrate               # Run migrations
php artisan migrate:rollback      # Undo last migration
php artisan migrate:fresh         # Reset database (⚠️ destructive)
php artisan db:seed              # Run seeders
```

## Configuration

### Important Files
- `.env` - Environment configuration
- `config/app.php` - Application settings
- `config/database.php` - Database configuration
- `config/sanctum.php` - API token settings

### Sanctum Configuration
Setup stateless guards for mobile apps in `config/sanctum.php`:
```php
'guard' => ['sanctum'],
'stateless' => true,
```

## Key Design Decisions

1. **Stateless API**: Using Sanctum tokens for mobile compatibility
2. **Role-Based Access**: Simple role system (user, guide, admin)
3. **Modular Controllers**: Separated API and Admin controllers
4. **Comprehensive Validation**: All inputs validated at controller level
5. **Soft Deletes**: Available for audit trails (not implemented by default)

## Security Features

✅ Password hashing with `Hash::make()`  
✅ Token-based authentication with Sanctum  
✅ Admin middleware authorization  
✅ Input validation on all endpoints  
✅ User status management (active/inactive/suspended)  
✅ Guide verification system  
✅ Review moderation system  

## Future Enhancements

- [ ] Payment gateway integration (Stripe/PayPal)
- [ ] Email notifications for bookings
- [ ] SMS notifications for OTP
- [ ] Advanced analytics dashboard
- [ ] Rating/recommendation engine
- [ ] Image upload for destinations
- [ ] Real-time booking notifications
- [ ] Multi-language support
- [ ] API rate limiting
- [ ] Comprehensive logging

## Troubleshooting

**Issue**: Token not working
- Verify token format: `Authorization: Bearer {token}`
- Check token exists in `personal_access_tokens` table
- Ensure user is not suspended

**Issue**: Database connection error
- Check `.env` database credentials
- Verify database exists
- Run `php artisan migrate`

**Issue**: Admin endpoints return 403
- Verify user role is `'admin'`
- Check token is valid
- Ensure Authorization header included

## Learning Resources

- [Laravel Documentation](https://laravel.com/docs)
- [Sanctum Guide](https://laravel.com/docs/sanctum)
- [REST API Best Practices](https://restfulapi.net/)
- [API Documentation](./API_DOCUMENTATION.md)
- [Setup Guide](./SETUP_GUIDE.md)

## License

This project is open-source and available under the [MIT license](LICENSE).

## Support

For questions or issues:
1. Review [API_DOCUMENTATION.md](./API_DOCUMENTATION.md)
2. Check [SETUP_GUIDE.md](./SETUP_GUIDE.md)
3. Review controller comments in `app/Http/Controllers/`
4. Check model relationships in `app/Models/`

---

**Built with ❤️ using Laravel 11**

## Agentic Development

Laravel's predictable structure and conventions make it ideal for AI coding agents like Claude Code, Cursor, and GitHub Copilot. Install [Laravel Boost](https://laravel.com/docs/ai) to supercharge your AI workflow:

```bash
composer require laravel/boost --dev

php artisan boost:install
```

Boost provides your agent 15+ tools and skills that help agents build Laravel applications while following best practices.

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
