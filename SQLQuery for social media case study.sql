--Creating a CTE to reference a new 'ER' variable
--Shows complete table with the engagement rate 
WITH CTE AS (
	SELECT *, CASE 
		WHEN Total_Impressions >0 THEN (CAST((Total_Engagements) AS DECIMAL)/CAST((Total_Impressions) AS DECIMAL) * 100) ELSE 0 END as ER
	FROM [EGsocialdata - Sheet1]
	
	)
SELECT *
FROM CTE ;

--Finding the average ER based on the number of posts (excluding outliers with over 100% ER) 
WITH CTE AS (
	SELECT *, CASE 
		WHEN Total_Impressions >0 THEN (CAST((Total_Engagements) AS DECIMAL)/CAST((Total_Impressions) AS DECIMAL) * 100) ELSE 0 END as ER
	FROM [EGsocialdata - Sheet1]
	)

SELECT SUM(ER)/COUNT(*) AS Avg_Engagement_Rate
FROM CTE
WHERE ER <= 100 ;

-- social media platform vs social performance 
-- We omit 3 entries which heavily influence the average ER
WITH CTE AS (
	SELECT *, CASE 
		WHEN Total_Impressions >0 THEN (CAST((Total_Engagements) AS DECIMAL)/CAST((Total_Impressions) AS DECIMAL) * 100) ELSE 0 END as ER
	FROM [EGsocialdata - Sheet1]
	)

SELECT account_type, sum(total_impressions) as sum_of_impressions, sum(total_engagements) as sum_of_engagements, avg(total_impressions) as avg_impressions, avg(total_engagements) as avg_engagements, 
	(CAST(SUM(Total_Engagements) AS DECIMAL)/CAST(SUM(Total_Impressions) AS DECIMAL) * 100) as engagement_rate, SUM(ER)/COUNT(*) as avg_er_per_post, COUNT(*) as num_of_posts,
	MAX(total_impressions) as max_impressions, MAX(total_engagements) as max_engagements
FROM CTE
WHERE Total_Engagements <= Total_Impressions
GROUP BY Account_Type 
ORDER BY engagement_rate DESC

-- How is the social performance for the games? 
WITH CTE AS (
	SELECT *, CASE 
		WHEN Total_Impressions >0 THEN (CAST((Total_Engagements) AS DECIMAL)/CAST((Total_Impressions) AS DECIMAL) * 100) ELSE 0 END as ER
	FROM [EGsocialdata - Sheet1]
	)

SELECT account, SUM(total_impressions) as sum_of_impressions, 
	SUM(total_engagements) as sum_of_engagements, AVG(total_impressions) as avg_impressions, AVG(total_engagements) as avg_engagements, 
	CAST(AVG(Total_Engagements) AS DECIMAL)/CAST(AVG(Total_Impressions) AS DECIMAL) * 100 as engagement_rate, SUM(ER)/COUNT(*) as avg_er_per_post, COUNT(*) as num_of_posts,
	MAX(total_impressions) as max_impressions, MAX(total_engagements) as
	max_engagements
FROM CTE
WHERE account not in ('content creators', 'general')
GROUP BY account
ORDER BY engagement_rate desc


-- Which media type is performing the best? 
-- We omit 3 entries which heavily influence the average ER
WITH CTE AS (
	SELECT *, CASE 
		WHEN Total_Impressions >0 THEN (CAST((Total_Engagements) AS DECIMAL)/CAST((Total_Impressions) AS DECIMAL) * 100) ELSE 0 END as ER
	FROM [EGsocialdata - Sheet1]
	)

SELECT media_type,
	sum(total_impressions) as sum_of_impressions, sum(total_engagements) as sum_of_engagements,
	avg(Total_Impressions) as avg_impressions, avg(Total_Engagements) as avg_engagements, CAST(AVG(Total_Engagements) AS DECIMAL)/CAST(AVG(Total_Impressions) AS DECIMAL) * 100 as engagement_rate,
	SUM(ER)/COUNT(*) as avg_er_per_post,
	COUNT(*) as num_of_posts, MAX(total_impressions) as max_impressions, MAX(total_engagements) as max_engagements
FROM CTE
WHERE Total_Engagements <= Total_Impressions
GROUP BY Media_Type
ORDER BY engagement_rate desc


-- Which Campaign is performing the best? 
-- We omit 3 entries which heavily influence the average ER
WITH CTE AS (
	SELECT *, CASE 
		WHEN Total_Impressions >0 THEN (CAST((Total_Engagements) AS DECIMAL)/CAST((Total_Impressions) AS DECIMAL) * 100) ELSE 0 END as ER
	FROM [EGsocialdata - Sheet1]
	)

SELECT Campaign_Name, SUM(total_impressions) as sum_of_impressions, 
	SUM(total_engagements) as sum_of_engagements, AVG(total_impressions) as avg_impressions, AVG(total_engagements) as avg_engagements, 
	CAST(AVG(Total_Engagements) AS DECIMAL)/CAST(AVG(Total_Impressions) AS DECIMAL) * 100 as engagement_rate, SUM(ER)/COUNT(*) as avg_er_per_post, COUNT(*) as num_of_posts,
	MAX(total_impressions) as max_impressions, MAX(total_engagements) as max_engagements
FROM CTE
WHERE Total_Engagements <= Total_Impressions
GROUP BY Campaign_Name
ORDER BY engagement_rate desc
