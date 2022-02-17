select SaleDateConverted, CONVERT(Date, SaleDate)
from Portfolio.dbo.NashvilleHousing


Alter table Portfolio.dbo.NashvilleHousing
add SaleDateConverted Date;

Update Portfolio.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID] 
Where a.PropertyAddress is Null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is Null



select PropertyAddress, Address
from Portfolio.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address

From Portfolio.dbo.NashvilleHousing

Alter table Portfolio.dbo.NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter table Portfolio.dbo.NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

select *
from portfolio.dbo.NashvilleHousing

Select 
PARSENAME(replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(replace(OwnerAddress, ',', '.'), 2)
,PARSENAME(replace(OwnerAddress, ',', '.'), 1)
From Portfolio.dbo.NashvilleHousing


Alter table Portfolio.dbo.NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)

Alter table Portfolio.dbo.NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)

Alter table Portfolio.dbo.NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'), 1)

select SoldAsVacant
, Case when SoldAsVacant = 'Y' THEN 'YES'
	   When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant 
	   END
from portfolio.dbo.NashvilleHousing

Update portfolio.dbo.NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'YES'
	   When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant 
	   END

select distinct(SoldAsVacant), count(soldasvacant)
from portfolio.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

WITH RowNumberCTE AS(
select *, 
	ROW_NUMBER() Over (
	Partition BY ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order BY
					UniqueID
					) row_num

from Portfolio.dbo.NashvilleHousing
--order by ParcelID
)
Select *
from RowNumberCTE
where row_num > 1
order by PropertyAddress

select *
from Portfolio.dbo.NashvilleHousing

