#Visualizando diagrama de BD.

#Escribir consulta para mostrar el nombre, el apellido, el numero de departamento y el nombre del departamento de cada empleado

SELECT e.nombre_empleado, e.apellido_empleado, d.id_departamento, d.nombre_departamento
FROM hr_unicorn.empleados e
LEFT JOIN hr_unicorn.departamentos d ON e.id_departamento = d.id_departamento;

#Escribir consulta para mostrar el nombre y apellido, departamento, ciudad y provincia de cada empleado

SELECT e.nombre_empleado, e.apellido_empleado, d.nombre_departamento, u.ciudad, u.estado_provincia
FROM hr_unicorn.empleados e
LEFT JOIN hr_unicorn.departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN hr_unicorn.ubicaciones u ON d.id_ubicacion = u.id_ubicacion;

#Escribir consulta para mostrar el nombre, apellido, salario y categoria laboral de todos los empleados

SELECT e.nombre_empleado, e.apellido_empleado, e.salario, t.titulo_trabajo
FROM hr_unicorn.empleados e
LEFT JOIN hr_unicorn.trabajos t ON e.id_trabajo = t.id_trabajo;


#Esribir consulta para mostrar nombre, apellido, n° de depto, nombre de deot para todos los empleados de los departamentos 80 O 40.

SELECT e.nombre_empleado, e.apellido_empleado, e.id_departamento, d.nombre_departamento
FROM hr_unicorn.empleados e
LEFT JOIN hr_unicorn.departamentos d ON d.id_departamento = e.id_departamento
WHERE e.id_departamento IN(40,80); # WHERE e.id_departamento = 40 OR e.id_departamento = 80

#Escribir consulta para mostrar aquellos empleados que tengan una letra z en su nombre y tambien muestre su apellido, depto, ciudad y provincia del estado.

SELECT e.nombre_empleado, e.apellido_empleado, d.nombre_departamento, u.ciudad, u.estado_provincia
FROM hr_unicorn.empleados e
LEFT JOIN hr_unicorn.departamentos d ON d.id_departamento = e.id_departamento
LEFT JOIN hr_unicorn.ubicaciones u ON u.id_ubicacion = d.id_ubicacion
WHERE e.nombre_empleado LIKE '%z%';

#Escribir consulta para mostrar todos los departamentos incluidos aquellos donde no tiene ningun empleado.

SELECT *
FROM hr_unicorn.departamentos d
LEFT JOIN hr_unicorn.empleados e ON e.id_departamento = d.id_departamento;
#WHERE id_empleado IS NULL;

#Escribir consulta para mostrar el nombre, apellido y el salario de aquellos empleados que ganan mas de 4800

SELECT e.nombre_empleado, e.apellido_empleado, e.salario
FROM hr_unicorn.empleados e
WHERE e.salario > 4800
ORDER BY salario DESC;

#Escribir consulta para mostrar nombre, apellido y el salario de aquellos empleados que viven en Seattle o Venice

SELECT e.nombre_empleado, e.apellido_empleado, e.salario, u.ciudad
FROM hr_unicorn.empleados e
LEFT JOIN hr_unicorn.departamentos d ON d.id_departamento = e.id_departamento
LEFT JOIN hr_unicorn.ubicaciones u ON u.id_ubicacion = d.id_ubicacion
WHERE u.ciudad IN ('Seattle','Venice');

#Escribir consulta para mostrar el nombre de todos los empleados que se han incorporado luego de la fecha '2002-08-17' y que viven en la ciudad de Seattle

SELECT e.nombre_empleado, e.fecha_contratacion, u.ciudad
FROM hr_unicorn.empleados e
LEFT JOIN hr_unicorn.departamentos d ON d.id_departamento = e.id_departamento
LEFT JOIN hr_unicorn.ubicaciones u ON u.id_ubicacion = d.id_ubicacion
WHERE u.ciudad = 'Seattle' AND e.fecha_contratacion > '2002-08-17';

#Escribir consulta para mostrar nombre, apellido y salario de aquellos empleados que su categoria de salario sea mayor o igual a 30000

SELECT e.nombre_empleado, e.apellido_empleado, e.salario, e.id_trabajo, t.titulo_trabajo
FROM hr_unicorn.empleados e
LEFT JOIN hr_unicorn.trabajos t ON t.id_trabajo = e.id_trabajo
WHERE t.salario_max >= 30000;
