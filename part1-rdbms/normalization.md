## Anomaly Analysis

### Insert Anomaly
**Problem:** A new sales representative cannot be added to the system without first creating an order. For example, if a new rep "Sunita Rao" (SR04) joins the company, there is no way to record her details (name, email, office) until she handles at least one order. The flat file has no separate table for sales reps — their information only exists as part of an order row.

**CSV Evidence:** Columns `sales_rep_id`, `sales_rep_name`, `sales_rep_email`, `office_address` appear only alongside order data. There is no standalone record for any sales rep.

---

### Update Anomaly
**Problem:** If sales representative Deepak Joshi (SR01) changes his email address, the update must be applied to every single row where `sales_rep_id = 'SR01'`. There are dozens of such rows (e.g., ORD1114, ORD1153 row 3, ORD1091, ORD1061, etc.). If even one row is missed, the data becomes inconsistent — some orders will show the old email and some the new one.

**CSV Evidence:** `sales_rep_email` = `deepak@corp.com` is repeated across many rows for SR01. The same issue applies to `customer_email` and `customer_name` columns.

---

### Delete Anomaly
**Problem:** Product P008 (Webcam, price ₹2100, category Electronics) appears in only one order: `ORD1185`. If this order is deleted (e.g., because the customer cancelled and the record is removed), all information about the Webcam product is permanently lost from the system. There is no separate products table to preserve it.

**CSV Evidence:** Row with `order_id = ORD1185` is the only row containing `product_id = P008` (Webcam). Deleting this row destroys the product record entirely.

---

## Normalization Justification

The manager's argument that "keeping everything in one table is simpler" may seem appealing at first glance, but the `orders_flat.csv` dataset itself demonstrates exactly why this approach breaks down in practice.

Consider what happens with customer Deepak Joshi (SR01): his name, email, and office address are repeated in dozens of rows throughout the file. If the company relocates the Mumbai HQ office, a developer must update every single matching row. Miss even one, and reports will show contradictory office addresses for the same sales rep — a real problem for audits and HR records.

Now consider the Webcam (P008) situation. This product exists in only one order. The moment that order is removed — perhaps because the customer returned the item — the entire product record vanishes. There is no way to run a "products with no sales" report, because the product itself ceases to exist in the database. This makes inventory management impossible.

The flat structure also makes simple business questions unnecessarily complex. "How many products do we sell?" requires scanning every row and deduplicating product IDs manually, rather than just counting rows in a products table.

Normalization to 3NF solves all of this by creating dedicated tables for Customers, Products, Sales Representatives, and Orders. Each entity is stored once and referenced by ID. Updating Deepak Joshi's email now means changing one row in one table. Adding a new product doesn't require inventing a fake order. Deleting an order doesn't erase customer or product history.

Far from being over-engineering, normalization is the minimum responsible design for any system that will grow, be maintained, or be trusted with real business data. The one-table approach trades a small upfront simplicity for compounding data quality problems over time.
