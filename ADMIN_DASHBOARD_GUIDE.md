# Tourist Guide Admin Dashboard - Filament

## Overview

A complete, production-ready **Filament Admin Dashboard** for managing the Saudi Arabia Tourism Guidance Application. Filament is a modern admin panel builder for Laravel with a beautiful, intuitive interface.

## 🎯 Dashboard URL

**admin.local/admin** or **127.0.0.1:8000/admin**

## 📋 Login Credentials

```
Email:    admin@tourism.local
Password: password123
```

## 📊 Dashboard Resources

The admin dashboard includes the following management modules:

### 1. **Dashboard Overview** (Home)
- **Total Users**: Real-time count of registered users
- **Events**: Active events in the system
- **Restaurants**: Registered restaurants
- **Event Bookings**: Total bookings made
- **Total Revenue**: Revenue from event bookings in SAR

### 2. **Events Management**
**Path**: `/admin/events`

#### Features:
- ✅ Create new events
- ✅ Edit event details
- ✅ Delete events
- ✅ View event information
- ✅ Filter by status (active, inactive, completed, cancelled)
- ✅ Filter by category
- ✅ Mark as featured

#### Fields:
- **Event Name**: Title of the event
- **Description**: Detailed event information
- **Category**: Event category
- **City**: Event location city
- **Latitude/Longitude**: GPS coordinates
- **Start Date & Time**: When the event begins
- **End Date & Time**: When the event ends
- **Capacity**: Total ticket availability
- **Ticket Price**: Price per ticket in SAR
- **Status**: Active/Inactive/Completed/Cancelled
- **Featured**: Make event appear in featured section

### 3. **Restaurants Management**
**Path**: `/admin/restaurants`

#### Features:
- ✅ Create new restaurants
- ✅ Edit restaurant details
- ✅ Delete restaurants
- ✅ View restaurant information
- ✅ Filter by status (active, inactive, closed)
- ✅ Filter by category
- ✅ Filter by cuisine type
- ✅ Mark as featured

#### Fields:
- **Restaurant Name**: Name of establishment
- **Description**: Details about the restaurant
- **Cuisine Type**: Type of cuisine (Italian, Asian, Saudi, etc.)
- **Category**: Restaurant category
- **City**: Location city
- **Latitude/Longitude**: GPS coordinates
- **Opening/Closing Time**: Operating hours
- **Average Cost**: Cost per person in SAR
- **Contact Phone**: Phone number
- **Contact Email**: Email address
- **Status**: Active/Inactive/Closed
- **Featured**: Highlight in featured restaurants

### 4. **Categories Management**
**Path**: `/admin/categories`

#### Features:
- ✅ Create categories for destinations, events, restaurants
- ✅ Edit existing categories
- ✅ Delete categories (with safety checks)
- ✅ View category information
- ✅ Filter by type (destination, event, restaurant)

#### Fields:
- **Name**: Category name
- **Slug**: URL-friendly identifier (auto-generated)
- **Type**: Destination/Event/Restaurant
- **Description**: Category description (optional)
- **Icon URL**: Icon URL for display
- **Active**: Enable/disable category

### 5. **Event Bookings Management**
**Path**: `/admin/event-bookings`

#### Features:
- ✅ View all event bookings
- ✅ View booking details
- ✅ Update booking status
- ✅ Update payment status
- ✅ Add admin notes
- ✅ Filter by booking status
- ✅ Filter by payment status

#### Fields:
- **Booking Reference**: Unique booking ID
- **Event**: Associated event
- **User**: Customer name
- **Tickets**: Number of tickets
- **Total Price**: Booking total in SAR
- **Booking Status**: Pending/Confirmed/Cancelled
- **Payment Status**: Unpaid/Paid/Refunded
- **Admin Notes**: Internal notes

### 6. **Users Management**
**Path**: `/admin/users`

#### Features:
- ✅ View all users
- ✅ Edit user information
- ✅ Edit user role (user, guide, admin)
- ✅ Verify email status
- ✅ Delete users
- ✅ Filter by role

#### Fields:
- **Name**: User full name
- **Email**: Email address (unique)
- **Phone**: Phone number
- **City**: City of residence
- **Country**: Country of residence
- **Role**: User/Guide/Admin
- **Email Verified**: Verification status

### 7. **Reviews Management**
**Path**: `/admin/reviews`

#### Features:
- ✅ View all reviews (events & restaurants)
- ✅ Approve/reject reviews
- ✅ Add rejection reason for public display
- ✅ Delete reviews
- ✅ Filter by approval status
- ✅ View reviewer information

#### Fields:
- **Item**: Event or Restaurant being reviewed
- **Reviewer**: User who submitted review
- **Rating**: 1-5 star rating
- **Comment**: Review text
- **Status**: Pending/Approved/Rejected
- **Rejection Reason**: Why review was rejected (if applicable)

### 8. **Destinations Management**
**Path**: `/admin/destinations`

#### Features:
- ✅ Create new destinations
- ✅ Edit destination details
- ✅ Delete destinations
- ✅ View destination information
- ✅ Filter by status
- ✅ Filter by category
- ✅ Mark as featured

#### Fields:
- **Name**: Destination name
- **Description**: Detailed description
- **Category**: Destination category
- **City**: Location city
- **Latitude/Longitude**: GPS coordinates
- **Best Time to Visit**: Recommended season
- **Status**: Active/Inactive/Under Maintenance
- **Featured**: Highlight in featured destinations

## 🎨 Dashboard Features

### Table Features:
- **Search**: Search across all columns
- **Sort**: Click column headers to sort
- **Filter**: Use filter buttons to narrow results
- **Pagination**: Navigate through pages
- **Bulk Actions**: Select multiple items for bulk operations
- **Toggle Columns**: Show/hide columns

### Form Features:
- **Field Validation**: Real-time error messages
- **Relationships**: Dropdown selection for related records
- **Rich Editor**: Textarea for long descriptions
- **Toggle Switches**: Boolean fields
- **Date/Time Picker**: Date and time selection
- **Required Fields**: Clear indication of mandatory fields

## 📱 Responsive Design

The Filament dashboard is fully responsive and works on:
- ✅ Desktop browsers
- ✅ Tablets
- ✅ Mobile devices

## 🔒 Security Features

- ✅ User authentication required
- ✅ Role-based access control
- ✅ CSRF token protection
- ✅ Input validation
- ✅ SQL injection prevention (Eloquent ORM)
- ✅ XSS protection

## 🚀 Advanced Features

### 1. **Bulk Operations**
Select multiple items and:
- Delete multiple records at once
- Update multiple records (future enhancement)

### 2. **Advanced Filtering**
- Primary filter on main status
- Secondary filter on category
- Ternary filter for featured items
- Combined filters for precise results

### 3. **Real-time Statistics**
Dashboard widgets automatically update with:
- User count
- Event count
- Restaurant count
- Booking count
- Revenue calculation

### 4. **Search & Navigation**
- Global search across all resources
- Quick access via sidebar navigation
- Breadcrumb navigation
- Quick action buttons

## 📊 API Integration

The dashboard integrates with your REST API endpoints:
- Users managed via `/api/users`
- Events managed via `/api/events` (admin endpoints)
- Restaurants managed via `/api/restaurants` (admin endpoints)
- All data syncs between dashboard and API

## 🔧 Customization

To customize the dashboard:

1. **Edit Resources**: Modify files in `app/Filament/Admin/Resources/`
2. **Edit Widgets**: Modify files in `app/Filament/Admin/Widgets/`
3. **Edit Pages**: Modify files in `app/Filament/Admin/Pages/`

### Add New Column to Table:
```php
Tables\Columns\TextColumn::make('field_name')
    ->searchable()
    ->sortable(),
```

### Add New Filter:
```php
Tables\Filters\SelectFilter::make('status')
    ->options([...])
```

### Add New Form Field:
```php
Forms\Components\TextInput::make('field_name')
    ->required()
    ->placeholder('...')
```

## 🐛 Troubleshooting

### Dashboard Not Loading?
1. Run `php artisan migrate` to set up database
2. Run `php artisan cache:clear`
3. Run `php artisan config:cache`
4. Ensure server is running: `php artisan serve`

### Can't Login?
1. Check credentials (default: admin@tourism.local / password123)
2. Verify user exists: `php artisan db:seed --class=AdminUserSeeder`
3. Check database connection

### Resources Not Showing?
1. Clear config cache: `php artisan config:cache`
2. Clear routes: `php artisan route:clear`
3. Restart server

## 📱 Mobile Access

Access the dashboard on mobile:
1. Find your computer's IP address
2. On mobile, visit: `http://YOUR_IP:8000/admin`
3. Use same login credentials

## 🎓 Best Practices

1. **Regular Backups**: Backup database regularly
2. **Featured Items**: Carefully select featured items for quality
3. **Review Moderation**: Regularly moderate and approve reviews
4. **Category Management**: Keep categories organized and up-to-date
5. **Booking Monitoring**: Monitor booking statuses and payment status
6. **User Management**: Handle user reports and admin assignments

## 📞 Support

For issues or questions:
1. Check the API documentation at `/ENHANCED_API_DOCUMENTATION.md`
2. Review Filament documentation: https://filamentphp.com/docs/guide
3. Check Laravel documentation: https://laravel.com/docs

## 🗺️ Next Steps

1. ✅ Login to dashboard at `/admin`
2. ✅ Create initial categories
3. ✅ Add destinations, events, and restaurants
4. ✅ Invite users to the platform
5. ✅ Monitor bookings and reviews
6. ✅ Integration with payment gateway
7. ✅ Set up email notifications

---

**Dashboard Version**: 1.0
**Last Updated**: April 2, 2026
**Framework**: Filament 5.4.3 / Laravel 11
