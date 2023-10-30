#CREAR TABLA EN SCHEMA call_center_verde

CREATE TABLE call_center_verde.calls(
ID CHAR(50),
cust_name CHAR(50),
sentiment CHAR(20),
csat_score INT,
call_timestamp CHAR(10),
reason CHAR(20),
city CHAR(20),
state CHAR(20),
channel CHAR(20),
response_time CHAR(20),
call_duration_minutes INT,
call_center CHAR(20)
);

# Visualización de la importación de csv
SELECT *
FROM call_center_verde.calls;

# MIN y MAX para fecha y duración de llamadas
SELECT MIN(call_duration_minutes) AS min_tiempo_llamada, MAX(call_duration_minutes) max_tiempo_llamada, COUNT(call_duration_minutes) AS total_llamadas,
MIN(call_timestamp) AS rango_fecha_min, MAX(call_timestamp) AS rango_fecha_max
FROM call_center_verde.calls;

# Visualización de cantidad de columnas
SELECT COUNT(column_name) AS qty_cols
FROM information_schema.columns 
WHERE table_name = 'calls' AND table_schema = 'call_center_verde';

# Visualización de cantidad de filas
SELECT COUNT(*) AS qty_rows
FROM call_center_verde.calls;

# Cantidad de valores unicos para las columnas sentiment, reason, channel, response_time, call_center y state
SELECT COUNT(DISTINCT sentiment) AS sentiment_unique_values, COUNT(DISTINCT reason) AS reason_unique_values, COUNT(DISTINCT channel) AS channel_unique_values, 
COUNT(DISTINCT response_time) AS response_time_unique_values, COUNT(DISTINCT call_center) AS call_center_unique_values, COUNT(DISTINCT state) state_unique_values
FROM call_center_verde.calls;

# Chequear la cantidad de registros y porcentajes de las columnas que miramos anteriormente
# sentiment
SELECT sentiment, 
       COUNT(*) AS qty,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM call_center_verde.calls)),2) AS porcentaje_registros_unicos
FROM call_center_verde.calls
GROUP BY sentiment
ORDER BY qty DESC;

# reason
SELECT reason, 
       COUNT(*) AS qty,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM call_center_verde.calls)),2) AS porcentaje_registros_unicos
FROM call_center_verde.calls
GROUP BY reason
ORDER BY qty DESC;

# channel
SELECT channel, 
       COUNT(*) AS qty,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM call_center_verde.calls)),2) AS porcentaje_registros_unicos
FROM call_center_verde.calls
GROUP BY channel
ORDER BY qty DESC;

# response_time
SELECT response_time, 
       COUNT(*) AS qty,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM call_center_verde.calls)),2) AS porcentaje_registros_unicos
FROM call_center_verde.calls
GROUP BY response_time
ORDER BY qty DESC;

# call_center
SELECT call_center, 
       COUNT(*) AS qty,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM call_center_verde.calls)),2) AS porcentaje_registros_unicos
FROM call_center_verde.calls
GROUP BY call_center
ORDER BY qty DESC;

# state
SELECT state, 
       COUNT(*) AS qty,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM call_center_verde.calls)),2) AS porcentaje_registros_unicos
FROM call_center_verde.calls
GROUP BY state
ORDER BY qty DESC;

# Del campo ID se debe estraer el código de 8 dígitos que viene luego de las letras en un nuevo campo que se llame green_code

SELECT *
FROM call_center_verde.calls;

SELECT ID,
       SUBSTRING_INDEX(SUBSTRING_INDEX(ID, '-', 2), '-', -1) AS green_code
FROM call_center_verde.calls;

SELECT SUBSTRING(ID,5,8) AS green_code
FROM call_center_verde.calls;

# Debemos actualizar el formato de las fechas que se encuentran como string a Fecha

SELECT str_to_date(call_timestamp, '%m/%d/%y') AS fecha_actualizada
FROM call_center_verde.calls;

UPDATE call_center_verde.calls
SET call_timestamp = str_to_date(call_timestamp, '%m/%d/%y');


# Aquellas llamadas que tengan csat_score = 0 deben convertirse en nulas

UPDATE call_center_verde.calls
SET csat_score = NULL
WHERE csat_score = 0;

SELECT *
FROM call_center_verde.calls
WHERE csat_score IS NULL;

SELECT COUNT(*) AS total_valores_nulos
FROM (
    SELECT *
    FROM call_center_verde.calls
    WHERE csat_score IS NULL
) AS valores_nulos;


# La ciudad de Nueva York se ha descargado mal por un problema con el software y hay que pasar aquellos que no tengan el formato adecuado al que corresponde

SELECT DISTINCT state
FROM call_center_verde.calls
WHERE state LIKE '%York%';

UPDATE call_center_verde.calls
SET state = 'New York'
WHERE state = 'NewYork' OR state = 'NY';

# Hay que convertir los minutos que están como enteros a hh:mm:ss

SELECT sec_to_time(call_duration_minutes*60) AS call_duration_minutes
FROM call_center_verde.calls;

# Crear nueva tabla con los campos limpios: call_verde

CREATE TABLE call_center_verde.calls_verde
SELECT 
ID,
SUBSTRING_INDEX(SUBSTRING_INDEX(ID, '-', 2), '-', -1) AS green_code,
cust_name,
sentiment,
CASE WHEN csat_score = 0 THEN csat_score = NULL ELSE csat_score END AS csat_score,
str_to_date(call_timestamp, '%m/%d/%Y') AS call_timestamp,
reason,
city,
CASE WHEN state IN('NY', 'NewYork') THEN state = 'New York' ELSE state END AS state,
channel,
response_time,
SEC_TO_TIME(call_duration_minutes*60) as call_duration_minutes,
call_center
FROM call_center_verde.calls; 


