#					   Bank Loan Approval & Repayment System
SELECT * FROM loan_approval;
SELECT count(*) FROM loan_approval WHERE loan_status=1;
SELECT count(*) FROM loan_approval WHERE loan_status=0;
SELECT count(*) AS Male_Count FROM loan_approval WHERE Gender='Male';
SELECT count(*) AS Female_Count FROM loan_approval WHERE Gender='Female';
SELECT DISTINCT  Employment_Status FROM loan_approval ;
SELECT DISTINCT  Education FROM loan_approval ;
SELECT Occupation_Type ,Count(*) AS TOTAL_TYPE FROM loan_approval WHERE Loan_Status=1 GROUP BY Occupation_Type ;
SELECT Gender,Age,Marital_Status,Annual_Income,Monthly_Expenses, CASE WHEN Credit_score >=750 THEN 'EXCELLENT' WHEN Credit_score BETWEEN 650 AND 749 THEN 'GOOD' WHEN Credit_score <650 THEN 'POOR' END AS Credit_customer FROM loan_approval ;
SELECT Avg(Loan_Requested) AS Avg_Loan,SUM(Loan_Requested) AS Total_Loan,Count(*) AS Total_Customers FROM loan_approval;
SELECT Gender,Age,Annual_Income,Loan_Status FROM loan_approval WHERE Loan_Status=1 order by Loan_Requested DESC LIMIT 10 ;
SELECT * FROM loan_approval WHERE Credit_Score IS NULL;
SELECT * FROM loan_approval WHERE Credit_Score IS NOT NULL;
SELECT Loan_ID, IFNULL(Annual_Income, 0) AS Annual_Income FROM loan_approval;
SELECT Education, Marital_Status, AVG(Annual_Income) AS avg_income FROM loan_approval GROUP BY Education, Marital_Status;

DELIMITER //
CREATE TRIGGER update_loan_status
BEFORE INSERT ON loan_approval
FOR EACH ROW
BEGIN
  IF NEW.credit_score >= 750 THEN
    SET NEW.loan_status = 1;
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE approval_summary_marital()
BEGIN
  SELECT Marital_Status,
         COUNT(*) AS total,
         SUM(CASE WHEN Loan_Status = 1 THEN 1 ELSE 0 END) AS approved,
         SUM(CASE WHEN Loan_Status = 0 THEN 1 ELSE 0 END) AS rejected,
         ROUND(SUM(CASE WHEN Loan_Status = 1 THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS approval_rate
  FROM loan_approval
  GROUP BY Marital_Status;
END;
//
DELIMITER ;
CALL approval_summary_marital;
ALTER TABLE loan_approval ADD Repayment_Status VARCHAR(20);
UPDATE loan_approval SET Repayment_Status = 'Paid' WHERE Loan_Status = 1;
UPDATE loan_approval SET Repayment_Status = 'rejected' WHERE Loan_Status = 0;
CREATE VIEW approved_loans AS SELECT loan_id, Gender, Age,Annual_Income,Loan_Requested FROM loan_approval WHERE loan_status = 1;
INSERT INTO loan_approval (credit_score, loan_status,Education,Annual_Income) VALUES (760, NULL,'Graduate',198200),(710,NULL,'Postgraduate',209200),(730,Null,'High school','109922'); 
CREATE TABLE customers (Customer_ID INT PRIMARY KEY,Customer_Name VARCHAR(100),Mobile_Number VARCHAR(15),Email VARCHAR(100));
ALTER TABLE loan_approval ADD Customer_ID INT, ADD CONSTRAINT fk_customer FOREIGN KEY (Customer_ID) REFERENCES customers(Customer_ID);
INSERT INTO customers VALUES (1,'Mano',8737930292,'mano@123gmail.com'),(2,'ranjith',6663992023,'ranjith@gmail.com'),(3,'vinoth',7389292938,'vinoth@gmail.com');
SELECT * FROM customers;
SELECT Customers.Customer_ID,Customers.Customer_Name,Customers.Mobile_Number,loan_approval.loan_id,loan_approval.Marital_Status,loan_approval.Annual_Income FROM customers INNER JOIN loan_approval ON customers.Customer_ID=loan_approval.Loan_id;
SELECT Customer_ID, 'Approved' AS Status FROM loan_approval WHERE Loan_Status = 1 UNION SELECT Customer_ID, 'Rejected' AS Status FROM loan_approval WHERE Loan_Status = 0;


