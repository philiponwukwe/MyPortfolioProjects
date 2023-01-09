-- Loaded all the data in the table for inspection
SELECT * FROM dbo.AdsRevenueData

-- Standardized the date format
ALTER TABLE dbo.AdsRevenueData
Add DateConverted Date;

UPDATE dbo.AdsRevenueData
SET DateConverted = CONVERT(Date, Date);

--Formating currencies to GPB

SELECT Campaign_ID, Campaign, Campaign_Type, DateConverted, 
		FORMAT (Daily_Budget, 'C', 'GB-GB') AS Daily_Budget_GBP,
		FORMAT (Facebook_Ads_Revenue, 'C', 'GB-GB') AS Facebook_Ads_Revenue_GBP,
		FORMAT (Google_Ads_Revenue, 'C', 'GB-GB') AS Google_Ads_Revenue_GBP,
		FORMAT (Google_Ads_Cost, 'C', 'GB-GB') AS Google_Ads_Cost_GBP
FROM dbo.AdsRevenueData;

-- Rounding up Facebook_ROAS, Google_ROAS, Facebook_COS and Google_COS to 2 decimal places
SELECT ROUND(Facebook_ROAS, 2), 
		ROUND(Google_ROAS, 2), 
		ROUND(Facebook_COS, 2), 
		ROUND(Google_COS, 2)
FROM dbo.AdsRevenueData;


-- See different campaigns, their budget and how much they generated on facebook and google ads
SELECT Campaign, COUNT (campaign) AS N0_Of_Campaigns,
		SUM (Daily_Budget) AS Total_Budget,
		SUM(Facebook_Ads_Revenue) AS Total_Facebook_Revenue, 
		SUM(Google_Ads_Revenue) AS Total_Google_Revenue
FROM dbo.AdsRevenueData
GROUP BY Campaign

-- See different campaign types, their budgets and how much they generated on facebook and google ads
SELECT Campaign_type, COUNT (campaign_type) AS N0_Of_Campaigns, 
		SUM (Daily_Budget) AS Total_Budget,
		SUM(Facebook_Ads_Revenue) AS Total_Facebook_Revenue, 
		SUM(Google_Ads_Revenue) AS Total_Google_Revenue
FROM dbo.AdsRevenueData
GROUP BY Campaign_type

-- Lets see the campaign that generated the highest revenue on Facebook
SELECT TOP (1) Campaign_ID, Campaign, Campaign_type, daily_budget, Facebook_Ads_Revenue
FROM dbo.AdsRevenueData
ORDER BY Facebook_Ads_Revenue DESC;

-- Lets see the campaign that generated the highest revenue on Google
SELECT TOP (1) Campaign_ID, Campaign, Campaign_type, daily_budget, Google_Ads_Revenue
FROM dbo.AdsRevenueData
ORDER BY Google_Ads_Revenue DESC;

-- Lets see the campaign with the highest ROAS on Facebook
SELECT TOP (1) Campaign_ID, Campaign, Campaign_type, daily_budget, Facebook_ROAS
FROM dbo.AdsRevenueData
ORDER BY Facebook_ROAS DESC;

-- Lets see the campaign with the highest ROAS on Google
SELECT TOP (1) Campaign_ID, Campaign, Campaign_type, daily_budget, Google_ROAS
FROM dbo.AdsRevenueData
ORDER BY Google_ROAS DESC;

-- Having a look at the null values in in the relevant fields
SELECT *
FROM dbo.AdsRevenueData
WHERE Daily_Budget IS NULL 
		OR Facebook_Ads_Revenue IS NULL 
		OR Google_Ads_Revenue IS NULL
		OR Facebook_ROAS IS NULL
		OR Google_ROAS IS NULL
		OR Facebook_COS IS NULL
		OR Google_COS IS NULL;

-- Deleted the NULL rows even if this is not always best practice
DELETE FROM dbo.AdsRevenueData
WHERE Daily_Budget IS NULL 
		OR Facebook_Ads_Revenue IS NULL 
		OR Google_Ads_Revenue IS NULL
		OR Facebook_ROAS IS NULL
		OR Google_ROAS IS NULL
		OR Facebook_COS IS NULL
		OR Google_COS IS NULL;

-- Had a look at the table just to be sure the changes took effect.
SELECT * FROM dbo.AdsRevenueData

-- Dropped the irrelevant columns
ALTER TABLE dbo.AdsRevenueData
DROP COLUMN Date, Google_Ads_Transactions, Google_Clicks, Google_Impressions

SELECT * FROM dbo.AdsRevenueData

-- Preparing and creating a view of the table for visualizations
SELECT Campaign_ID, Campaign, Campaign_Type, DateConverted AS Date,
		FORMAT (Daily_Budget, 'C', 'GB-GB') AS Daily_Budget,
		FORMAT (Facebook_Ads_Revenue, 'C', 'GB-GB') AS Facebook_Ads_Revenue,
		FORMAT (Google_Ads_Revenue, 'C', 'GB-GB') AS Google_Ads_Revenue,
		FORMAT (Google_Ads_Cost, 'C', 'GB-GB') AS Google_Ads_Cost,
		ROUND(Facebook_ROAS, 2) AS Facebook_ROAS,
		ROUND(Google_ROAS, 2) AS Google_ROAS,
		ROUND(Facebook_COS, 2) AS Facebook_COS,
		ROUND(Google_COS, 2) AS Google_COS
FROM dbo.AdsRevenueData;

CREATE VIEW FacebookAds_Vs_GoogleAds AS

SELECT Campaign_ID, Campaign, Campaign_Type, DateConverted AS Date,
		FORMAT (Daily_Budget, 'C', 'GB-GB') AS Daily_Budget,
		FORMAT (Facebook_Ads_Revenue, 'C', 'GB-GB') AS Facebook_Ads_Revenue,
		FORMAT (Google_Ads_Revenue, 'C', 'GB-GB') AS Google_Ads_Revenue,
		FORMAT (Google_Ads_Cost, 'C', 'GB-GB') AS Google_Ads_Cost,
		ROUND(Facebook_ROAS, 2) AS Facebook_ROAS,
		ROUND(Google_ROAS, 2) AS Google_ROAS,
		ROUND(Facebook_COS, 2) AS Facebook_COS,
		ROUND(Google_COS, 2) AS Google_COS
FROM dbo.AdsRevenueData;