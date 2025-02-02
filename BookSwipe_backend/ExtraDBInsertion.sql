-- Insert New Authors
INSERT INTO authors (au_fname, au_lname) VALUES
('Stephen', 'King'),
('Agatha', 'Christie'),
('Gabriel', 'García Márquez'),
('Margaret', 'Atwood'),
('Neil', 'Gaiman'),
('Virginia', 'Woolf'),
('Haruki', 'Murakami'),
('Ernest', 'Hemingway'),
('Toni', 'Morrison'),
('Philip', 'K. Dick'),
('Terry', 'Pratchett'),
('Frank', 'Herbert'),
('Douglas', 'Adams'),
('Ray', 'Bradbury'),
('Arthur', 'C. Clarke'),
('Isaac', 'Asimov'),
('Ursula K.', 'Le Guin'),
('George R.R.', 'Martin'),
('Dan', 'Brown'),
('John', 'Steinbeck'),
('Paulo', 'Coelho'),
('Fyodor', 'Dostoevsky'),
('Leo', 'Tolstoy'),
('Charles', 'Dickens'),
('Emily', 'Brontë'),
('Charlotte', 'Brontë'),
('Oscar', 'Wilde'),
('Jules', 'Verne'),
('H.G.', 'Wells'),
('Aldous', 'Huxley');

-- Insert New Titles
INSERT INTO titles (name, pages, price, pubdate, is_available, ISBN, cover_image_url, average_rating, publisher) VALUES
('The Shining', 447, 18.99, '1977-01-28', TRUE, '9780385121675', 'https://example.com/images/shining.jpg', 4.2, 'Doubleday'),
('Murder on the Orient Express', 256, 14.99, '1934-01-01', TRUE, '9780007119318', 'https://example.com/images/orient.jpg', 4.5, 'Collins Crime Club'),
('One Hundred Years of Solitude', 417, 16.99, '1967-05-30', TRUE, '9780060883287', 'https://example.com/images/solitude.jpg', 4.7, 'Harper'),
('The Handmaid''s Tale', 311, 15.99, '1985-06-14', TRUE, '9780385490818', 'https://example.com/images/handmaid.jpg', 4.4, 'McClelland & Stewart'),
('American Gods', 465, 19.99, '2001-06-19', TRUE, '9780380973651', 'https://example.com/images/gods.jpg', 4.3, 'William Morrow'),
('Mrs. Dalloway', 176, 12.99, '1925-05-14', TRUE, '9780156628709', 'https://example.com/images/dalloway.jpg', 4.0, 'Hogarth Press'),
('Norwegian Wood', 296, 15.99, '1987-08-04', TRUE, '9780375704024', 'https://example.com/images/norwegian.jpg', 4.1, 'Kodansha'),
('The Old Man and the Sea', 127, 13.99, '1952-09-01', TRUE, '9780684801223', 'https://example.com/images/oldman.jpg', 4.4, 'Charles Scribner''s Sons'),
('Beloved', 324, 16.99, '1987-09-02', TRUE, '9781400033416', 'https://example.com/images/beloved.jpg', 4.3, 'Alfred A. Knopf'),
('Do Androids Dream of Electric Sheep?', 210, 14.99, '1968-01-01', TRUE, '9780345404473', 'https://example.com/images/androids.jpg', 4.1, 'Doubleday'),
('Good Omens', 288, 15.99, '1990-05-01', TRUE, '9780552137030', 'https://example.com/images/omens.jpg', 4.5, 'Gollancz'),
('Dune', 412, 17.99, '1965-08-01', TRUE, '9780441172719', 'https://example.com/images/dune.jpg', 4.6, 'Chilton Books'),
('The Hitchhiker''s Guide to the Galaxy', 193, 14.99, '1979-10-12', TRUE, '9780345391803', 'https://example.com/images/hitchhiker.jpg', 4.7, 'Pan Books'),
('Fahrenheit 451', 249, 15.99, '1953-10-19', TRUE, '9781451673319', 'https://example.com/images/fahrenheit.jpg', 4.4, 'Ballantine Books'),
('2001: A Space Odyssey', 221, 14.99, '1968-04-01', TRUE, '9780451457998', 'https://example.com/images/2001.jpg', 4.3, 'New American Library'),
('Foundation', 255, 15.99, '1951-05-01', TRUE, '9780553293357', 'https://example.com/images/foundation.jpg', 4.4, 'Gnome Press'),
('The Left Hand of Darkness', 304, 16.99, '1969-03-01', TRUE, '9780441478125', 'https://example.com/images/darkness.jpg', 4.2, 'Ace Books'),
('A Game of Thrones', 694, 19.99, '1996-08-01', TRUE, '9780553103540', 'https://example.com/images/got.jpg', 4.7, 'Bantam Spectra'),
('The Da Vinci Code', 454, 16.99, '2003-03-18', TRUE, '9780385504201', 'https://example.com/images/davinci.jpg', 4.1, 'Doubleday'),
('The Grapes of Wrath', 464, 17.99, '1939-04-14', TRUE, '9780143039433', 'https://example.com/images/grapes.jpg', 4.5, 'The Viking Press'),
('The Alchemist', 197, 14.99, '1988-01-01', TRUE, '9780062315007', 'https://example.com/images/alchemist.jpg', 4.3, 'HarperOne'),
('Crime and Punishment', 671, 18.99, '1866-01-01', TRUE, '9780143058142', 'https://example.com/images/crime.jpg', 4.6, 'The Russian Messenger'),
('War and Peace', 1225, 24.99, '1869-01-01', TRUE, '9781400079988', 'https://example.com/images/war.jpg', 4.7, 'The Russian Messenger'),
('Great Expectations', 505, 16.99, '1861-08-01', TRUE, '9780141439563', 'https://example.com/images/expectations.jpg', 4.3, 'Chapman & Hall'),
('Wuthering Heights', 342, 15.99, '1847-12-01', TRUE, '9780141439556', 'https://example.com/images/wuthering.jpg', 4.2, 'Thomas Cautley Newby'),
('Jane Eyre', 532, 16.99, '1847-10-16', TRUE, '9780141441146', 'https://example.com/images/jane.jpg', 4.4, 'Smith, Elder & Co.'),
('The Picture of Dorian Gray', 254, 14.99, '1890-07-01', TRUE, '9780141439570', 'https://example.com/images/dorian.jpg', 4.3, 'Ward, Lock & Co.'),
('Twenty Thousand Leagues Under the Sea', 392, 16.99, '1870-06-20', TRUE, '9780140367966', 'https://example.com/images/leagues.jpg', 4.2, 'Pierre-Jules Hetzel'),
('The Time Machine', 118, 13.99, '1895-05-07', TRUE, '9780141439976', 'https://example.com/images/time.jpg', 4.1, 'William Heinemann'),
('Brave New World', 311, 15.99, '1932-01-01', TRUE, '9780060850524', 'https://example.com/images/brave.jpg', 4.4, 'Chatto & Windus');

-- Link Titles and Authors
INSERT INTO titles_authors (title_id, author_id) VALUES
(5, 5), -- The Shining by Stephen King
(6, 6), -- Murder on the Orient Express by Agatha Christie
(7, 7), -- One Hundred Years of Solitude by Gabriel García Márquez
(8, 8), -- The Handmaid's Tale by Margaret Atwood
(9, 9), -- American Gods by Neil Gaiman
(10, 10), -- Mrs. Dalloway by Virginia Woolf
(11, 11), -- Norwegian Wood by Haruki Murakami
(12, 12), -- The Old Man and the Sea by Ernest Hemingway
(13, 13), -- Beloved by Toni Morrison
(14, 14), -- Do Androids Dream of Electric Sheep? by Philip K. Dick
(15, 15), -- Good Omens by Terry Pratchett
(16, 16), -- Dune by Frank Herbert
(17, 17), -- The Hitchhiker's Guide to the Galaxy by Douglas Adams
(18, 18), -- Fahrenheit 451 by Ray Bradbury
(19, 19), -- 2001: A Space Odyssey by Arthur C. Clarke
(20, 20), -- Foundation by Isaac Asimov
(21, 21), -- The Left Hand of Darkness by Ursula K. Le Guin
(22, 22), -- A Game of Thrones by George R.R. Martin
(23, 23), -- The Da Vinci Code by Dan Brown
(24, 24), -- The Grapes of Wrath by John Steinbeck
(25, 25), -- The Alchemist by Paulo Coelho
(26, 26), -- Crime and Punishment by Fyodor Dostoevsky
(27, 27), -- War and Peace by Leo Tolstoy
(28, 28), -- Great Expectations by Charles Dickens
(29, 29), -- Wuthering Heights by Emily Brontë
(30, 30), -- Jane Eyre by Charlotte Brontë
(31, 31), -- The Picture of Dorian Gray by Oscar Wilde
(32, 32), -- Twenty Thousand Leagues Under the Sea by Jules Verne
(33, 33), -- The Time Machine by H.G. Wells
(34, 34); -- Brave New World by Aldous Huxley

-- Link Titles and Genres
INSERT INTO titles_genres (title_id, genre_id) VALUES
(5, 17), -- The Shining - Horror
(6, 22), -- Murder on the Orient Express - Mystery
(7, 13), -- One Hundred Years of Solitude - Fiction
(8, 31), -- The Handmaid's Tale - Science Fiction
(9, 12), -- American Gods - Fantasy
(10, 13), -- Mrs. Dalloway - Fiction
(11, 13), -- Norwegian Wood - Fiction
(12, 13), -- The Old Man and the Sea - Fiction
(13, 13), -- Beloved - Fiction
(14, 31), -- Do Androids Dream of Electric Sheep? - Science Fiction
(15, 12), -- Good Omens - Fantasy
(16, 31), -- Dune - Science Fiction
(17, 31), -- The Hitchhiker's Guide to the Galaxy - Science Fiction
(18, 31), -- Fahrenheit 451 - Science Fiction
(19, 31), -- 2001: A Space Odyssey - Science Fiction
(20, 31), -- Foundation - Science Fiction
(21, 31), -- The Left Hand of Darkness - Science Fiction
(22, 12), -- A Game of Thrones - Fantasy
(23, 36), -- The Da Vinci Code - Thriller
(24, 13), -- The Grapes of Wrath - Fiction
(25, 13), -- The Alchemist - Fiction
(26, 13), -- Crime and Punishment - Fiction
(27, 15), -- War and Peace - Historical
(28, 6), -- Great Expectations - Classics
(29, 6), -- Wuthering Heights - Classics
(30, 6), -- Jane Eyre - Classics
(31, 6), -- The Picture of Dorian Gray - Classics
(32, 31), -- Twenty Thousand Leagues Under the Sea - Science Fiction
(33, 31), -- The Time Machine - Science Fiction
(34, 31); -- Brave New World - Science Fiction

-- Link Titles and Languages (all in English for simplicity)
INSERT INTO titles_languages (title_id, language_id) VALUES
(5, 16), (6, 16), (7, 16), (8, 16), (9, 16), (10, 16), (11, 16), (12, 16), (13, 16), (14, 16),
(15, 16), (16, 16), (17, 16), (18, 16), (19, 16), (20, 16), (21, 16), (22, 16), (23, 16), (24, 16),
(25, 16), (26, 16), (27, 16), (28, 16), (29, 16), (30, 16), (31, 16), (32, 16), (33, 16), (34, 16);

-- Link Titles and Formats (adding both hardcover and paperback for each)
INSERT INTO titles_formats (title_id, format_id) VALUES
(5, 1), (5, 4), (6, 1), (6, 4), (7, 1), (7, 4), (8, 1), (8, 4), (9, 1), (9, 4),
(10, 1), (10, 4), (11, 1), (11, 4), (12, 1), (12, 4), (13, 1), (13, 4), (14, 1), (14, 4),
(15, 1), (15, 4), (16, 1), (16, 4), (17, 1), (17, 4), (18, 1), (18, 4), (19, 1), (19, 4),
(20, 1), (20, 4), (21, 1), (21, 4), (22, 1), (22, 4), (23, 1), (23, 4), (24, 1), (24, 4),
(25, 1), (25, 4), (26, 1), (26, 4), (27, 1), (27, 4), (28, 1), (28, 4), (29, 1), (29, 4),
(30, 1), (30, 4), (31, 1), (31, 4), (32, 1), (32, 4), (33, 1), (33, 4), (34, 1), (34, 4);
