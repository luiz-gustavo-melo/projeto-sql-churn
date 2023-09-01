USE Treinamento_TSQL

-- SELECT comum
SELECT * FROM TB_CHURN
------------------------------------------------------------------------------------------------------------------------------------------------
-- verificando número total de clientes
------------------------------------------------------------------------------------------------------------------------------------------------
SELECT COUNT(*) AS NumeroTotalClientes
FROM TB_CHURN

------------------------------------------------------------------------------------------------------------------------------------------------
-- checando clientes duplicados
-- R: Nenhum cliente duplicado
------------------------------------------------------------------------------------------------------------------------------------------------
SELECT CustomerID, COUNT(CustomerID) AS TotalClientes 
FROM TB_CHURN
GROUP BY CustomerID
HAVING COUNT(CustomerID) >1
------------------------------------------------------------------------------------------------------------------------------------------------
-- verificação de valores nulos/vazios
-- Tenure, WarehouseToHome, HourSpendOnApp, OrderAmountHikeFromlastYear, CouponUsed, OrderCount, DaySinceLastOrder possuem valores nulos/vazios 
------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 'Tenure' AS ColumnName, COUNT(*) QuantityNull
FROM [dbo].[TB_CHURN]
WHERE Tenure = ''
UNION 
SELECT 'WarehouseToHome' AS ColumnName, COUNT(*) QuantityNull
FROM [dbo].[TB_CHURN]
WHERE WarehouseToHome = ''
UNION 
SELECT 'HourSpendOnApp' AS ColumnName, COUNT(*) QuantityNull
FROM [dbo].[TB_CHURN]
WHERE HourSpendOnApp = ''
UNION 
SELECT 'OrderAmountHikeFromlastYear' AS ColumnName, COUNT(*) QuantityNull
FROM [dbo].[TB_CHURN]
WHERE OrderAmountHikeFromlastYear = ''
UNION 
SELECT 'CouponUsed' AS ColumnName, COUNT(*) QuantityNull
FROM [dbo].[TB_CHURN]
WHERE CouponUsed = ''
UNION 
SELECT 'OrderCount' AS ColumnName, COUNT(*) QuantityNull
FROM [dbo].[TB_CHURN]
WHERE OrderCount = ''
UNION 
SELECT 'DaySinceLastOrder' AS ColumnName, COUNT(*) QuantityNull
FROM [dbo].[TB_CHURN]
WHERE DaySinceLastOrder = ''

------------------------------------------------------------------------------------------------------------------------------------------------
-- substituição dos valores em branco/null pela média dos dados
------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE TB_CHURN ALTER COLUMN HourSpendOnApp SMALLINT

UPDATE TB_CHURN
SET HourSpendOnApp = (SELECT AVG(HourSpendOnApp) FROM TB_CHURN)
WHERE HourSpendOnApp = 0
--
--
ALTER TABLE TB_CHURN ALTER COLUMN Tenure SMALLINT

UPDATE TB_CHURN
SET Tenure = (SELECT AVG(Tenure) FROM TB_CHURN)
WHERE Tenure = ''
--
--
ALTER TABLE TB_CHURN ALTER COLUMN WarehouseToHome SMALLINT

UPDATE TB_CHURN
SET WarehouseToHome = (SELECT AVG(WarehouseToHome)FROM TB_CHURN)
WHERE WarehouseToHome = ''
--
--
ALTER TABLE TB_CHURN ALTER COLUMN OrderAmountHikeFromlastYear SMALLINT

UPDATE TB_CHURN
SET OrderAmountHikeFromlastYear = (SELECT AVG(OrderAmountHikeFromlastYear) FROM TB_CHURN)
WHERE OrderAmountHikeFromlastYear = ''
--
--
ALTER TABLE TB_CHURN ALTER COLUMN CouponUsed SMALLINT

UPDATE TB_CHURN 
SET CouponUsed = (SELECT AVG(CouponUsed) FROM TB_CHURN)
WHERE CouponUsed = ''
--
--
ALTER TABLE TB_CHURN ALTER COLUMN OrderCount SMALLINT

UPDATE TB_CHURN
SET OrderCount = (SELECT AVG(OrderCount) FROM TB_CHURN)
WHERE OrderCount = ''
--
--
ALTER TABLE TB_CHURN ALTER COLUMN DaySinceLastOrder SMALLINT

UPDATE TB_CHURN
SET DaySinceLastOrder = (SELECT AVG(DaySinceLastOrder) FROM TB_CHURN)
WHERE DaySinceLastOrder = ''

SP_HELP TB_CHURN


------------------------------------------------------------------------------------------------------------------------------------------------
-- ADICIONAR COLUNA COM STATUS DO CHURN
------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE TB_CHURN
ADD CustomerStatus VARCHAR(20)


UPDATE TB_CHURN
SET CustomerStatus = 
CASE 
	WHEN Churn = 1 THEN 'Churn'
	WHEN Churn = 0 THEN 'Stayed'
END 

------------------------------------------------------------------------------------------------------------------------------------------------
-- ADICIONAR COLUNA COM STATUS DO CHURN
------------------------------------------------------------------------------------------------------------------------------------------------
 ALTER TABLE TB_CHURN
 ADD ComplainRecieved VARCHAR(20)

UPDATE TB_CHURN
SET ComplainRecieved = 
CASE 
	WHEN Complain = 1 THEN 'Yes'
	WHEN Complain = 0 THEN 'No'
END 

SELECT * FROM TB_CHURN

------------------------------------------------------------------------------------------------------------------------------------------------
-- REMOVER STATUS DUPLICADOS COM NOMENCLATURAS DIFERENTES
------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	DISTINCT preferredlogindevice  
FROM TB_CHURN

UPDATE TB_CHURN
SET preferredlogindevice = 'Phone' 
WHERE preferredlogindevice = 'Mobile Phone'

SELECT 
	DISTINCT PreferedOrderCat 
FROM TB_CHURN

UPDATE TB_CHURN
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile'

SELECT 
	DISTINCT PreferredPaymentMode 
FROM TB_CHURN

UPDATE TB_CHURN
SET PreferredPaymentMode = 'COD'
WHERE PreferredPaymentMode = 'Cash on Delivery'

------------------------------------------------------------------------------------------------------------------------------------------------
-- REMOVENDO DADOS INCONSISTENTES/OUTLIERS
------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	DISTINCT warehousetohome 
FROM TB_CHURN
ORDER BY 
	warehousetohome

UPDATE TB_CHURN
SET warehousetohome = '26'
WHERE warehousetohome = '126'

UPDATE TB_CHURN
SET warehousetohome= '27'
WHERE warehousetohome = '127'




