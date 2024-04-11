/*1.Customer Behavior Analysis: What patterns can be observed in the spending habits of long-term customers compared
 to new customers, and what might these patterns suggest about customer loyalty?
select Tenure,
sum(EstimatedSalary)-sum(balance) as amount_spent,sum(EstimatedSalary) as Sum_salary, Sum(Balance) as Sum_balance
from bank_churn_data b
join customer_info c 
on c.CustomerID=b.CustomerID
group by tenure
order by tenure desc;

2.	Product Affinity Study: Which bank products or services are most commonly used together, 
and how might this influence cross-selling strategies?
select count(Credit_Card),NumOfProducts from bank_churn_data
where Credit_Card='Yes'
group by NumOfProducts
3.	Geographic Market Trends: How do economic indicators in different geographic regions correlate
 with the number of active accounts and customer churn rates?
 
 SELECT c.Geography,b.Active_Member,SUM(b.HasExited) / COUNT(b.CustomerID) AS Exit_Rate
FROM bank_churn_data b
JOIN customer_info c ON b.CustomerID = c.CustomerID
GROUP BY c.Geography, b.Active_Member;*/

SELECT 
    CASE 
        WHEN Age < 30 THEN 'Young'
        WHEN Age >= 30 AND Age < 50 THEN 'Middle-aged'
        ELSE 'Elderly'
    END AS age_group,Gender,Geography,COUNT(*) AS customer_count,AVG(Balance) AS average_balance
FROM customer_info c join bank_churn_data b on b.CustomerID=c.CustomerID
GROUP BY age_group, Gender,Geography;

ALTER TABLE bank_churn_data
RENAME COLUMN HasCrCard TO Has_creditcard;


 

