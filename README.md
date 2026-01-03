# <a href="https://rockdontstock.onrender.com">Rock Don't Stock</a> 👟

A marketplace connecting buyers and sellers of **authentic sneakers**, with expert verification to combat counterfeits in the French resale market.

---

## 🎯 Why This Project?

The sneaker resale market in France has exploded, but platforms like Vinted and Leboncoin are flooded with counterfeit pairs. Buyers have no guarantee of authenticity.

**Rock Don't Stock solves this problem** by providing:
- Expert verification of every pair before shipment
- Detailed condition reports delivered within 24 hours
- A trusted marketplace where buyers can purchase with confidence

---

## ✨ Key Features

### For Buyers
- Browse verified authentic sneakers
- Advanced search and filtering
- Secure payment processing (Stripe)
- Real-time shipping tracking
- Discount code support

### For Sellers
- Legal seller verification (Stripe Connect)
- Add new sneaker listings to the catalog
- Automatic photo optimization before upload
- Profile management with listing overview
- Relay point selection for shipping

### Operations & Admin
- Automated shipping label generation (Sendcloud)
- Transactional emails (Mailjet)
- Marketing automation (Sendinblue)
- Custom admin panel with 11 smart actions (Forest Admin)
- Comprehensive order and inventory management

---

## 🛠 Tech Stack

### Backend
- **Ruby on Rails** — Core application framework
- **PostgreSQL** — Database
- **Heroku** — Hosting and deployment
- **Forest Admin** — Admin panel with custom actions

### Frontend
- **HTML/CSS/JavaScript** — Core web technologies
- **Bootstrap** — Responsive UI framework

### Integrations
- **Stripe Payment** — Secure payment processing
- **Stripe Connect** — Seller verification and payouts
- **Sendcloud** — Shipping logistics (relay points, labels, tracking)
- **Cloudinary** — Image storage and optimization
- **Mailjet** — Transactional emails
- **Sendinblue** — Marketing automation

---

## 🚀 Installation

### Prerequisites
- Ruby 2.7+ (check with `ruby -v`)
- Rails 6.0+ (check with `rails -v`)
- PostgreSQL 12+ (check with `psql --version`)
- Node.js & Yarn (for asset compilation)

### Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/rock-dont-stock.git
cd rock-dont-stock

# Install dependencies
bundle install
yarn install

# Setup database
rails db:create db:migrate db:seed

# Configure environment variables
# Copy .env.example to .env and fill in:
# - Stripe API keys (STRIPE_PUBLIC_KEY, STRIPE_SECRET_KEY)
# - Sendcloud API credentials
# - Cloudinary credentials
# - Mailjet API keys
# - Sendinblue API keys

# Start the server
rails server
```

Visit `http://localhost:3000` to see the app running.

---

## 💡 Usage

### As a Buyer
1. Browse the catalog or search for specific sneakers
2. Add items to cart and proceed to checkout
3. Complete payment via Stripe
4. Receive confirmation and tracking updates via email
5. Track your shipment in real-time

### As a Seller
1. Register and complete legal verification (Stripe Connect)
2. Add new sneaker listings with photos and details
3. Ship to buyer's selected relay point when notified
4. Receive automated shipping labels via Sendcloud
5. Get paid securely through Stripe Connect


**Built with ❤️ for sneaker enthusiasts who deserve authenticity. Enjoy !**
