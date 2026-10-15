-- 
-- Autor: Fran Morano
-- Fecha: Octubre 2026 (Lab03)
-- Descripción: Consultas SQL de ejemplo para academic
--              Cubre conceptos de consultas simples
-- 

USE academic;
-- q1: Todas las asignaturas
SELECT * FROM subjects;

-- q2: Asignaturas acronimos especificos
-- 	Seleccion o Sigma-Restriccion (Filtra subconjunto de filas)
SELECT * FROM subjects 
	WHERE acronym = 'IISSI-1';
	
-- q3: Columnas especificas de todas las asignturas
--		Proyeccion algebráica (Extraccion vertical de un subconjunto de atributos)
SELECT subject_name, acronym FROM subjects;

-- q13: Suspensos y sobresalientes
SELECT * FROM grades
	WHERE  grade_value <5 OR grade_value>=9;
	
-- q14: Aprobados (ENtre 5 y 7)
SELECT * FROM grades
	WHERE  grade_value BETWEEN 5 AND 6.99;
	
-- q15: Profesores titulares y ayudantes
SELECT * FROM professors
	WHERE category IN ('Titular', 'Ayudante');

-- q17: Nombres de grupos diferentes y eliminacion de duplicados
SELECT DISTINCT group_name FROM groups;

-- q23: Personas con dni terminado en "A"
SELECT person_id, dni, first_name, last_name
	FROM people
	WHERE dni LIKE '%A';
	
-- q25: Personas cuyo nombre tiene 5 letras
SELECT * FROM people
	WHERE first_name LIKE '_____';
-- Tambien se puede hacer como 	WHERE char_length(first_name)==5


-- q30a: Notas de menor a mayor
SELECT * FROM grades
	ORDER BY grade_value;
	
-- q30b: Notas de mayor a menor
SELECT * FROM grades
	ORDER BY grade_value DESC;
	
-- q30d: 3 mejores notas
SELECT * FROM grades
	ORDER BY grade_value DESC
	LIMIT 3;

-- Aprobados por convocatoria y depues orden descendete de nota
SELECT * FROM grades
		WHERE grade_value BETWEEN 5 AND 10
		ORDER BY exam_call, grade_value DESC;
		
/* paginacion de resultados */
SELECT * FROM grades
	ORDER BY grade_value DESC
	LIMIT 6 OFFSET 6;
	
	
/* Funciones agregadas*/
SELECT MIN(grade_value) AS 'minimo',
   MAX(grade_value) 'maximo',
   AVG(grade_value), 
   STD(grade_value),
	COUNT(*),
	SUM(grade_value)
	  FROM grades;

/*Consultas sobre mas de una tabla*/

-- Producto cartesiano
SELECT * FROM degrees, professors;

SELECT * FROM people P, professors S
WHERE P.person_id=S.professor_id;

-- Theta join interno
SELECT * FROM people P
	INNER JOIN professors S
	ON P.person_id=S.professor_id;

-- Outer Theta join interno
SELECT * FROM people P
	LEFT OUTER JOIN professors S
	ON P.person_id=S.professor_id;


