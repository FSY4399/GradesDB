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

-- theta-join como Sigma-restriccion del producto cartesiano
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


/* NATURAL JOIN
	Esquemas no calificados
	Condicion de JOIN: atributos comunes entre relaciones */
	
SELECT * FROM grades NATURAL JOIN students;

SELECT * FROM grades NATURAL JOIN students NATURAL JOIN groups;

SELECT * FROM grades 
	NATURAL JOIN students 
	NATURAL JOIN groups
	NATURAL JOIN subjects;


SELECT * FROM grades 
	NATURAL JOIN students 
	NATURAL JOIN groups
	NATURAL JOIN subjects
	NATURAL JOIN degrees;
	
	
SELECT * FROM grades 
	NATURAL JOIN students 
	NATURAL JOIN groups
	NATURAL JOIN subjects
	NATURAL JOIN degrees
	NATURAL JOIN people; -- este no funciona bien porque poeple no tiene los mismosa tributos que el resto por diseño de la base de datos
	
	
SELECT * FROM students ST JOIN people P ON ST.student_id = P.person_id;

	
/* definir vistas enriquecidas ascendentes desd egrades hasta entidades independientes */
CREATE OR REPLACE VIEW V_grades AS
	SELECT * FROM (
		SELECT * from grades 
			NATURAL JOIN students 
			NATURAL JOIN groups
			NATURAL JOIN subjects
			NATURAL JOIN degrees
	)X -- subconsulta	
	JOIN people P ON X.student_id= P.person_id;

-- Otra vista ascendente desd eteaching loads hasta entidades independientes
CREATE OR REPLACE VIEW T_loads AS
	SELECT * FROM teaching_loads
		NATURAL JOIN groups
		NATURAL JOIN professors
		NATURAL JOIN subjects
		NATURAL JOIN degrees 
		JOIN people on people.person_id = professors.professor_id;




-- q44: Contar estudiantes por metodo de acceso

SELECT access_method, COUNT(*) FROM students
	GROUP BY access_method;
	
-- q45: Cuenta asignaturas por grado

SELECT degree_id, degree_name,COUNT(*) FROM subjects NATURAL JOIN degrees
	GROUP BY degree_id, degree_name;


-- q46: cuenta grupos por asignatura
SELECT subject_id, subject_name, COUNT(*) FROM groups NATURAL JOIN SUBJECTs
	GROUP BY subject_id, subject_name;
	
	
-- q47: Estudiantes con media superior a 7
SELECT student_id, AVG(grade_value), COUNT(*), SUM(grade_value), SUM(grade_value)/COUNT(*)
	FROM grades
	GROUP BY student_id
	HAVING AVG(grade_value) >=7;

-- Lo de antes como subconsulta
SELECT * FROM
	( SELECT student_id, AVG(grade_value) nm
	FROM grades
	GROUP BY student_id) AS X
	WHERE nm >=7
	
	
-- q55: tres asignaturas con mas estudiantes matriculados en grupos del 2024
SELECT subject_id, subject_name, COUNT(*) FROM group_enrollments
	NATURAL JOIN GROUPS
	NATURAL JOIN subjects
	GROUP BY subject_id, subject_name
	ORDER BY 3 DESC
	LIMIT 3;
	

-- q58: nota mas alta por cada estudiante
SELECT student_id, first_name, last_name, MAX(grade_value) FROM V_grades
	group by student_id, first_name, last_name
	ORDER BY 4 DESC;
		
	
