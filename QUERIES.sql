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
	 FROM tb_churn ) AS Total,

	(SELECT COUNT(*) TotalNumberOfChurnedCustomers
	 FROM tb_churn
	 WHERE CustomerStatus = 'Churn') AS Churned;

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TAXA DE CHURN POR CANAL DE LOGIN
-------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	PreferredLoginDevice,
	COUNT(*) AS TotalCustomers,
	SUM(Churn) AS TotalChurn,
	CAST(SUM(Churn) * 1.0/COUNT(*) * 100 AS Decimal (10,2)) AS ChurnRate
FROM tb_churn
GROUP BY 
	PreferredLoginDevice;

-- Stored Procedure para verificar detalhes sobre a tb_churn
SP_HELP tb_churn

-- Alterando o tipo de dado da coluna Churn para INT
ALTER TABLE tb_churn ALTER COLUMN Churn INT;

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TAXA DE CHURN POR CIDADE
-------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	CityTier,
	COUNT(*) AS TotalCustomers,
	SUM(Churn) AS TotalChurn,
	CAST(SUM(Churn) * 1.0/COUNT(*) * 100 AS Decimal (10,2)) AS ChurnRate
FROM tb_churn
GROUP BY CityTier
ORDER BY ChurnRate;

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CRIANDO COLUNA PARA DESCREVER A DISTANCIA DA CASA DOS CLIENTES VS ARMAZEM
-------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE tb_churn
ADD WareHouseToHomeRange VARCHAR(100);

UPDATE tb_churn
SET WareHouseToHomeRange = 
	CASE 
		WHEN warehouseToHome <= 10 THEN 'Very close distance'
		WHEN warehouseToHome > 10 AND warehouseToHome <= 20 THEN 'Close distance'
		WHEN warehouseToHome > 20 AND warehouseToHome <= 30 THEN 'Moderate distance'
		WHEN warehouseToHome > 30 THEN 'Far distance'
	END ;

-- Identificando qual maior churn por distancia
SELECT 
	WareHouseToHomeRange,
	COUNT(*) AS TotalCustomers,
	SUM(Churn) AS Churn,
	CAST(SUM(Churn)  * 100.0  / COUNT(*)  AS decimal(5,2))AS '%Churn'
FROM tb_churn
GROUP BY 
	WareHouseToHomeRange
ORDER BY Churn DESC;