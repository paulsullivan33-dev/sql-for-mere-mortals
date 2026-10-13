-- setup.sql — sample bookstore database for "SQL for Mere Mortals".
-- Idempotent: drop tables first so it can be re-run safely.
-- Usage: sqlite3 bookstore.db < setup.sql

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS books;

CREATE TABLE books (
  id INTEGER PRIMARY KEY,
  title TEXT,
  author TEXT,
  year INTEGER,
  price REAL,
  in_stock INTEGER
);

CREATE TABLE sales (
  id INTEGER PRIMARY KEY,
  book_id INTEGER,
  sale_date TEXT,
  quantity INTEGER
);

INSERT INTO books VALUES
  (1, 'The Hobbit', 'J.R.R. Tolkien', 1937, 12.99, 14),
  (2, 'Dune', 'Frank Herbert', 1965, 15.99, 8),
  (3, 'Neuromancer', 'William Gibson', 1984, 13.50, 0),
  (4, 'The Left Hand of Darkness', 'Ursula K. Le Guin', 1969, 14.00, 5),
  (5, 'Foundation', 'Isaac Asimov', 1951, 11.99, 11),
  (6, 'Snow Crash', 'Neal Stephenson', 1992, 16.99, 3),
  (7, 'A Wizard of Earthsea', 'Ursula K. Le Guin', 1968, 10.99, 7),
  (8, 'The Dispossessed', 'Ursula K. Le Guin', NULL, 13.99, 4);

INSERT INTO sales VALUES
  (1, 1, '2026-10-01', 2),
  (2, 2, '2026-10-01', 1),
  (3, 1, '2026-10-03', 1),
  (4, 5, '2026-10-04', 3),
  (5, 3, '2026-10-05', 1),
  (6, 7, '2026-10-06', 2),
  (7, 2, '2026-10-08', 2),
  (8, 6, '2026-10-09', 1),
  (9, 4, '2026-10-10', 1),
  (10, 1, '2026-10-12', 1);
