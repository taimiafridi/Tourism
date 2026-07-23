#!/bin/bash

# Tourism Guidance App - API Quick Reference Script
# Use this script to quickly test API endpoints with curl commands

API_URL="http://localhost:8000/api/v1"
ADMIN_URL="http://localhost:8000/api/admin"

# Store tokens
USER_TOKEN=""
ADMIN_TOKEN=""

echo "Tourism Guidance App - API Quick Tests"
echo "========================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. Test User Registration
test_registration() {
    echo -e "${BLUE}1. Testing User Registration...${NC}"
    
    RESPONSE=$(curl -s -X POST "$API_URL/register" \
      -H "Content-Type: application/json" \
      -d '{
        "name": "Test User",
        "email": "test@example.com",
        "password": "TestPassword123",
        "phone": "+1234567890",
        "role": "user"
      }')
    
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    echo ""
}

# 2. Test User Login
test_login() {
    echo -e "${BLUE}2. Testing User Login...${NC}"
    
    RESPONSE=$(curl -s -X POST "$API_URL/login" \
      -H "Content-Type: application/json" \
      -d '{
        "email": "test@example.com",
        "password": "TestPassword123"
      }')
    
    TOKEN=$(echo "$RESPONSE" | jq -r '.access_token' 2>/dev/null)
    
    if [ "$TOKEN" != "null" ] && [ ! -z "$TOKEN" ]; then
        USER_TOKEN=$TOKEN
        echo -e "${GREEN}Login successful! Token saved.${NC}"
    fi
    
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    echo ""
}

# 3. Test Get Destinations
test_get_destinations() {
    echo -e "${BLUE}3. Testing Get Destinations...${NC}"
    
    RESPONSE=$(curl -s -X GET "$API_URL/destinations?per_page=5" \
      -H "Content-Type: application/json")
    
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    echo ""
}

# 4. Test Get Profile (Requires Auth)
test_get_profile() {
    echo -e "${BLUE}4. Testing Get User Profile...${NC}"
    
    if [ -z "$USER_TOKEN" ]; then
        echo -e "${RED}Error: No user token available. Run login test first.${NC}"
        return
    fi
    
    RESPONSE=$(curl -s -X GET "$API_URL/profile" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $USER_TOKEN")
    
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    echo ""
}

# 5. Test Create Booking (Requires Auth)
test_create_booking() {
    echo -e "${BLUE}5. Testing Create Booking...${NC}"
    
    if [ -z "$USER_TOKEN" ]; then
        echo -e "${RED}Error: No user token available. Run login test first.${NC}"
        return
    fi
    
    RESPONSE=$(curl -s -X POST "$API_URL/bookings" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $USER_TOKEN" \
      -d '{
        "tour_id": 1,
        "number_of_participants": 2,
        "payment_method": "card"
      }')
    
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    echo ""
}

# 6. Test Get Tours
test_get_tours() {
    echo -e "${BLUE}6. Testing Get Tours...${NC}"
    
    RESPONSE=$(curl -s -X GET "$API_URL/tours?per_page=5" \
      -H "Content-Type: application/json")
    
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    echo ""
}

# 7. Test Get Guides
test_get_guides() {
    echo -e "${BLUE}7. Testing Get Guides...${NC}"
    
    RESPONSE=$(curl -s -X GET "$API_URL/guides?per_page=5" \
      -H "Content-Type: application/json")
    
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    echo ""
}

# 8. Test Submit Review (Requires Auth)
test_submit_review() {
    echo -e "${BLUE}8. Testing Submit Review...${NC}"
    
    if [ -z "$USER_TOKEN" ]; then
        echo -e "${RED}Error: No user token available. Run login test first.${NC}"
        return
    fi
    
    RESPONSE=$(curl -s -X POST "$API_URL/reviews" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $USER_TOKEN" \
      -d '{
        "destination_id": 1,
        "rating": 5,
        "comment": "Amazing place! Highly recommended."
      }')
    
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    echo ""
}

# 9. Admin Test - Register Admin User
test_admin_registration() {
    echo -e "${BLUE}9. Testing Admin Registration...${NC}"
    
    RESPONSE=$(curl -s -X POST "$API_URL/register" \
      -H "Content-Type: application/json" \
      -d '{
        "name": "Admin User",
        "email": "admin@example.com",
        "password": "AdminPassword123",
        "phone": "+1234567890",
        "role": "user"
      }')
    
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    echo ""
}

# 10. Admin Test - Get Dashboard Statistics
test_admin_dashboard() {
    echo -e "${BLUE}10. Testing Admin Dashboard...${NC}"
    
    # Note: This requires an admin token. For testing, manually set admin token
    ADMIN_TOKEN="$USER_TOKEN"  # Change this to actual admin token
    
    if [ -z "$ADMIN_TOKEN" ]; then
        echo -e "${RED}Error: No admin token available.${NC}"
        return
    fi
    
    RESPONSE=$(curl -s -X GET "$ADMIN_URL/dashboard/statistics" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $ADMIN_TOKEN")
    
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    echo ""
}

# Run all tests
run_all_tests() {
    echo -e "${GREEN}Starting API Tests...${NC}\n"
    
    test_registration
    test_login
    test_get_destinations
    test_get_tours
    test_get_guides
    test_get_profile
    test_create_booking
    test_submit_review
    test_admin_registration
    
    echo -e "${GREEN}Tests completed!${NC}"
}

# Interactive menu
show_menu() {
    echo "Select Test to Run:"
    echo "1. User Registration"
    echo "2. User Login"
    echo "3. Get Destinations"
    echo "4. Get User Profile"
    echo "5. Create Booking"
    echo "6. Get Tours"
    echo "7. Get Guides"
    echo "8. Submit Review"
    echo "9. Admin Registration"
    echo "10. Admin Dashboard"
    echo "11. Run All Tests"
    echo "0. Exit"
    echo ""
    read -p "Enter your choice: " choice
}

# Main loop
while true; do
    show_menu
    
    case $choice in
        1) test_registration ;;
        2) test_login ;;
        3) test_get_destinations ;;
        4) test_get_profile ;;
        5) test_create_booking ;;
        6) test_get_tours ;;
        7) test_get_guides ;;
        8) test_submit_review ;;
        9) test_admin_registration ;;
        10) test_admin_dashboard ;;
        11) run_all_tests ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice!" ;;
    esac
done
