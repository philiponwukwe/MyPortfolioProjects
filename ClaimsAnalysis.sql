-- Loaded the entire data on the table for a preview
SELECT * 
FROM dbo.ClaimsAnalysis;

-- Picked the necessary fields for the analysis
SELECT DISTINCT Date_of_loss AS Date, Claim_number, Inception_to_loss, Notifier, Notification_period, location_of_incident AS Location, Weather_conditions AS Weather, vehicle_mobile, Main_Driver, PH_considered_TP_at_fault, Incurred AS Cost_Incurred
FROM dbo.ClaimsAnalysis;

-- How does notification period affect cost incurred
SELECT claim_number, Notification_period, Incurred AS Cost_Incurred
FROM dbo.ClaimsAnalysis
ORDER BY cost_incurred DESC;

-- See if the claim with the highest Cost Incurred was driven by main driver, also location of Incident and what was the weather condition
SELECT Claim_number, incurred, Main_driver, location_of_incident, weather_conditions
FROM dbo.ClaimsAnalysis
ORDER BY Incurred DESC


-- Weather condition with the highest number of incidents and how much they incurred
SELECT Weather_conditions, COUNT (Weather_conditions) AS Total_claims, SUM (Incurred) AS Total_Incurred
FROM dbo.ClaimsAnalysis
GROUP BY Weather_conditions
ORDER BY Total_claims DESC;

-- Locations that incurred highest cost
SELECT Location_of_incident, COUNT (Location_of_incident) AS Number_Of_Incidents,
        SUM (Incurred) AS Total_Cost_Incurred
FROM dbo.ClaimsAnalysis
GROUP BY Location_of_incident
ORDER BY Total_Cost_Incurred DESC;

-- Group the notification period by location of incident and cost incurred
SELECT DISTINCT date_of_loss, Claim_number, Notifier, Location_of_incident, 
    Weather_conditions, vehicle_mobile, Main_Driver, 
    Notification_period,
    CASE  WHEN notification_period <= 1 THEN 'Wthin Notice Period' ELSE 'Exceeded Notice Period' END AS Notice_Period_Grouping, Incurred   
FROM dbo.ClaimsAnalysis
ORDER BY Claim_number;

-- Calculating average cost incurred by location of incident
SELECT Location_of_incident AS Location, ROUND (AVG (Incurred) , 2) AS Avg_Cost_Incurred
FROM dbo.ClaimsAnalysis
GROUP BY Location_of_incident
ORDER BY Avg_Cost_Incurred DESC;

-- Calculating Average Cost Incurred by Weather Condition
SELECT Weather_conditions AS Weather, ROUND (AVG (Incurred) , 2) AS Avg_Cost_Incurred
FROM dbo.ClaimsAnalysis
GROUP BY Weather_conditions
ORDER BY Avg_Cost_Incurred DESC;

-- Calculating Average Cost Incurred by Driver
SELECT Main_driver AS Driver, ROUND (AVG (Incurred) , 2) AS Avg_Cost_Incurred
FROM dbo.ClaimsAnalysis
GROUP BY Main_driver
ORDER BY Avg_Cost_Incurred DESC;

-- Calculating Average Cost Incurred by Vehicle Mobilty
SELECT Vehicle_mobile AS Vehicle_Mobility, ROUND (AVG (Incurred) , 2) AS Avg_Cost_Incurred
FROM dbo.ClaimsAnalysis
GROUP BY Vehicle_mobile
ORDER BY Avg_Cost_Incurred DESC;

-- Forecasting future cost incurred using first notification of loss.
SELECT DISTINCT 
    date_of_loss AS Date, 
    claim_number, 
    Notifier, 
    Notification_period,
    Notification_period,
    (Notification_period - 1) AS Notice_Period_Expired,
    Inception_to_loss,  
    location_of_incident AS Location, 
    Weather_conditions AS Weather, 
    vehicle_mobile, 
    Main_Driver,
    PH_considered_TP_at_fault,
    Incurred AS Present_Cost_Incurred,
    ROUND ((Notification_period - 1) * (incurred/Notification_period), 2) AS Accrued_Cost_Overtime,
    ROUND (Incurred - ((Notification_period - 1) * (incurred/Notification_period)), 2) AS Predicted_Future_Cost
FROM dbo.ClaimsAnalysis
WHERE Notification_period > 1
ORDER BY Claim_number;

-- Created view for visualization
CREATE VIEW ForecastingCostOfClaim AS
SELECT DISTINCT 
    date_of_loss AS Date, 
    claim_number, 
    Notifier, 
    Notification_period,
    (Notification_period - 1) AS Notice_Period_Expired,
    Inception_to_loss,  
    location_of_incident AS Location, 
    Weather_conditions AS Weather, 
    vehicle_mobile, 
    Main_Driver,
    PH_considered_TP_at_fault,
    Incurred AS Present_Cost_Incurred,
    ROUND ((Notification_period - 1) * (incurred/Notification_period), 2) AS Accrued_Cost_Overtime,
    ROUND (Incurred - ((Notification_period - 1) * (incurred/Notification_period)), 2) AS Predicted_Future_Cost
FROM dbo.ClaimsAnalysis
WHERE Notification_period > 1
