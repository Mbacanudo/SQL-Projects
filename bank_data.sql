#1. ¿Cuántos nodos únicos hay en el sistema del banco de datos?
SELECT COUNT(DISTINCT(node_id)) AS nodos_unicos
FROM customer_nodes;

SELECT DISTINCT(node_id) AS nodos
FROM customer_nodes
ORDER BY nodos DESC;

#2. ¿Cuál es el número de nodos por nombre de región?
SELECT region_name, 
COUNT(DISTINCT(node_id)) AS nodos
FROM data_bank.customer_nodes cn
LEFT JOIN data_bank.regions r ON r.region_id = cn.region_id
GROUP BY region_name;

#3. ¿Cuántos clientes únicos se asignan a cada nombre de región?
SELECT region_name,
COUNT(DISTINCT(customer_id)) AS clientes_unicos
FROM data_bank.customer_nodes cn
LEFT JOIN data_bank.regions r ON r.region_id = cn.region_id
GROUP BY region_name
ORDER BY clientes_unicos DESC;

#4. ¿Cuántos días en promedio se reasignan los clientes a un nodo diferente? *Resuelve éste ejercicio con una CTE para calcular los dias de rotacion.*
SELECT *
FROM data_bank.customer_nodes
WHERE customer_id = 1;

WITH dias_de_reasignacion as (
SELECT
*,
DATEDIFF(end_date,start_date) AS dias_de_reasignacion
FROM data_bank.customer_nodes
ORDER BY dias_de_reasignacion DESC)

SELECT
AVG(dias_de_reasignacion) AS dias_prom
FROM dias_de_reasignacion;



#5. ¿Que puedes observar del resultado? ¿Esta bien el numero que te da? Hay algun outlier *(valor fuera de lo normal)* de fechas? ¿Como volverías a calular el ejercicio 4 sin estos valores?

WITH dias_de_reasignacion as (
SELECT
*,
DATEDIFF(end_date,start_date) AS dias_de_reasignacion
FROM data_bank.customer_nodes
WHERE end_date <> '9999-12-31'
ORDER BY dias_de_reasignacion DESC)

SELECT
AVG(dias_de_reasignacion) AS dias_prom
FROM dias_de_reasignacion;

#6. ¿Puedes filtrar devolver los nodos de clientes que tienen como nombre de region australia pero con una subconsulta condicional?

SELECT
*
FROM data_bank.customer_nodes
WHERE region_id = (select region_id from data_bank.regions where region_name LIKE 'Australia');


#7. ¿Cuál es el recuento único y el monto total para cada tipo de transacción?

SELECT txn_type, COUNT(*) AS qty_transacciones, SUM(txn_amount) AS total_transacciones
FROM data_bank.customer_transactions
GROUP BY txn_type;

#8. ¿Cuál es el total histórico promedio de recuentos y montos de depósitos para todos los clientes?

#CTE
WITH info_depositos as (SELECT 
customer_id,
COUNT(*) AS qty_depositos,
SUM(txn_amount) AS total_depositos
FROM data_bank.customer_transactions
WHERE txn_type = 'deposit'
GROUP BY customer_id)

SELECT
ROUND(AVG(qty_depositos),1) prom_qty_depositos,
ROUND(AVG(total_depositos),1) prom_monto_depositos
FROM info_depositos;

#SUBQUERY
SELECT
ROUND(AVG(qty_depositos),1) AS prom_qty_depositos,
ROUND(AVG(total_depositos),1) AS prom_monto_depositos
FROM (SELECT 
customer_id,
COUNT(*) AS qty_depositos,
SUM(txn_amount) AS total_depositos
FROM data_bank.customer_transactions
WHERE txn_type = 'deposit'
GROUP BY customer_id) as historico;

#9. Para cada mes, ¿cuántos clientes de Data Bank hacen más de 1 depósito y 1 compra o 1 retiro en un solo mes?

SELECT MIN(txn_date) as fecha_minima, MAX(txn_date) as fecha_max
FROM data_bank.customer_transactions;

SELECT customer_id,
COUNT(*) AS cantidad_transacciones,
MONTH(txn_date) AS mes_transaccion
FROM data_bank.customer_transactions
GROUP BY mes_transaccion, customer_id
ORDER BY cantidad_transacciones DESC;

WITH cantidad_transacciones_clt as(
SELECT MONTHNAME(txn_date) as mes,
customer_id,
COUNT(*) as qty_transacciones
FROM data_bank.customer_transactions
GROUP BY customer_id, mes)

SELECT
COUNT(customer_id) as qty_clientes
FROM cantidad_transacciones_clt
WHERE qty_transacciones > 1;

#10. ¿Puedes a la tabla de transacciones original incluir una columna que devuelva el total de cantidad de transacciones de cada cliente con una función ventana?

SELECT *,
COUNT(*) OVER(PARTITION BY customer_id) AS total_transacciones
FROM data_bank.customer_transactions;

#11. Para el id de cliente = 1 puedes traer todas las transacciones y luego en una columna aparte la cantidad de sus transacciones por mes con una función ventana?

SELECT *,
COUNT(*) OVER(PARTITION BY MONTH(txn_date)) AS qty_transacciones_mes
FROM data_bank.customer_transactions
WHERE customer_id = 1;

#12. ¿Puedes calcular el saldo de cada cliente de cada mes son una subconsulta?

SELECT
MONTHNAME(txn_date) as month,
customer_id,
SUM(txn_amount_neto) as saldo
FROM (
SELECT *,
CASE WHEN txn_type = 'deposit' THEN txn_amount
	 WHEN txn_type = 'withdrawal' THEN -txn_amount
     WHEN txn_type = 'purchase' THEN -txn_amount
     END AS
     txn_amount_neto
FROM customer_transactions) AS ct
GROUP BY customer_id, month

