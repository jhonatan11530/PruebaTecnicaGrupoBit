/* ------------------------ INICIO DE LA SOLUCION PUNTO 4 MODELAR UN SISTEMA DE EVALUACION ---------------------*/
 
 /*SQUIRT SQL DE LA CREACION DE LA BASE DE DATOS */

CREATE DATABASE sistema_autoevaluacion CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE Asignaturas (
  id_asignatura INT AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  id_profesor INT NOT NULL,
  PRIMARY KEY (id_asignatura),
  FOREIGN KEY (id_profesor) REFERENCES Profesores(id_profesor)
);

-- La tabla Asignaturas contiene información sobre cada asignatura, como su nombre y el profesor que la imparte.

CREATE TABLE Temas (
  id_tema INT AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  id_asignatura INT NOT NULL,
  PRIMARY KEY (id_tema),
  FOREIGN KEY (id_asignatura) REFERENCES Asignaturas(id_asignatura)
);

-- La tabla Temas contiene información sobre los temas de cada asignatura, como su nombre y la asignatura a la que pertenecen.

CREATE TABLE Ejercicios (
  id_ejercicio INT AUTO_INCREMENT,
  enunciado TEXT NOT NULL,
  solucion TEXT NOT NULL,
  grado_dificultad ENUM('facil', 'media', 'dificil', 'muy dificil') NOT NULL,
  PRIMARY KEY (id_ejercicio)
);

-- La tabla Ejercicios contiene información sobre cada ejercicio, como su enunciado, solución y grado de dificultad.

CREATE TABLE Ejercicios_Temas (
  id_ejercicio INT NOT NULL,
  id_tema INT NOT NULL,
  PRIMARY KEY (id_ejercicio, id_tema),
  FOREIGN KEY (id_ejercicio) REFERENCES Ejercicios(id_ejercicio),
  FOREIGN KEY (id_tema) REFERENCES Temas(id_tema)
);

-- La tabla Ejercicios_Temas se utiliza para relacionar los ejercicios con los temas de la asignatura a los que pertenecen.

CREATE TABLE HojasProblemas (
  id_hoja INT AUTO_INCREMENT,
  titulo VARCHAR(50) NOT NULL,
  fecha_publicacion DATE NOT NULL,
  fecha_entrega DATE NOT NULL,
  id_profesor INT NOT NULL,
  PRIMARY KEY (id_hoja),
  FOREIGN KEY (id_profesor) REFERENCES Profesores(id_profesor)
);

-- La tabla HojasProblemas contiene información sobre las hojas de problemas que los profesores pueden generar para que los alumnos las resuelvan.

CREATE TABLE Ejercicios_HojasProblemas (
  id_ejercicio INT NOT NULL,
  id_hoja INT NOT NULL,
  PRIMARY KEY (id_ejercicio, id_hoja),
  FOREIGN KEY (id_ejercicio) REFERENCES Ejercicios(id_ejercicio),
  FOREIGN KEY (id_hoja) REFERENCES HojasProblemas(id_hoja)
);

-- La tabla Ejercicios_HojasProblemas se utiliza para relacionar los ejercicios que aparecen en una hoja de problemas determinada.

CREATE TABLE Examenes (
  id_examen INT AUTO_INCREMENT,
  titulo VARCHAR(50) NOT NULL,
  fecha DATE NOT NULL,
  tipo ENUM('final', 'parcial') NOT NULL,
  porcentaje_ejercicios FLOAT NOT NULL,
  id_profesor INT NOT NULL,
  PRIMARY KEY (id_examen),
  FOREIGN KEY (id_profesor) REFERENCES Profesores(id_profesor)
);

-- La tabla Examenes contiene información sobre los exámenes que pueden


/* ------------------------ FIN DE LA SOLUCION PUNTO 4 MODELAR UN SISTEMA DE EVALUACION ---------------------*/


/* ------------------------ INICIO DE LA SOLUCION PUNTO 5 RESPONDE A PREGUNTAS ULTILIZANDO SQL ---------------------*/

/*SOLUCION AL PUNTO #1 */ 
SELECT alumnos.nombre AS NOMBRE_ALUMNO, asignaturas.denominacion AS NOMBRE_ASIGNATURA 
FROM alumnos 
INNER JOIN matriculas ON alumnos.cod_alu = matriculas.cod_alu 
INNER JOIN asignaturas ON matriculas.cod_asig = asignaturas.cod_asig
WHERE alumnos.cod_alu = asignaturas.cod_asig
ORDER BY alumnos.nombre ASC, asignaturas.denominacion ASC;

/*SOLUCION AL PUNTO #2 */

SELECT nombre, fecha_nacimiento
FROM alumnos
WHERE fecha_nacimiento <> ''
GROUP BY fecha_nacimiento
HAVING COUNT(*) > 1;

/*SOLUCION AL PUNTO #3 */
SELECT 
  alumnos.nombre AS NOMBRE_ALUMNO, 
  COUNT(matriculas.cod_matr) AS N_MATRICULAS, 
  asignaturas.denominacion AS NOMBRE_ASIGNATURA
FROM alumnos 
INNER JOIN matriculas 
  ON alumnos.cod_alu = matriculas.cod_alu
INNER JOIN asignaturas
  ON matriculas.cod_asig = asignaturas.cod_asig
WHERE alumnos.cod_alu = matriculas.cod_alu
GROUP BY alumnos.nombre, asignaturas.denominacion
ORDER BY alumnos.nombre ASC;

/*SOLUCION AL PUNTO #4 */

SELECT asignaturas.denominacion AS NOMBRE_ASIGNATURA, COUNT(*) AS NUMERO_MATRICULAS
FROM asignaturas
INNER JOIN matriculas ON asignaturas.cod_asig = matriculas.cod_asig
GROUP BY asignaturas.cod_asig, asignaturas.denominacion
ORDER BY NUMERO_MATRICULAS DESC;

/*SOLUCION AL PUNTO #5 */

SELECT alumnos.nombre AS nombre_alumno, COUNT(*) * 10 AS dinero_pagar
FROM alumnos 
INNER JOIN matriculas 
ON alumnos.cod_alu = matriculas.cod_alu
INNER JOIN examenes 
ON matriculas.cod_matr = examenes.cod_matr
GROUP BY alumnos.cod_alu, alumnos.nombre
HAVING COUNT(*) > 5
ORDER BY COUNT(*) DESC;

/*SOLUCION AL PUNTO #6 */

SELECT alumnos.nombre
FROM alumnos
INNER JOIN calificaciones ON alumnos.cod_alu = calificaciones.cod_alu
WHERE calificaciones.nota = (SELECT MAX(nota) FROM calificaciones)

/*SOLUCION AL PUNTO #7 */

SELECT DISTINCT a2.nombre
FROM alumnos a1
INNER JOIN matriculas m1 ON a1.cod_alu = m1.cod_alu
INNER JOIN matriculas m2 ON m1.cod_asig = m2.cod_asig AND m1.cod_matr <> m2.cod_matr
INNER JOIN alumnos a2 ON m2.cod_alu = a2.cod_alu
WHERE a1.apellidos = 'Gutierrez'

/*SOLUCION AL PUNTO #8 */

SELECT AVG(nota) AS nota_media_primera_evaluacion
FROM notas
WHERE asignatura = 'Bases de Datos' AND evaluacion = 1;

/*SOLUCION AL PUNTO #9 */

SELECT asignaturas.denominacion AS NOMBRE_ASIGNATURA
FROM asignaturas
LEFT JOIN matriculas ON asignaturas.cod_asig = matriculas.cod_asig
WHERE matriculas.cod_matr IS NULL;

/*SOLUCION AL PUNTO #10 */

SELECT alumnos.nombre AS alumno, asignaturas.denominacion AS asignatura, 
    costos.coste_matricula + (COUNT(notas.nota) * costos.coste_examen) AS dinero_pagado
FROM alumnos 
INNER JOIN matriculas 
    ON alumnos.cod_alu = matriculas.cod_alu
INNER JOIN asignaturas
    ON matriculas.cod_asig = asignaturas.cod_asig
INNER JOIN costos
    ON asignaturas.cod_asig = costos.cod_asig
LEFT JOIN notas 
    ON matriculas.cod_matr = notas.cod_matr
GROUP BY alumnos.nombre, asignaturas.denominacion
HAVING COUNT(notas.nota) > 5
ORDER BY alumnos.nombre, asignaturas.denominacion;

/* ------------------------ FIN DE LA SOLUCION PUNTO 5 RESPONDE A PREGUNTAS ULTILIZANDO SQL ---------------------*/


/* ------------------------ INICIO DE LA SOLUCION PUNTO 6 AHORA PROGRAMEMOS EN LA BD ---------------------*/

/*SOLUCION PUNTO #1*/

CREATE PROCEDURE RegistrarCompra
    @rut_cliente VARCHAR(20),
    @codigo_producto INT,
    @cantidad INT,
    @precio_unitario MONEY
AS
BEGIN
    SET NOCOUNT ON;

    -- Declarar variables locales
    DECLARE @codigo_compra INT;
    DECLARE @fecha_compra DATETIME;
    DECLARE @total_compra MONEY;

    -- Obtener la fecha actual
    SET @fecha_compra = GETDATE();

    -- Calcular el total de la compra
    SET @total_compra = @cantidad * @precio_unitario;

    -- Insertar la compra en la tabla "compra"
    INSERT INTO compra (cliente, fecha, total)
    VALUES (@rut_cliente, @fecha_compra, @total_compra);

    -- Obtener el código de la compra recién insertada
    SET @codigo_compra = SCOPE_IDENTITY();

    -- Insertar el producto comprado en la tabla "prod_compra"
    INSERT INTO prod_compra (codigo_c, producto, cantidad)
    VALUES (@codigo_compra, @codigo_producto, @cantidad);
END

/*SOLUCION PUNTO #2*/

CREATE PROCEDURE calcularValorCompraYActualizarPuntos 
    @num_compra INT
AS
BEGIN
    DECLARE @total FLOAT
    DECLARE @cliente INT
    DECLARE @puntos_ganados INT

    -- Calcula el valor total de la compra
    SELECT @total = SUM(producto.precio * prod_compra.cantidad)
    FROM compra
    INNER JOIN prod_compra ON compra.codigo_c = prod_compra.codigo_c
    INNER JOIN producto ON prod_compra.producto = producto.codigo_producto
    WHERE compra.codigo_c = @num_compra

    -- Si el cliente está registrado, calcula los puntos ganados y actualiza la cantidad acumulada
    SELECT @cliente = cliente, @puntos_ganados = puntos
    FROM compra
    INNER JOIN cliente ON compra.cliente = cliente.rut_cliente
    WHERE compra.codigo_c = @num_compra

    IF @cliente IS NOT NULL
    BEGIN
        SET @puntos_ganados = FLOOR(@total / 10000) -- Se otorga 1 punto por cada $10.000 de compra
        UPDATE cliente SET puntos = puntos + @puntos_ganados WHERE rut_cliente = @cliente
    END

    -- Retorna el valor total de la compra y los puntos ganados (si el cliente está registrado)
    SELECT @total AS valor_total, @puntos_ganados AS puntos_ganados
END
