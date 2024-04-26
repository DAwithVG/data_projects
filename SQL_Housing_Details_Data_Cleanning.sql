
--Cleaning Data 

-- to add a new columnn called s_date derived from SaleDate to displau=y just the date 


-- To fill the property address which have null
--this below query shows  us the total number of rows who don't have a adress
select ns1.ParcelID,ns1.PropertyAddress,ns2.PropertyAddress,isnull(ns2.PropertyAddress,ns1.PropertyAddress) from nashville_sheet ns1
join nashville_sheet ns2 on ns1.ParcelID = ns2.ParcelID
 and ns1.[UniqueID ]!=ns2.[UniqueID ]
 where ns2.PropertyAddress is null

 --to update these rows
 update ns2
 set PropertyAddress =  isnull(ns1.PropertyAddress,ns2.PropertyAddress) from nashville_sheet ns1
join nashville_sheet ns2 on ns1.ParcelID = ns2.ParcelID
 and ns1.[UniqueID ]!=ns2.[UniqueID ]
 where ns2.PropertyAddress is null


 select * from nashville_sheet
 where PropertyAddress is null


 --breaking the propertyaddress column into address,city,state
 -- to break the address
 select SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address
 from nashville_sheet

 --to break state 
 select substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City from nashville_sheet

 --add these two columns Address and City into the table 
Alter table nashville_sheet
add Property_Address varchar(50)

Alter table nashville_sheet
add Property_City varchar(40)

update nashville_sheet
set Property_Address = substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)

select *from nashville_sheet

update nashville_sheet
set Property_City = substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))
-- to remove extra spaces in the column City and Address
update nashville_sheet
set City = TRIM(Property_City)

update nashville_sheet
set Address = TRIM(Property_Address)

select * from nashville_sheet

--To split owner address into Owner_Adress,Owner_City,Owner_state
select PARSENAME(replace(OwnerAddress,',','.'),3) as Owner_Address,
 PARSENAME(replace(OwnerAddress,',','.'),2) as Owner_City,
 PARSENAME(replace(OwnerAddress,',','.'),1) as Owner_State

from nashville_sheet

-- To add the s[plit column and update them

Alter table nashville_sheet
add Owner_Address varchar(60)

Alter table nashville_sheet
add Owner_City varchar(60)

Alter table nashville_sheet
add Owner_State varchar(60)

update nashville_sheet
set Owner_Address = PARSENAME(replace(OwnerAddress,',','.'),3)

update nashville_sheet
set Owner_City = PARSENAME(replace(OwnerAddress,',','.'),2)

update nashville_sheet
set Owner_State = PARSENAME(replace(OwnerAddress,',','.'),1)

--remove unwanted spaces in the entries in the newy created columns 
update nashville_sheet
set Owner_Address = TRIM(Owner_Address)

update nashville_sheet
set Owner_City = TRIM(Owner_City)

update nashville_sheet
set Owner_State = TRIM(Owner_State)

-- to change Y and N present in SoldAsVacant to Yes and No for data uniformity inside the column
select distinct(SoldAsVacant), Count(SoldAsVacant) from 
nashville_sheet
group by SoldAsVacant
order by 2

select SoldAsVacant, case when SoldAsVacant = 'Y' then 'Yes'
                          when SoldAsVacant = 'N' then 'No'
					 else SoldAsVacant end from nashville_sheet
-- To update these values
update nashville_sheet
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
                          when SoldAsVacant = 'N' then 'No'
					 else SoldAsVacant end

SELECT *  from nashville_sheet


-- To Delete duplicate rows in the table
with table_cte  as(select *,ROW_NUMBER()over(partition by ParcelID,PropertyAddress,
                                       s_date,SalePrice,LegalReference
									   order by UniqueID) num
from nashville_sheet)

delete from table_cte 
where num>1

-- to delete unused columns in the table 

alter table nashville_sheet
drop column Owneraddress,TaxDistrict,PropertyAddress

