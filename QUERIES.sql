USE Treinamento_TSQL

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TAXA DE CHURN
-------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	TotalCustomers,
	CustomersChurn,
	CAST((CustomersChurn * 1.0/TotalCustomers * 1.0) * 100 AS decimal(10,2)) AS ChurnRate
FROM
	(SELECT COUNT(*) AS TotalCustomers
	 FROM tb_churn ) AS Total,

	(SELECT COUNT(*) CustomersChurn
	 FROM tb_churn
	 WHERE CustomerStatus = 'Churn') AS Churned;

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TAXA DE CHURN POR CANAL DE LOGIN
-------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	PreferredLoginDevice,
	COUNT(*) AS TotalCustomers,
	SUM(Churn) AS CustomersChurn,
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
	SUM(Churn) AS CustomersChurn,
	CAST(SUM(Churn) * 1.0/COUNT(*) * 100 AS Decimal (10,2)) AS ChurnRate
FROM tb_churn
GROUP BY CityTier
ORDER BY ChurnRate;

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DISTANCIA DA CASA DOS CLIENTES VS ARMAZEM
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
	SUM(Churn) AS CustomersChurn,
	CAST(SUM(Churn)  * 100.0  / COUNT(*)  AS decimal(5,2))AS '%Churn'
FROM tb_churn
GROUP BY 
	WareHouseToHomeRange
ORDER BY CustomersChurn DESC;


-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MODALIDADE DE PAGAMENTO ENTRE OS CLIENTES
-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Modificando a abreviação para nome completo
UPDATE tb_churn
SET PreferredPaymentMode = 'Cash On Delivery'
WHERE PreferredPaymentMode = 'COD'


-- qtd de clientes e %churn pela forma de pagamento
SELECT 
	 PreferredPaymentMode, 
	 COUNT(1) AS TotalCustomers,
	 SUM(Churn) AS CustomersChurn,
	 CAST(SUM(Churn)  * 100.0  / COUNT(*)  AS decimal(5,2))AS '%Churn'
FROM tb_churn
GROUP BY 
	PreferredPaymentMode
ORDER BY 
	CustomersChurn DESC;


-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TEMPO DE PERMANÊNCIA P/ FAIXA DE TEMPO
-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Criar status, com tempo de permanência 
ALTER TABLE tb_churn ADD TenureRange VARCHAR(100);

UPDATE tb_churn 
SET TenureRange = 
	CASE 
		WHEN tenure <= 6 THEN  '6 meses'
		WHEN tenure > 6 AND tenure <= 12 THEN  '1 ano'
		WHEN tenure > 12 AND tenure <= 24 THEN  '2 anos'
		WHEN tenure > 24  THEN  'Maior que 2 anos'
	END;


-- qtd de clientes e %churn, por tempo de permanência
SELECT 
	TenureRange,
	COUNT(*) AS TotalCustomers,
	SUM(Churn) AS CustomersChurn,
	CAST(SUM(CHURN) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS '%Churn'
FROM tb_churn
GROUP BY TenureRange
ORDER BY '%Churn' DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TAXA DE CANCELAMENTO POR GÊNERO
-------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	Gender,
	COUNT(1) AS TotalCustomers,
	SUM(Churn) AS CustomersChurn,
	CAST(SUM(Churn) * 100.0 / COUNT(1) AS decimal(5,2)) AS '%Churn'
FROM tb_churn
GROUP BY Gender
ORDER BY CustomersChurn DESC

