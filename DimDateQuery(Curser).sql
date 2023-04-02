DECLARE @StartDate  date = '01/01/2015';
DECLARE @EndDate date = '12/31/2021';
;WITH seq(n) AS
(
    SELECT 0 UNION ALL SELECT n + 1 FROM seq
    WHERE n < DATEDIFF(DAY, @StartDate, @EndDate)
),
d(d) AS
(
    SELECT DATEADD(DAY, n, @StartDate) FROM seq
),
src AS
(
    SELECT
	    [Date_Key] =  format(cast(d as date),'yyyyMMdd'),
        [Full_Date_Alternate_Key]  = CONVERT(date, d),
        [Year]          = DATEPART(YEAR, d),
        [Month_Number]      = FORMAT(d,'MM'),
        [Year_Month_Number] = FORMAT(d,'yyyy-MM'),
        [Year_Month_Short]  = FORMAT(d, 'yyyy-MMM'),
        [Month_Name_Short]  = FORMAT(d,'MMM'),
        [Month_Name_Long]   = FORMAT(d,'MMMM'),
        [Day_of_Week_Number]= DATEPART(WEEKDAY, d),
        [Day_of_Week]       = DATENAME(WEEKDAY, d),
        [Day_of_Week_Short] = FORMAT(d,'ddd'),
        [Quarter]       =  'Q' + CAST(DATEPART(QUARTER,d) AS NCHAR(1)),
        [Year_Quarter]  = CAST(YEAR(d) AS NCHAR(4)) + '-Q' + CAST(DATEPART(QUARTER,d) AS NCHAR(1)),
        [Week_Number]   = DATEPART(WEEK, d)
    FROM d
)
select  * INTO DimDate
 FROM src 
ORDER BY [Full_Date_Alternate_Key]
OPTION (MAXRECURSION 0);
