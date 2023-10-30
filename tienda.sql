#¿Cuál es la cantidad total vendida de todos los productos?

SELECT SUM(qty) AS total_productos_vendidos
FROM sandia_clothing.ventas;

#¿Cuál es el ingreso total generado por todos los productos antes de los descuentos?

SELECT SUM(qty * precio) AS venta_bruta
FROM sandia_clothing.ventas;

#¿Cuál es el ingreso medio generado por todos los productos antes de descuentos?

SELECT AVG(qty * precio) AS ingreso_medio_bruto
FROM sandia_clothing.ventas;

#¿Cuál es el ingreso total generado por cada producto antes de los descuentos?

SELECT v.id_producto, p.nombre_producto, SUM(v.qty * v.precio) AS total_ingreso_bruto
FROM sandia_clothing.ventas v
LEFT JOIN sandia_clothing.producto_detalle p ON p.id_producto = v.id_producto
GROUP BY id_producto, p.nombre_producto
ORDER BY total_ingreso_bruto DESC;

#¿Cuál fue el monto total del descuento para todos los productos?

SELECT SUM(descuento) AS total_descuentos
FROM sandia_clothing.ventas;

#¿Cuál fue el monto total del descuento por cada producto?

SELECT v.id_producto, p.nombre_producto, SUM(v.descuento) AS total_descuentos
FROM sandia_clothing.ventas v
LEFT JOIN sandia_clothing.producto_detalle p ON p.id_producto = v.id_producto
GROUP BY v.id_producto, p.nombre_producto
ORDER BY total_descuentos DESC;

#¿Cuántas transacciones únicas hubo? id_txn
SELECT COUNT(DISTINCT id_txn) as transacciones_únicas
FROM sandia_clothing.ventas;

#¿Cuáles son las ventas totales brutas de cada transacción?
SELECT id_txn, SUM(qty * precio) AS total_ventas_brutas
FROM sandia_clothing.ventas
GROUP BY id_txn
ORDER BY total_ventas_brutas DESC;

#¿Qué cantidad de productos totales se compran en cada transacción?
SELECT v.id_txn, SUM(v.qty) AS total_productos
FROM sandia_clothing.ventas v
GROUP BY v.id_txn
ORDER BY total_productos DESC;


#Ordena el resultado anterior de mayor a menor cantidad de productos.
SELECT v.id_txn, SUM(v.qty) AS total_productos
FROM sandia_clothing.ventas v
GROUP BY v.id_txn
ORDER BY total_productos DESC;

#¿Cuál es el valor de descuento promedio por transacción?
SELECT id_txn, ROUND(AVG(descuento),2) AS descuento_promedio_por_transaccion
FROM sandia_clothing.ventas
GROUP BY id_txn
ORDER BY descuento_promedio_por_transaccion DESC;

#¿Cuál es el ingreso promedio neto para transacciones de miembros "t"?
SELECT id_txn, ROUND(AVG((precio*qty)-descuento),2) AS media_ventas_netas
FROM sandia_clothing.ventas
WHERE miembro = 't'
GROUP BY id_txn
ORDER BY media_ventas_netas DESC;

#¿Cuáles son los 3 productos principales por ingresos totales antes del descuento?
SELECT p.nombre_producto, SUM(v.qty* v.precio) AS ingreso_total_bruto
FROM sandia_clothing.ventas v
LEFT JOIN sandia_clothing.producto_detalle p ON p.id_producto = v.id_producto
GROUP BY p.nombre_producto
ORDER BY ingreso_total_bruto DESC
LIMIT 3;

#¿Cuál es la cantidad total, los ingresos y el descuento de cada segmento de producto?
SELECT p.nombre_segmento, SUM(v.qty) AS total_vendidos, SUM(v.precio*v.qty-descuento) AS total_ingresos_netos, SUM(v.descuento) AS total_descuentos
FROM sandia_clothing.ventas v
LEFT JOIN sandia_clothing.producto_detalle p ON p.id_producto = v.id_producto
GROUP BY p.nombre_segmento
ORDER BY total_ingresos_netos DESC;

#¿Cuál es el producto más vendido para cada segmento?

SELECT p.nombre_segmento, p.nombre_producto, SUM(v.qty*v.precio-v.descuento) AS ventas_netas
FROM sandia_clothing.ventas v
LEFT JOIN sandia_clothing.producto_detalle p ON p.id_producto = v.id_producto
GROUP BY p.nombre_segmento, p.nombre_producto
ORDER BY ventas_netas DESC;

#¿Cuál es la cantidad total, los ingresos y el descuento para cada categoría?

SELECT p.nombre_categoria, SUM(v.qty) AS cantidad_vendida,SUM(v.qty * v.precio-v.descuento) AS ventas_netas, SUM(v.descuento) AS total_descuentos
FROM sandia_clothing.ventas v
LEFT JOIN sandia_clothing.producto_detalle p ON p.id_producto = v.id_producto
GROUP BY p.nombre_categoria;

#¿Cuál es el producto más vendido de cada categoría?
SELECT p.nombre_categoria, p.nombre_producto, SUM(v.qty * v.precio-v.descuento) AS ventas_netas
FROM sandia_clothing.ventas v
LEFT JOIN sandia_clothing.producto_detalle p on p.id_producto = v.id_producto
GROUP BY p.nombre_categoria, p.nombre_producto
ORDER BY ventas_netas DESC
LIMIT 2;

#¿Cuáles son los 5 productos que menos venden?
SELECT p.nombre_producto, SUM(v.qty * v.precio-v.descuento) AS ventas_netas
FROM sandia_clothing.ventas v
LEFT JOIN sandia_clothing.producto_detalle p ON p.id_producto = v.id_producto
GROUP BY p.nombre_producto
ORDER BY ventas_netas ASC
LIMIT 5;

#¿Cuál es la cantidad de productos vendidos para la categoría 'Mujer'?
SELECT p.nombre_categoria, SUM(v.qty) AS total_productos_vendidos, SUM(v.qty * v.precio-v.descuento) AS ventas_netas
FROM sandia_clothing.ventas v
LEFT JOIN sandia_clothing.producto_detalle p ON p.id_producto = v.id_producto
WHERE p.nombre_categoria = 'Mujer'
GROUP BY p.nombre_categoria;