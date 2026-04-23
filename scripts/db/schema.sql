-- FLIPPA PRODUCTION-GRADE SCHEMA
-- Relational Source of Truth (Postgres)

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Unified Identity & Access
CREATE TYPE user_role AS ENUM (
  'consumer',
  'individual_seller',
  'business_seller',
  'admin'
);

CREATE TABLE users (
  id UUID PRIMARY KEY,                -- Matches Firebase UID
  email TEXT UNIQUE NOT NULL,
  phone TEXT,
  display_name TEXT,
  role user_role DEFAULT 'consumer',
  country_code CHAR(2),
  currency_code CHAR(3) DEFAULT 'USD',
  is_verified BOOLEAN DEFAULT FALSE,
  is_blocked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE org_type AS ENUM ('individual', 'business', 'enterprise');

CREATE TABLE organizations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_user_id UUID NOT NULL REFERENCES users(id),
  type org_type NOT NULL,
  legal_name TEXT NOT NULL,
  country_code CHAR(2) NOT NULL,
  tax_id TEXT,
  verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE org_member_role AS ENUM ('owner', 'admin', 'staff');

CREATE TABLE organization_members (
  org_id UUID REFERENCES organizations(id),
  user_id UUID REFERENCES users(id),
  role org_member_role DEFAULT 'staff',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (org_id, user_id)
);

-- Marketplace Catalog
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  parent_id UUID REFERENCES categories(id),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  level INT DEFAULT 0
);

CREATE TYPE listing_type AS ENUM (
  'buy',
  'rent_short',
  'rent_long',
  'lease',
  'hybrid'
);

CREATE TYPE listing_condition AS ENUM ('new', 'used', 'refurbished');
CREATE TYPE listing_status AS ENUM ('draft', 'active', 'paused', 'deleted');

CREATE TABLE listings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_user_id UUID NOT NULL REFERENCES users(id),
  organization_id UUID REFERENCES organizations(id),
  category_id UUID NOT NULL REFERENCES categories(id),
  title TEXT NOT NULL,
  description TEXT,
  listing_type listing_type NOT NULL,
  condition listing_condition,
  country_code CHAR(2) NOT NULL,
  city TEXT,
  status listing_status DEFAULT 'draft',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE listing_assets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  listing_id UUID NOT NULL REFERENCES listings(id) ON DELETE CASCADE,
  type TEXT NOT NULL, -- 'image', 'video'
  url TEXT NOT NULL,
  sort_order INT DEFAULT 0
);

-- Pricing & Availability
CREATE TYPE price_type AS ENUM ('fixed', 'per_day', 'per_month');

CREATE TABLE pricing_models (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  listing_id UUID NOT NULL REFERENCES listings(id) ON DELETE CASCADE,
  currency CHAR(3) NOT NULL,
  price_type price_type NOT NULL,
  amount DECIMAL(12, 2) NOT NULL,
  deposit_amount DECIMAL(12, 2) DEFAULT 0,
  min_duration INT,
  max_duration INT
);

CREATE TYPE availability_status AS ENUM ('available', 'reserved', 'blocked');

CREATE TABLE availability_calendar (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  listing_id UUID NOT NULL REFERENCES listings(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  status availability_status DEFAULT 'available',
  reservation_id UUID, -- References order_id later if needed
  UNIQUE(listing_id, date)
);

-- Orders & Rentals
CREATE TYPE order_type AS ENUM ('buy', 'rent', 'lease');
CREATE TYPE order_status AS ENUM ('created', 'paid', 'active', 'completed', 'cancelled');

CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  buyer_user_id UUID NOT NULL REFERENCES users(id),
  listing_id UUID NOT NULL REFERENCES listings(id),
  order_type order_type NOT NULL,
  status order_status DEFAULT 'created',
  total_amount DECIMAL(12, 2) NOT NULL,
  currency CHAR(3) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE rental_status AS ENUM ('reserved', 'active', 'returned', 'late', 'disputed');

CREATE TABLE rentals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID NOT NULL REFERENCES orders(id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status rental_status DEFAULT 'reserved'
);

-- Payments & Escrow
CREATE TYPE payment_status AS ENUM ('initiated', 'authorized', 'captured', 'refunded');

CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID NOT NULL REFERENCES orders(id),
  provider TEXT DEFAULT 'stripe',
  intent_id TEXT,
  amount DECIMAL(12, 2) NOT NULL,
  currency CHAR(3) NOT NULL,
  status payment_status DEFAULT 'initiated',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE escrow_type AS ENUM ('hold', 'release', 'refund');

CREATE TABLE escrow_ledger (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID NOT NULL REFERENCES orders(id),
  type escrow_type NOT NULL,
  amount DECIMAL(12, 2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Trust & Disputes
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID NOT NULL REFERENCES orders(id),
  reviewer_user_id UUID NOT NULL REFERENCES users(id),
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE dispute_reason AS ENUM ('damage', 'late_return', 'fraud', 'not_as_described');
CREATE TYPE dispute_status AS ENUM ('open', 'under_review', 'resolved', 'rejected');

CREATE TABLE disputes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID NOT NULL REFERENCES orders(id),
  raised_by UUID NOT NULL REFERENCES users(id),
  reason dispute_reason NOT NULL,
  status dispute_status DEFAULT 'open',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Messaging
CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  listing_id UUID NOT NULL REFERENCES listings(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID NOT NULL REFERENCES conversations(id),
  sender_id UUID NOT NULL REFERENCES users(id),
  body TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Admin & Moderation
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  actor_user_id UUID REFERENCES users(id),
  entity_type TEXT NOT NULL,
  entity_id UUID NOT NULL,
  action TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
