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
INSERT INTO titles (name, pages, price, pubdate, is_available, ISBN, cover_image_url, average_rating, publisher, description) VALUES
('The Shining', 447, 18.99, '1977-01-28', TRUE, '9780385121675', '91U7HNa2NQL.jpg', 4.2, 'Doubleday', 'A psychological horror novel that follows Jack Torrance, an aspiring writer and recovering alcoholic, who accepts a winter caretaking job at the isolated Overlook Hotel, only to slowly descend into madness as supernatural forces take control.'),
('Murder on the Orient Express', 256, 14.99, '1934-01-01', TRUE, '9780007119318', '71ihbKf67RL.jpg', 4.5, 'Collins Crime Club', 'Detective Hercule Poirot solves a murder mystery aboard the luxurious train, the Orient Express, where every passenger is a suspect. A brilliant, intricately plotted whodunit by Agatha Christie.'),
('One Hundred Years of Solitude', 417, 16.99, '1967-05-30', TRUE, '9780060883287', '81dy4cfPGuL.jpg', 4.7, 'Harper', 'Gabriel García Márquez’s masterpiece, blending magical realism with history, chronicles the rise and fall of the Buendía family in the fictional town of Macondo over the course of a century.'),
('The Handmaid''s Tale', 311, 15.99, '1985-06-14', TRUE, '9780385490818', '61su39k8NUL.jpg', 4.4, 'McClelland & Stewart', 'In a dystopian future where a totalitarian regime controls fertility, Offred, a handmaid, navigates her oppressive life as she is forced to bear children for the elite. A powerful exploration of gender, power, and freedom.'),
('American Gods', 465, 19.99, '2001-06-19', TRUE, '9780380973651', '81r7fuk0rKL.jpg', 4.3, 'William Morrow', 'A gripping blend of mythology and Americana, Neil Gaiman’s novel follows Shadow Moon, a man caught in a war between ancient gods and modern-day deities. Themes of faith, identity, and the changing landscape of America.'),
('Mrs. Dalloway', 176, 12.99, '1925-05-14', TRUE, '9780156628709', '91OZZN8uEOL.jpg', 4.0, 'Hogarth Press', 'Virginia Woolf’s stream-of-consciousness novel explores a day in the life of Clarissa Dalloway as she prepares for a party, weaving together themes of mental illness, post-war England, and human connection.'),
('Norwegian Wood', 296, 15.99, '1987-08-04', TRUE, '9780375704024', 'NorwegianWood.jpg', 4.1, 'Kodansha', 'A poignant coming-of-age novel by Haruki Murakami, focusing on Toru Watanabe as he navigates love, loss, and identity during his student years in Tokyo. A story of emotional depth and transformation.'),
('The Old Man and the Sea', 127, 13.99, '1952-09-01', TRUE, '9780684801223', 'TheOldManAndTheSea.jpg', 4.4, 'Charles Scribner''s Sons', 'Hemingway’s short, powerful novel follows Santiago, an old Cuban fisherman, in his epic struggle to catch a giant marlin. A timeless story of human endurance, struggle, and triumph over adversity.'),
('Beloved', 324, 16.99, '1987-09-02', TRUE, '9781400033416', 'Beloved', 4.3, 'Alfred A. Knopf', 'Toni Morrison’s Pulitzer Prize-winning novel tells the story of Sethe, an escaped slave haunted by the ghost of her dead child, as she confronts the trauma of her past. A profound meditation on memory, slavery, and motherhood.'),
('Do Androids Dream of Electric Sheep?', 210, 14.99, '1968-01-01', TRUE, '9780345404473', 'DoAndroidsDreamOfElectricSheep.jpg', 4.1, 'Doubleday', 'Philip K. Dick’s science fiction classic explores the blurred lines between humans and androids in a dystopian future where a bounty hunter is tasked with "retiring" rogue robots. A chilling examination of humanity.'),
('Good Omens', 288, 15.99, '1990-05-01', TRUE, '9780552137030', 'GoodOmens.jpg', 4.5, 'Gollancz', 'A comedic novel by Neil Gaiman and Terry Pratchett, centering on an angel and demon who team up to prevent the apocalypse. Witty, absurd, and full of satire, it’s a fun twist on the end of the world.'),
('Dune', 412, 17.99, '1965-08-01', TRUE, '9780441172719', 'Dune.jpg', 4.6, 'Chilton Books', 'Frank Herbert’s epic sci-fi novel set on the desert planet of Arrakis, where politics, religion, and ecology intersect around the valuable spice melange. A story of survival, power, and prophecy in a vast universe.'),
('The Hitchhiker''s Guide to the Galaxy', 193, 14.99, '1979-10-12', TRUE, '9780345391803', 'The HitchhikersGuideToTheGalaxy.jpg', 4.7, 'Pan Books', 'A wildly humorous science fiction adventure by Douglas Adams, following Arthur Dent as he is swept off Earth just before it’s destroyed and travels through space with a motley crew of characters.'),
('Fahrenheit 451', 249, 15.99, '1953-10-19', TRUE, '9781451673319', 'Fahrenheit451.jpg', 4.4, 'Ballantine Books', 'Ray Bradbury’s dystopian novel takes place in a future society where books are banned and “firemen” burn them. Guy Montag, a fireman, begins to question his role in this oppressive world and the value of knowledge.'),
('2001: A Space Odyssey', 221, 14.99, '1968-04-01', TRUE, '9780451457998', '2001.jpg', 4.3, 'New American Library', 'Arthur C. Clarke’s groundbreaking novel explores humanity’s first contact with extraterrestrial life, as a mysterious monolith is discovered on the Moon. A philosophical journey into the future of space exploration.'),
('Foundation', 255, 15.99, '1951-05-01', TRUE, '9780553293357', 'Foundation.jpg', 4.4, 'Gnome Press', 'Isaac Asimov’s foundational sci-fi series explores the efforts of mathematician Hari Seldon to preserve knowledge and guide humanity through a dark age using the science of psychohistory.'),
('The Left Hand of Darkness', 304, 16.99, '1969-03-01', TRUE, '9780441478125', 'LeftHandOfDarkness.jpg', 4.2, 'Ace Books', 'Ursula K. Le Guin’s novel follows a human envoy to a distant planet where inhabitants can change sex. The story explores themes of gender, politics, and societal structures in an alien world.'),
('A Game of Thrones', 694, 19.99, '1996-08-01', TRUE, '9780553103540', 'GOT.jpg', 4.7, 'Bantam Spectra', 'George R.R. Martin’s epic fantasy series begins with political intrigue, betrayal, and war as noble families vie for control of the Seven Kingdoms of Westeros. A complex, gritty tale of power, loyalty, and survival.'),
('The Da Vinci Code', 454, 16.99, '2003-03-18', TRUE, '9780385504201', 'DaVinci.jpg', 4.1, 'Doubleday', 'A fast-paced thriller by Dan Brown, following symbologist Robert Langdon as he uncovers hidden secrets in famous works of art. A race against time to solve a centuries-old mystery that could shake the foundations of Christianity.'),
('The Grapes of Wrath', 464, 17.99, '1939-04-14', TRUE, '9780143039433', 'GrapesOfWrath.jpg', 4.5, 'The Viking Press', 'John Steinbeck’s Pulitzer Prize-winning novel tells the story of the Joad family’s struggle for survival during the Great Depression as they travel west in search of work and a better life.'),
('The Alchemist', 197, 14.99, '1988-01-01', TRUE, '9780062315007', 'Alchemist.jpg', 4.3, 'HarperOne', 'Paulo Coelho’s philosophical novel follows Santiago, a young shepherd, on a journey to discover his personal legend. A story of following one’s dreams and listening to the wisdom of the heart.'),
('Crime and Punishment', 671, 18.99, '1866-01-01', TRUE, '9780143058142', 'CrimeAndPunishment.jpg', 4.6, 'The Russian Messenger', 'Fyodor Dostoevsky’s classic novel explores the moral and psychological dilemmas of Rodion Raskolnikov, a young man who commits a murder and struggles with the consequences of his crime.'),
('War and Peace', 1225, 24.99, '1869-01-01', TRUE, '9781400079988', 'WarAndPeace.jpg', 4.7, 'The Russian Messenger', 'Leo Tolstoy’s epic historical novel covers the Napoleonic Wars and the lives of several aristocratic families in Russia, blending personal stories with grand historical events.'),
('Great Expectations', 505, 16.99, '1861-08-01', TRUE, '9780141439563', 'GreatExpectations.jpg', 4.3, 'Chapman & Hall', 'Charles Dickens’ coming-of-age novel follows Pip, an orphan who dreams of rising above his station in life. His journey is filled with twists, heartbreak, and self-discovery.'),
('Wuthering Heights', 342, 15.99, '1847-12-01', TRUE, '9780141439556', 'WutheringHeights.jpg', 4.2, 'Thomas Cautley Newby', 'Emily Brontë’s dark and passionate novel explores the destructive love between Heathcliff and Catherine Earnshaw at the isolated Wuthering Heights, set against the windswept Yorkshire moors.'),
('Jane Eyre', 532, 16.99, '1847-10-16', TRUE, '9780141441146', 'JaneEyre.jpg', 4.4, 'Smith, Elder & Co.', 'Charlotte Brontë’s gothic novel follows the life of Jane Eyre, an orphan who becomes a governess at Thornfield Hall, where she discovers dark secrets about her employer, Mr. Rochester.'),
('The Picture of Dorian Gray', 254, 14.99, '1890-07-01', TRUE, '9780141439570', 'DorianGray.jpg', 4.3, 'Ward, Lock & Co.', 'Oscar Wilde’s only novel tells the story of Dorian Gray, a young man whose portrait ages while he remains forever youthful, allowing him to indulge in a hedonistic life of excess without facing consequences.'),
('Twenty Thousand Leagues Under the Sea', 392, 16.99, '1870-06-20', TRUE, '9780140367966', '20000LeaguesUnderTheSea.jpg', 4.2, 'Pierre-Jules Hetzel', 'Jules Verne’s adventure novel follows Professor Aronnax and his companions as they are captured by Captain Nemo aboard the submarine Nautilus. A thrilling exploration of the ocean’s depths and the mysteries of the sea.'),
('The Time Machine', 118, 13.99, '1895-05-07', TRUE, '9780141439976', 'TimeMachine.jpg', 4.1, 'William Heinemann', 'H.G. Wells’ pioneering science fiction novel tells the story of a Victorian scientist who invents a time machine and travels to the distant future, witnessing the fate of humanity and civilization.'),
('Brave New World', 311, 15.99, '1932-01-01', TRUE, '9780060850524', 'BraveNewWorld.jpg', 4.4, 'Chatto & Windus', 'Aldous Huxley’s dystopian novel portrays a world where technology and genetic engineering control every aspect of life, from birth to death. It explores themes of individuality, freedom, and the cost of happiness.');

INSERT INTO genres (name) VALUES
('Art'),
('Biography'),
('Business'),
('Children'),
('Christian'),
('Classics'),
('Comics'),
('Contemporary'),
('Cookbooks'),
('Crime'),
('Ebooks'),
('Fantasy'),
('Fiction'),
('Graphic_Novels'),
('Historical'),
('History'),
('Horror'),
('Comedy'),
('Manga'),
('Memoir'),
('Music'),
('Mystery'),
('Nonfiction'),
('Paranormal'),
('Philosophy'),
('Poetry'),
('Psychology'),
('Religion'),
('Romance'),
('Science'),
('Science_Fiction'),
('Self_Help'),
('Suspense'),
('Spirituality'),
('Sports'),
('Thriller'),
('Travel'),
('Young_Adult');

INSERT INTO languages (name) VALUES
('Afrikaans'), 
('Arabic'), 
('Bengali'), 
('Bulgarian'), 
('Catalan'), 
('Cantonese'), 
('Croatian'), 
('Czech'), 
('Danish'), 
('Dutch'), 
('Lithuanian'), 
('Malay'), 
('Malayalam'), 
('Panjabi'), 
('Tamil'), 
('English'), 
('Finnish'), 
('French'), 
('German'), 
('Greek'), 
('Hebrew'), 
('Hindi'), 
('Hungarian'), 
('Indonesian'), 
('Italian'), 
('Japanese'), 
('Javanese'), 
('Korean'), 
('Norwegian'), 
('Polish'), 
('Portuguese'), 
('Romanian'), 
('Russian'), 
('Serbian'), 
('Slovak'), 
('Slovene'), 
('Spanish'), 
('Swedish'), 
('Telugu'), 
('Thai'), 
('Turkish'), 
('Ukrainian'), 
('Vietnamese'), 
('Welsh'), 
('Sign'), 
('Algerian'), 
('Aramaic'), 
('Armenian'), 
('Berber'), 
('Burmese'), 
('Bosnian'), 
('Brazilian'), 
('Cypriot'), 
('Corsica'), 
('Creole'), 
('Scottish'), 
('Egyptian'), 
('Esperanto'), 
('Estonian'), 
('Finn'), 
('Flemish'), 
('Georgian'), 
('Hawaiian'), 
('Inuit'), 
('Irish'), 
('Icelandic'), 
('Latin'), 
('Mandarin'), 
('Nepalese'), 
('Sanskrit'), 
('Tagalog'), 
('Tahitian'), 
('Tibetan'), 
('Gypsy'), 
('Wu');

INSERT INTO formats (type) VALUES
('hardcover'), 
('ebook'), 
('audiobook'), 
('paperback');

-- Link Titles and Authors
INSERT INTO titles_authors (title_id, author_id) VALUES
(1, 1), -- The Shining by Stephen King
(2, 2), -- Murder on the Orient Express by Agatha Christie
(3, 3), -- One Hundred Years of Solitude by Gabriel García Márquez
(4, 4), -- The Handmaid's Tale by Margaret Atwood
(5, 5), -- American Gods by Neil Gaiman
(6, 6), -- Mrs. Dalloway by Virginia Woolf
(7, 7), -- Norwegian Wood by Haruki Murakami
(8, 8), -- The Old Man and the Sea by Ernest Hemingway
(9, 9), -- Beloved by Toni Morrison
(10, 10), -- Do Androids Dream of Electric Sheep? by Philip K. Dick
(11, 11), -- Good Omens by Neil Gaiman
(12, 12), -- Dune by Frank Herbert
(13, 13), -- The Hitchhiker's Guide to the Galaxy by Douglas Adams
(14, 14), -- Fahrenheit 451 by Ray Bradbury
(15, 15), -- 2001: A Space Odyssey by Arthur C. Clarke
(16, 16), -- Foundation by Isaac Asimov
(17, 17), -- The Left Hand of Darkness by Ursula K. Le Guin
(18, 18), -- A Game of Thrones by George R.R. Martin
(19, 19), -- The Da Vinci Code by Dan Brown
(20, 20), -- The Grapes of Wrath by John Steinbeck
(21, 21), -- The Alchemist by Paulo Coelho
(22, 22), -- Crime and Punishment by Fyodor Dostoevsky
(23, 23), -- War and Peace by Leo Tolstoy
(24, 24), -- Great Expectations by Charles Dickens
(25, 25), -- Wuthering Heights by Emily Brontë
(26, 26), -- Jane Eyre by Charlotte Brontë
(27, 27), -- The Picture of Dorian Gray by Oscar Wilde
(28, 28), -- Twenty Thousand Leagues Under the Sea by Jules Verne
(29, 29), -- The Time Machine by H.G. Wells
(30, 30); -- Brave New World by Aldous Huxley

-- Link Titles and Genres
INSERT INTO titles_genres (title_id, genre_id) VALUES
(1, 17), -- The Shining - Horror
(2, 22), -- Murder on the Orient Express - Mystery
(3, 13), -- One Hundred Years of Solitude - Fiction
(4, 31), -- The Handmaid's Tale - Science Fiction
(5, 12), -- American Gods - Fantasy
(6, 13), -- Mrs. Dalloway - Fiction
(7, 13), -- Norwegian Wood - Fiction
(8, 13), -- The Old Man and the Sea - Fiction
(9, 13), -- Beloved - Fiction
(10, 31), -- Do Androids Dream of Electric Sheep? - Science Fiction
(11, 12), -- Good Omens - Fantasy
(12, 31), -- Dune - Science Fiction
(13, 31), -- The Hitchhiker's Guide to the Galaxy - Science Fiction
(14, 31), -- Fahrenheit 451 - Science Fiction
(15, 31), -- 2001: A Space Odyssey - Science Fiction
(16, 31), -- Foundation - Science Fiction
(17, 31), -- The Left Hand of Darkness - Science Fiction
(18, 12), -- A Game of Thrones - Fantasy
(19, 36), -- The Da Vinci Code - Thriller
(20, 13), -- The Grapes of Wrath - Fiction
(21, 13), -- The Alchemist - Fiction
(22, 13), -- Crime and Punishment - Fiction
(23, 15), -- War and Peace - Historical
(24, 6), -- Great Expectations - Classics
(25, 6), -- Wuthering Heights - Classics
(26, 6), -- Jane Eyre - Classics
(27, 6), -- The Picture of Dorian Gray - Classics
(28, 31), -- Twenty Thousand Leagues Under the Sea - Science Fiction
(29, 31), -- The Time Machine - Science Fiction
(30, 31); -- Brave New World - Science Fiction

-- Link Titles and Languages (all in English for simplicity)
INSERT INTO titles_languages (title_id, language_id) VALUES
(1, 16), (2, 16), (3, 16), (4, 16), (5, 16), (6, 16), (7, 16), (8, 16), (9, 16), (10, 16),
(11, 16), (12, 16), (13, 16), (14, 16), (15, 16), (16, 16), (17, 16), (18, 16), (19, 16), (20, 16),
(21, 16), (22, 16), (23, 16), (24, 16), (25, 16), (26, 16), (27, 16), (28, 16), (29, 16), (30, 16);

-- Link Titles and Formats (adding both hardcover and paperback for each)
INSERT INTO titles_formats (title_id, format_id) VALUES
(1, 1), (1, 4), (2, 1), (2, 4), (3, 1), (3, 4), (4, 1), (4, 4), (5, 1), (5, 4),
(6, 1), (6, 4), (7, 1), (7, 4), (8, 1), (8, 4), (9, 1), (9, 4), (10, 1), (10, 4),
(11, 1), (11, 4), (12, 1), (12, 4), (13, 1), (13, 4), (14, 1), (14, 4), (15, 1), (15, 4),
(16, 1), (16, 4), (17, 1), (17, 4), (18, 1), (18, 4), (19, 1), (19, 4), (20, 1), (20, 4),
(21, 1), (21, 4), (22, 1), (22, 4), (23, 1), (23, 4), (24, 1), (24, 4), (25, 1), (25, 4),
(26, 1), (26, 4), (27, 1), (27, 4), (28, 1), (28, 4), (29, 1), (29, 4), (30, 1), (30, 4);









