#DATABASE CREATION
CREATE DATABASE patient_satisfaction_survey_Analysis;
#USING DATABASE
use patient_satisfaction_survey_Analysis;
#RETRIVING THE DATA
SELECT * FROM patient_survey;
#to view the structure of data
DESCRIBE patient_survey;
#CREATING PROCEDURE TO GET DOCTOR INFORMATION
DELIMITER $$
CREATE PROCEDURE GetDoctorInfo(
IN Min_Doctor_Rating int,
IN Min_Doctor_Clarity int
)
BEGIN
SELECT * FROM patient_survey
WHERE Doctor_Rating>=Min_Doctor_Rating AND Doctor_Clarity>=Min_Doctor_Clarity;
END $$
DELIMITER $$
#CALLING THE PROCEDURE
CALL GetDoctorInfo(10,5)
#SATISFIED PATIENTS WITH DOCTOR TREATMENT
SELECT COUNT(*) as Satisfied_Patients_WIth_Doctor_Treatment FROM patient_survey
WHERE Doctor_Rating=10;
#2.What is the average age of patients, grouped by gender?
SELECT Gender,AVG(Age) as MEAN 
FROM patient_survey 
GROUP BY Gender;
#3.What are the ratings (Doctor, Nurse, Pharmacy, Admin, and Fee Structure) given by patients who visited as an Emergency?
SELECT Visit_Type,Doctor_Rating,Nurse_Rating,Pharmacy_Rating,Admin_Rating,Fee_Structure_Rating 
FROM patient_survey
WHERE Visit_Type='Emergency';
#4.How many patients who visited as Emergency reported their doctor interaction as ‘Very Satisfied
SELECT count(*) as Satisfied_Patients
FROM patient_survey
WHERE Visit_Type='Emergency' AND Doctor_Level='Very Satisfied';
#5.How many patients are there in each gender category?
SELECT Gender,COUNT(*)
FROM patient_survey 
GROUP BY Gender;
#6.How many patients fall into each Visit_Type category?
SELECT Visit_Type,COUNT(*)
FROM patient_survey
GROUP BY Visit_Type;
#7.What is the distribution of responses in the Doctor Recommended?
SELECT Doctor_Recommend,COUNT(*)
FROM patient_survey
GROUP BY Doctor_Recommend;
#8.What is the count of each visit type for every gender category in the data?
SELECT Gender,Visit_Type,COUNT(*) AS Total_Patients
FROM patient_survey
GROUP BY Gender,Visit_Type;
#9.How are different doctor levels distributed across genders?
SELECT Gender,Doctor_Level,COUNT(*) AS PATIENT_COUNT
FROM patient_survey
GROUP BY Gender,Doctor_Level;
#9.How are different Nurse levels distributed across genders?
SELECT Gender,Nurse_Level,COUNT(*) AS PATIENT_COUNT
FROM patient_survey
GROUP BY Gender,Nurse_Level;
#9.How are different Pharmacy levels distributed across genders?
SELECT Gender,Pharmacy_Level,COUNT(*) AS PATIENT_COUNT
FROM patient_survey
GROUP BY Gender,Pharmacy_Level;
#9.How are different Admin levels distributed across genders?
SELECT Gender,Admin_Level,COUNT(*) AS PATIENT_COUNT
FROM patient_survey
GROUP BY Gender,Admin_Level;
#CREATING PROCEDURE TO GET DOCTOR INFORMATION WITH RSPECT TO VISIT TYPE 
DELIMITER $$
CREATE PROCEDURE GetVisitTypeDoctorInfo (
    IN in_doctor_level VARCHAR(50),
    IN in_visit_type VARCHAR(50)
)
BEGIN
SELECT Patient_ID, Age,Gender,Visit_Type,Doctor_Level FROM patient_survey
WHERE Doctor_Level = in_doctor_level
AND Visit_Type = in_visit_type;
END $$
DELIMITER $$
#10.How many emergency visits involved patients who were 'Very Satisfied' with the doctor?
call GetVisitTypeDoctorInfo('Very Satisfied','Emergency');
#11.How many emergency visits involved patients who were 'Satisfied' with the doctor?
call GetVisitTypeDoctorInfo('Satisfied','Emergency');
#11.How many emergency visits involved patients who were 'Dissatisfied' with the doctor?
call GetVisitTypeDoctorInfo('Dissatisfied','Emergency');
#CREATING PROCEDURE TO GET NURSE INFORMATION WITH RSPECT TO VISIT TYPE 
DELIMITER $$
CREATE PROCEDURE GetVisitTypeNurseInfo (
    IN in_nurse_level VARCHAR(50),
    IN in_visit_type VARCHAR(50)
)
BEGIN
SELECT Patient_ID, Age,Gender,Visit_Type,Nurse_Level FROM patient_survey
WHERE Nurse_Level = in_nurse_level
AND Visit_Type = in_visit_type;
END $$
DELIMITER $$
call GetVisitTypeNurseInfo ('Very Satisfied','Emergency');
#Among all patient visits, how many patients rated ‘Very Satisfied’ (≥ 5) across every service category?
SELECT COUNT(*) AS very_satisfied_patients
FROM patient_survey
WHERE Doctor_Rating    >= 5
  AND Nurse_Rating     >= 5
  AND Pharmacy_Rating  >= 5
  AND Admin_Rating     >= 5
  AND Fee_Structure_Rating >= 5;
  #Percentage of Satisfied Patients
  SELECT
  COUNT(*) AS very_satisfied_patients,
  ROUND(COUNT(*) * 100.0 / 2000, 2) AS very_satisfied_percentage
FROM patient_survey
WHERE Doctor_Rating        >= 5
  AND Nurse_Rating         >= 5
  AND Pharmacy_Rating      >= 5
  AND Admin_Rating         >= 5
  AND Fee_Structure_Rating >= 5;
#How many patients rated the doctor’s treatment as ‘Satisfied’(ratings between 9 and 10)?
SELECT COUNT(*) AS patients_Satisfied_with_Doctor_Treatment
FROM patient_survey
WHERE Doctor_Rating BETWEEN 9 AND 10;
#How many patients rated the doctor’s treatment as ‘Dissatisfied’(ratings between 0 and 2)?
SELECT COUNT(*) AS patient_Dissatisfied
FROM patient_survey
WHERE Doctor_Rating BETWEEN 0 AND 2;
#How many patients rated the Nurse treatment as ‘Satisfied’(ratings between 9 and 10)?
SELECT COUNT(*) AS satisfied_with_nurse
FROM patient_survey
WHERE Nurse_Rating BETWEEN 9 AND 10;
#How many patients rated the Nurse treatment as ‘Dissatisfied’(ratings between 0 and 2)?
SELECT COUNT(*) AS patient_Dissatisfied
FROM patient_survey
WHERE Nurse_Rating BETWEEN 0 AND 2;
#How many patients rated the Pharmacy treatment as ‘Satisfied’(ratings between 9 and 10)?
SELECT COUNT(*) AS satisfied_with_Pharmacy
FROM patient_survey
WHERE Pharmacy_Rating BETWEEN 9 AND 10;
#How many patients rated the Pharmacy treatment as ‘Dissatisfied’(ratings between 0 and 2)?
SELECT COUNT(*) AS patient_Dissatisfied
FROM patient_survey
WHERE Pharmacy_Rating BETWEEN 0 AND 2;
#How many patients rated the Admin treatment as ‘Satisfied’(ratings between 9 and 10)?
SELECT COUNT(*) AS satisfied_with_Admin
FROM patient_survey
WHERE Admin_Rating BETWEEN 9 AND 10;
#How many patients rated the Admin treatment as ‘Dissatisfied’(ratings between 0 and 2)?
SELECT COUNT(*) AS patient_Dissatisfied
FROM patient_survey
WHERE Admin_Rating BETWEEN 0 AND 2;
#creating columns by taking rating as input
SELECT
  *,
  CASE WHEN Doctor_Rating >= 7 THEN 'yes' ELSE 'no' END AS is_doctor_satisfied,
  CASE WHEN Nurse_Rating >= 7 THEN 'yes' ELSE 'no' END AS is_nurse_satisfied,
  CASE WHEN Pharmacy_Rating >= 7 THEN 'yes' ELSE 'no' END AS is_pharmacy_satisfied,
  CASE WHEN Admin_Rating >= 7 THEN 'yes' ELSE 'no' END AS is_admin_satisfied,
  CASE WHEN Fee_Structure_Rating >= 7 THEN 'yes' ELSE 'no' END AS is_fee_satisfied
FROM patient_survey;
SELECT *,
(
    CASE WHEN Doctor_Rating          >= 7 THEN 1 ELSE 0 END +
    CASE WHEN Nurse_Rating           >= 7 THEN 1 ELSE 0 END +
    CASE WHEN Pharmacy_Rating       >= 7 THEN 1 ELSE 0 END +
    CASE WHEN Admin_Rating          >= 7 THEN 1 ELSE 0 END +
    CASE WHEN Fee_Structure_Rating >= 7 THEN 1 ELSE 0 END
  ) AS num_satisfied,

  CASE
    WHEN (
      CASE WHEN Doctor_Rating          >= 7 THEN 1 ELSE 0 END +
      CASE WHEN Nurse_Rating           >= 7 THEN 1 ELSE 0 END +
      CASE WHEN Pharmacy_Rating       >= 7 THEN 1 ELSE 0 END +
      CASE WHEN Admin_Rating          >= 7 THEN 1 ELSE 0 END +
      CASE WHEN Fee_Structure_Rating >= 7 THEN 1 ELSE 0 END
    ) >= 3 THEN 1
    ELSE 0
  END AS overall_satisfied
FROM patient_survey;
#TOTAL SATISFIED PATIENTS
SELECT
  SUM(CASE
        WHEN (CASE WHEN Doctor_Rating >= 7 THEN 1 ELSE 0 END
            + CASE WHEN Nurse_Rating >= 7 THEN 1 ELSE 0 END
            + CASE WHEN Pharmacy_Rating >= 7 THEN 1 ELSE 0 END
            + CASE WHEN Admin_Rating >= 7 THEN 1 ELSE 0 END
            + CASE WHEN Fee_Structure_Rating >= 7 THEN 1 ELSE 0 END) >= 3
        THEN 1 ELSE 0
      END) AS Total_Satisfied_Patients
FROM patient_survey;
#percentage of total satisfied patients
SELECT
  100 * AVG(
    (
      (Doctor_Rating       >= 7)
    + (Nurse_Rating        >= 7)
    + (Pharmacy_Rating     >= 7)
    + (Admin_Rating        >= 7)
    + (Fee_Structure_Rating>= 7)
    ) >= 3
  ) AS Satisfaction_Rate_Percent
FROM patient_survey;







