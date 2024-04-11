/*1. What is the distribution of account balances across different regions?
select c.Geography,sum(b.Balance) as Total from customer_info c 
    join bank_churn_data b on c.CustomerID=b.CustomerID
    group by Geography
    order by Total desc;
2.Identify the top 5 customers with the highest Estimated Salary in the last quarter of the year. (SQL)
select CustomerID,Surname,Gender,Geography,Doj from customer_info
order by EstimatedSalary desc
limit 5;
3. Calculate the average number of products used by customers who have a credit card. (SQL)
select avg(NumOfProducts) from bank_churn_data
where Credit_Card='Yes';
4. Determine the churn rate by gender for the most recent year in the dataset.
WITH RecentYear AS (
    SELECT MAX(EXTRACT(YEAR FROM Doj)) AS recent_year FROM customer_info
),ChurnedCustomers AS (
    SELECT c.Gender, COUNT(*) AS churned_count FROM customer_info c
    JOIN bank_churn_data b ON c.CustomerID = b.CustomerID
    WHERE b.HasExited = 1
    AND EXTRACT(YEAR FROM c.Doj) = (SELECT recent_year FROM RecentYear)
    GROUP BY c.Gender
)SELECT Gender,churned_count,
ROUND(churned_count / SUM(churned_count) OVER () * 100, 2) AS churn_rate_percentage FROM ChurnedCustomers;
5. Compare the average credit score of customers who have exited and those who remain. (SQL)
select avg(CreditScore),Exited from bank_churn_data
group by Exited;
6. Which gender has a higher average estimated salary, and how does it relate to the number of active accounts? (SQL)
select avg(c.EstimatedSalary) as Avg_Estimate,c.gender from customer_info c
join bank_churn_data b
on c.CustomerID=b.CustomerID
where b.IsActiveMember=1
group by c.gender
order by Avg_Estimate
limit 1
7. Segment the customers based on their credit score and identify the segment with the highest exit rate. (SQL)
with CreditSegment as(
SELECT CustomerID,HasExited,CreditScore,
case
when b.CreditScore between 300 and 579 then "Poor_Credit_Score"
when b.CreditScore between 580 and 669 then "Fair_Credit_Score"
when b.CreditScore between 670 and 739 then "Good_Credit_Score"
when b.CreditScore between 740 and 799 then "VeryGood_Credit_Score"
else "Excellent_Credit_Score"
end as 	Creditworthiness from bank_churn_data b ),
ExitRates as(
select Creditworthiness,(sum(HasExited)/count(CustomerID)) as exit_rate from CreditSegment 
group by Creditworthiness)
select * from ExitRates where exit_rate=(select max(exit_rate) from ExitRates);
8.Find out which geographic region has the highest number of active customers with a tenure greater than 5 years. (SQL)

    SELECT c.Geography,COUNT(b.Active_Member) AS Active_count,b.tenure FROM  customer_info c
    JOIN bank_churn_data b ON c.CustomerID = b.CustomerID
    WHERE b.Active_Member = "Yes" AND b.tenure >= 5
    GROUP BY c.Geography,b.tenure
    ORDER BY Active_count DESC limit 1;

9. What is the impact of having a credit card on customer churn, based on the available data?
select count(Exited) as exit_count from bank_churn_data
where Credit_Card="Yes" and Exited="Yes";
select count(Exited) as exited_count from bank_churn_data
where Exited="Yes";
10.For customers who have exited, what is the most common number of products they have used?
select avg(NumOfProducts) from bank_churn_data
where Exited="Yes"
11. Examine the trend of customers joining over time and identify any seasonal patterns (yearly or monthly). Prepare the data through SQL and then visualize it.*/
/*select extract(year from Doj) as year_of_join,
extract(month from Doj) as month_of_join,
count(CustomerID) from customer_info
group by year_of_join,month_of_join
order by year_of_join,month_of_join
12.Analyze the relationship between the number of products and the account balance for customers who have exited.
13.Identify any potential outliers in terms of balance among customers who have remained with the bank.
select avg(Balance) as avg_balance,max(Balance) as max_balance,min(Balance) as min_balance 
from bank_churn_data
where Exited='No'
14.How many different tables are given in the dataset, out of these tables which table only consists of categorical variables?
15. Using SQL, write a query to find out the gender-wise average income of males and females in each geography id. Also, rank the gender according to the average value. (SQL)
select Gender,avg(EstimatedSalary) as Avg_Salary,Geography,
rank() over(order by avg(EstimatedSalary)) as rankings from customer_info 
group by Gender,Geography
16. Using SQL, write a query to find out the average tenure of the people who have exited in each age bracket (18-30, 30-50, 50+).*/
/*with people_age as
(select c.Age,c.Doj,(b.Exited) as Exit_count,
case
when c.Age between 18 and 30 then "Young"
when c.Age between 30 and 50 then "Medium"
else "Senior"
end as age_brackets
from customer_info c
join bank_churn_data b 
on b.CustomerID=c.CustomerID
where b.Exited="Yes"
group by c.Age,c.Doj,age_brackets)
select age_brackets,avg(TIMESTAMPDIFF(YEAR,Doj, CURRENT_DATE()) )AS avg_tenure from people_age
group by age_brackets;
17. Is there any direct correlation between salary and the balance of the customers? And is it different for people who have exited or not?*/
/*19. Rank each bucket of credit score as per the number of customers who have churned the bank.
SELECT
case
when CreditScore between 300 and 579 then "Poor_Credit_Score"
when CreditScore between 580 and 669 then "Fair_Credit_Score"
when CreditScore between 670 and 739 then "Good_Credit_Score"
when CreditScore between 740 and 799 then "VeryGood_Credit_Score"
else "Excellent_Credit_Score"
end as 	Creditworthiness,SUM(HasExited) AS churned_customers,RANK() OVER (ORDER BY SUM(HasExited) DESC) AS ranking
FROM bank_churn_data
GROUP BY Creditworthiness
ORDER BY ranking;
20.According to the age buckets find the number of customers who have a credit card. Also retrieve those buckets that have lesser than average number of credit cards per bucket.*/
/*with people_age as(
select 
case
when c.Age between 18 and 30 then "18-30"
when c.Age between 30 and 50 then "30-50"
else "50+"
end as age_brackets,
sum(b.HasCrCard) as CreditCard_count,
count(c.CustomerID) as total_customers from customer_info c 
join bank_churn_data b 
on c.CustomerID=b.CustomerID
group by age_brackets
)select age_brackets,CreditCard_count,total_customers from people_age
21 Rank the Locations as per the number of people who have churned the bank and average balance of the customers.*/
/*select c.Geography,b.Exited,avg(b.Balance) as avg_balance ,
rank() over(order by avg(b.Balance) desc) as Geography_rank
from customer_info c 
join bank_churn_data b 
on b.CustomerID=c.CustomerID
where b.Exited="Yes"
group by c.Geography
22.As we can see that the “CustomerInfo” table has the CustomerID and Surname, now if we have to join it with a table where the primary key is also a combination of CustomerID and Surname, come up with a column where the format is “CustomerID_Surname”.
select concat(CustomerID,Surname) as CustomerID_Surname from customer_info
23.Without using “Join”, can we get the “ExitCategory” from ExitCustomers table to Bank_Churn table? If yes do this using SQL.
24.Were there any missing values in the data, using which tool did you replace them and what are the ways to handle them?
25.Write the query to get the customer IDs, their last name, and whether they are active or not for the customers whose surname ends with “on”.*/
select c.CustomerID,c.Surname,b.Active_Member from customer_info c 
join bank_churn_data b 
on c.CustomerID=b.CustomerID 
where C.Surname like '%on';


