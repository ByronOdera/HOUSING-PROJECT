SELECT * 
FROM [HOUSING PROJECT].[dbO].[NashvilleHousing]

-- STANDARDIZED DATE FORMAT

SELECT SaleDateConverted, CONVERT(date,SaleDate)
FROM [HOUSING PROJECT].[dbO].[NashvilleHousing]

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)

SELECT *
FROM [HOUSING PROJECT].[dbO].[NashvilleHousing]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [HOUSING PROJECT].[dbO].[NashvilleHousing] a
JOIN [HOUSING PROJECT].[dbO].[NashvilleHousing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [HOUSING PROJECT].[dbO].[NashvilleHousing] a
JOIN [HOUSING PROJECT].[dbO].[NashvilleHousing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


SELECT PropertyAddress
FROM [HOUSING PROJECT].[dbO].[NashvilleHousing]
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT 
SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address
,SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM [HOUSING PROJECT].[dbO].[NashvilleHousing]

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
FROM [HOUSING PROJECT].[dbO].[NashvilleHousing]

SELECT OwnerAddress
FROM [HOUSING PROJECT].[dbO].[NashvilleHousing]

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM [HOUSING PROJECT].[dbO].[NashvilleHousing]


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT *
FROM [HOUSING PROJECT].[dbo].[NashvilleHousing]

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM [HOUSING PROJECT].[dbo].[NashvilleHousing]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N'THEN 'NO'
	ELSE SoldAsVacant
	END
FROM [HOUSING PROJECT].[dbo].[NashvilleHousing]

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N'THEN 'NO'
	ELSE SoldAsVacant
	END

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM [HOUSING PROJECT].[dbo].[NashvilleHousing]
GROUP BY SoldAsVacant
ORDER BY 2

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
		ORDER BY 
		UniqueID
		) row_num
FROM [HOUSING PROJECT].[dbo].[NashvilleHousing]
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
		ORDER BY 
		UniqueID
		) row_num
FROM [HOUSING PROJECT].[dbo].[NashvilleHousing]

)
DELETE 
FROM RowNumCTE
WHERE row_num > 1


SELECT *
FROM [HOUSING PROJECT].[dbo].[NashvilleHousing]

ALTER TABLE [HOUSING PROJECT].[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE [HOUSING PROJECT].[dbo].[NashvilleHousing]
DROP COLUMN SaleDate

SELECT *
FROM [HOUSING PROJECT].[dbo].[NashvilleHousing]