# Grouping and Aggregates

Individual rows answer "what happened"; **aggregates** answer "what
does it add up to." An aggregate function takes many rows in and
produces one value out: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`.

## One number from many rows

```sql
SELECT COUNT(*) AS book_count FROM books;
```

**Check (verified):**

```
book_count
----------
8
```

```sql
SELECT SUM(quantity) AS total_copies_sold FROM sales;
```

**Check (verified):**

```
total_copies_sold
-----------------
15
```

```sql
SELECT AVG(price) AS avg_price, MIN(price) AS cheapest, MAX(price) AS priciest FROM books;
```

**Check (verified):**

```
avg_price  cheapest  priciest
---------  --------  --------
13.805     10.99     16.99
```

No WHERE, no grouping — the aggregate collapses the whole table to
a single row.

## GROUP BY: one number per group

Add `GROUP BY` to compute the aggregate separately for each group
— "how many books per author":

```sql
SELECT author, COUNT(*) AS books
FROM books
GROUP BY author
ORDER BY books DESC, author;
```

**Check (verified):**

```
author             books
-----------------  -----
Ursula K. Le Guin  3
Frank Herbert      1
Isaac Asimov       1
J.R.R. Tolkien     1
Neal Stephenson    1
William Gibson     1
```

The database sorts rows into buckets by `author`, counts each
bucket, and returns one row per bucket. (The extra `, author` in
ORDER BY keeps the five one-book authors in a stable order.)

## HAVING: filter the groups

`WHERE` filters *rows before* grouping; `HAVING` filters *groups
after* grouping. "Authors with more than one book":

```sql
SELECT author, COUNT(*) AS books
FROM books
GROUP BY author
HAVING COUNT(*) > 1;
```

**Check (verified):**

```
author             books
-----------------  -----
Ursula K. Le Guin  3
```

| | WHERE | HAVING |
|---|---|---|
| Filters | individual rows, *before* grouping | groups, *after* grouping |
| Can use | columns and expressions | aggregates like `COUNT(*)`, `AVG(price)` |
| Example | `WHERE price > 13` — drop cheap books first | `HAVING AVG(price) > 13` — drop cheap-author groups |

They compose — filter rows, group, then filter groups:

```sql
SELECT author, AVG(price) AS avg_price
FROM books
WHERE year IS NOT NULL
GROUP BY author
HAVING AVG(price) > 13
ORDER BY avg_price;
```

**Check (verified):**

```
author           avg_price
---------------  ---------
William Gibson   13.5
Frank Herbert    15.99
Neal Stephenson  16.99
```

(The `WHERE year IS NOT NULL` drops The Dispossessed before
grouping — more on NULLs in [NULLs](nulls.md).)

## COUNT(*) vs COUNT(column)

```sql
SELECT COUNT(*) AS all_books, COUNT(year) AS books_with_year FROM books;
```

**Check (verified):**

```
all_books  books_with_year
---------  ---------------
8          7
```

`COUNT(*)` counts rows — all 8. `COUNT(year)` counts non-NULL
values in that column — 7, because The Dispossessed has no year.
Aggregates (except `COUNT(*)`) silently skip NULLs. Usually that's
what you want; just know it's happening.

## The aggregation pipeline

For a query with all the clauses, the database works in this order
— not the order you typed them:

1. `FROM` — gather the tables
2. `WHERE` — drop rows that don't qualify
3. `GROUP BY` — sort the survivors into buckets
4. `HAVING` — drop buckets that don't qualify
5. `SELECT` — compute the output columns (aggregates included)
6. `ORDER BY`, `LIMIT` — sort and trim

That's why `WHERE` can't use an aggregate (`WHERE COUNT(*) > 1`
fails — the groups don't exist yet) and why `HAVING` can't use a
`SELECT` alias in some databases. Order of typing is for humans;
order of execution is for the machine.

**Next:** [NULLs](nulls.md)
