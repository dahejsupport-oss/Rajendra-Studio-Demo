-- =============================================================================
-- RAJENDRA STUDIO & FRAMING - COMPLETE SUPABASE DATABASE SCHEMA & POLICIES
-- Execute this complete script in your Supabase SQL Editor:
-- https://supabase.com/dashboard/project/_/sql
-- =============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- 1. CATEGORIES TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT DEFAULT '🏷️',
  "desc" TEXT,
  badge TEXT,
  color TEXT DEFAULT '#C99A3D',
  bg TEXT DEFAULT 'rgba(201, 154, 61, 0.15)',
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ensure newly added columns exist if table already existed
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS icon TEXT DEFAULT '🏷️';
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS "desc" TEXT;
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS badge TEXT;
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS color TEXT DEFAULT '#C99A3D';
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS bg TEXT DEFAULT 'rgba(201, 154, 61, 0.15)';
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS is_default BOOLEAN DEFAULT FALSE;
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

CREATE INDEX IF NOT EXISTS idx_categories_created_at ON public.categories(created_at ASC);

-- =============================================================================
-- 2. PRODUCTS TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.products (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  category_label TEXT,
  price NUMERIC NOT NULL,
  original_price NUMERIC,
  price_display TEXT,
  rating NUMERIC DEFAULT 5.0,
  reviews_count INTEGER DEFAULT 100,
  badge TEXT,
  image TEXT,
  images JSONB DEFAULT '[]'::jsonb,
  short_description TEXT,
  description TEXT,
  material TEXT,
  printing_type TEXT,
  status TEXT DEFAULT 'In Stock',
  in_stock BOOLEAN DEFAULT TRUE,
  stock_qty INTEGER DEFAULT 100,
  lead_time TEXT DEFAULT '24 - 48 Hours',
  sizes JSONB DEFAULT '[]'::jsonb,
  finishes JSONB DEFAULT '[]'::jsonb,
  variants JSONB DEFAULT '[]'::jsonb,
  features JSONB DEFAULT '[]'::jsonb,
  requires_photo BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ensure newly added columns exist if table already existed
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS requires_photo BOOLEAN DEFAULT FALSE;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS original_price NUMERIC;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS images JSONB DEFAULT '[]'::jsonb;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS in_stock BOOLEAN DEFAULT TRUE;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS stock_qty INTEGER DEFAULT 100;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS variants JSONB DEFAULT '[]'::jsonb;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS features JSONB DEFAULT '[]'::jsonb;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

CREATE INDEX IF NOT EXISTS idx_products_category ON public.products(category);
CREATE INDEX IF NOT EXISTS idx_products_status ON public.products(status);

-- =============================================================================
-- 3. ORDERS TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.orders (
  order_id TEXT PRIMARY KEY,
  customer JSONB NOT NULL,
  items JSONB NOT NULL,
  subtotal NUMERIC DEFAULT 0,
  shipping NUMERIC DEFAULT 0,
  total NUMERIC NOT NULL,
  notes TEXT,
  order_photo JSONB,
  payment_method TEXT DEFAULT 'Instant UPI Payment (QR Code)',
  payment_status TEXT DEFAULT 'Pending',
  upi_utr TEXT,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS order_photo JSONB;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS payment_status TEXT DEFAULT 'Pending';
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS upi_utr TEXT;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS confirmed_at TIMESTAMPTZ;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS confirmation_date TEXT;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS picked_up_at TIMESTAMPTZ;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS pickup_date TEXT;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS confirmed_email_sent BOOLEAN DEFAULT FALSE;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS ready_email_sent BOOLEAN DEFAULT FALSE;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS cancelled_email_sent BOOLEAN DEFAULT FALSE;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

CREATE INDEX IF NOT EXISTS idx_orders_created_at ON public.orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_status ON public.orders(status);

-- =============================================================================
-- 4. INQUIRIES & LEADS TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.inquiries (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  product TEXT,
  specs TEXT,
  quantity INTEGER DEFAULT 1,
  estimated_value NUMERIC DEFAULT 0,
  notes TEXT,
  status TEXT DEFAULT 'pending',
  has_upload BOOLEAN DEFAULT FALSE,
  upload_file_name TEXT,
  uploaded_file_url TEXT,
  delivery_address TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.inquiries ADD COLUMN IF NOT EXISTS uploaded_file_url TEXT;
ALTER TABLE public.inquiries ADD COLUMN IF NOT EXISTS delivery_address TEXT;
ALTER TABLE public.inquiries ADD COLUMN IF NOT EXISTS confirmed_at TIMESTAMPTZ;
ALTER TABLE public.inquiries ADD COLUMN IF NOT EXISTS confirmation_date TEXT;
ALTER TABLE public.inquiries ADD COLUMN IF NOT EXISTS picked_up_at TIMESTAMPTZ;
ALTER TABLE public.inquiries ADD COLUMN IF NOT EXISTS pickup_date TEXT;
ALTER TABLE public.inquiries ADD COLUMN IF NOT EXISTS confirmed_email_sent BOOLEAN DEFAULT FALSE;
ALTER TABLE public.inquiries ADD COLUMN IF NOT EXISTS ready_email_sent BOOLEAN DEFAULT FALSE;
ALTER TABLE public.inquiries ADD COLUMN IF NOT EXISTS cancelled_email_sent BOOLEAN DEFAULT FALSE;
ALTER TABLE public.inquiries ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

CREATE INDEX IF NOT EXISTS idx_inquiries_created_at ON public.inquiries(created_at DESC);

-- =============================================================================
-- 5. CONTACT MESSAGES TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.messages (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  service TEXT,
  message TEXT NOT NULL,
  status TEXT DEFAULT 'Unread',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_messages_created_at ON public.messages(created_at DESC);

-- =============================================================================
-- 6. CUSTOMERS TABLE (Accounts, Logins & Metrics)
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.customers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone TEXT,
  registered_at TIMESTAMPTZ DEFAULT NOW(),
  last_login_at TIMESTAMPTZ DEFAULT NOW(),
  login_count INTEGER DEFAULT 1,
  total_orders INTEGER DEFAULT 0,
  total_spent NUMERIC DEFAULT 0,
  cart JSONB DEFAULT '[]'::jsonb,
  wishlist JSONB DEFAULT '[]'::jsonb,
  status TEXT DEFAULT 'Active',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS cart JSONB DEFAULT '[]'::jsonb;
ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS wishlist JSONB DEFAULT '[]'::jsonb;

CREATE INDEX IF NOT EXISTS idx_customers_email ON public.customers(email);

-- =============================================================================
-- 7. REVIEWS TABLE (Customer Reviews & Ratings)
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.reviews (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL,
  author TEXT NOT NULL,
  city TEXT DEFAULT 'Dahej / Bharuch',
  rating NUMERIC DEFAULT 5,
  date TEXT,
  headline TEXT NOT NULL,
  comment TEXT NOT NULL,
  verified BOOLEAN DEFAULT TRUE,
  helpful INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reviews_product ON public.reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON public.reviews(created_at DESC);

-- =============================================================================
-- 8. ADMIN CONFIG & SETTINGS TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.admin_config (
  id TEXT PRIMARY KEY DEFAULT 'default',
  admin_email TEXT DEFAULT 'shop@rajendrastudioandgifts.in',
  secondary_admin_email TEXT DEFAULT 'order@rajendrastudioandgifts.in',
  admin_password TEXT DEFAULT 'Admin@Rajesh2026',
  admin_name TEXT DEFAULT 'Rajendra Studio Admin',
  smtp JSONB DEFAULT '{
    "enabled": true,
    "service": "brevo",
    "host": "smtp-relay.brevo.com",
    "port": 587,
    "secure": false,
    "user": "rajendrastudioframing@gmail.com",
    "pass": "",
    "fromEmail": "Rajendra Studio & Framing <shop@rajendrastudioandgifts.in>"
  }'::jsonb,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.admin_config ADD COLUMN IF NOT EXISTS secondary_admin_email TEXT;

-- =============================================================================
-- 9. SUPABASE STORAGE BUCKET FOR PHOTO UPLOADS
-- =============================================================================
INSERT INTO storage.buckets (id, name, public)
VALUES ('photos', 'photos', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Storage Policies for Public Bucket Access
DROP POLICY IF EXISTS "Public Read Photos Bucket" ON storage.objects;
CREATE POLICY "Public Read Photos Bucket" ON storage.objects
  FOR SELECT USING (bucket_id = 'photos');

DROP POLICY IF EXISTS "Public Upload Photos Bucket" ON storage.objects;
CREATE POLICY "Public Upload Photos Bucket" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'photos');

DROP POLICY IF EXISTS "Public Update Photos Bucket" ON storage.objects;
CREATE POLICY "Public Update Photos Bucket" ON storage.objects
  FOR UPDATE USING (bucket_id = 'photos');

DROP POLICY IF EXISTS "Public Delete Photos Bucket" ON storage.objects;
CREATE POLICY "Public Delete Photos Bucket" ON storage.objects
  FOR DELETE USING (bucket_id = 'photos');

-- =============================================================================
-- 10. ROW LEVEL SECURITY (RLS) POLICIES
-- =============================================================================
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inquiries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_config ENABLE ROW LEVEL SECURITY;

-- Categories RLS: Full read/write access for website and admin operations
DROP POLICY IF EXISTS "Allow Read Categories" ON public.categories;
CREATE POLICY "Allow Read Categories" ON public.categories FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow Insert Categories" ON public.categories;
CREATE POLICY "Allow Insert Categories" ON public.categories FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Update Categories" ON public.categories;
CREATE POLICY "Allow Update Categories" ON public.categories FOR UPDATE USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Delete Categories" ON public.categories;
CREATE POLICY "Allow Delete Categories" ON public.categories FOR DELETE USING (true);

-- Products RLS: Full read/write access for website catalog and admin panel
DROP POLICY IF EXISTS "Allow Read Products" ON public.products;
CREATE POLICY "Allow Read Products" ON public.products FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow Insert Products" ON public.products;
CREATE POLICY "Allow Insert Products" ON public.products FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Update Products" ON public.products;
CREATE POLICY "Allow Update Products" ON public.products FOR UPDATE USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Delete Products" ON public.products;
CREATE POLICY "Allow Delete Products" ON public.products FOR DELETE USING (true);

-- Orders RLS: Customers can place and track orders; Admin can manage all orders
DROP POLICY IF EXISTS "Allow Read Orders" ON public.orders;
CREATE POLICY "Allow Read Orders" ON public.orders FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow Insert Orders" ON public.orders;
CREATE POLICY "Allow Insert Orders" ON public.orders FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Update Orders" ON public.orders;
CREATE POLICY "Allow Update Orders" ON public.orders FOR UPDATE USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Delete Orders" ON public.orders;
CREATE POLICY "Allow Delete Orders" ON public.orders FOR DELETE USING (true);

-- Inquiries RLS: Public lead submission and admin management
DROP POLICY IF EXISTS "Allow Read Inquiries" ON public.inquiries;
CREATE POLICY "Allow Read Inquiries" ON public.inquiries FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow Insert Inquiries" ON public.inquiries;
CREATE POLICY "Allow Insert Inquiries" ON public.inquiries FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Update Inquiries" ON public.inquiries;
CREATE POLICY "Allow Update Inquiries" ON public.inquiries FOR UPDATE USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Delete Inquiries" ON public.inquiries;
CREATE POLICY "Allow Delete Inquiries" ON public.inquiries FOR DELETE USING (true);

-- Messages RLS: Public contact submissions and admin management
DROP POLICY IF EXISTS "Allow Read Messages" ON public.messages;
CREATE POLICY "Allow Read Messages" ON public.messages FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow Insert Messages" ON public.messages;
CREATE POLICY "Allow Insert Messages" ON public.messages FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Update Messages" ON public.messages;
CREATE POLICY "Allow Update Messages" ON public.messages FOR UPDATE USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Delete Messages" ON public.messages;
CREATE POLICY "Allow Delete Messages" ON public.messages FOR DELETE USING (true);

-- Customers RLS: Customer OTP registration, authentication and statistics
DROP POLICY IF EXISTS "Allow Read Customers" ON public.customers;
CREATE POLICY "Allow Read Customers" ON public.customers FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow Insert Customers" ON public.customers;
CREATE POLICY "Allow Insert Customers" ON public.customers FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Update Customers" ON public.customers;
CREATE POLICY "Allow Update Customers" ON public.customers FOR UPDATE USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Delete Customers" ON public.customers;
CREATE POLICY "Allow Delete Customers" ON public.customers FOR DELETE USING (true);

-- Reviews RLS: Public reviews display, submissions and admin curation
DROP POLICY IF EXISTS "Allow Read Reviews" ON public.reviews;
CREATE POLICY "Allow Read Reviews" ON public.reviews FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow Insert Reviews" ON public.reviews;
CREATE POLICY "Allow Insert Reviews" ON public.reviews FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Update Reviews" ON public.reviews;
CREATE POLICY "Allow Update Reviews" ON public.reviews FOR UPDATE USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow Delete Reviews" ON public.reviews;
CREATE POLICY "Allow Delete Reviews" ON public.reviews FOR DELETE USING (true);

-- Admin Config RLS: Settings management
DROP POLICY IF EXISTS "Allow Read Admin Config" ON public.admin_config;
CREATE POLICY "Allow Read Admin Config" ON public.admin_config FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow Upsert Admin Config" ON public.admin_config;
CREATE POLICY "Allow Upsert Admin Config" ON public.admin_config FOR ALL USING (true) WITH CHECK (true);

-- Grant schema and table permissions to all roles
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;

-- =============================================================================
-- 11. SEED DEFAULT ADMIN CONFIGURATION
-- =============================================================================
INSERT INTO public.admin_config (id, admin_email, secondary_admin_email, admin_password, admin_name, smtp)
VALUES (
  'default',
  'dahejsupport@gmail.com',
  'dahejsupport@gmail.com',
  'Admin123',
  'Dahej Support Admin',
  '{
    "enabled": true,
    "service": "brevo",
    "host": "smtp-relay.brevo.com",
    "port": 587,
    "secure": false,
    "user": "jobs@dahejsupport.com",
    "pass": "",
    "fromEmail": "Dahej Support <jobs@dahejsupport.com>"
  }'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  admin_email = EXCLUDED.admin_email,
  secondary_admin_email = EXCLUDED.secondary_admin_email,
  admin_name = EXCLUDED.admin_name,
  smtp = EXCLUDED.smtp,
  updated_at = NOW();
