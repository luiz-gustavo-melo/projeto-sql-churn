USE Treinamento_TSQL

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TAXA DE CHURN
-------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	TotalNumberofCustomers,
	TotalNumberOfChurnedCustomers,
	CAST((TotalNumberOfChurnedCustomers * 1.0/TotalNumberofCustomers * 1.0) * 100 AS decimal(10,2)) AS ChurnRate
FROM
	(SELECT COUNT(*) AS TotalNumberofCustomers
	 FROM TB_CHURN ) AS Total,

	(SELECT COUNT(*) TotalNumberOfChurnedCustomers
	 FROM TB_CHURN
	 WHERE CustomerStatus = 'Churn') AS Churned

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TAXA DE CHURN POR CANAL DE LOGIN
-------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	PreferredLoginDevice,
	COUNT(*) AS TotalCustomers,
	SUM(Churn) AS TotalChurn,
	CAST(SUM(Churn) * 1.0/COUNT(*) * 100 AS Decimal (10,2)) AS ChurnRate
FROM TB_CHURN
GROUP BY 
	PreferredLoginDevice

-- Stored Procedure para verificar detalhes sobre a TB_CHURN
SP_HELP TB_CHURN

-- Alterando o tipo de dado da coluna Churn para INT
ALTER TABLE TB_CHURN ALTER COLUMN Churn INT

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TAXA DE CHURN POR CIDADE
-------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	CityTier,
	COUNT(*) AS TotalCustomers,
	SUM(Churn) AS TotalChurn,
	CAST(SUM(Churn) * 1.0/COUNT(*) * 100 AS Decimal (10,2)) AS ChurnRate
FROM TB_CHURN
GROUP BY 
	CityTier

