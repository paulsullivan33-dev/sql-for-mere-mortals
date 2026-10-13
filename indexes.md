# Indexes

## The book-index analogy

Finding every mention of "whale" in a novel by reading it cover to
cover is a **scan**. Looking it up in the index at the back —
sorted, with page numbers — is a **seek**. A database **index** is
the same idea: a separate sorted structure that lets the database
jump straight to matching rows instead of reading the whole table.

You don't need indexes to get correct answers. You need them to get
fast answers on big tables. Our bookstore is tiny — everything is
instant either way — so this chapter demonstrates the *mechanism* on
small data. The payoff comes when your tables have thousands of
rows or more.

## CREATE INDEX

"Find books by this author" gets asked a lot. Ask the database how
it plans to run that query, before and after indexing. First, the
plan with no index:

```sql
EXPLAIN QUERY PLAN SELECT title FROM books WHERE author = 'Frank Herbert';
```

**Check (verified):** (no index yet)

```
QUERY PLAN
`--SCAN books
```

`SCAN` = read every row and check. Now add the index:

```sql
CREATE INDEX idx_books_author ON books(author);
```

Run the same EXPLAIN again:

```sql
EXPLAIN QUERY PLAN SELECT title FROM books WHERE author = 'Frank Herbert';
```

**Check (verified):**

```
QUERY PLAN
`--SEARCH books USING INDEX idx_books_author (author=?)
```

`SEARCH ... USING INDEX` = jump straight to the matching rows.
The query didn't change; the database just found a shortcut.

Same for the foreign key in `sales` — joins follow it constantly.
Plan first:

```sql
EXPLAIN QUERY PLAN SELECT * FROM sales WHERE book_id = 1;
```

**Check (verified):** (no index yet)

```
QUERY PLAN
`--SCAN sales
```

Then the index:

```sql
CREATE INDEX idx_sales_book_id ON sales(book_id);
```

Run the same query's EXPLAIN again:

```sql
EXPLAIN QUERY PLAN SELECT * FROM sales WHERE book_id = 1;
```

**Check (verified):**

```
QUERY PLAN
`--SEARCH sales USING INDEX idx_sales_book_id (book_id=?)
```

(`EXPLAIN QUERY PLAN` is a diagnostic — it shows the plan without
running the query. The backtick-dash art is sqlite3's tree
drawing, not something you type.)

## What indexes speed up

- `WHERE` on the indexed column (exact matches, ranges, `IN`)
- Joins on the indexed column (the `ON` condition)
- `ORDER BY` on the indexed column (the index is already sorted)
- `MIN`/`MAX` on the indexed column

What they *don't* speed up: `WHERE` on some *other* column, or
`LIKE '%middle%'` patterns (the index sorts from the start of the
value, so a leading wildcard can't use it).

## When NOT to index

Indexes aren't free. Every `INSERT`, `UPDATE`, and `DELETE` on the
table must also update each index — writes get slower with every
index you add. The honest tradeoffs:

- **Small tables:** a scan of 8 rows is already instant; an index
  adds nothing but bookkeeping. (That's why the bookstore doesn't
  ship with indexes.)
- **Write-heavy tables:** if you insert thousands of rows a minute
  and rarely query them, each index is pure cost.
- **Low-value columns:** an index on a true/false column barely
  narrows anything down.

The working rule: index foreign keys and the columns your `WHERE`
and `JOIN` clauses actually use, then stop. Measure before adding
more — `EXPLAIN QUERY PLAN` is how.

(For tidiness, this chapter's indexes were dropped afterward with
`DROP INDEX idx_books_author;` — re-run `setup.sql` and your
database is pristine again.)

**Next:** [SQLite](sqlite.md)
