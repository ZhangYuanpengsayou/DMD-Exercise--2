/* Create a table medication_stock in your Smart Old Age Home database. The table must have the following attributes:
 1. medication_id (integer, primary key)
 2. medication_name (varchar, not null)
 3. quantity (integer, not null)
 Insert some values into the medication_stock table. 
 Practice SQL with the following:
 */
CREATE TABLE IF NOT EXISTS medication_stock (
    medication_id   INTEGER PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    quantity        INTEGER      NOT NULL
);

INSERT INTO medication_stock VALUES
(1,'Aspirin',200),
(2,'Insulin',50),
(3,'Lisinopril',30),
(4,'Metformin',10),
(5,'Atorvastatin',5);
 -- Q!: List all patients name and ages 
SELECT name, age FROM patients;

 -- Q2: List all doctors specializing in 'Cardiology'
SELECT * FROM doctors WHERE specialization = 'Cardiology';

 
 -- Q3: Find all patients that are older than 80
SELECT * FROM patients WHERE age > 80;



-- Q4: List all the patients ordered by their age (youngest first)
SELECT * FROM patients ORDER BY age ASC;



-- Q5: Count the number of doctors in each specialization
SELECT specialization, COUNT(*) AS doctor_count
FROM doctors
GROUP BY specialization;


-- Q6: List patients and their doctors' names
SELECT p.name AS patient_name, d.name AS doctor_name
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;

-- Q7: Show treatments along with patient names and doctor names
SELECT t.treatment_id,
       p.name  AS patient_name,
       n.name  AS nurse_name,
       t.treatment_type,
       t.treatment_time
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN nurses   n ON t.nurse_id   = n.nurse_id;


-- Q8: Count how many patients each doctor supervises
SELECT d.name, COUNT(*) AS patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name;


-- Q9: List the average age of patients and display it as average_age
SELECT AVG(age) AS average_age FROM patients;


-- Q10: Find the most common treatment type, and display only that
SELECT treatment_type, COUNT(*) AS cnt
FROM treatments
GROUP BY treatment_type
ORDER BY cnt DESC
LIMIT 1;


-- Q11: List patients who are older than the average age of all patients
SELECT * FROM patients
WHERE age > (SELECT AVG(age) FROM patients);


-- Q12: List all the doctors who have more than 5 patients
SELECT d.name, COUNT(*) AS cnt
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name
HAVING COUNT(*) > 5; 



-- Q13: List all the treatments that are provided by nurses that work in the morning shift. List patient name as well. 
SELECT t.treatment_id, p.name AS patient_name, t.treatment_type
FROM treatments t
JOIN nurses   n ON t.nurse_id   = n.nurse_id
JOIN patients p ON t.patient_id = p.patient_id
WHERE n.shift = 'Morning';



-- Q14: Find the latest treatment for each patient
SELECT DISTINCT ON (patient_id) patient_id, treatment_id, treatment_time
FROM treatments
ORDER BY patient_id, treatment_time DESC;


-- Q15: List all the doctors and average age of their patients
SELECT d.name, AVG(p.age) AS avg_patient_age
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name;


-- Q16: List the names of the doctors who supervise more than 3 patients
SELECT d.name
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name
HAVING COUNT(*) > 3;


-- Q17: List all the patients who have not received any treatments (HINT: Use NOT IN)
SELECT * FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM treatments);



-- Q18: List all the medicines whose stock (quantity) is less than the average stock
SELECT * FROM medication_stock
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);



-- Q19: For each doctor, rank their patients by age
SELECT p.patient_id, p.name, p.age, d.name AS doctor_name,
       RANK() OVER (PARTITION BY p.doctor_id ORDER BY p.age DESC) AS age_rank
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;


-- Q20: For each specialization, find the doctor with the oldest patient
SELECT specialization, name AS doctor_name, max_age
FROM (
    SELECT d.specialization,
           d.name,
           MAX(p.age) AS max_age,
           RANK() OVER (PARTITION BY d.specialization ORDER BY MAX(p.age) DESC) AS rnk
    FROM doctors d
    JOIN patients p ON d.doctor_id = p.doctor_id
    GROUP BY d.specialization, d.name
) t
WHERE rnk = 1;







