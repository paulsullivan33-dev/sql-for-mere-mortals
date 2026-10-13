# SQLite

Every example in this guide runs on **SQLite**: a free, public-domain
database engine. Its defining trait: **one file = one database**.
`bookstore.db` is the whole database — tables, indexes, data, all in
that file. Copy it, email it, back it up like any file. There is no
server to install, no service to start, no password to forget.

## The essential dot-commands

Dot-commands are instructions to the `sqlite3` program itself, not
SQL — that's why they start with a dot and need no semicolon:

```bash
sqlite3 bookstore.db
sqlite> .tables
```

**Check (verified):**

```
books  sales
```

```bash
sqlite> .schema books
```

**Check (verified):**

```
CREATE TABLE books (
  id INTEGER PRIMARY KEY,
  title TEXT,
  author TEXT,
  year INTEGER,
  price REAL,
  in_stock INTEGER
);
```

`.schema` shows the SQL that built the table — handy when you've
forgotten a column name (see [Troubleshooting](troubleshooting.md)).

| Command | Does |
|---------|------|
| `.tables` | List tables |
| `.schema <table>` | Show a table's CREATE statement |
| `.headers on` | Print column names above results |
| `.mode column` | Neat aligned columns (what this guide's outputs use) |
| `.quit` or Ctrl+D | Leave sqlite3 |

## Type affinity: flexible, with one rule

Most databases reject a value that doesn't match the column type.
SQLite is lenient: a column declared `INTEGER` *prefers* integers
(called **type affinity**) but will store text if you insist:

```sql
INSERT INTO books (title, author, year, price, in_stock)
VALUES ('Type Demo', 'Nobody', 'not a number', 9.99, 1);
SELECT title, year, typeof(year) FROM books WHERE title = 'Type Demo';
```

**Check (verified):**

```
title      year          typeof(year)
---------  ------------  ------------
Type Demo  not a number  text
```

`typeof()` reveals what actually got stored: text, in an INTEGER
column. The flexibility is real — and so is the footgun: a typo
like `'1984 '` (trailing space) silently becomes text and sorts
oddly. Clean it up before moving on:

```sql
DELETE FROM books WHERE title = 'Type Demo';
```

The one hard rule: an `INTEGER PRIMARY KEY` column must
hold integers (or NULL) — anything else is a "datatype mismatch"
error.

## INTEGER PRIMARY KEY assigns ids for you

Declare a column `INTEGER PRIMARY KEY` and SQLite auto-assigns the
next unused integer on INSERT — that's why the guide's INSERTs
never mention `id`:

```sql
INSERT INTO books (title) VALUES ('Rowid Demo');
SELECT last_insert_rowid();
```

**Check (verified):**

```
last_insert_rowid()
-------------------
9
```

The new row got id 9, and `last_insert_rowid()` reports it (same
session only, like `changes()`). One caveat: without the
`AUTOINCREMENT` keyword, deleting the highest-id row lets a later
insert reuse that id. (In this guide's examples, ids only ever grow
because we never delete the top row — but don't rely on "never
reused" in real schemas.)

## Dates as TEXT sort correctly — if you use YYYY-MM-DD

SQLite has no dedicated date type; the convention is TEXT in
`YYYY-MM-DD` format, which sorts alphabetically *and*
chronologically:

```sql
SELECT sale_date FROM sales ORDER BY sale_date DESC LIMIT 3;
```

**Check (verified):**

```
sale_date
----------
2026-10-12
2026-10-10
2026-10-09
```

Write dates any other way (`10/12/2026`, `12-Oct-26`) and sorting
breaks — stick to the format.

## PRAGMA foreign_keys: off by default

SQLite *parses* foreign key declarations but doesn't *enforce*
them unless you ask, per connection:

```sql
PRAGMA foreign_keys;
```

**Check (verified):**

```
foreign_keys
------------
0
```

`0` means off — SQLite will happily let you insert a sale for
book_id 999, which doesn't exist. Turn it on with `PRAGMA
foreign_keys = ON;` at the start of each session if you want the
database to reject orphans. (Our `setup.sql` doesn't declare
foreign keys at all — one less thing to trip over while learning.
Real schemas should declare them.)

## SQLite is already on your devices

You've been using SQLite for years without knowing it. It ships
inside phones, web browsers, and countless desktop and mobile apps
— anywhere a program needs a small, reliable database without
running a server. The file on your disk and the database in a
phone app are the same technology. When this guide says "one file
= one database," that's literally the file those apps carry around.

That's also why the SQL you learn here travels: the core language
is the same in SQLite, PostgreSQL, MySQL, and the rest. Only the
edges differ.

**Next:** [Troubleshooting](troubleshooting.md)
