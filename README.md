## Bike Store Database Schema

This repository contains the SQL scripts to create and manage a **Bike Store Database**. The schema includes tables for managing data related to products, brands, categories, customers, stores, staff, orders, and inventory. 

### Table Structure

- **Categories**: Stores product categories (e.g., Mountain Bikes, Road Bikes).
- **Brands**: Stores brand details of the products.
- **Products**: Contains product details, including brand, category, model year, and list price.
- **Customers**: Manages customer information such as names, contact details, and address.
- **Stores**: Contains information about each store, including contact details and location.
- **Staffs**: Manages staff details, including assigned store and manager hierarchy.
- **Orders**: Keeps track of customer orders, including order status, dates, and associated staff.
- **Order Items**: Details the items within each order, including product, quantity, and discount.
- **Stocks**: Monitors product inventory levels in each store.

### Key Features

- **Data Relationships**: Implements foreign keys to maintain data integrity and support cascade operations.
- **Inventory Management**: Tracks stock levels by store to assist in stock management.
- **Order Management**: Manages customer orders and associated details for efficient processing and tracking.

### How to Use

1. Clone the repository.
2. Run the provided SQL scripts to create the database and tables.
3. Use SQL queries to interact with the data for analysis, reporting, or integration with BI tools like Power BI.

### License

Feel free to use and modify the SQL scripts as needed.
