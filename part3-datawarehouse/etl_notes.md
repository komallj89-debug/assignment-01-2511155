## ETL Decisions

### Decision 1 — Standardizing Inconsistent Date Formats

**Problem:** The `date` column in `retail_transactions.csv` contains three different formats mixed throughout the file: ISO format (`2023-02-05`), slash-separated (`29/08/2023`), and hyphen-separated with day-first ordering (`12-12-2023`, `20-02-2023`). SQL date columns require a single consistent format, and loading raw data directly would cause parse errors or silently insert incorrect dates (e.g., treating `12-12-2023` as December 12 vs. the 12th of December).

**Resolution:** Before loading into `dim_date` and `fact_sales`, all dates were standardized to the ISO 8601 format (`YYYY-MM-DD`). Dates in `DD/MM/YYYY` format were identified by the presence of forward slashes and converted by rearranging the components. Dates in `DD-MM-YYYY` format were identified by checking whether the first numeric segment exceeded 12 (making it unambiguously a day, not a month), and similarly reordered. The `date_id` surrogate key was then derived from the cleaned date as an integer in `YYYYMMDD` format for efficient indexing.

---

### Decision 2 — Normalizing Inconsistent Category Casing

**Problem:** The `category` column in `retail_transactions.csv` contains the same category spelled with different casing across rows. For example, `electronics` (lowercase), `Electronics` (title case), `Groceries`, and `Grocery` all appear for what should be two categories. This means a simple `GROUP BY category` would return four separate groups instead of two, producing incorrect aggregations in business intelligence reports.

**Resolution:** All category values were standardized to title case and mapped to a canonical list before loading into `dim_product`. Specifically, `electronics` was mapped to `Electronics`, and `Grocery` was mapped to `Grocery` (consolidating with `Groceries`). This normalization was applied at the ETL stage so the warehouse always contains clean, deduplicated category values. The canonical category list was defined upfront and enforced as the only accepted values in `dim_product`.

---

### Decision 3 — Handling NULL and Missing Values

**Problem:** The raw `retail_transactions.csv` file contains rows with missing or NULL values in key columns such as `store_name`, `units_sold`, and `unit_price`. Loading these rows as-is would introduce incomplete fact records that corrupt revenue aggregations — for example, a NULL `unit_price` would make `total_revenue` NULL for that transaction, silently excluding it from SUM calculations.

**Resolution:** Rows with NULL values in any of the primary measure columns (`units_sold`, `unit_price`) were excluded from the warehouse load entirely, as there is no reliable way to impute transactional financial data. For rows with a missing `store_name` but a known `store_city`, the city was used to look up the correct store from a reference list and the name was backfilled. The `total_revenue` column in `fact_sales` was always computed as `units_sold * unit_price` during the ETL process (never taken from raw data) to ensure mathematical consistency across all records.
