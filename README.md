# Revenue Metrics Dashboard
## Project Overview
This project involves creating a dashboard to analyze revenue streams for a project. The main goal is to provide product managers with a tool to track revenue dynamics and perform high-level analysis of the factors influencing these changes.

## Timeframe
The project started on April 15, 2024, and is scheduled to be completed by April 29, 2024.

## Data Sources
The data for the dashboard was obtained from two tables in the "project" schema of a PostgreSQL database:
- project.games_paid_users
(Columns: user_id, game_name, language, has_older_device_model, age)
- project.games_payments
(Columns: user_id, game_name, payment_date, revenue_amount_usd)

### Key Metrics
The following metrics were calculated based on the data:
- Monthly Recurring Revenue (MRR) - Sum of revenue_amount_usd for each month where revenue_amount_usd > 0, grouped by month.
- Paid Users - Count of unique user_id for each month where revenue_amount_usd > 0.
- Average Revenue Per Paid User (ARPPU) - MRR divided by Paid Users for each month.
- New Paid Users - Count of unique user_id appearing for the first time in the current month.
- New MRR - Sum of revenue_amount_usd for New Paid Users each month.
- Churned Users - Count of unique user_id from the previous month that are absent in the current month.
- Churn Rate - Churned Users divided by Paid Users of the previous month.
- Churned Revenue - Sum of revenue_amount_usd for Churned Users from the previous month.
- Revenue Churn Rate - Churned Revenue divided by MRR of the previous month.
- Expansion MRR - Increase in MRR in the current month compared to the previous month due to users who increased their payments.
- Contraction MRR - Decrease in MRR in the current month compared to the previous month due to users who decreased their payments.
- Customer Lifetime (LT) - Average number of months between the first and last payment for each user_id.
- Customer Lifetime Value (LTV) - Average sum of revenue_amount_usd over the entire period for each user_id.

### Dashboard Features
The dashboard includes 10 of the listed metrics and has:
- charts, diagrams
- Filters by date, user language, and user age
- two charts showing the factors influencing changes in revenue and paid users from month to month

### Visual Design
The visual design of the dashboard will follow these principles:
- 5-second principle
- Placement of important information
- Metric labels and annotations
- Color scheme usage

### Technology Stack
- PostgreSQL
- Tableau Public

The data for the dashboard was obtained from the PostgreSQL database by writing SQL queries against the tables in the "project" schema. The dashboard will be created in Tableau Public and will be accessible to all internet users.

### Project Design and Conclusions
In designing the dashboard, I focused on creating a clear and intuitive layout that would allow product managers to quickly identify key trends and insights. I utilized a combination of bar charts, line graphs, and scatter plots to visualize the various metrics and their relationships.
One of the challenges I encountered was finding an effective way to display the factors influencing changes in revenue and paid users from month to month. After experimenting with different chart types, I settled on a waterfall chart to clearly illustrate the contributions of new users, churned users, expansions, and contractions to the overall changes.

Through this project, I gained valuable experience in data exploration, metric calculation, and data visualization using Tableau. I learned the importance of designing dashboards with the end-user in mind and adhering to best practices for effective communication of insights.

### What have I learned from this program?
This project deepened my understanding of recurring revenue metrics and their significance in evaluating the health and growth potential of a product or service. I learned how to calculate and interpret metrics such as MRR, ARPPU, churn rates, and customer lifetime value, which are crucial for making informed business decisions.
Additionally, I improved my skills in data manipulation and transformation using SQL, as well as data visualization techniques in Tableau. I gained experience in creating interactive dashboards that allow users to explore data from multiple perspectives and extract meaningful insights.

Overall, this project provided me with a practical opportunity to apply my knowledge of data analysis, SQL, and data visualization to a real-world business scenario, preparing me for future challenges in the field of data analytics and product management.
