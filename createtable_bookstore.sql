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
    affiliation VARCHAR(255) NOT NULL,
    department VARCHAR(255),
    class int NOT NULL,
    school VARCHAR(255) NOT NULL,
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
	affiliation VARCHAR(255) NOT NULL,
    department VARCHAR(255),
    class int NOT NULL,
    school VARCHAR(255) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE contributions
(
	id int NOT NULL AUTO_INCREMENT,
    user_id int NOT NULL,
    contribution_name VARCHAR(255) NOT NULL,
    isbn_num VARCHAR(255) NOT NULL,
    book_rating int,
    book_price DOUBLE NOT NULL,
    description text,
	ts TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    book_photourl VARCHAR(255),
    publisher VARCHAR(255) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE pending_contributions
(
	id int NOT NULL AUTO_INCREMENT,
    user_id int NOT NULL,
    contribution_name VARCHAR(255) NOT NULL,
    isbn_num VARCHAR(255) NOT NULL,
    book_rating int,
    book_price double,
	description text,
	book_photourl VARCHAR(255),
    publisher VARCHAR(255) NOT NULL,
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
    ts TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
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

CREATE PROCEDURE add_review(
_contribution_id int,
_poster_id int,
_review_text text
)
BEGIN

	START TRANSACTION;

	INSERT INTO pending_reviews VALUES (DEFAULT, _contribution_id, _poster_id, 0, _review_text);

	COMMIT;

END $$


CREATE PROCEDURE submit_contribution(
_user_id INT,
_contribution_name VARCHAR(255),
_isbn_num VARCHAR(255),
_book_price DOUBLE,
_description text,
_photo_url VARCHAR(255),
_publisher VARCHAR(255),
_rating int
)
BEGIN

	START TRANSACTION;

	INSERT INTO pending_contributions VALUES(DEFAULT, _user_id, _contribution_name, isbn_num, _rating, _book_price, _description, _photo_url, _publisher);

	COMMIT;

END $$

CREATE PROCEDURE submit_and_approve(
_user_id INT,
_contribution_name VARCHAR(255),
_isbn_num VARCHAR(255),
_book_price DOUBLE,
_description text,
_photo_url VARCHAR(255),
_publisher VARCHAR(255),
_rating INT
)
BEGIN

	START TRANSACTION;

	INSERT INTO contributions VALUES(DEFAULT, _user_id, _contribution_name, isbn_num, _rating, _book_price, _description, now(), _photo_url, _publisher);

	COMMIT;

END $$


CREATE PROCEDURE approve_review(
_review_id INT
)
BEGIN

	START TRANSACTION;

	SELECT contribution_id, poster_id, rating, review_text FROM pending_reviews WHERE id = _review_id INTO @contribution_id, @poster_id, @rating, @review_text;
	INSERT INTO reviews VALUES (DEFAULT, @contribution_id, @poster_id, @rating, @review_text, now());
	DELETE FROM pending_reviews WHERE id = _review_id;

	COMMIT;

END $$

CREATE PROCEDURE approve_user(
_user_id INT
)
BEGIN

	START TRANSACTION;

	SELECT first_name, last_name, email, password, affiliation, department, class, school FROM pending_users 
    WHERE id = _user_id INTO @first_name, @last_name, @email, @password, @affiliation, @department, @class, @school;
	INSERT INTO users VALUES (DEFAULT, @first_name, @last_name, @email, @password, 0, @affiliation, @department, @class, @school);
	DELETE FROM pending_users WHERE id = _user_id;

	COMMIT;

END $$

CREATE PROCEDURE approve_contribution(
_contribution_id INT
)
BEGIN

	START TRANSACTION;

	SELECT user_id, contribution_name, isbn_num, book_rating,book_price, description, book_photourl, publisher FROM pending_contributions 
    WHERE id = _contribution_id INTO @user_id, @contribution_name, @isbn_num, @book_rating, @book_price, @description, @book_photourl, @publisher;
	INSERT INTO contributions VALUES (DEFAULT, @user_id, @contribution_name, @isbn_num, @book_rating, @book_price, @description, now(), @book_photourl, @publisher);
	DELETE FROM pending_contributions WHERE id = _contribution_id;

	COMMIT;

END $$


CREATE PROCEDURE edit_bio(
_id int,
_photo_url VARCHAR(250),
_display_name VARCHAR(250),
_info TEXT
)
BEGIN
	
    START TRANSACTION;
    
    UPDATE biography SET user_photourl=_photo_url, user_description=_info, user_displayname=_display_name WHERE user_id=_id;

    COMMIT;

END $$

DELIMITER ;
INSERT INTO users VALUES (DEFAULT, 'testuser', 'testpass', 'test@test.com', 'testpass', 6, 'Student', 'Informatics', 2015, 'Information and Computer Science');
INSERT INTO users VALUES (DEFAULT,'Suzanne', 'Collins', 'suzanne@uci.edu', 'collins', 3, 'Faculty', 'Chemistry', 1990, 'Biological Sciences');
INSERT INTO users VALUES (DEFAULT, 'J.K.', 'Rowling', 'jk@uci.edu', 'rowling', 5, 'Alumni', 'Asian American Studies', 2002, 'Humanities');
INSERT INTO users VALUES (DEFAULT, 'Harper', 'Lee', 'harper@uci.edu', 'lee', 1, 'Staff', null, 2007, 'Nursing Science');
INSERT INTO users VALUES (DEFAULT, 'Stephenie', 'Meyer', 'stephenie@uci.edu', 'meyer', 2, 'Faculty', 'Statistics and Statistical Theory', 2015, 'Information and Computer Science');
INSERT INTO users VALUES (DEFAULT, 'Jane', 'Austen', 'jane@uci.edu', 'austen', 2, 'Student', 'Criminology, Law and Society', 2017, 'Law');
INSERT INTO users VALUES (DEFAULT, 'Margaret', 'Mitchell', 'margaret@uci.edu', 'mitchell', 7, 'Student', 'Music', 2018, 'Arts');
INSERT INTO users VALUES (DEFAULT, 'Jane', 'Lee', 'jane@uci.edu', 'lee', 3, 'Alumni', 'Business Administration', 1980, 'Business');


INSERT INTO biography VALUES(1, 'testuser testpass', 'My purpose is for testing!', 'https://www.policygenius.com/blog/wp-content/uploads/2014/02/user_testing.jpg');
INSERT INTO biography VALUES(2, 'Suzanne Collins', 'I am the author of the popular trilogy Hunger Games', 'http://images.usatoday.com/life/_photos/Raw_Images/dystopian_ST/d01_book19_author_4C.jpg');
INSERT INTO biography VALUES(3, 'J.K. Rowling', 'I am the creator of the Harry Potter fantasy series, one of the most popular book and film franchises in history.', 'http://blankfictionmag.com/wp-content/uploads/2014/07/J.K.-Rowling.jpg');
INSERT INTO biography VALUES(4, 'Harper Lee', 'I am best known for writing the Pulitzer Prize-winning best-seller To Kill a Mockingbird. My only published novel.', 'http://a4.files.biography.com/image/upload/c_fill,dpr_1.0,g_face,h_300,q_80,w_300/MTE4MDAzNDEwNTk2MjM0NzY2.jpg');
INSERT INTO biography VALUES(5, 'Stephenie Meyer', 'I am the famous author of the glittery vampires who were adored by young ladies. Twilight was one of the most talked about novels in 2005 and within weeks of its release the book debuted at #5 on The New York Times bestseller list. Twilight was also named an ALA Top Ten Books for Young Adults, an Best Book of the Decade...So Far by Amazon, and a Publishers Weekly Best Book of the Year.', 'http://upload.wikimedia.org/wikipedia/commons/6/63/Stephenie_Meyer_by_Gage_Skidmore.jpg');
INSERT INTO biography VALUES(6, 'Jane Austen', 'An English novelist whose works of romantic fiction, set among the landed gentry, earned her a place as one of the most widely read writers in English literature.', 'http://upload.wikimedia.org/wikipedia/commons/d/d4/Jane_Austen_coloured_version.jpg');
INSERT INTO biography VALUES(7, 'Margaret Mitchell', 'An American author and journalist. Known for writing the popular novel Gone with the Wind.', 'http://blogs.bookforum.com/wp-content/uploads/2013/12/Margaret-Mitchell.jpg');
INSERT INTO biography VALUES(8, 'Jane Lee', 'Author of Gypsy Jane my life story.', 'http://d.gr-assets.com/books/1344737208l/14925831.jpg');

INSERT INTO pending_users VALUES (DEFAULT, 'Jacob', 'Michaelson', 'jacob@uci.edu', 'michaelson', 'The name is Michaelson. Jacob Michaelson.', 'Staff', null, 1999, 'Education');
INSERT INTO pending_users VALUES (DEFAULT, 'Hector', 'Chen', 'hector@uci.edu', 'chen', 'Cha ching!', 'Student', 'Electrical Enginnering', 2016, 'Enginnering');
INSERT INTO pending_users VALUES (DEFAULT, 'Louie', 'James', 'louie@uci.edu', 'james', 'The name is Michaelson. Jacob Michaelson.', 'Alumni', 'Literary Journalism', 1992, 'Humanities');
INSERT INTO pending_users VALUES (DEFAULT, 'Ashley', 'Rodriguez', 'ashely@uci.edu', 'rodriguez', 'The name is Michaelson. Jacob Michaelson.', 'Student', null, 2017, 'Undeclared');

INSERT INTO contributions VALUES (DEFAULT,'1', 'Book1', '0001', 0, 5.99, 'test book1', now(), 'http://kosmosaicbooks.com/wp-content/uploads/2011/07/WOT-Book-1-cover_web.jpg', 'Ace Books');
INSERT INTO contributions VALUES (DEFAULT,'1', 'Book2', '0002', 0, 6.99, 'test book2', now(), 'http://img2.wikia.nocookie.net/__cb20130710023017/disney/images/7/75/The_Jungle_Book_2_cover.jpg', 'John Wiley & Sons');
INSERT INTO contributions VALUES (DEFAULT,'1', 'Book3', '0003', 0, 7.99, 'test book3', now(), 'http://upload.wikimedia.org/wikipedia/en/b/ba/Airbender-CompleteBook3.jpg', 'Verso Books');
INSERT INTO contributions VALUES (DEFAULT,'1', 'Book4', '0004', 0, 8.99, 'test book4', now(), 'http://mediaroom.scholastic.com/files/SAnimals_4.jpg', 'University of California Press');
INSERT INTO contributions VALUES (DEFAULT,'1', 'Book5', '0005', 0, 9.99, 'test book1', now(), 'http://covers.booktopia.com.au/big/9780099596370/middle-school-ultimate-showdown.jpg', 'Scholastic Press');
INSERT INTO contributions VALUES (DEFAULT,'1', 'Book6', '0006', 0, 19.99, 'test book1', now(), 'http://boltcity.com/wp-content/uploads/2014/02/Amulet-6-Cover.jpg', 'Remington & Co');
INSERT INTO contributions VALUES (DEFAULT, '2', 'The Hunger Games', '0007', 4, 19.99, 'Hunger Games starring Katniss and Peeta', now(), 'http://upload.wikimedia.org/wikipedia/en/a/ab/Hunger_games.jpg', 'Phaidon Press');
INSERT INTO contributions VALUES (DEFAULT, '2', 'Harry Potter and the Order of the Phoenix', '0008', 4, 19.99, 'A wizard', now(), 'http://harrypotterfanzone.com/wp-content/2009/06/ootp-us-jacket-art.jpg', 'Kensington Books');
INSERT INTO contributions VALUES (DEFAULT, '2', 'To Kill a Mockingbird', '0008', 5, 4.99, 'Literature', now(), 'https://ritikab.files.wordpress.com/2010/07/to-kill-a-mockingbird2.jpg', 'B & W Publishing');
INSERT INTO contributions VALUES (DEFAULT, '3', 'Twilight', '0009', 3, 19.99, 'Vampires', now(), 'http://upload.wikimedia.org/wikipedia/en/1/1d/Twilightbook.jpg', 'Blackwell Publishing');
INSERT INTO contributions VALUES (DEFAULT, '3', 'Pride and Prejudice', '0010', 3, 19.99, 'Great', now(), 'https://themodernmanuscript.files.wordpress.com/2013/01/pride-and-prejudice-1946.jpg', 'Brill Publishers');
INSERT INTO contributions VALUES (DEFAULT, '3', 'Gone with the Wind', '0011', 3, 19.01, 'Windy', now(), 'https://thepulitzerblog.files.wordpress.com/2014/03/gonewiththewind.jpg', 'Chick Publications');
INSERT INTO contributions VALUES (DEFAULT, '3', 'The Chronicles of Narnia', '0012', 2, 29.99, 'Adventures walking into a closet', now(), 'http://cache.coverbrowser.com/image/classic-childrens-books/11-1.jpg', 'Cisco Press');
INSERT INTO contributions VALUES (DEFAULT, '3', 'Animal Farm', '0013', 1, 19.99, 'A classic', now(), 'http://www.penguin.com.au/jpg-large/9780141036137.jpg', 'Remington & Co');
INSERT INTO contributions VALUES (DEFAULT, '4', 'The Giving Tree', '0014', 4, 8.99, 'Poems', now(), 'http://alisoncherrybooks.com/storage/GivingTree.jpg?__SQUARESPACE_CACHEVERSION=1323369477554', 'Remington & Co');
INSERT INTO contributions VALUES (DEFAULT, '5', 'The Hitchhiker\'s Guide to the Galaxy', '0015', 2, 49.99, 'The guide to the galaxy', now(), 'http://vignette4.wikia.nocookie.net/hitchhikers/images/1/11/The_Hitchhiker\'s_Guide_to_the_Galaxy.jpg/revision/latest?cb=20140520174710', 'Verso Books');
INSERT INTO contributions VALUES (DEFAULT, '5', 'Wuthering Heights', '0016', 0, 12.99, 'Another classic', now(), 'https://hauntedhearts.files.wordpress.com/2012/11/wuthering-heights.jpg', 'Ace Books');
INSERT INTO contributions VALUES (DEFAULT, '6', 'The Book Thief', '0017', 0, 17.99, 'Thief', now(), 'http://bibliofiend.com/wp-content/uploads/2013/09/bookthiefposter.jpg', 'Scholastic Press');
INSERT INTO contributions VALUES (DEFAULT, '6', 'Memoirs of a Geisha', '0018', 4, 5.99, 'Magnificent', now(), 'http://d.gr-assets.com/books/1388367666l/930.jpg', 'Ace Books');
INSERT INTO contributions VALUES (DEFAULT, '7', 'The Da Vinci Code', '0019', 5, 99.99, 'How to crack the code', now(), 'http://www.marshall.edu/library/bannedbooks/Images/davincicode.jpg', 'Scholastic Press');
INSERT INTO contributions VALUES (DEFAULT, '7', 'Alice\'s Adventures in Wonderland & Through the Looking-Glass', '0020', 0, 102.99, 'Time is ticking', now(), 'http://d.gr-assets.com/books/1327872220l/24213.jpg', 'University of California Press');
INSERT INTO contributions VALUES (DEFAULT, '7', '4-Book Boxed Set: The Hobbit and The Lord of the Rings', '0021', 0, 399.99, 'So many books for such a small price', now(), 'http://www.bangzo.com/ebayimages/jrrtolkin_boxed.jpg', 'University of California Press');
INSERT INTO contributions VALUES (DEFAULT, '7', 'Romeo and Juliet', '0022', 4, 2.99, 'Shakespeare Yea!', now(), 'http://d28hgpri8am2if.cloudfront.net/book_images/cvr9781451621709_9781451621709_hr.jpg', 'Blackwell Publishing');
INSERT INTO contributions VALUES (DEFAULT, '7', 'Les Misérables', '0023', 0, 23.99, 'Very very interesting with singing', now(), 'http://www.pagepulp.com/wp-content/38.jpg', 'Scholastic Press');
INSERT INTO contributions VALUES (DEFAULT, '7', 'The Fault in Our Stars', '0024', 2, 35.99, 'Good', now(), 'http://upload.wikimedia.org/wikipedia/en/a/a9/The_Fault_in_Our_Stars.jpg', 'Blackwell Publishing');
INSERT INTO contributions VALUES (DEFAULT, '7', 'Lord of the Flies', '0025', 0, 19.99, 'There are pigs', now(), 'http://ecx.images-amazon.com/images/I/51H9V4kDN%2BL.jpg', 'Scholastic Press');
INSERT INTO contributions VALUES (DEFAULT, '8', 'The Picture of Dorian Gray', '0026', 0, 9.99, 'Wild', now(), 'http://ecx.images-amazon.com/images/I/51QYC8ZZB6L.jpg', 'Brill Publishers');
INSERT INTO contributions VALUES (DEFAULT, '8', 'Ender\'s Game', '0027', 1, 29.99, 'A game', now(), 'http://ecx.images-amazon.com/images/I/610KU5avW4L.jpg', 'Hackett Publishing Company');
INSERT INTO contributions VALUES (DEFAULT, '8', 'Crime and Punishment', '0028', 0, 52.03, 'A very long book', now(), 'https://adambenjones.wikispaces.com/file/view/crime.jpg/32566375/268x436/crime.jpg', 'Cisco Press');

INSERT INTO pending_contributions VALUES(1, 1, 'The Alchemist', '0029', 0, 1.00, 'Powerful addicting beautifully written', 'http://static1.squarespace.com/static/527fdb09e4b0a82a76942ecf/52d586b1e4b0c4f1c24c1880/532a1be5e4b079860b034df5/1395268604438/The+Alchemist.jpg', 'University of California Press');
INSERT INTO pending_contributions VALUES(DEFAULT, 1, 'Charlotte\'s Web', '0030', 0, 50.00, 'Spiders and pigs and much much more', 'http://www.kidsmomo.com/wordpress/wp-content/uploads/charlottes-web-cover.gif', 'Hackett Publishing Company');
INSERT INTO pending_contributions VALUES(DEFAULT, 2, 'Anne of Green Gables', '0031', 0, 65.99, 'Greeny', 'http://thebooksmugglers.com/wp-content/uploads/2015/01/AnneGreenGables17.jpg', 'Chick Publications');
INSERT INTO pending_contributions VALUES(DEFAULT, 3, 'Fahrenheit 451', '0032', 0, 35.99, 'Interesting', 'http://bookriotcom.c.presscdn.com/wp-content/uploads/2012/09/Fahrenheit-451-2012-cover.jpeg', 'Blackwell Publishing');
INSERT INTO pending_contributions VALUES(DEFAULT, 7, 'Of Mice and Men', '0033', 0, 27.00, 'Novel literature', 'http://www.marshall.edu/library/bannedbooks/Images/miceandmen.gif', 'Verso Books');
INSERT INTO pending_contributions VALUES(DEFAULT, 7, 'Dracula', '0034', 0, 25.99, 'More vampires', 'http://www.theedgesusu.co.uk/wp-content/uploads/2014/10/dracula-book-cover-e1368750274302.jpg','Scholastic Press');
INSERT INTO pending_contributions VALUES(DEFAULT, 7, 'The Help ', '0035', 0, 29.23, 'Turned into a movie', 'http://www.penguin.com.au/jpg-large/9780241956533.jpg', 'Chick Publications');
INSERT INTO pending_contributions VALUES(DEFAULT, 8, 'Divergent', '0036', 0, 11.99, 'Science fiction', 'http://api.ning.com/files/BfJIQarv7Anu*u*5SDcrOgfEZPmDtGDnAJ1ARWxeixXALyrmmTyLmeG2M484bJ-Y9zpFehZrKxZnJifw6YvGbvR9vI4LKs-H/divergent_hq.jpg', 'Remington & Co');
INSERT INTO pending_contributions VALUES(DEFAULT, 8, 'A Wrinkle in Time', '0037', 0, 12.03, 'Must fix this wrinkle', 'http://www.saltmanz.com/pictures/albums/Cover%20Scans/Book%20Covers/Wrinkle%20in%20Time.jpg', 'John Wiley & Sons');
INSERT INTO pending_contributions VALUES(DEFAULT, 8, 'The Princess Bride', '0038', 0, 14.99, 'Wedding dress', 'http://ecx.images-amazon.com/images/I/91K4xKACvOL._SL1500_.jpg', 'John Wiley & Sons');
INSERT INTO pending_contributions VALUES(DEFAULT, 8, 'Brave New World', '0039', 0, 3.99, 'Yay!', 'https://murderbymedia.files.wordpress.com/2014/09/cover-new_905.jpg', 'Dick and Fitzgerald');

INSERT INTO pending_reviews VALUES(DEFAULT, 20, 2, 4, 'I cracked the code. The movie did not do justice to this book.');
INSERT INTO pending_reviews VALUES(DEFAULT, 28, 4, 5,'Ender\'s Game is a great sci-fi boook. It not only manages to have a strong message, but it is also a joy to read. The plot is enthralling, the characters are complex and realistic, and the descriptions of the battleroom are so realistic I get lost in it.');
INSERT INTO pending_reviews VALUES(DEFAULT, 23, 1, 4,'Promising young writer.');
INSERT INTO pending_reviews VALUES(DEFAULT, 23, 5, 4,'As Expected from this author. William is awesome.');
INSERT INTO pending_reviews VALUES(DEFAULT, 10, 3, 1,'This book is great for people who don\'t know what good writing looks like. Teens will love it.');
INSERT INTO pending_reviews VALUES(DEFAULT, 24, 2, 3,'A famous novel and it is an extremely famous play. It is a great read to pass the time!');

INSERT INTO reviews VALUES(DEFAULT, 1, 2, 1,'WHO titled this book?! Filled with nothing nothing nothing.', now());
INSERT INTO reviews VALUES(DEFAULT, 3, 8, 3,'A really really good coloring book!', now());
INSERT INTO reviews VALUES(DEFAULT, 4, 7, 1,'Pages and pages of blank space. I rather listen to Taylor Swift\s blank space than stare at blank space.', now());
INSERT INTO reviews VALUES(DEFAULT, 6, 8, 2,'Five books later and the title is still bland. I bought this book opened it up and it was blank...', now());
INSERT INTO reviews VALUES(DEFAULT, 7, 1, 4,'I couldn\'t stop reading. The Hunger Games is amazing.', now());
INSERT INTO reviews VALUES(DEFAULT, 7, 4, 5,'The Hunger Games (Trilogy) is one of the most "unputdownable" books to enter the teen market in a long time. The cliffhangers at the end of each volume are so intense, you can\'t help but continue on. Knowing this in advance, I decided against reading the series last summer despite the fact that everyone was talking about it. I waited the extra year, and I\'m glad I did--even a week was torture when it came to getting my grubby mitts on a copy of Mockingjay.', now());
INSERT INTO reviews VALUES(DEFAULT, 8, 3, 4,'ORDER OF THE PHOENIX could well be my favorite book of them all, if Azkaban and Deathly Hallows weren\'t as good as they were. For all the talk about GOBLET being the one where Rowling really hikes up the intensity and the complexity in the series, it is here, in PHOENIX, she gives us Potter\'s darkest, and most complex, adventure of all. 

The second most complex novel in the entire Potter sequence (the first being Book 7), this book is probably the second best one, though I still like Azkaban better. This novel introduces the Order of the Phoenix, a whole litany of new characters and a more indepth look at the Ministry For Magic.', now());
INSERT INTO reviews VALUES(DEFAULT, 8, 7, 5,'I can only imagine the kind of pressure J.K. Rowling faces when she sits down to write a Harry Potter book. EACH BOOK IS AMAZING!!', now());
INSERT INTO reviews VALUES(DEFAULT, 8, 8, 3,'In comparison to the previous four books, this book is disappointing.', now());
INSERT INTO reviews VALUES(DEFAULT, 9, 1, 5,'To Kill a Mockingbird is a piece of our American history that depicts racism and prejudice, childhood innocence, and the perseverence of a man who risked it all to stand up for what he believed in. Wonderful portrayal and one I will read again.', now());
INSERT INTO reviews VALUES(DEFAULT, 9, 4, 4,'I read it in high school this book is a CLASSIC!', now());
INSERT INTO reviews VALUES(DEFAULT, 10, 6, 2,'The book itself is a rather easy read, however, the characters seem somewhat shallow. Bella is supposed to be an honour student, but behaves exactly the opposite. Edward, who has been in existence for more than a hundred years, should be more intelligent and far wiser than is portrayed in his character.', now());
INSERT INTO reviews VALUES(DEFAULT, 11, 4, 5,'Jane Austen is one of the great masters of the English language.  PRIDE AND PREJUDICE is her greatest masterpiece.  It describes a world in the early 19th Century English society where men held all the power and women were required to negotiate mine-fields of social status, respectability, wealth, love, and sex in order to marry both to their own liking and to the advantage of their family.', now());
INSERT INTO reviews VALUES(DEFAULT, 11, 1, 1,'Had to read this in highschool hated it.', now());
INSERT INTO reviews VALUES(DEFAULT, 11, 7, 5,'Most amusing and entertaining love story I have ever read.', now());
INSERT INTO reviews VALUES(DEFAULT, 11, 8, 4,'Jane Austen\'s novels have a recurring theme of love and marriage and forever invoke the absurdly beautiful art of humour and irony to fabricate a mesh of interwoven ideas tied by that central idea.', now());
INSERT INTO reviews VALUES(DEFAULT, 12, 8, 5,'I would give this 100 stars if I could. The chemistry was flying off the pages.', now());
INSERT INTO reviews VALUES(DEFAULT, 12, 4, 5,'The author\'s use of prose was beautiful. It made all the scenes come alive for me. My imagination was running wild. I couldn\t put the book down!', now());
INSERT INTO reviews VALUES(DEFAULT, 12, 6, 4,'The most readable long novel ever written!', now());
INSERT INTO reviews VALUES(DEFAULT, 14, 2, 5,'A complete and enjoyable read that had me hooked from the very first sentence.', now());
INSERT INTO reviews VALUES(DEFAULT, 14, 1, 4,'George Orwell is a fatastic author. I loved all his works since reading 1984.', now());
INSERT INTO reviews VALUES(DEFAULT, 15, 5, 5,'I fell in love with this book the first time it was read to me, and my feelings have never changed. As I child I knew it was a sad book, but I didn\'t know why. Now that I am an adult, I can understand the cost of unconditional love and I know why the tree was sad. One o the best books I have ever read.', now());
INSERT INTO reviews VALUES(DEFAULT, 17, 4, 4,'The book is absolutely breathtaking but is not suited for everyone. But it is without a fact timeless literature.', now());
INSERT INTO reviews VALUES(DEFAULT, 19, 5, 5,'One of the most beautifully written novels of the past 20 or more years, and definitely one of my personal favorites. The author paints a remarkably truthful account of one woman\'s training and practice as a geisha.', now());
INSERT INTO reviews VALUES(DEFAULT, 19, 3, 4,'I loved this book! From the minute I picked it up I couldn\'t put it down. It tells the story of a young girl sold into geisha training in Japan. I had no idea how much of an art form geisha was in this pre-WWII setting Gion and it was very interesting to learn so much more about it through the eyes of a young girl caught up in it. Sayuri is a wonderfully drawn character with a wide range of emotions as she endures cruelty, jealousy, misery and a whole new way of life and comes to accept it, excel in it and even embrace it. Particularly intriguing are the questions and conflicts raised by the novel about destiny, love, survival and tradition.', now());
INSERT INTO reviews VALUES(DEFAULT, 19, 1, 1,'This story is a fairy tale it does not portray the real Japanese people and culture.', now());
INSERT INTO reviews VALUES(DEFAULT, 23, 5, 5,'We just started reading Romeo and Juliet and I had the same problem so I bought this book. Boy, did it help me! I got an A in my class!', now());
INSERT INTO reviews VALUES(DEFAULT, 23, 8, 4,'I have loved him since high school in the 40s. I always go back to read and reread his writings and i never get bored with any of his work.', now());
INSERT INTO reviews VALUES(DEFAULT, 24, 3, 3,'The story has an epic feel to it, but the plot was often interrupted by what I called "political rants" that ran on for about 20-30 pages.', now());
INSERT INTO reviews VALUES(DEFAULT, 24, 2, 3,'Better than watching the movie with all that singing.', now());
INSERT INTO reviews VALUES(DEFAULT, 25, 2, 4,'Very well written it covers a topic that is hard to talk about.', now());
INSERT INTO reviews VALUES(DEFAULT, 25, 3, 2,'The book is terrible too many cliches. I only read it after watching the movie.', now());
INSERT INTO reviews VALUES(DEFAULT, 29, 7, 4,'My first time reading a book from this author. It is a smoothly flowing and fascinating story of a young man who succumbs to the most base desire, and the impact this has both psychologically and otherwise on himself and those around him.', now());
INSERT INTO reviews VALUES(DEFAULT, 29, 5, 2,'boring boring boring...', now());
INSERT INTO reviews VALUES(DEFAULT, 29, 6, 3,'THIS BOOK NEEDS TO BE TRANSLATED PROPERLY!! IT\'S SO HARD TO READ!!!', now());

INSERT INTO administrators VALUES(1, 'Steve', 'Carter', 'steve@uci.edu', 'carter', 29, 8);
