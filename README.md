📊 Vistora Ecommerce Sales Dashboard — Power BI Project

An end-to-end Business Intelligence project analyzing 1,500+ e-commerce transactions across India. Data was cleaned and transformed using SQL, then visualized in a fully interactive Power BI dashboard with DAX measures, slicers, and drill-down reporting.

📸 Dashboard Preview-----

![image altr]()

🎯 Project Objective
To analyze sales performance of a fictional Indian e-commerce brand Vistora by building an interactive BI dashboard that helps stakeholders:

Monitor overall revenue, profit, quantity, and AOV at a glance
Identify top-performing states, customers, categories, and sub-categories
Understand monthly profit trends and spot loss-making periods
Analyze customer payment preferences across product categories
Filter all insights by Quarter and State dynamically

-------🎓 What I Learned

🔗 Writing multi-table SQL JOINs and reusable views optimized for BI consumption
🪟 Using window functions — RANK(), PERCENTILE_CONT(), SUM() OVER() — for advanced analytics
🧮 Building DAX measures in Power BI for dynamic, context-aware KPI calculations
🎨 Designing a dark-themed dashboard with consistent color coding per category
🔘 Implementing cross-visual filtering with Quarter and State slicers
💡 Extracting real business insights from raw data — not just visualizing, but interpreting

-------📂 Dataset Overview
FileRecordsColumnsDescriptionOrders.csv500Order ID, Order Date, Customer Name, State, CityCustomer & order metadataDetails.csv1,500Order ID, Amount, Profit, Quantity, Category, Sub-Category, Payment ModeTransaction line items

-----Categories & Sub-Categories
CategorySub-CategoriesClothing (63%)Saree, Kurta, T-shirt, Shirt, Trousers, Skirt, Leggings, Stole, Accessories, HankerchiefElectronics (21%)Printers, Phones, Electronic GamesFurniture (17%)Chairs, Bookcases, Tables, Furnishings

-----States Covered
19 Indian states including Maharashtra, Madhya Pradesh, Uttar Pradesh, Delhi, Rajasthan, Gujarat, Karnataka, and more.

-----Payment Modes
COD · UPI · Debit Card · Credit Card · EMI

🛠️ Tools & Technologies
ToolPurposeSQL (MySQL)Data cleaning, transformation, KPI queries, JOIN, viewsPower BI DesktopDashboard creation, DAX measures, visuals, slicersDAXCustom measures — profit margin %, AOV, running totalsMicrosoft ExcelInitial data inspection and validationVS CodeSQL query writing and file management

🔄 Workflow — How It Was Built
Raw CSV Files
     │
     ▼
SQL — Data Cleaning & Transformation
  • Null checks & duplicate detection
  • Whitespace trimming & standardization
  • JOIN Orders + Details → master view
  • Derived columns: Month, Quarter, AOV, Profit Margin %
     │
     ▼
Power BI — Data Modeling & Visualization
  • Imported cleaned view / CSVs
  • Built relationships between tables
  • Created DAX measures
  • Designed interactive dashboard
     │
     ▼
Insights & Reporting

-----📊 Dashboard Visuals
🖼️ Visual📐 Type💡 Insight💰 KPI CardsCardRevenue (438K) · Profit (37K) · Qty (5615) · AOV (121K)📅 Profit by MonthBar ChartPeaks in Jan, Feb & Nov — dips mid-year🗺️ Revenue by StateBar ChartMaharashtra leads, followed by Madhya Pradesh👗 Quantity by CategoryDonut ChartClothing dominates at 63%💳 Quantity by Payment ModeDonut ChartCOD most preferred at 44%🖨️ Profit by Sub-CategoryBar ChartPrinters & Bookcases most profitable👤 Revenue by CustomerBar ChartTop 5 customers ranked by total spend🔘 Quarter FilterSlicerDynamically filter all visuals by Qtr 1–4📍 State FilterDropdownDrill down into any of the 19 states

-----📈 Key Business Insights
💰 ₹4.38 Lakh in total revenue generated from 500 orders across 19 Indian states
📉 Seasonal dip detected — June to September shows negative profit, likely due to low demand or heavy discounting
👗 Clothing is the highest volume category (63%) but Electronics — especially Printers — drives the most profit
🗺️ Maharashtra is the #1 revenue-generating state, followed closely by Madhya Pradesh
💳 COD still dominates at 44% — there's a clear opportunity to push digital payment incentives
🖨️ Printers & Bookcases are the star sub-categories — high profit despite lower sales volume
👥 Top customers — Harivansh, Madhav, Madan Mohan — are repeat high-value buyers worth retaining

⚙️ How to Run This Project
🅰️ Option A — Power BI Template (Quickest)
1. 📥 Download  VistoraEcommerceDashboard.pbit
2. 📂 Open in   Power BI Desktop
3. 📄 Link to   Orders.csv  and  Details.csv
4. 🔄 Hit Refresh — dashboard loads instantly ✅

👨‍💻 Author
<div align="center">
Sumit Ganesh Deshmukh
