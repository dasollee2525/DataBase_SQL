/*NUMBER1*/
SELECT building, max(cnt) AS Most
FROM (SELECT DISTINCT building, COUNT(building) as cnt
FROM course, department
WHERE department.dept_name = course.dept_name
GROUP BY building) A;
/*NUMBER2*/
SELECT building, MAX(cnt) AS Second_Most
FROM (SELECT DISTINCT building, COUNT(building) as cnt
FROM course, department
WHERE department.dept_name = course.dept_name
GROUP BY building) A
WHERE cnt NOT IN (SELECT MAX(cnt)
FROM (SELECT DISTINCT building, COUNT(building) as cnt
FROM course, department
WHERE department.dept_name = course.dept_name
GROUP BY building) A);
/*NUMBER3*/
SELECT ID, name, dept_name, COUNT(*) AS Students
FROM instructor, advisor
WHERE instructor.ID = advisor.i_ID
GROUP BY advisor.i_ID
/*NUMBER4*/
SELECT name
FROM (
SELECT takes.ID, course.course_id, course.dept_name, year, building, student.name
FROM takes, course, department, student
WHERE course.course_id = takes.course_id
and department.dept_name = course.dept_name
and takes.ID = student.ID) A
WHERE building = "Painter"
and year = 2009;
/*NUMBER5*/
SELECT instructor.name AS Instructor
FROM (SELECT DISTINCT prereq_id FROM prereq) A, teaches, takes, student, instructor
WHERE teaches.course_id = A.prereq_id
and A.prereq_id = takes.course_id
and takes.semester = teaches.semester
and takes.year = teaches.year
and takes.year = 2009
and takes.ID = student.ID
and student.name = "Williams"
and instructor.ID = teaches.ID;
/*NUMBER6*/
DELIMITER $$
CREATE FUNCTION `Conv`(Score VARCHAR(10))
    RETURNS float
    DETERMINISTIC
BEGIN
    DECLARE Result FLOAT;
    SELECT 1 into Result
    from takes
    LIMIT 1;
    IF  Score = "A+" THEN
		SET Result = 4.3;
    ELSEIF  Score = "A" THEN
		SET Result = 4.0;
    ELSEIF  Score = "A-" THEN
		SET Result = 3.7;
    ELSEIF  Score = "B+" THEN
		SET Result = 3.3;
    ELSEIF  Score = "B" THEN
		SET Result = 3.0;
    ELSEIF  Score = "B-" THEN
		SET Result = 2.7;
    ELSEIF  Score = "C+" THEN
		SET Result = 2.3;
    ELSEIF  Score = "C" THEN
		SET Result = 2.0;
    ELSEIF  Score = "C-" THEN
		SET Result = 1.7;
    ELSEIF  Score = "D+" THEN
    SET Result = 1.3;
    ELSEIF  Score = "D" THEN
		SET Result = 1.0;
    ELSEIF  Score = "D-" THEN
		SET Result = 0.7;
    ELSEIF  Score = "F" THEN
		SET Result = 0;
    END IF;
    RETURN Result;
END $$
DELIMITER ;

SELECT student.ID, student.name, ROUND(AVG(university.Conv(grade)),2) as GPA
FROM takes, student
WHERE grade IS NOT NULL
and takes.ID = student.ID
GROUP BY student.ID;
