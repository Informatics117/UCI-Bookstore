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
    isbn_num int NOT NULL,
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
