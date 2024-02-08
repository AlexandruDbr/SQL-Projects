

-------------------------------------------------/* Cleaning Data in SQL Queries */----------------------------------------
USE ProjectsDB;
GO

CREATE PROCEDURE NashvilleH
AS
SELECT * FROM NashvilleHousing

--1. Update the sales date column format from datetime to date

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)

SELECT * FROM NashvilleHousing;
GO

--2. Populate the PropertyAddress null cells based PropertyAddress not null values with the same ParcellID

	/* Every row had a ParcelID but not every row had a PropertyAddress. Fortunately every ParcelID which had null 
		values had a duplicate row with both ParcelID and PropertyAddress NOT NULL, so I joined them on ParcelID and 
		I added a PropertyAddress based on NOT NULL row. */
		

SELECT * FROM NashvilleHousing
WHERE PropertyAddress is null
ORDER BY ParcelID;
GO


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND
a.UniqueID <> b.UniqueID;


--3. Breaking out OwnerAddress into Individual Columns (Address, City, State)

 --3.1 Check if the owners have addresses duplicated

SELECT OwnerAddress, COUNT(OwnerAddress) as count_adress FROM NashvilleHousing 
GROUP BY OwnerAddress
ORDER BY count_adress DESC;

 --3.2 Add Address, city, State columns

ALTER TABLE NashvilleHousing
ADD OwnerStreet VARCHAR(100);

ALTER TABLE NashvilleHousing
ADD OwnerCity VARCHAR(100);

ALTER TABLE NashvilleHousing
ADD OwnerState VARCHAR(10);
	
 --3.3 Add value based on OwnerAddress

UPDATE NashvilleHousing
SET OwnerStreet = 
	SUBSTRING(OwnerAddress, 0, CHARINDEX( ',', OwnerAddress ) ),
OwnerCity = SUBSTRING( OwnerAddress
        , ( CHARINDEX( ',', OwnerAddress) + 1 )  -- starting position from which to take the values.
        , CHARINDEX( ',', OwnerAddress,  ( CHARINDEX( ',', OwnerAddress ) + 1 )) 
		- ( CHARINDEX( ',', OwnerAddress) + 1 )), -- start to search for the second delimiter right after the first delimiter. 
													-- length of the column being the number of characters between the two delimiters.
OwnerState = SUBSTRING(OwnerAddress, CHARINDEX( ',', OwnerAddress, ( CHARINDEX( ',', OwnerAddress) + 1 ) ) + 1, LEN(OwnerAddress))
FROM NashvilleHousing

 --3.4 Delete column OwnerAddress

 ALTER TABLE NashvilleHousing
 DROP COLUMN OwnerAddress;

 --3.5 Update Column name to OwnerAddress

 sp_RENAME 'NashvilleHousing.OwnerStreet', 'OwnerAddress', 'COLUMN';

SELECT * FROM NashvilleHousing;


	--3.6 Check if we have multiple lines with the same parcel ID but no address or with address but no owner name

SELECT a.ParcelID, b.ParcelID, a.OwnerName, b.OwnerName, a.OwnerStreet,  b.OwnerStreet
FROM NashvilleHousing AS a
JOIN NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
AND
a.UniqueID <> b.UniqueID
WHERE
a.OwnerStreet IS NULL 
AND 
b.OwnerStreet IS NOT NULL
OR
b.OwnerStreet IS NULL 
AND 
a.OwnerStreet IS NOT NULL
OR
a.OwnerName IS NULL 
AND 
b.OwnerName IS NOT NULL
OR
b.OwnerName IS NULL 
AND 
a.OwnerName IS NOT NULL
;

EXEC NashvilleH;

--4. Add a new column PropertyCity based on PropertyAddress and keep only street name

ALTER TABLE NashvilleHousing
ADD PropertyCity VARCHAR(30);

UPDATE NashvilleHousing
SET PropertyCity = SUBSTRING(
	PropertyAddress, 
	(CHARINDEX(',', PropertyAddress,1)+1),
	LEN(PropertyAddress));

UPDATE NashvilleHousing
SET PropertyAddress = SUBSTRING(
	PropertyAddress,
	1, 
	(
	CHARINDEX(',', PropertyAddress,1)-1)
	);

EXEC NashvilleH;

--5. Change 1 and 0 to Yes and No in "Sold as Vacant" field

UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE
WHEN SoldAsVacant = 0 THEN 'No'
WHEN SoldAsVacant = 1 THEN 'Yes'
END;

--Check the result

EXEC NashvilleH;



--6. Remove Duplicates

--6.1 Create a CTE to find the duplicate rows

WITH ROWRANKING AS (
SELECT *, 
	ROW_NUMBER() 
	OVER(
		PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY ParcelID) ROWN
FROM NashvilleHousing
)
SELECT * FROM ROWRANKING
WHERE ROWN > 1

--Check the result
EXEC NashvilleH;



-----------------------------------------------------------------------------------------------------------------------------------------
