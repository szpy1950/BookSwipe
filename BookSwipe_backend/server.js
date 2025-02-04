const express = require("express");
const app = express();
const cors = require('cors');
const { Client } = require('pg');
const { sha256 } = require("pg/lib/crypto/utils-legacy.js");

// Database configuration
const db = new Client({
    host: "localhost",
    user: "postgres",
    password: "myverysecretpassword",
    database: "BinderDBTest",
    port: 5432,
});

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Database connection
db.connect()
.then(() => console.log("Connected to database successfully"))
.catch(err => {
    console.error("Database connection error:", err);
    process.exit(1);
});

const jwt = require('jsonwebtoken');
const JWT_SECRET = 'your-secret-key'; // In production, use environment variable
const TOKEN_EXPIRY = '7d'; // Token valid for 7 days

const authenticateToken = (req, res, next) => {
    const token = req.headers['authorization']?.split(' ')[1];
    if (!token) return res.status(401).json({ success: false, message: "No token provided" });

    try {
        const decoded = jwt.verify(token, JWT_SECRET);
        req.userId = decoded.userId;
        next();
    } catch (err) {
        return res.status(403).json({ success: false, message: "Invalid token" });
    }
};

app.use('/images', express.static('images'));


// Routes
app.get("/", (req, res) => {
    res.json({ message: "Server is running" });
});

// Login route
app.post("/login", async (req, res) => {
    try {
        const { username, password } = req.body;

        if (!username || !password) {
            return res.status(400).json({
                success: false,
                message: "Username and password are required"
            });
        }

        const userQuery = 'SELECT * FROM users WHERE username = $1';
        const userResult = await db.query(userQuery, [username]);

        if (userResult.rows.length === 0) {
            return res.status(401).json({
                success: false,
                message: "User not found"
            });
        }

        const user = userResult.rows[0];
        const hashedPassword = sha256(password).toString('hex');

        if (hashedPassword === user.password_hash) {
            const { password_hash, ...userData } = user;

            // Generate JWT token
            const token = jwt.sign(
                { userId: user.id },
                JWT_SECRET,
                { expiresIn: TOKEN_EXPIRY }
            );

            res.json({
                success: true,
                user: userData,
                token: token
            });
        } else {
            res.status(401).json({
                success: false,
                message: "Invalid credentials"
            });
        }
    } catch (err) {
        console.error("Login error:", err);
        res.status(500).json({
            success: false,
            message: "Server error"
        });
    }
});

// Signup route
app.post("/signup", async (req, res) => {
    try {
        const { username, password } = req.body;
        console.log("Received signup request for username:", username);

        if (!username || !password) {
            return res.status(400).json({
                success: false,
                message: "Username and password are required"
            });
        }

        // Check if username already exists
        const checkUser = await db.query('SELECT * FROM users WHERE username = $1', [username]);
        if (checkUser.rows.length > 0) {
            return res.status(400).json({
                success: false,
                message: "Username already exists"
            });
        }

        // Create new user
        const hashedPassword = sha256(password).toString('hex');
        const query = 'INSERT INTO users(username, password_hash) VALUES ($1, $2) RETURNING id, username';
        const result = await db.query(query, [username, hashedPassword]);

        res.json({
            success: true,
            user: result.rows[0],
            message: "User created successfully"
        });
    } catch (err) {
        console.error("Signup error:", err);
        res.status(500).json({
            success: false,
            message: "Server error during signup"
        });
    }
});

// Get recommended books through search algorithm
app.get("/recommended-books", authenticateToken, async (req, res) => {
    try {
        const userId = req.userId;

        // First, fetch all user preferences in parallel
        const [genrePrefs, languagePrefs, lengthPrefs, authorPrefs] = await Promise.all([
            db.query(`
            SELECT g.name
            FROM genre_preferences gp
            JOIN genres g ON gp.genre_id = g.id
            WHERE gp.user_id = $1
            `, [userId]),
            db.query(`
            SELECT l.name
            FROM language_preferences lp
            JOIN languages l ON lp.language_id = l.id
            WHERE lp.user_id = $1
            `, [userId]),
            db.query(`
            SELECT l.length
            FROM length_preferences lp
            JOIN lengths l ON lp.length_id = l.id
            WHERE lp.user_id = $1
            `, [userId]),
            db.query(`
            SELECT CONCAT(a.au_fname, ' ', a.au_lname) as name
            FROM author_preferences ap
            JOIN authors a ON ap.author_id = a.id
            WHERE ap.user_id = $1
            `, [userId])
        ]);

        // Transform preferences into arrays
        const genres = genrePrefs.rows.map(g => g.name);
        const languages = languagePrefs.rows.map(l => l.name);
        const lengths = lengthPrefs.rows.map(l => l.length);
        const authors = authorPrefs.rows.map(a => a.name);

        // Set defaults if any preferences are empty
        if (genres.length === 0) genres.push('Fiction');
        if (languages.length === 0) languages.push('English');
        if (lengths.length === 0) lengths.push('medium');

        console.log('Using preferences:', { genres, authors, languages, lengths });

        /*
        Book search algorithm functionality:
        1)Begin book search
        2)Exclude books the user has already liked
        3)Calculate book score through weighted combinationsGenre: 35%; Author: 25%; Language: 20%; Page count: 20%
        4)Sort by score in descending order and limit results to 10
        */
        const recommendationQuery = `
        WITH book_scores AS (
            SELECT
            t.id,
            t.name as title,
            t.cover_image_url,
            t.average_rating,
            t.description,
            STRING_AGG(DISTINCT (a.au_fname || ' ' || a.au_lname), ', ') AS author,
            array_agg(DISTINCT g.name)::text[] as genres,
            array_agg(DISTINCT l.name)::text[] as languages,
            t.pages,
            t.publisher,
            t.pubdate,
            t.isbn,
            t.is_available,
            t.price,

            -- Genre match score (35%) - FIXED VERSION
            CASE WHEN array_agg(DISTINCT g.name::text) && $2::text[]
            THEN 0.35 * (
                COUNT(DISTINCT g.name)::float /
                GREATEST(array_length($2::text[], 1), COUNT(DISTINCT g.name))
            )
            ELSE 0 END +

            -- Author match score (25%)
            CASE WHEN CONCAT(a.au_fname, ' ', a.au_lname) IN (SELECT UNNEST($3::text[]))
            THEN 0.25 ELSE 0 END +

            -- Language match score (20%)
            CASE WHEN array_agg(DISTINCT l.name::text) && $4::text[]
            THEN 0.20 ELSE 0 END +

            -- Length match score (20%)
            CASE
            WHEN $5::text[] @> ARRAY['short']::text[] AND t.pages < 200 THEN 0.20
            WHEN $5::text[] @> ARRAY['medium']::text[] AND t.pages BETWEEN 200 AND 400 THEN 0.20
            WHEN $5::text[] @> ARRAY['long']::text[] AND t.pages BETWEEN 401 AND 500 THEN 0.20
            WHEN $5::text[] @> ARRAY['very_long']::text[] AND t.pages BETWEEN 501 AND 800 THEN 0.20
            WHEN $5::text[] @> ARRAY['humongous']::text[] AND t.pages > 800 THEN 0.20
            ELSE 0
            END as match_score

            FROM titles t
            LEFT JOIN titles_authors ta ON t.id = ta.title_id
            LEFT JOIN authors a ON ta.author_id = a.id
            LEFT JOIN titles_genres tg ON t.id = tg.title_id
            LEFT JOIN genres g ON tg.genre_id = g.id
            LEFT JOIN titles_languages tl ON t.id = tl.title_id
            LEFT JOIN languages l ON tl.language_id = l.id
            WHERE t.is_available = true
            AND t.id NOT IN (
                SELECT title_id
                FROM liked_titles
                WHERE user_id = $1
            )
            AND t.id NOT IN (
                SELECT title_id
                FROM disliked_titles
                WHERE user_id = $1
            )
            GROUP BY t.id, t.name, t.cover_image_url, t.average_rating, t.pages,
            t.publisher, t.pubdate, t.isbn, t.is_available, t.price, a.au_fname, a.au_lname
        )
        SELECT
        id,
        title,
        cover_image_url,
        average_rating,
        author,
        genres,
        languages,
        pages,
        publisher,
        pubdate,
        isbn,
        is_available,
        price,
        description,
        match_score
        FROM book_scores
        WHERE match_score > 0
        ORDER BY match_score DESC, average_rating DESC NULLS LAST
        LIMIT 10;
        `;

        const result = await db.query(
            recommendationQuery,
            [userId, genres, authors, languages, lengths]
        );

        console.log(`Found ${result.rows.length} recommended books for user ${userId}`);

        res.json({
            success: true,
            books: result.rows
        });
    } catch (err) {
        console.error("Error in book recommendations:", err);
        res.status(500).json({
            success: false,
            message: err.toString()
        });
    }
});

// Route to verify JWT token
app.post("/verify-token", async (req, res) => {
    try {
        const { token } = req.body;
        const decoded = jwt.verify(token, JWT_SECRET);

        const userQuery = 'SELECT * FROM users WHERE id = $1';
        const userResult = await db.query(userQuery, [decoded.userId]);

        if (userResult.rows.length === 0) {
            return res.status(401).json({
                success: false,
                message: "User not found"
            });
        }

        const { password_hash, ...userData } = userResult.rows[0];

        res.json({
            success: true,
            user: userData
        });
    } catch (err) {
        res.status(401).json({
            success: false,
            message: "Invalid token"
        });
    }
});

// Route to fetch books
app.get("/books", async (req, res) => {
    try {
        const query = `
        SELECT
        t.id,
        t.name as title,
        t.pages,
        t.price,
        t.pubdate,
        t.is_available,
        t.ISBN as isbn,
        t.cover_image_url,
        t.average_rating,
        t.publisher,
        t.description,
        STRING_AGG(DISTINCT a.au_fname || ' ' || a.au_lname, ', ') AS author,
        ARRAY_TO_JSON(ARRAY_AGG(DISTINCT g.name)) as genres,
        ARRAY_TO_JSON(ARRAY_AGG(DISTINCT l.name)) as languages,
        ARRAY_TO_JSON(ARRAY_AGG(DISTINCT f.type)) as formats
        FROM titles t
        LEFT JOIN titles_authors ta ON t.id = ta.title_id
        LEFT JOIN authors a ON ta.author_id = a.id
        LEFT JOIN titles_genres tg ON t.id = tg.title_id
        LEFT JOIN genres g ON tg.genre_id = g.id
        LEFT JOIN titles_languages tl ON t.id = tl.title_id
        LEFT JOIN languages l ON tl.language_id = l.id
        LEFT JOIN titles_formats tf ON t.id = tf.title_id
        LEFT JOIN formats f ON tf.format_id = f.id
        WHERE t.is_available = true
        GROUP BY t.id
        ORDER BY t.id;
        `;

        const result = await db.query(query);
        res.json({
            success: true,
            books: result.rows
        });
    } catch (err) {
        console.error("Error fetching books:", err);
        res.status(500).json({
            success: false,
            message: "Error fetching books"
        });
    }
});

// Get user preferences
app.get("/user/:userId/preferences", authenticateToken, async (req, res) => {

    if (req.userId !== parseInt(req.params.userId)) {
        return res.status(403).json({ success: false, message: "Unauthorized access" });
    }


    try {
        const userId = req.params.userId;

        // Get all preferences in parallel
        const [genres, languages, lengths, authors] = await Promise.all([
            db.query(`
            SELECT g.name
            FROM genre_preferences gp
            JOIN genres g ON gp.genre_id = g.id
            WHERE gp.user_id = $1
            `, [userId]),
            db.query(`
            SELECT l.name
            FROM language_preferences lp
            JOIN languages l ON lp.language_id = l.id
            WHERE lp.user_id = $1
            `, [userId]),
            db.query(`
            SELECT l.length
            FROM length_preferences lp
            JOIN lengths l ON lp.length_id = l.id
            WHERE lp.user_id = $1
            `, [userId]),
            db.query(`
            SELECT CONCAT(a.au_fname, ' ', a.au_lname) as name
            FROM author_preferences ap
            JOIN authors a ON ap.author_id = a.id
            WHERE ap.user_id = $1
            `, [userId])
        ]);

        res.json({
            success: true,
            preferences: {
                'Genres': genres.rows.map(g => g.name),
                 'Languages': languages.rows.map(l => l.name),
                 'Book Length': lengths.rows.map(l => l.length),
                 'Authors': authors.rows.map(a => a.name)
            }
        });
    } catch (err) {
        console.error("Error fetching preferences:", err);
        res.status(500).json({
            success: false,
            message: "Error fetching preferences"
        });
    }
});

// Route to select available preferences
app.get("/available-preferences", async (req, res) => {
    try {
        console.log("Fetching available preferences...");

        // First check if tables have data
        const counts = await Promise.all([
            db.query('SELECT COUNT(*) FROM genres'),
                                         db.query('SELECT COUNT(*) FROM languages'),
                                         db.query('SELECT COUNT(*) FROM lengths'),
                                         db.query('SELECT COUNT(*) FROM authors')
        ]);


        const [genres, languages, lengths, authors] = await Promise.all([
            db.query('SELECT name FROM genres ORDER BY name'),
            db.query('SELECT name FROM languages ORDER BY name'),
            db.query('SELECT length FROM lengths ORDER BY length'),
            db.query('SELECT CONCAT(au_fname, \' \', au_lname) as name FROM authors ORDER BY au_lname')
        ]);
        
        res.json({
            success: true,
            preferences: {
                'Genres': genres.rows.map(g => g.name),
                 'Languages': languages.rows.map(l => l.name),
                 'Book Length': lengths.rows.map(l => l.length),
                 'Authors': authors.rows.map(a => a.name)
            }
        });
    } catch (err) {
        console.error("Error fetching available preferences:", err);
        res.status(500).json({
            success: false,
            message: "Error fetching available preferences"
        });
    }
});

// Update user preferences
app.post("/user/:userId/preferences", authenticateToken, async (req, res) => {

    try {
        const userId = req.params.userId;
        const { preferences } = req.body;

        console.log(`
        Preference Update Request:
        User ID: ${userId}
        Updated Preferences:
        - Genres: ${preferences['Genres']?.join(', ') || 'none'}
        - Languages: ${preferences['Languages']?.join(', ') || 'none'}
        - Book Length: ${preferences['Book Length']?.join(', ') || 'none'}
        - Authors: ${preferences['Authors']?.join(', ') || 'none'}
        `);

        if (!preferences || typeof preferences !== 'object') {
            return res.status(400).json({
                success: false,
                message: "Invalid preferences format"
            });
        }

        if (preferences['Book Length']?.some(length =>
            !['short', 'medium', 'long', 'very_long', 'humongous'].includes(length))) {
            return res.status(400).json({
                success: false,
                message: "Invalid book length value"
            });
            }

        // Use your existing resetPreferences function
        await resetPreferences(
            userId,
            preferences['Genres'],
            preferences['Languages'],
            preferences['Book Length']
        );

        res.json({
            success: true,
            message: "Preferences updated successfully"
        });
    } catch (err) {
        console.error("Error updating preferences:", err);
        res.status(500).json({
            success: false,
            message: "Error updating preferences"
        });
    }
});

// Modify the existing dislike route to add more logging
app.post("/user/:userId/dislike-book", authenticateToken, async (req, res) => {
    try {
        const userId = req.userId;
        const { bookId } = req.body;

        console.log(`Dislike book request - UserID: ${userId}, BookID: ${bookId}`);

        // Validate input
        if (!bookId) {
            return res.status(400).json({
                success: false,
                message: "BookId is required"
            });
        }

        // Check if book exists
        const bookCheck = await db.query(
            'SELECT id FROM titles WHERE id = $1',
            [bookId]
        );

        if (bookCheck.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: "Book not found"
            });
        }

        // Check if already disliked
        const existingDislike = await db.query(
            'SELECT * FROM disliked_titles WHERE user_id = $1 AND title_id = $2',
            [userId, bookId]
        );

        if (existingDislike.rows.length > 0) {
            return res.json({
                success: true,
                message: "Book was already disliked"
            });
        }

        // Insert new dislike
        await db.query(
            'INSERT INTO disliked_titles (user_id, title_id) VALUES ($1, $2)',
                       [userId, bookId]
        );

        console.log(`Successfully disliked book ${bookId} for user ${userId}`);

        res.json({
            success: true,
            message: "Book disliked successfully"
        });
    } catch (err) {
        console.error("Error disliking book:", err);
        res.status(500).json({
            success: false,
            message: "Error disliking book: " + err.message
        });
    }
});

app.get("/user/:userId/liked-books", authenticateToken, async (req, res) => {
    try {
        const userId = req.params.userId;
        console.log(`Fetching liked books for user: ${userId}`);

        // First check if user has any liked books
        const checkLikes = await db.query('SELECT COUNT(*) FROM liked_titles WHERE user_id = $1', [userId]);
        console.log(`Number of liked books found: ${checkLikes.rows[0].count}`);

        const query = `
        SELECT
        t.id,
        t.name as title,
        STRING_AGG(DISTINCT CONCAT(a.au_fname, ' ', a.au_lname), ', ') as author,
        t.cover_image_url,
        t.average_rating,
        ARRAY_TO_JSON(ARRAY_AGG(DISTINCT g.name)) as genres
        FROM liked_titles lt
        JOIN titles t ON lt.title_id = t.id
        LEFT JOIN titles_authors ta ON t.id = ta.title_id
        LEFT JOIN authors a ON ta.author_id = a.id
        LEFT JOIN titles_genres tg ON t.id = tg.title_id
        LEFT JOIN genres g ON tg.genre_id = g.id
        WHERE lt.user_id = $1
        GROUP BY t.id
        `;

        const result = await db.query(query, [userId]);
        console.log(`Retrieved ${result.rows.length} liked books with details`);

        res.json({
            success: true,
            books: result.rows
        });
    } catch (err) {
        console.error("Error fetching liked books:", err);
        res.status(500).json({
            success: false,
            message: "Error fetching liked books"
        });
    }
});

// Route to record user likes 
app.post("/user/:userId/like-book", authenticateToken, async (req, res) => {
    try {
        const userId = req.userId;  // Get from token
        const { bookId } = req.body;

        console.log(`Like book request - UserID: ${userId}, BookID: ${bookId}`);

        // Validate input
        if (!bookId) {
            return res.status(400).json({
                success: false,
                message: "BookId is required"
            });
        }

        // Check if book exists
        const bookCheck = await db.query(
            'SELECT id FROM titles WHERE id = $1',
            [bookId]
        );

        if (bookCheck.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: "Book not found"
            });
        }

        // Check if already liked
        const existingLike = await db.query(
            'SELECT * FROM liked_titles WHERE user_id = $1 AND title_id = $2',
            [userId, bookId]
        );

        if (existingLike.rows.length > 0) {
            return res.json({
                success: true,
                message: "Book was already liked"
            });
        }

        // Insert new like
        await db.query(
            'INSERT INTO liked_titles (user_id, title_id) VALUES ($1, $2)',
                       [userId, bookId]
        );

        console.log(`Successfully liked book ${bookId} for user ${userId}`);

        res.json({
            success: true,
            message: "Book liked successfully"
        });
    } catch (err) {
        console.error("Error liking book:", err);
        res.status(500).json({
            success: false,
            message: "Error liking book: " + err.message
        });
    }
});

// Add this new GET route for disliked books
app.get("/user/:userId/disliked-books", authenticateToken, async (req, res) => {
    try {
        const userId = req.params.userId;
        console.log(`Fetching disliked books for user: ${userId}`);

        // First check if user has any disliked books
        const checkDislikes = await db.query('SELECT COUNT(*) FROM disliked_titles WHERE user_id = $1', [userId]);
        console.log(`Number of disliked books found: ${checkDislikes.rows[0].count}`);

        const query = `
        SELECT
        t.id,
        t.name as title,
        STRING_AGG(DISTINCT CONCAT(a.au_fname, ' ', a.au_lname), ', ') as author,
        t.cover_image_url,
        t.average_rating,
        ARRAY_TO_JSON(ARRAY_AGG(DISTINCT g.name)) as genres
        FROM disliked_titles dt
        JOIN titles t ON dt.title_id = t.id
        LEFT JOIN titles_authors ta ON t.id = ta.title_id
        LEFT JOIN authors a ON ta.author_id = a.id
        LEFT JOIN titles_genres tg ON t.id = tg.title_id
        LEFT JOIN genres g ON tg.genre_id = g.id
        WHERE dt.user_id = $1
        GROUP BY t.id
        `;

        const result = await db.query(query, [userId]);
        console.log(`Retrieved ${result.rows.length} disliked books with details`);

        res.json({
            success: true,
            books: result.rows
        });
    } catch (err) {
        console.error("Error fetching disliked books:", err);
        res.status(500).json({
            success: false,
            message: "Error fetching disliked books"
        });
    }
});

// Utility Functions
// Function to get password from said user
async function getPassword(username) {
    try {
        const query = 'SELECT password_hash FROM users WHERE username = $1';
        const result = await db.query(query, [username]);
        if (result.rows.length === 0) throw new Error('User not found');
        return result.rows[0].password_hash;
    } catch (err) {
        console.error("Get password error:", err);
        throw err;
    }
}

// Function to reset preferences
async function resetPreferences(userId, genres, languages, lengths) {
    try {
        await db.query('BEGIN');

        // Execute each DELETE statement separately
        await db.query('DELETE FROM genre_preferences WHERE user_id = $1', [userId]);
        await db.query('DELETE FROM language_preferences WHERE user_id = $1', [userId]);
        await db.query('DELETE FROM length_preferences WHERE user_id = $1', [userId]);

        // Insert new preferences with proper type casting
        if (genres?.length) {
            const genreQuery = `
            INSERT INTO genre_preferences (user_id, genre_id)
            SELECT $1, g.id
            FROM genres g
            WHERE g.name::text = ANY($2::text[])
            `;
            await db.query(genreQuery, [userId, genres]);
        }

        if (languages?.length) {
            const langQuery = `
            INSERT INTO language_preferences (user_id, language_id)
            SELECT $1, l.id
            FROM languages l
            WHERE l.name::text = ANY($2::text[])
            `;
            await db.query(langQuery, [userId, languages]);
        }

        if (lengths?.length) {
            const lengthQuery = `
            INSERT INTO length_preferences (user_id, length_id)
            SELECT $1, l.id
            FROM lengths l
            WHERE l.length::text = ANY($2::text[])
            `;
            await db.query(lengthQuery, [userId, lengths]);
        }

        await db.query('COMMIT');
        return true;
    } catch (err) {
        await db.query('ROLLBACK');
        console.error("Reset preferences error:", err);
        throw err;
    }
}

// Server startup
const PORT = 8080;
app.listen(PORT, '0.0.0.0')
.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
        console.error(`Port ${PORT} is already in use. Please choose a different port or kill the process using this port.`);
    } else {
        console.error('Server error:', err);
    }
    process.exit(1);
})
.on('listening', () => {
    console.log(`Server running on http://192.168.1.102:${PORT}`);
});

// Error handling for uncaught exceptions
process.on('uncaughtException', (err) => {
    console.error('Uncaught Exception:', err);
    process.exit(1);
});

process.on('unhandledRejection', (err) => {
    console.error('Unhandled Rejection:', err);
    process.exit(1);
});
