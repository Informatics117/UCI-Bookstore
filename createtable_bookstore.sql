DROP DATABASE IF EXISTS authorsdb;

CREATE DATABASE authorsdb;
 
USE authorsdb;


CREATE TABLE users
(
	id int NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    num_contributions int,
    PRIMARY KEY(id)
);

CREATE TABLE contributions
(
	id int NOT NULL AUTO_INCREMENT,
    user_id int NOT NULL,
    contribution_name VARCHAR(255) NOT NULL,
    isbn_num VARCHAR(255) NOT NULL,
    book_rating int,
    book_price double,
    description text,
    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE pending_contributions
(
	id int NOT NULL AUTO_INCREMENT,
    user_id int NOT NULL,
    contribution_name VARCHAR(255) NOT NULL,
    isbn_num int NOT NULL,
    book_rating int,
    book_price double,
	description text,
    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE adminstrators
(
	id int NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(255),
    last_name VARCHAR(255),
	email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    num_contr_appr int,
    num_user_appr int,
    PRIMARY KEY(id)
);

INSERT INTO users(first_name, last_name, email, password, num_contribution) VALUES ('testuser', 'testpass', 'test@test.com', 'testpass', 0);
INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book1', '0001', '', 5.99, 'test book1');
INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book2', '0002', '', 6.99, 'test book2');
INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book3', '0003', '', 7.99, 'test book3');
INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book4', '0004', '', 8.99, 'test book4');
INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book5', '0005', '', 9.99, 'test book1');
INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book6', '0006', '', 19.99, 'test book1');
