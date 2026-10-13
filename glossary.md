# Glossary

Every jargon term used in this guide, in one place. Terms are
explained on first use in the chapters; this is the quick-reference
version.

- **Aggregate** — a function that takes many rows in and returns one
  value out: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`. See [Grouping and
  Aggregates](grouping.md).
- **Alias** — a temporary rename. A column alias (`SELECT title AS
  book_title`) renames a result column; a table alias (`FROM books
  b`) gives a table a short name for the rest of the query.
- **Clause** — one labeled part of a SQL statement: the `SELECT`
  clause, the `WHERE` clause, the `ORDER BY` clause.
- **Column** — one vertical slice of a table: one fact recorded for
  every row (e.g. every book has a `title`).
- **Constraint** — a rule the database enforces on data: `PRIMARY
  KEY` (unique, not null), `UNIQUE`, `NOT NULL`. Violating one
  produces an error like `UNIQUE constraint failed`.
- **Database** — an organized collection of tables that a program
  can search, sort, and update. SQLite stores a whole database in
  one file.
- **Dot-command** — an instruction to the `sqlite3` program itself
  (`.tables`, `.schema`), not SQL. Starts with a dot, needs no
  semicolon.
- **Foreign key** — a column in one table holding the primary key of
  a row in another table (`sales.book_id` → `books.id`). It's the
  link that [joins](joins.md) follow.
- **GROUP BY** — a clause that sorts rows into buckets so an
  aggregate computes one value per bucket ("books per author").
- **HAVING** — filters groups *after* grouping (unlike `WHERE`,
  which filters rows *before*). Only meaningful with `GROUP BY`.
- **Index** — a separate sorted structure on a column that lets the
  database jump to matching rows instead of scanning the whole
  table. Speeds up reads; slows down writes slightly.
- **INSERT / UPDATE / DELETE** — the three statements that change
  data: add rows, change rows, remove rows. See [Changing
  Data](changing-data.md).
- **JOIN** — combines rows from two tables by matching a rule in the
  `ON` clause. `INNER JOIN` keeps only matches; `LEFT JOIN` keeps
  all left-table rows. See [Joins](joins.md).
- **NULL** — "we don't know." Not zero, not empty string. Test with
  `IS NULL` / `IS NOT NULL`; `= NULL` never matches. See
  [NULLs](nulls.md).
- **Predicate** — the condition in a `WHERE` clause that each row is
  tested against (`price < 14`).
- **Primary key** — the column (or columns) that uniquely identifies
  each row in a table. In this guide, every table's `id` is its
  primary key, auto-assigned.
- **Query** — a `SELECT` statement: a question you ask the database.
  ("Query" is sometimes used loosely for any SQL statement.)
- **Row** — one horizontal line of a table: a single thing (one
  book, one sale).
- **Schema** — the structure of a database: its tables, columns, and
  types. (Also the verb form: `.schema` shows a table's CREATE
  statement.)
- **SELECT** — the question-asking statement. The skeleton: `SELECT
  <columns> FROM <table> WHERE <filter> ORDER BY <sort> LIMIT
  <n>;`
- **SQL** — Structured Query Language: the language for asking a
  database questions and changing its data. Pronounced "sequel" or
  "S-Q-L."
- **SQLite** — a free, public-domain database engine where one file
  is one database. The engine this guide uses.
- **Statement** — one complete SQL command, ending with a
  semicolon.
- **Table** — one grid of rows and columns holding one kind of
  thing (books, sales).
- **Transaction** — a group of statements treated as all-or-nothing.
  `BEGIN` starts one, `COMMIT` saves it, `ROLLBACK` undoes it.
- **Type affinity** — SQLite's flexible typing: a column *prefers* a
  type but tolerates others (except `INTEGER PRIMARY KEY`, which is
  strict).
