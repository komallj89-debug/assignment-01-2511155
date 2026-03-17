// mongo_queries.js
// Part 2.2 — MongoDB Operations
// Run these in the MongoDB shell or Compass shell against database: ecommerce_db
// Collection: products

// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    "_id": ObjectId("64f1a2b3c4d5e6f7a8b9c001"),
    "product_id": "PROD-E001",
    "name": "Samsung 55-inch 4K Smart TV",
    "category": "Electronics",
    "brand": "Samsung",
    "price": 52999,
    "currency": "INR",
    "in_stock": true,
    "stock_quantity": 34,
    "specifications": {
      "display": {
        "size_inches": 55,
        "resolution": "3840x2160",
        "panel_type": "QLED",
        "refresh_rate_hz": 120
      },
      "connectivity": ["WiFi", "Bluetooth 5.0", "HDMI x3", "USB x2"],
      "operating_system": "Tizen OS 7.0",
      "voltage": "220V",
      "power_consumption_watts": 130
    },
    "warranty": {
      "years": 2,
      "type": "Comprehensive",
      "includes_parts_and_labour": true
    },
    "ratings": { "average": 4.4, "total_reviews": 1823 },
    "tags": ["smart tv", "4k", "qled", "samsung"]
  },
  {
    "_id": ObjectId("64f1a2b3c4d5e6f7a8b9c002"),
    "product_id": "PROD-C001",
    "name": "Men's Slim Fit Chino Trousers",
    "category": "Clothing",
    "brand": "FabIndia",
    "price": 1799,
    "currency": "INR",
    "in_stock": true,
    "stock_quantity": 210,
    "specifications": {
      "material": "98% Cotton, 2% Elastane",
      "fit": "Slim Fit",
      "available_sizes": ["S", "M", "L", "XL", "XXL"],
      "available_colors": ["Navy Blue", "Olive Green", "Beige", "Charcoal"],
      "care_instructions": ["Machine wash cold", "Do not bleach", "Tumble dry low"],
      "occasion": ["Casual", "Semi-formal"]
    },
    "ratings": { "average": 4.1, "total_reviews": 542 },
    "tags": ["trousers", "slim fit", "chino", "menswear"]
  },
  {
    "_id": ObjectId("64f1a2b3c4d5e6f7a8b9c003"),
    "product_id": "PROD-G001",
    "name": "Organic Rolled Oats 1kg",
    "category": "Groceries",
    "brand": "Organic India",
    "price": 299,
    "currency": "INR",
    "in_stock": true,
    "stock_quantity": 875,
    "specifications": {
      "weight_grams": 1000,
      "organic_certified": true,
      "certifications": ["USDA Organic", "FSSAI Approved"],
      "storage": "Store in a cool, dry place away from direct sunlight"
    },
    "expiry_date": ISODate("2025-09-30"),
    "manufactured_date": ISODate("2024-09-01"),
    "nutritional_info": {
      "serving_size_grams": 40,
      "per_serving": {
        "calories": 150,
        "protein_grams": 5,
        "carbohydrates_grams": 27,
        "fat_grams": 2.5,
        "fibre_grams": 4,
        "sugar_grams": 1
      }
    },
    "allergens": ["Contains Gluten"],
    "ratings": { "average": 4.6, "total_reviews": 3201 },
    "tags": ["oats", "organic", "breakfast", "healthy"]
  }
]);

// OP2: find() — retrieve all Electronics products with price > 20000
db.products.find(
  {
    category: "Electronics",
    price: { $gt: 20000 }
  },
  {
    name: 1,
    brand: 1,
    price: 1,
    category: 1
  }
);

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find(
  {
    category: "Groceries",
    expiry_date: { $lt: ISODate("2025-01-01") }
  },
  {
    name: 1,
    expiry_date: 1,
    brand: 1
  }
);

// OP4: updateOne() — add a "discount_percent" field to a specific product
db.products.updateOne(
  { product_id: "PROD-E001" },
  {
    $set: {
      discount_percent: 10,
      discounted_price: 47699.10
    }
  }
);

// OP5: createIndex() — create an index on category field and explain why
// WHY: The most common query pattern in a product catalog is filtering by category
// (e.g., "show all Electronics"). Without an index, MongoDB performs a full collection
// scan (O(n)) on every such query. With an index on `category`, lookups become O(log n),
// which dramatically reduces response time as the catalog grows to thousands of products.
db.products.createIndex(
  { category: 1 },
  { name: "idx_category", background: true }
);

// Verify the index was created
db.products.getIndexes();
