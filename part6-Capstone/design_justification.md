## Storage Systems

The hospital network's four goals require four distinct storage systems, each chosen to match the nature of its workload.

**Goal 1 — Predict patient readmission risk:** Historical treatment data (diagnoses, procedures, lab results, medications) is stored in a **Data Warehouse** (e.g., Amazon Redshift or Google BigQuery). This structured, tabular data needs to be aggregated and queried for feature engineering — calculating readmission rates, average length of stay, comorbidity patterns. The warehouse's columnar storage makes these aggregations fast. The ML model itself is trained on warehouse exports and deployed as a separate service.

**Goal 2 — Allow doctors to query patient history in plain English:** This requires a **Vector Database** (e.g., Pinecone or Weaviate) in combination with a Large Language Model. Clinical notes, discharge summaries, and medical records are converted into semantic embeddings and stored in the vector database. When a doctor asks "Has this patient had a cardiac event before?", the query is embedded and a semantic similarity search retrieves the most relevant patient history chunks — regardless of exact terminology used in the original notes. An RDBMS or keyword search cannot perform this semantic retrieval.

**Goal 3 — Generate monthly management reports:** Hospital management reports (bed occupancy, department-wise costs) are classic OLAP workloads, best served by the same **Data Warehouse** used for Goal 1. Pre-aggregated summary tables and materialized views ensure that monthly reports run in seconds rather than scanning raw operational data.

**Goal 4 — Stream and store real-time ICU vitals:** ICU monitoring devices produce high-frequency time-series data (heart rate, blood pressure, SpO2 sampled every few seconds). This requires a **Time-Series Database** (e.g., InfluxDB or TimescaleDB), fronted by a streaming pipeline (Apache Kafka). Time-series databases are optimized for ingesting millions of timestamped data points per second, downsampling historical data automatically, and triggering alerts when values cross thresholds.

## OLTP vs OLAP Boundary

The transactional (OLTP) system is the hospital's existing operational database — the Electronic Health Record (EHR) system — which handles real-time patient registrations, prescription writes, and appointment bookings. This system prioritizes low-latency writes and consistency.

The OLTP-to-OLAP boundary is the **ETL/ELT pipeline** that runs nightly (or in near-real-time via change data capture). This pipeline extracts data from the EHR system, transforms it (cleaning, standardizing, computing derived features), and loads it into the Data Warehouse. Once data crosses this boundary, it is read-only for the analytical layer. Doctors and clinical staff interact with the OLTP (EHR) system during care delivery; analysts, data scientists, and management interact with the OLAP (warehouse) layer for reporting and model training.

## Trade-offs

**Significant trade-off: Data duplication and synchronization complexity.** Using four separate storage systems (Data Warehouse, Vector Database, Time-Series DB, OLTP EHR) means that patient data exists in multiple places. A patient's record might be in the EHR, partially indexed in the vector database, and summarized in the warehouse. Keeping these in sync requires robust pipelines, and any pipeline failure could result in a doctor querying stale information.

**Mitigation:** Implement a central data orchestration layer (e.g., Apache Airflow) with clear SLA monitoring on every pipeline. Establish a "golden record" principle — the EHR is always the source of truth for clinical decisions. The warehouse and vector database are clearly labelled as analytical copies with a defined lag (e.g., "data updated as of last night"). For ICU vitals, the time-series database feeds real-time alerts directly without going through the warehouse, eliminating the synchronization problem for the most time-critical data.
