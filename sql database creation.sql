CREATE DATABASE companyHR;
USE companyHR;
CREATE TABLE co_employees(
	id INT PRIMARY KEY AUTO_INCREMENT,
	em_name VARCHAR(255) NOT NULL,
	gender CHAR(1) NOT NULL,
	contact_number VARCHAR(255),
	age INT NOT NULL,
	date_created TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE TABLE mentorships(
	mentor_id INT NOT NULL,
    mentee_id INT NOT NULL,
    status VARCHAR(255) NOT NULL,
    project VARCHAR(255) NOT NULL,
    
    PRIMARY KEY(mentor_id,mentee_id,project),
    CONSTRAINT fk1 FOREIGN KEY(mentor_id) REFERENCES co_employees(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT fk2 FOREIGN KEY(mentee_id) REFERENCES co_employees(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT mm_constraint UNIQUE(mentor_id,mentee_id)
);
RENAME TABLE co_employees TO employees;
ALTER TABLE employees
DROP COLUMN age,
ADD COLUMN salary FLOAT NOT NULL AFTER contact_number,
ADD COLUMN years_in_company INT NOT NULL AFTER salary;
DESCRIBE employees;
ALTER TABLE mentorships
DROP FOREIGN KEY fk2;
ALTER TABLE mentorships
ADD CONSTRAINT fk2 FOREIGN KEY(mentee_id) REFERENCES
employees(id) ON DELETE CASCADE ON UPDATE CASCADE,
DROP INDEX mm_constraint;
INSERT INTO employees (em_name, gender, contact_number, salary,
years_in_company) VALUES
('James Lee', 'M', '516-514-6568', 3500, 11),
('Peter Pasternak', 'M', '845-644-7919', 6010, 10),
('Clara Couto', 'F', '845-641-5236', 3900, 8),
('Walker Welch', 'M', NULL, 2500, 4),
('Li Xiao Ting', 'F', '646-218-7733', 5600, 4),
('Joyce Jones', 'F', '523-172-2191', 8000, 3),
('Jason Cerrone', 'M', '725-441-7172', 7980, 2),
('Prudence Phelps', 'F', '546-312-5112', 11000, 2),
('Larry Zucker', 'M', '817-267-9799', 3500, 1),
('Serena Parker', 'F', '621-211-7342', 12000, 1);
INSERT INTO mentorships (mentor_id, mentee_id, status, project)
VALUES
(1, 2, 'Ongoing', 'SQF Limited'),
(1, 3, 'Past', 'Wayne Fibre'),
(2, 3, 'Ongoing', 'SQF Limited'),
(3, 4, 'Ongoing', 'SQF Limited'),
(6, 5, 'Past', 'Flynn Tech');
UPDATE employees
SET contact_number = '516-514-1729'
WHERE id = 1;
DELETE FROM employees
WHERE id = 5;
INSERT INTO mentorships VALUES
(4, 21, 'Ongoing', 'Flynn Tech');
UPDATE employees
SET id = 12
WHERE id = 1;
UPDATE employees
SET id = 11
WHERE id = 4;
SELECT * FROM employees;
SELECT * FROM mentorships;
SELECT em_name, gender from employees;
SELECT em_name AS `Employee Name`, gender AS Gender FROM
employees;
SELECT em_name AS 'Employee Name', gender AS Gender FROM
employees LIMIT 3;
SELECT DISTINCT(gender) FROM employees;
SELECT * FROM employees WHERE id != 1
SELECT * 
FROM employees 
WHERE id BETWEEN 1 AND 3;
SELECT * FROM employees WHERE em_name LIKE '%er';
SELECT * FROM employees WHERE em_name LIKE '%er%';
SELECT * FROM employees WHERE em_name LIKE '_er';
SELECT * FROM employees WHERE em_name LIKE '____e%';
SELECT * FROM employees WHERE id IN (6, 7, 9);
SELECT * FROM employees WHERE (years_in_company > 5 OR salary >
5000) AND gender = 'F';
SELECT em_name from employees WHERE id IN
(SELECT mentor_id FROM mentorships WHERE project = 'SQF
Limited');
SELECT * FROM employees ORDER BY gender, em_name;
SELECT * FROM employees ORDER BY gender DESC, em_name;
SELECT CONCAT('Hello', ' World');
SELECT SUBSTRING('Programming', 2);
SELECT SUBSTRING('Programming', 2, 6);
SELECT CURDATE();
SELECT NOW();
SELECT CURTIME();
SELECT COUNT(*) FROM employees;
SELECT COUNT(contact_number) FROM employees;
SELECT COUNT(DISTINCT gender) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT ROUND(AVG(salary), 2) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT SUM(salary) FROM employees;
SELECT gender, MAX(salary) FROM employees GROUP BY gender;
SELECT gender, MAX(salary) FROM employees GROUP BY gender HAVING
MAX(salary) > 10000;
SELECT employees.id, mentorships.mentor_id, employees.em_name AS
'Mentor', mentorships.project AS 'Project Name'
FROM
mentorships
JOIN
employees
ON
employees.id = mentorships.mentor_id
SELECT employees.em_name AS 'Mentor', mentorships.project AS
'Project Name'
FROM
mentorships
JOIN
employees
ON
employees.id = mentorships.mentor_id;
SELECT em_name, salary FROM employees WHERE gender = 'M'
UNION
SELECT em_name, years_in_company FROM employees WHERE gender =
'F';
SELECT mentor_id FROM mentorships
UNION ALL
SELECT id FROM employees WHERE gender = 'F';
CREATE VIEW myView AS
SELECT employees.id, mentorships.mentor_id, employees.em_name AS
'Mentor', mentorships.project AS 'Project Name'
FROM
mentorships
JOIN
employees
ON
employees.id = mentorships.mentor_id;
SELECT * FROM myView;
SELECT mentor_id, `Project Name` FROM myView;
ALTER VIEW myView AS
SELECT employees.id, mentorships.mentor_id, employees.em_name AS
'Mentor', mentorships.project AS 'Project'
FROM
mentorships
JOIN
employees
ON
employees.id = mentorships.mentor_id;
DROP VIEW IF EXISTS myView;
CREATE TABLE ex_employees (
em_id INT PRIMARY KEY,
em_name VARCHAR(255) NOT NULL,
gender CHAR(1) NOT NULL,
date_left TIMESTAMP DEFAULT NOW()
);
DELIMITER $$
CREATE TRIGGER update_ex_employees BEFORE DELETE ON employees FOR
EACH ROW
BEGIN
INSERT INTO ex_employees (em_id, em_name, gender) VALUES
(OLD.id, OLD.em_name, OLD.gender);
END $$
DELIMITER ;
DELETE FROM employees WHERE id = 10;
SELECT * FROM employees;
SELECT * FROM ex_employees;
DROP TRIGGER IF EXISTS update_ex_employees;
SET @em_id = 1;
SELECT * FROM mentorships WHERE mentor_id = @em_id;
SELECT * FROM mentorships WHERE mentee_id = @em_id;
SELECT * FROM employees WHERE id = @em_id;
SET @result = SQRT(9);
SELECT @result;
SELECT @result:=SQRT(9)
DELIMITER $$
CREATE FUNCTION calculateBonus(p_salary DOUBLE, p_multiple
DOUBLE) RETURNS DOUBLE DETERMINISTIC
BEGIN
DECLARE bonus DOUBLE(8, 2);
SET bonus = p_salary*p_multiple;
RETURN bonus;
END $$
DELIMITER ;
SELECT id, em_name, salary, calculateBonus(salary, 1.5) AS bonus
FROM employees;
DROP FUNCTION IF EXISTS calculateBonus;
DELIMITER $$
CREATE FUNCTION if_demo_A(x INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
IF x > 0 THEN RETURN 'x is positive';
ELSEIF x = 0 THEN RETURN 'x is zero';
ELSE RETURN 'x is negative';
END IF;
END $$
DELIMITER ;
SELECT if_demo_A(2);
DELIMITER $$
CREATE FUNCTION if_demo_B(x INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
IF x > 0 THEN RETURN 'x is positive';
ELSEIF x = 0 THEN RETURN 'x is zero';
END IF;
END $$
DELIMITER ;
SELECT if_demo_B(-1);
DELIMITER $$
CREATE FUNCTION case_demo_A(x INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
CASE x
WHEN 1 THEN RETURN 'x is 1';
WHEN 2 THEN RETURN 'x is 2';
ELSE RETURN 'x is neither 1 nor 2';
END CASE;
END $$
DELIMITER ;
SELECT case_demo_A(1);
SELECT case_demo_A(5);
DELIMITER $$
CREATE FUNCTION case_demo_B(x INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
CASE
WHEN x > 0 THEN RETURN 'x is positive';
WHEN x = 0 THEN RETURN 'x is zero';
ELSE RETURN 'x is negative';
END CASE;
END $$
DELIMITER ;
SELECT case_demo_B(1);
SELECT case_demo_B(-1);
DELIMITER $$
CREATE FUNCTION while_demo(x INT, y INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
DECLARE z VARCHAR(255);
SET z = '';
while_example: WHILE x<y DO
SET x = x + 1;
SET z = concat(z, x);
END WHILE;
RETURN z;
END $$
DELIMITER ;
SELECT while_demo(1, 5);
DELIMITER $$
CREATE FUNCTION repeat_demo(x INT, y INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
DECLARE z VARCHAR(255);
SET z = '';
REPEAT
SET x = x + 1;
SET z = concat(z, x);
UNTIL x>=y
END REPEAT;
RETURN z;
END $$
DELIMITER ;
SELECT repeat_demo(1, 5);
SELECT repeat_demo(5, 1);
DELIMITER $$
CREATE FUNCTION loop_demo_A(x INT, y INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
DECLARE z VARCHAR(255);
SET z = '';
simple_loop: LOOP
SET x = x + 1;
IF x > y THEN
LEAVE simple_loop;
END IF;
SET z = concat(z, x);
END LOOP;
RETURN z;
END $$
DELIMITER ;
SELECT loop_demo_A(1, 5);
DELIMITER $$
CREATE FUNCTION loop_demo_B(x INT, y INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
DECLARE z VARCHAR(255);
SET z = '';
simple_loop: LOOP
SET x = x + 1;
IF x = 3 THEN ITERATE simple_loop;
ELSEIF x > y THEN LEAVE simple_loop;
END IF;
SET z = concat(z, x);
END LOOP;
RETURN z;
END $$
DELIMITER ;
SELECT loop_demo_B(1, 5);
DELIMITER $$
CREATE FUNCTION get_employees () RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
DECLARE v_employees VARCHAR(255) DEFAULT '';
DECLARE v_name VARCHAR(255);
DECLARE v_gender CHAR(1);
DECLARE v_done INT DEFAULT 0;
DECLARE cur CURSOR FOR
SELECT em_name, gender FROM employees;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
OPEN cur;
employees_loop: LOOP
FETCH cur INTO v_name, v_gender;
IF v_done = 1 THEN LEAVE employees_loop;
ELSE SET v_employees = concat(v_employees, ', ',
v_name, ': ', v_gender);
END IF;
END LOOP;
CLOSE cur;
RETURN substring(v_employees, 3);
END $$
DELIMITER ;
SELECT get_employees();



































    