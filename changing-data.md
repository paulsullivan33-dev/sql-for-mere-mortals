# Changing Data

Reading is safe; writing is where mistakes cost you. This chapter
covers `INSERT`, `UPDATE`, and `DELETE` — plus transactions, the
undo button SQL gives you. Run the examples in order against a fresh
`setup.sql` load: they change the data, so each output depends on
the ones before it.

## INSERT: add rows

Name the columns, then the values:

```sql
INSERT INTO books (title, author, year, price, in_stock)
VALUES ('Kindred', 'Octavia E. Butler', 1979, 14.99, 6);
```

INSERT prints nothing on success — check it with a SELECT:

```sql
SELECT id, title, author FROM books WHERE author = 'Octavia E. Butler';
```

**Check (verified):**

```
id  title    author
--  -------  -----------------
9   Kindred  Octavia E. Butler
```

The database assigned `id` 9 itself — that's the `INTEGER PRIMARY
KEY` auto-assigning the next rowid (see [SQLite](sqlite.md)). You
can insert several rows with one statement:

```sql
INSERT INTO sales (book_id, sale_date, quantity)
VALUES (2, '2026-10-13', 1),
       (5, '2026-10-13', 2);
```

```sql
SELECT id, book_id, sale_date, quantity FROM sales WHERE sale_date = '2026-10-13';
```

**Check (verified):**

```
id  book_id  sale_date   quantity
--  -------  ----------  --------
11  2        2026-10-13  1
12  5        2026-10-13  2
```

Two rows, one statement. (The ids are 11 and 12 because the table
already held rows 1–10.)

## UPDATE: change rows

**Careful:** `UPDATE` without a `WHERE` clause changes *every row*
in the table. Always write the WHERE first, and prove it with a
SELECT before you run the UPDATE:

```sql
-- Step 1: look at exactly the rows you're about to touch
SELECT title, price FROM books WHERE title = 'Dune';

-- Step 2: same WHERE, now change them
UPDATE books SET price = 19.99 WHERE title = 'Dune';
```

`changes()` tells you how many rows the last statement touched
(same sqlite3 session — it resets every connection):

```sql
UPDATE books SET price = 19.99 WHERE title = 'Dune';
SELECT changes();
```

**Check (verified):**

```
changes()
---------
1
```

```sql
SELECT title, price FROM books WHERE title = 'Dune';
```

**Check (verified):**

```
title  price
-----  -----
Dune   19.99
```

One row changed, as intended. The safe pattern — **SELECT first
with the same WHERE, then UPDATE** — is the habit that prevents the
"oh no, I repriced the whole store" moment. If the SELECT shows the
wrong rows, your WHERE is wrong and nothing is damaged yet.

You can set several columns at once: `SET price = 19.99, in_stock =
in_stock - 1 WHERE title = 'Dune';`

## DELETE: remove rows

**Careful:** `DELETE` without `WHERE` empties the whole table. Same
safe pattern — SELECT first, then delete:

```sql
-- Step 1: look
SELECT id, book_id, sale_date, quantity FROM sales WHERE sale_date = '2026-10-13';
```

**Check (verified):**

```
id  book_id  sale_date   quantity
--  -------  ----------  --------
11  2        2026-10-13  1
12  5        2026-10-13  2
```

```sql
-- Step 2: delete
DELETE FROM sales WHERE sale_date = '2026-10-13';
SELECT changes();
```

**Check (verified):**

```
changes()
---------
2
```

```sql
SELECT COUNT(*) AS sales_count FROM sales;
```

**Check (verified):**

```
sales_count
-----------
10
```

Back to the original 10 rows. DELETE removes whole rows only —
there's no "delete just this column" (that's what UPDATE … SET …
NULL is for; see [NULLs](nulls.md)).

## Transactions: the undo button

A **transaction** groups statements into an all-or-nothing unit.
`BEGIN` starts one; `COMMIT` saves everything; `ROLLBACK` throws it
all away. Watch — this deletes every sale, then un-deletes them:

```sql
BEGIN;
DELETE FROM sales;
SELECT COUNT(*) AS inside_transaction FROM sales;
ROLLBACK;
SELECT COUNT(*) AS after_rollback FROM sales;
```

**Check (verified):** (run as one sqlite3 invocation — a
transaction can't span separate connections)

```
inside_transaction
------------------
0
after_rollback
--------------
10
```

Inside the transaction the table was empty; `ROLLBACK` restored all
10 rows as if nothing happened. Use this shape whenever you're
nervous:

1. `BEGIN;`
2. Run your UPDATE or DELETE.
3. SELECT to check the result.
4. Happy? `COMMIT;` — Not happy? `ROLLBACK;`

One honest limit: `ROLLBACK` can't undo a `COMMIT`. Once committed,
it's permanent (short of restoring a backup). The transaction
protects you *before* you commit, not after.

## Final state check

```sql
SELECT COUNT(*) AS final_books, (SELECT COUNT(*) FROM sales) AS final_sales FROM books;
```

**Check (verified):**

```
final_books  final_sales
-----------  -----------
9            10
```

Nine books (the original eight plus Kindred) and the original ten
sales. If you want a pristine copy again, re-run `setup.sql`.

**Next:** [Joins: Combining Tables](joins.md)
