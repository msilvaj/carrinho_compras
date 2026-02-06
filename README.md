# Shopping Cart API

A RESTful API for managing shopping carts in an e-commerce application, built with Ruby on Rails 7.1.3.2.

## Technical Stack

- **Ruby**: 3.3.1
- **Rails**: 7.1.3.2
- **Database**: PostgreSQL 16
- **Cache/Jobs**: Redis 7.0.15
- **Background Jobs**: Sidekiq 7.0 with sidekiq-cron
- **Testing**: RSpec, FactoryBot, Faker
- **Containerization**: Docker & Docker Compose

## Features

### Core Functionality
- ✅ Add products to cart
- ✅ List cart items
- ✅ Update product quantities
- ✅ Remove products from cart
- ✅ Session-based cart management
- ✅ Automatic price calculation

### Background Jobs
- ✅ Mark carts as abandoned after 3 hours of inactivity
- ✅ Delete abandoned carts after 7 days
- ✅ Hourly cron job execution via Sidekiq

### Code Quality
- ✅ Clean, readable code following Rails conventions
- ✅ Comprehensive RSpec test coverage
- ✅ FactoryBot for test data
- ✅ Input validation and error handling
- ✅ Database indexes for performance

## API Endpoints

### 1. Add Product to Cart
**POST** `/cart`

```json
{
  "product_id": 1,
  "quantity": 2
}
```

**Response:**
```json
{
  "id": 1,
  "products": [
    {
      "id": 1,
      "name": "Laptop",
      "quantity": 2,
      "unit_price": 1000.0,
      "total_price": 2000.0
    }
  ],
  "total_price": 2000.0
}
```

### 2. View Current Cart
**GET** `/cart`

**Response:** Same as above

### 3. Update Product Quantity
**POST** `/cart/add_item`

```json
{
  "product_id": 1,
  "quantity": 1
}
```

**Response:** Updated cart with new quantities

### 4. Remove Product from Cart
**DELETE** `/cart/:product_id`

**Response:** Updated cart without the removed product

## Setup Instructions

### Using Docker (Recommended)

1. **Clone the repository**
```bash
git clone https://github.com/msilvaj/carrinho_compras.git
cd carrinho_compras
```

2. **Build and start containers**
```bash
docker-compose build
docker-compose up
```

3. **Setup database** (in another terminal)
```bash
docker-compose exec app bundle exec rails db:create db:migrate db:seed
```

4. **Access the application**
- API: http://localhost:3000
- Sidekiq Dashboard: http://localhost:3000/sidekiq

### Without Docker

**Prerequisites:**
- Ruby 3.3.1
- PostgreSQL 16
- Redis 7.0.15

**Steps:**

1. **Install dependencies**
```bash
bundle install
```

2. **Configure database**
```bash
# Edit config/database.yml with your PostgreSQL credentials
cp config/database.yml.example config/database.yml
```

3. **Setup database**
```bash
bundle exec rails db:create db:migrate db:seed
```

4. **Start Redis**
```bash
redis-server
```

5. **Start Sidekiq** (in separate terminal)
```bash
bundle exec sidekiq
```

6. **Start Rails server**
```bash
bundle exec rails server
```

## Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/cart_spec.rb

# Run with coverage
bundle exec rspec --format documentation
```

## Project Structure

```
app/
├── controllers/
│   └── carts_controller.rb      # Cart API endpoints
├── models/
│   ├── cart.rb                   # Cart model with status enum
│   ├── cart_item.rb              # Join model with price calculations
│   └── product.rb                # Product model
└── jobs/
    └── manage_abandoned_carts_job.rb  # Background job for cart cleanup

config/
├── initializers/
│   └── sidekiq.rb                # Sidekiq configuration
├── schedule.yml                  # Cron job schedule
└── routes.rb                     # API routes

db/
├── migrate/                      # Database migrations
└── seeds.rb                      # Sample product data

spec/
├── factories/                    # FactoryBot factories
├── models/                       # Model tests
└── requests/                     # API endpoint tests
```

## Database Schema

### Products
- `id`: Primary key
- `name`: Product name (required)
- `unit_price`: Decimal(10,2) (required, >= 0)
- `created_at`, `updated_at`: Timestamps

### Carts
- `id`: Primary key
- `status`: Integer (0=active, 1=abandoned)
- `total_price`: Decimal(10,2)
- `last_interaction_at`: Datetime
- `created_at`, `updated_at`: Timestamps

### CartItems
- `id`: Primary key
- `cart_id`: Foreign key to carts
- `product_id`: Foreign key to products
- `quantity`: Integer (required, > 0)
- `unit_price`: Decimal(10,2) (snapshot at time of addition)
- `total_price`: Decimal(10,2) (calculated)
- `created_at`, `updated_at`: Timestamps
- **Unique index**: `[cart_id, product_id]`

## Environment Variables

```bash
# Database
DB_HOST=db
DB_USER=postgres
DB_PASSWORD=password

# Redis
REDIS_URL=redis://redis:6379/1

# Rails
RAILS_ENV=development
```

## Development Notes

### Clean Code Principles Applied
- Single Responsibility: Each model/controller has a clear purpose
- DRY: Shared logic in model methods
- Meaningful names: Clear, descriptive variable and method names
- Small methods: Each method does one thing well
- Comments only where necessary

### Performance Considerations
- Database indexes on frequently queried columns
- Eager loading with `includes` to avoid N+1 queries
- Efficient background job processing with Sidekiq
- Session-based cart management (no authentication overhead)

### Error Handling
- Validates product existence before cart operations
- Ensures quantity is positive
- Returns appropriate HTTP status codes
- Clear error messages in JSON responses

## Monitoring

Access the Sidekiq dashboard at `/sidekiq` to monitor:
- Job execution status
- Queue sizes
- Failed jobs
- Cron schedule

## License

This project was created as a technical challenge.
