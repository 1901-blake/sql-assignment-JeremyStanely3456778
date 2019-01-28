/*SQL Lab

Jeremy Stanley
Class 1901- Blake Kruppa
Revature
January 23 2019*/


/*2.0 SQL Queries
In this section you will be performing various queries against the Postgres Chinook database.
2.1 SELECT
Task – Select all records from the Employee table.*/

select * from Employee;
 
/*Task – Select all records from the Employee table where last name is King.*/

select * 
from Employee
where lastname = 'King';

/*Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.*/

select * 
from Employee
where firstname = 'Andrew' and reportsto is null;

/*2.2 ORDER BY
Task – Select all albums in Album table and sort result set in descending order by title.*/

select * 
from album order by title desc;


/*Task – Select first name from Customer and sort result set in ascending order by city*/

select firstname 
from customer order by city asc;


/*2.3 INSERT INTO
Task – Insert two new records into Genre table*/

insert into genre(genreid, name) values(26, 'Techno');
insert into genre(genreid, name) values(27, 'Salsa');

/*ITask – Insert two new records into Employee table*/

insert into employee(employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email) 
values('Bob', 'Hope', 'IT Staff', 6, 1947-09-19 00:00:00, 2002-09-14 00:00:00, '11120 Redneck Ave NW', 'Tampa', 'FL', 'United States', 'B31361',
'+1 (780) 428-9489', '+1 (403) 263-4289', 'billybob@chinook.com');

/*Task – Insert two new records into Customer table*/

/*Tsk – Update Aaron Mitchell in Customer table to Robert Walter*/

update customer set firstname = 'Robert', lastname = 'Walter' 
where customerid = 32;

/*Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”*/

update artist set name = 'CCR'
where artistid = 24;

/*2.5 LIKE
Task – Select all invoices with a billing address like “T%”*/

select * from invoice
where billingaddress like 'T%';

/*2.6 BETWEEN
Task – Select all invoices that have a total between 15 and 50*/

select * from invoice
where total between 15.00 and 50.00 ;

/*Task – Select all employees hired between 1st of June 2003 and 1st of March 2004*/

select * from employee
where hiredate between '2003-06-01 00:00:00' and '2004-03-01 00:00:00';

/*2.7 DELETE
Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).

I used select statements to delete rows starting at invoiceline, then from invoice, and finally from the customer table. You delete from a column other than
the foreign key constraints.*/

delete from invoiceline
where invoiceline = 116;

delete from invoiceline where invoiceid = 22;

delete from invoice where customerid = 48;

/*3.0	SQL Functions
In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
3.1 System Defined Functions
Task – Create a function that returns the current time.*/

create function gettime() returns timetz as $$
select current_time;
	
$$ language sql;

/*Task – create a function that returns the length of a mediatype from the mediatype table*/

create function get_word_length(varchar(20)) returns int as $$
select length($1);
$$ language sql;

/*3.2 System Defined Aggregate Functions
Task – Create a function that returns the average total of all invoices*/

create function get_invoice_total() returns numeric as $$
SELECT AVG(total)
FROM invoice;
$$ language sql;


/*Task – Create a function that returns the most expensive track*/

create function get_mostexpensive_track() returns numeric as $$
SELECT max(unitprice)
FROM track;
$$ language sql;



/*3.3 User Defined Scalar Functions
Task – Create a function that returns the average price of invoiceline items in the invoiceline table*/

create function averageInvoicelinePrice() returns numeric as $$
SELECT avg(unitprice)
FROM invoiceline;
$$ language sql;

/*3.4 User Defined Table Valued Functions
Task – Create a function that returns all employees who are born after 1968.*/

create function employees_born_after_1968() returns varchar(20) as $$
SELECT lastname
FROM employee
where birthdate >= '1969-01-01 00:00:00';
$$ language sql;

/*4.0 Stored Procedures
 In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
4.1 Basic Stored Procedure*/

CREATE PROCEDURE Get_Employees()
LANGUAGE SQL
AS $$
select firstname, lastname
from employee;
$$;

CALL Get_Employees();

/*4.2 Stored Procedure Input Parameters
Task – Create a stored procedure that updates the personal information of an employee.*/

CREATE PROCEDURE update_employee_table()  
LANGUAGE SQL
AS $$
update employee set lastname = 'Iman'
where employeeid = '4';
$$;
CALL update_employee_table();


/*Task – Create a stored procedure that returns the managers of an employee.*/

CREATE PROCEDURE get_managers()  
LANGUAGE SQL
AS $$
select reportsto from employee;
$$;
CALL get_managers();

/*4.3 Stored Procedure Output Parameters
Task – Create a stored procedure that returns the name and company of a customer.*/

CREATE PROCEDURE get_customer()
LANGUAGE SQL
AS $$
select firstname, lastname, company
from customer;
$$;
CALL get_customer();

/*5.0 Transactions
In this section you will be working with transactions. Transactions are usually nested within a stored procedure.
Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table*/

CREATE PROCEDURE update_customer12()
LANGUAGE SQL
AS $$
update customer set customerid = 354, lastname = 'William', firstname = 'Jeremy', company = 'Google' , address = '189 SW Celine CT', city = 'Lake City', state = 'FL', country = 'United States', postalcode = 32024, 
phone = '890-987-4565' , fax = '890-987-4565', email = 'jeremy.stanley85@gmail.com', supportrepid = 5
where customerid = 32;
$$;
CALL update_customer12();


/*6.0 Triggers
In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
6.1 AFTER/FOR
Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.*/

INSERT INTO employee (employeeid, firstname, lastname, title, reportsto, birthdate, hiredate, city, state, country, postalcode, 
phone, fax, email)
VALUES (123, 'bob', 'Smith', 'IT staff', 1, '1991-01-01', '2015-01-01', '189 SW Celine CT', 'Fort BRAGER', 'fl', 'United States', '32024', '567-678-1234',
'556-321-9876', 'bob.smith@gmail.com');

CREATE OR REPLACE TRIGGER after_insert_trigger_employee_table 
after insert INSERT ON employee 
as
BEGIN
select * from employee; 
END

/*comment: You never said which action the trigger should take after firing.*/

/*Task – Create an after update trigger on the album table that fires after a row is inserted in the table+*/

CREATE OR REPLACE TRIGGER after_insert_trigger_album_table 
after insert ON album
BEGIN
    select * from album;
end


/*Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.*/

CREATE OR REPLACE TRIGGER after_delete_trigger_customer_table 
after delete ON customer
BEGIN
    select * from customer; 
end


/*7.0 JOINS
In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
7.1 INNER
Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.*/

SELECT customer.customerid ,customer.firstname, customer.lastname, invoice.invoiceid
FROM customer
INNER JOIN invoice ON customer.customerid = invoice.customerid;

/*7.2 OUTER
Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.*/

select customer.customerid, firstname, lastname, invoiceid, total
from customer full outer join invoice on 
invoice.customerid = customer.customerid;

/*Comment: there is no such thing as an outer join without using right, inner, left, or full key words. I chose full.*/

/*7.3 RIGHT
Task – Create a right join that joins album and artist specifying artist name and title.*/

SELECT *
FROM album
RIGHT JOIN artist ON artist.artistid = album.artistid;


/*7.4 CROSS
Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.*/

select * 
FROM album 
CROSS JOIN artist
ORDER BY artist.name;

/*7.5 SELF
Task – Perform a self-join on the employee table, joining on the reportsto column.
comment: This is what a join looks like in w3school website.*/

select a.reportsto, a.firstname, b.lastname from employee as a, employee as b
where a.reportsto = b.reportsto
order by a.reportsto;








