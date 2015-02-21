DROP DATABASE IF EXISTS bookstoredb;

CREATE DATABASE bookstoredb;
 
USE bookstoredb;

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

CREATE TABLE biography
(
    user_id NOT NULL,
    user_displayname VARCHAR(255),
    user_description text,
    user_photourl VARCHAR(255),
     FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
)

CREATE TABLE pending_users
(
	id int NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    info TEXT NOT NULL,
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

CREATE TABLE pending_reviews
(
	id int NOT NULL
	contribution_id int NOT NULL,
    poster_id int not NULL,
    review_text text,
    PRIMARY KEY(id);
    FOREIGN KEY(contribution_id) REFERENCES contributions(id) ON DELETE cascade,
    FOREIGN KEY(poster_id) REFERENCES users(id) ON DELETE cascade
);

CREATE TABLE reviews
(
	id int NOT NULL
	contribution_id int NOT NULL,
    poster_id int not NULL,
    review_text text,
    PRIMARY KEY(id);
    FOREIGN KEY(contribution_id) REFERENCES contributions(id) ON DELETE cascade,
    FOREIGN KEY(poster_id) REFERENCES users(id) ON DELETE cascade
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

INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ('testuser', 'testpass', 'test@test.com', 'testpass', 6);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ('Suzanne', 'Collins', 'suzanne@uci.edu', 'collins', 3);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'J.K.', 'Rowling', 'jk@uci.edu', 'rowling', 5);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'Harper', 'Lee', 'harper@uci.edu', 'lee', 1);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'Stephenie', 'Meyer', 'stephenie@uci.edu', 'meyer', 2);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'Jane', 'Austen', 'jane@uci.edu', 'austen', 2);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'Margaret', 'Mitchell', 'margaret@uci.edu', 'mitchell', 7);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'Jane', 'Lee', 'jane@uci.edu', 'lee', 3);

INSERT INTO pending_users VALUES (DEFAULT, 'Jacob', 'Michaelson', 'jacob@uci.edu', 'michaelson', 0);

INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book1', '0001', 0, 5.99, 'test book1');
INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book2', '0002', 0, 6.99, 'test book2');
INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book3', '0003', 0, 7.99, 'test book3');
INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book4', '0004', 0, 8.99, 'test book4');
INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book5', '0005', 0, 9.99, 'test book1');
INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating, book_price, description) VALUES ('1', 'Book6', '0006', 0, 19.99, 'test book1');
INSERT INTO contributions VALUES (DEFAULT, '2', 'The Hunger Games', '0007', 4, 19.99, 'Hunger Games starring Katniss and Peeta');
INSERT INTO contributions VALUES (DEFAULT, '2', 'Harry Potter and the Order of the Phoenix', '0008', 4, 19.99, 'A wizard');
INSERT INTO contributions VALUES (DEFAULT, '2', 'To Kill a Mockingbird', '0008', 5, 4.99, 'Literature');
INSERT INTO contributions VALUES (DEFAULT, '3', 'Twilight', '0009', 3, 19.99, 'Vampires');
INSERT INTO contributions VALUES (DEFAULT, '3', 'Pride and Prejudice', '0010', 3, 19.99, 'Great');
INSERT INTO contributions VALUES (DEFAULT, '3', 'Gone with the Wind', '0011', 3, 19.01, 'Windy');
INSERT INTO contributions VALUES (DEFAULT, '3', 'The Chronicles of Narnia', '0012', 2, 29.99, 'Adventures walking into a closet');
INSERT INTO contributions VALUES (DEFAULT, '3', 'Animal Farm', '0013', 1, 19.99, 'A classic');
INSERT INTO contributions VALUES (DEFAULT, '4', 'The Giving Tree', '0014', 4, 8.99, 'Poems');
INSERT INTO contributions VALUES (DEFAULT, '5', 'The Hitchhiker\'s Guide to the Galaxy', '0015', 2, 49.99, 'The guide to the galaxy');
INSERT INTO contributions VALUES (DEFAULT, '5', 'Wuthering Heights', '0016', 0, 12.99, 'Another classic');
INSERT INTO contributions VALUES (DEFAULT, '6', 'The Book Thief', '0017', 0, 17.99, 'Thief');
INSERT INTO contributions VALUES (DEFAULT, '6', 'Memoirs of a Geisha', '0018', 4, 5.99, 'Magnificent');
INSERT INTO contributions VALUES (DEFAULT, '7', 'The Da Vinci Code', '0019', 5, 99.99, 'How to crack the code');
INSERT INTO contributions VALUES (DEFAULT, '7', 'Alice\'s Adventures in Wonderland & Through the Looking-Glass', '0020', 0, 102.99, 'Time is ticking');
INSERT INTO contributions VALUES (DEFAULT, '7', '4-Book Boxed Set: The Hobbit and The Lord of the Rings ', '0021', 0, 399.99, 'So many books for such a small price');
INSERT INTO contributions VALUES (DEFAULT, '7', 'Romeo and Juliet ', '0022', 4, 2.99, 'Shakespeare Yea!');
INSERT INTO contributions VALUES (DEFAULT, '7', 'Les Misérables', '0023', 0, 23.99, 'Very very interesting with singing');
INSERT INTO contributions VALUES (DEFAULT, '7', 'The Fault in Our Stars', '0024', 2, 35.99, 'Good');
INSERT INTO contributions VALUES (DEFAULT, '7', 'Lord of the Flies', '0025', 0, 19.99, 'There are pigs');
INSERT INTO contributions VALUES (DEFAULT, '8', 'The Picture of Dorian Gray', '0026', 0, 9.99, 'Wild');
INSERT INTO contributions VALUES (DEFAULT, '8', 'Ender\'s Game', '0027', 1, 29.99, 'A game');
INSERT INTO contributions VALUES (DEFAULT, '8', 'Crime and Punishment', '0028', 0, 52.03, 'A very long book');

INSERT INTO pending_contributions VALUES(1, 1, 'The Alchemist', '0029', 0, 1.00, 'Powerful addicting beautifully written');
INSERT INTO pending_contributions VALUES(DEFAULT, 1, 'Charlotte\'s Web', '0030', 0, 50.00, 'Spiders and pigs and much much more');
INSERT INTO pending_contributions VALUES(DEFAULT, 2, 'Anne of Green Gables', '0031', 0, 65.99, 'Greeny');
INSERT INTO pending_contributions VALUES(DEFAULT, 3, 'Fahrenheit 451', '0032', 0, 35.99, 'Interesting');
INSERT INTO pending_contributions VALUES(DEFAULT, 7, 'Of Mice and Men', '0033', 0, 27.00, 'Novel literature');
INSERT INTO pending_contributions VALUES(DEFAULT, 7, 'Dracula', '0034', 0, 25.99, 'More vampires');
INSERT INTO pending_contributions VALUES(DEFAULT, 7, 'The Help ', '0035', 0, 29.23, 'Turned into a movie');
INSERT INTO pending_contributions VALUES(DEFAULT, 8, 'Divergent', '0036', 0, 11.99, 'Science fiction');
INSERT INTO pending_contributions VALUES(DEFAULT, 8, 'A Wrinkle in Time', '0037', 0, 12.03, 'Must fix this wrinkle');
INSERT INTO pending_contributions VALUES(DEFAULT, 8, 'The Princess Bride', '0038', 0, 14.99, 'Wedding dress');
INSERT INTO pending_contributions VALUES(DEFAULT, 8, 'Brave New World', '0039', 0, 3.99, 'Yay!');

INSERT INTO adminstrators VALUES(1, 'Steve', 'Carter', 'steve@uci.edu', 'carter', 29, 8);
