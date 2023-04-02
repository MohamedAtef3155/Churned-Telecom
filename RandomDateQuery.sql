update 
dimension_date
set
start_date = DATEADD(month,-[Tenure in Months], End_Date)
Where [End_Date] is Not Null

declare c7 cursor
for select
[Tenure in Months] 
from
dimension_date , [dbo].[churn_Status]
where dimension_date.[Customer ID] = [churn_Status].[Customer ID] And [Churn Label] = 'Yes'
for update
declare @Tenure_in_Months float
declare @year int
open c7
fetch c7 into @Tenure_in_Months 
while @@FETCH_STATUS=0
  begin
  ----------------
   if (@Tenure_in_Months >= 60)
       set @year = 2021
  else if (@Tenure_in_Months >= 48)
       set @year = 2020
  else if (@Tenure_in_Months >= 36)
       set @year = 2019
  else if (@Tenure_in_Months >= 24)
       set @year = 2018
  else if (@Tenure_in_Months >= 12)
       set @year = 2017
  else 
       set @year = 2016

  update 
  dimension_date
  set
  End_Date = datefromparts(FLOOR(RAND()*(2021-@year+1)+@year) , FLOOR(RAND()*(12-1+1)+1) , FLOOR(RAND()*(28-1+1)+1))
  --where [Customer ID] = @CustomerID
  where current of c7
  ----------------
 fetch c7 into @Tenure_in_Months 
   end 
	close c7
	deallocate c7
