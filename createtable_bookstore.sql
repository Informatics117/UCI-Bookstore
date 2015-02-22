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
    user_id int NOT NULL,
    user_displayname VARCHAR(255),
    user_description text,
    user_photourl VARCHAR(255),
     FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

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
	id int NOT NULL AUTO_INCREMENT,
	contribution_id int NOT NULL,
    poster_id int not NULL,
    rating int,
    review_text text,
    PRIMARY KEY(id),
    FOREIGN KEY(contribution_id) REFERENCES contributions(id) ON DELETE cascade,
    FOREIGN KEY(poster_id) REFERENCES users(id) ON DELETE cascade
);

CREATE TABLE reviews
(
	id int NOT NULL AUTO_INCREMENT,
	contribution_id int NOT NULL,
    poster_id int not NULL,
    rating int,
    review_text text,
    PRIMARY KEY(id),
    FOREIGN KEY(contribution_id) REFERENCES contributions(id) ON DELETE cascade,
    FOREIGN KEY(poster_id) REFERENCES users(id) ON DELETE cascade
);

CREATE TABLE administrators
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

DELIMITER $$

CREATE PROCEDURE approve_review(
_review_id INT
)
BEGIN

	START TRANSACTION;

	SELECT contribution_id, poster_id, review_text FROM pending_reviews WHERE id = _review_id INTO @contribution_id, @poster_id, @review_text;
	INSERT INTO reviews (contribution_id, poster_id, review_text) VALUES (@contribution_id, @poster_id, @review_text);
	DELETE FROM pending_reviews WHERE id = _review_id;

	COMMIT;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE approve_user(
_user_id INT
)
BEGIN

	START TRANSACTION;

	SELECT first_name, last_name, email, password FROM pending_users WHERE id = _user_id INTO @first_name, @last_name, @email, @password;
	INSERT INTO users (first_name, last_name, email, password) VALUES (@first_name, @last_name, @email, @password);
	DELETE FROM pending_users WHERE id = _user_id;

	COMMIT;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE approve_contribution(
_contribution_id INT
)
BEGIN

	START TRANSACTION;

	SELECT user_id, contribution_name, isbn_num, book_rating,book_price, description FROM pending_contributions WHERE id = _contribution_id INTO @user_id, @contribution_name, @isbn_num, @book_rating, @book_price, @description;
	INSERT INTO contributions (user_id, contribution_name, isbn_num, book_rating,book_price, description) VALUES (@user_id, @contribution_name, @isbn_num, @book_rating, @book_price, @description);
	DELETE FROM pending_contributions WHERE id = _contribution_id;

	COMMIT;

END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE edit_bio(
_id int,
_photo_url VARCHAR(250),
_display_name VARCHAR(250),
_info TEXT
)
BEGIN
	
    START TRANSACTION;
    
    UPDATE biopgrahy SET user_photourl=_photo_url, user_description=_info, user_displayname=_display_name WHERE user_id=_id;

    COMMIT;

END $$

DELIMETER ;

INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ('testuser', 'testpass', 'test@test.com', 'testpass', 6);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ('Suzanne', 'Collins', 'suzanne@uci.edu', 'collins', 3);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'J.K.', 'Rowling', 'jk@uci.edu', 'rowling', 5);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'Harper', 'Lee', 'harper@uci.edu', 'lee', 1);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'Stephenie', 'Meyer', 'stephenie@uci.edu', 'meyer', 2);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'Jane', 'Austen', 'jane@uci.edu', 'austen', 2);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'Margaret', 'Mitchell', 'margaret@uci.edu', 'mitchell', 7);
INSERT INTO users (first_name, last_name, email, password, num_contributions) VALUES ( 'Jane', 'Lee', 'jane@uci.edu', 'lee', 3);


INSERT INTO biography VALUES(1, 'testuser testpass', 'My purpose is for testing!', 'https://www.policygenius.com/blog/wp-content/uploads/2014/02/user_testing.jpg');
INSERT INTO biography VALUES(2, 'Suzanne Collins', 'I am the author of the popular trilogy Hunger Games', 'http://images.usatoday.com/life/_photos/Raw_Images/dystopian_ST/d01_book19_author_4C.jpg');
INSERT INTO biography VALUES(3, 'J.K. Rowling', 'I am the creator of the Harry Potter fantasy series, one of the most popular book and film franchises in history.', 'http://blankfictionmag.com/wp-content/uploads/2014/07/J.K.-Rowling.jpg');
INSERT INTO biography VALUES(4, 'Harper Lee', 'I am best known for writing the Pulitzer Prize-winning best-seller To Kill a Mockingbird. My only published novel.', 'http://a4.files.biography.com/image/upload/c_fill,dpr_1.0,g_face,h_300,q_80,w_300/MTE4MDAzNDEwNTk2MjM0NzY2.jpg');
INSERT INTO biography VALUES(5, 'Stephenie Meyer', 'I am the famous author of the glittery vampires who were adored by young ladies. Twilight was one of the most talked about novels in 2005 and within weeks of its release the book debuted at #5 on The New York Times bestseller list. Twilight was also named an ALA Top Ten Books for Young Adults, an Best Book of the Decade...So Far by Amazon, and a Publishers Weekly Best Book of the Year.', 'http://upload.wikimedia.org/wikipedia/commons/6/63/Stephenie_Meyer_by_Gage_Skidmore.jpg');
INSERT INTO biography VALUES(6, 'Jane Austen', 'An English novelist whose works of romantic fiction, set among the landed gentry, earned her a place as one of the most widely read writers in English literature.', 'http://upload.wikimedia.org/wikipedia/commons/d/d4/Jane_Austen_coloured_version.jpg');
INSERT INTO biography VALUES(7, 'Margaret Mitchell', 'An American author and journalist. Known for writing the popular novel Gone with the Wind.', 'http://blogs.bookforum.com/wp-content/uploads/2013/12/Margaret-Mitchell.jpg');
INSERT INTO biography VALUES(8, 'Jane Lee', 'Author of Gypsy Jane my life story.', 'http://d.gr-assets.com/books/1344737208l/14925831.jpg');

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
INSERT INTO contributions VALUES (DEFAULT, '7', 'Romeo and Juliet', '0022', 4, 2.99, 'Shakespeare Yea!');
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

INSERT INTO pending_reviews VALUES(DEFAULT, 20, 2, 4, 'I cracked the code. The movie did not do justice to this book.');
INSERT INTO pending_reviews VALUES(DEFAULT, 28, 4, 5,'Ender\'s Game is a great sci-fi boook. It not only manages to have a strong message, but it is also a joy to read. The plot is enthralling, the characters are complex and realistic, and the descriptions of the battleroom are so realistic I get lost in it.');
INSERT INTO pending_reviews VALUES(DEFAULT, 23, 1, 4,'Promising young writer.');
INSERT INTO pending_reviews VALUES(DEFAULT, 23, 5, 4,'As Expected from this author. William is awesome.');
INSERT INTO pending_reviews VALUES(DEFAULT, 10, 3, 1,'This book is great for people who don\'t know what good writing looks like. Teens will love it.');
INSERT INTO pending_reviews VALUES(DEFAULT, 24, 2, 3,'A famous novel and it is an extremely famous play. It is a great read to pass the time!');

INSERT INTO reviews VALUES(DEFAULT, 1, 2, 1,'WHO titled this book?! Filled with nothing nothing nothing.');
INSERT INTO reviews VALUES(DEFAULT, 3, 8, 3,'A really really good coloring book!');
INSERT INTO reviews VALUES(DEFAULT, 4, 7, 1,'Pages and pages of blank space. I rather listen to Taylor Swift\s blank space than stare at blank space.');
INSERT INTO reviews VALUES(DEFAULT, 6, 8, 2,'Five books later and the title is still bland. I bought this book opened it up and it was blank...');
INSERT INTO reviews VALUES(DEFAULT, 7, 1, 4,'I couldn\'t stop reading. The Hunger Games is amazing.');
INSERT INTO reviews VALUES(DEFAULT, 7, 4, 5,'The Hunger Games (Trilogy) is one of the most "unputdownable" books to enter the teen market in a long time. The cliffhangers at the end of each volume are so intense, you can\'t help but continue on. Knowing this in advance, I decided against reading the series last summer despite the fact that everyone was talking about it. I waited the extra year, and I\'m glad I did--even a week was torture when it came to getting my grubby mitts on a copy of Mockingjay.');
INSERT INTO reviews VALUES(DEFAULT, 8, 3, 4,'ORDER OF THE PHOENIX could well be my favorite book of them all, if Azkaban and Deathly Hallows weren\'t as good as they were. For all the talk about GOBLET being the one where Rowling really hikes up the intensity and the complexity in the series, it is here, in PHOENIX, she gives us Potter\'s darkest, and most complex, adventure of all. 

The second most complex novel in the entire Potter sequence (the first being Book 7), this book is probably the second best one, though I still like Azkaban better. This novel introduces the Order of the Phoenix, a whole litany of new characters and a more indepth look at the Ministry For Magic.');
INSERT INTO reviews VALUES(DEFAULT, 8, 7, 5,'I can only imagine the kind of pressure J.K. Rowling faces when she sits down to write a Harry Potter book. EACH BOOK IS AMAZING!!');
INSERT INTO reviews VALUES(DEFAULT, 8, 8, 3,'In comparison to the previous four books, this book is disappointing.');
INSERT INTO reviews VALUES(DEFAULT, 9, 1, 5,'To Kill a Mockingbird is a piece of our American history that depicts racism and prejudice, childhood innocence, and the perseverence of a man who risked it all to stand up for what he believed in. Wonderful portrayal and one I will read again.');
INSERT INTO reviews VALUES(DEFAULT, 9, 4, 4,'I read it in high school this book is a CLASSIC!');
INSERT INTO reviews VALUES(DEFAULT, 10, 6, 2,'The book itself is a rather easy read, however, the characters seem somewhat shallow. Bella is supposed to be an honour student, but behaves exactly the opposite. Edward, who has been in existence for more than a hundred years, should be more intelligent and far wiser than is portrayed in his character.');
INSERT INTO reviews VALUES(DEFAULT, 11, 4, 5,'Jane Austen is one of the great masters of the English language.  PRIDE AND PREJUDICE is her greatest masterpiece.  It describes a world in the early 19th Century English society where men held all the power and women were required to negotiate mine-fields of social status, respectability, wealth, love, and sex in order to marry both to their own liking and to the advantage of their family.');
INSERT INTO reviews VALUES(DEFAULT, 11, 1, 1,'Had to read this in highschool hated it.');
INSERT INTO reviews VALUES(DEFAULT, 11, 7, 5,'Most amusing and entertaining love story I have ever read.');
INSERT INTO reviews VALUES(DEFAULT, 11, 8, 4,'Jane Austen\'s novels have a recurring theme of love and marriage and forever invoke the absurdly beautiful art of humour and irony to fabricate a mesh of interwoven ideas tied by that central idea.');
INSERT INTO reviews VALUES(DEFAULT, 12, 8, 5,'I would give this 100 stars if I could. The chemistry was flying off the pages.');
INSERT INTO reviews VALUES(DEFAULT, 12, 4, 5,'The author\'s use of prose was beautiful. It made all the scenes come alive for me. My imagination was running wild. I couldn\t put the book down!');
INSERT INTO reviews VALUES(DEFAULT, 12, 6, 4,'The most readable long novel ever written!');
INSERT INTO reviews VALUES(DEFAULT, 14, 2, 5,'A complete and enjoyable read that had me hooked from the very first sentence.');
INSERT INTO reviews VALUES(DEFAULT, 14, 1, 4,'George Orwell is a fatastic author. I loved all his works since reading 1984.');
INSERT INTO reviews VALUES(DEFAULT, 15, 5, 5,'I fell in love with this book the first time it was read to me, and my feelings have never changed. As I child I knew it was a sad book, but I didn\'t know why. Now that I am an adult, I can understand the cost of unconditional love and I know why the tree was sad. One o the best books I have ever read.');
INSERT INTO reviews VALUES(DEFAULT, 17, 4, 4,'The book is absolutely breathtaking but is not suited for everyone. But it is without a fact timeless literature.');
INSERT INTO reviews VALUES(DEFAULT, 19, 5, 5,'One of the most beautifully written novels of the past 20 or more years, and definitely one of my personal favorites. The author paints a remarkably truthful account of one woman\'s training and practice as a geisha.');
INSERT INTO reviews VALUES(DEFAULT, 19, 3, 4,'I loved this book! From the minute I picked it up I couldn\'t put it down. It tells the story of a young girl sold into geisha training in Japan. I had no idea how much of an art form geisha was in this pre-WWII setting Gion and it was very interesting to learn so much more about it through the eyes of a young girl caught up in it. Sayuri is a wonderfully drawn character with a wide range of emotions as she endures cruelty, jealousy, misery and a whole new way of life and comes to accept it, excel in it and even embrace it. Particularly intriguing are the questions and conflicts raised by the novel about destiny, love, survival and tradition.');
INSERT INTO reviews VALUES(DEFAULT, 19, 1, 1,'This story is a fairy tale it does not portray the real Japanese people and culture.');
INSERT INTO reviews VALUES(DEFAULT, 23, 5, 5,'We just started reading Romeo and Juliet and I had the same problem so I bought this book. Boy, did it help me! I got an A in my class!');
INSERT INTO reviews VALUES(DEFAULT, 23, 8, 4,'I have loved him since high school in the 40s. I always go back to read and reread his writings and i never get bored with any of his work.');
INSERT INTO reviews VALUES(DEFAULT, 24, 3, 3,'The story has an epic feel to it, but the plot was often interrupted by what I called "political rants" that ran on for about 20-30 pages.');
INSERT INTO reviews VALUES(DEFAULT, 24, 2, 3,'Better than watching the movie with all that singing.');
INSERT INTO reviews VALUES(DEFAULT, 25, 2, 4,'Very well written it covers a topic that is hard to talk about.');
INSERT INTO reviews VALUES(DEFAULT, 25, 3, 2,'The book is terrible too many cliches. I only read it after watching the movie.');
INSERT INTO reviews VALUES(DEFAULT, 29, 7, 4,'My first time reading a book from this author. It is a smoothly flowing and fascinating story of a young man who succumbs to the most base desire, and the impact this has both psychologically and otherwise on himself and those around him.');
INSERT INTO reviews VALUES(DEFAULT, 29, 5, 2,'boring boring boring...');
INSERT INTO reviews VALUES(DEFAULT, 29, 6, 3,'THIS BOOK NEEDS TO BE TRANSLATED PROPERLY!! IT\'S SO HARD TO READ!!!');

INSERT INTO adminstrators VALUES(1, 'Steve', 'Carter', 'steve@uci.edu', 'carter', 29, 8);
