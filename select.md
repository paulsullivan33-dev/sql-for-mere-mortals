# SELECT: Asking Questions

`SELECT` is the question-asking statement. You'll use it more than
everything else in SQL combined, so this chapter is the longest.
Every example runs against the bookstore database from [Your First
Query](your-first-query.md).

## Choose your columns

Name the columns you want, in the order you want them:

```sql
SELECT title, author FROM books ORDER BY title;
```

**Check (verified):**

```
title                      author
-------------------------  -----------------
A Wizard of Earthsea       Ursula K. Le Guin
Dune                       Frank Herbert
Foundation                 Isaac Asimov
Neuromancer                William Gibson
Snow Crash                 Neal Stephenson
The Dispossessed           Ursula K. Le Guin
The Hobbit                 J.R.R. Tolkien
The Left Hand of Darkness  Ursula K. Le Guin
```

The `*` means "all columns":

```sql
SELECT * FROM books WHERE id = 1;
```

**Check (verified):**

```
id  title       author          year  price  in_stock
--  ----------  --------------  ----  -----  --------
1   The Hobbit  J.R.R. Tolkien  1937  12.99  14
```

`*` is handy for exploring; in real queries, name your columns —
it's clearer and it keeps working if someone adds a column later.

## WHERE: filter the rows

`WHERE` keeps only rows matching a condition (called a
**predicate**). Comparison operators:

| Operator | Meaning                  |
|----------|--------------------------|
| `=`      | equal                    |
| `!=` or `<>` | not equal            |
| `<`      | less than                |
| `<=`     | less than or equal       |
| `>`      | greater than             |
| `>=`     | greater than or equal    |

```sql
SELECT title, price FROM books WHERE price < 14 ORDER BY price;
```

**Check (verified):**

```
title                 price
--------------------  -----
A Wizard of Earthsea  10.99
Foundation            11.99
The Hobbit            12.99
Neuromancer           13.5
The Dispossessed      13.99
```

Text comparisons use `=` too, with single quotes:

```sql
SELECT title, year FROM books WHERE author = 'Ursula K. Le Guin' ORDER BY year;
```

**Check (verified):**

```
title                      year
-------------------------  ----
The Dispossessed
A Wizard of Earthsea       1968
The Left Hand of Darkness  1969
```

(Single quotes around text; double quotes mean something else in
SQL — a column name. And note the blank year on The Dispossessed:
that's a [NULL](nulls.md), not a zero.)

## AND, OR, NOT: combine conditions

```sql
SELECT title, price FROM books WHERE price >= 15 AND in_stock > 0 ORDER BY price;
```

**Check (verified):**

```
title       price
----------  -----
Dune        15.99
Snow Crash  16.99
```

```sql
SELECT title, in_stock FROM books WHERE in_stock = 0 OR price > 16 ORDER BY title;
```

**Check (verified):**

```
title        in_stock
-----------  --------
Neuromancer  0
Snow Crash   3
```

```sql
SELECT title, in_stock FROM books WHERE NOT (in_stock = 0) ORDER BY title;
```

**Check (verified):**

```
title                      in_stock
-------------------------  --------
A Wizard of Earthsea       7
Dune                       8
Foundation                 11
Snow Crash                 3
The Dispossessed           4
The Hobbit                 14
The Left Hand of Darkness  5
```

Parentheses matter when you mix them: `WHERE a AND b OR c` means
`(a AND b) OR c`, because `AND` binds tighter than `OR`. When in
doubt, add parentheses — they cost nothing and prevent surprises.

## LIKE: pattern matching

`LIKE` matches text against a pattern. `%` means "any characters"
(including none):

```sql
SELECT title, author FROM books WHERE author LIKE '%Le Guin%';
```

**Check (verified):**

```
title                      author
-------------------------  -----------------
The Left Hand of Darkness  Ursula K. Le Guin
A Wizard of Earthsea       Ursula K. Le Guin
The Dispossessed           Ursula K. Le Guin
```

`LIKE 'The%'` matches titles starting with "The"; `LIKE '%ss'`
matches text ending in "ss". (`_` matches exactly one character.)

## IN and BETWEEN: lists and ranges

`IN` tests against a list:

```sql
SELECT title, author FROM books WHERE author IN ('Frank Herbert', 'Isaac Asimov') ORDER BY author;
```

**Check (verified):**

```
title       author
----------  -------------
Dune        Frank Herbert
Foundation  Isaac Asimov
```

`BETWEEN` tests a range — inclusive on both ends:

```sql
SELECT title, year FROM books WHERE year BETWEEN 1960 AND 1970 ORDER BY year;
```

**Check (verified):**

```
title                      year
-------------------------  ----
Dune                       1965
A Wizard of Earthsea       1968
The Left Hand of Darkness  1969
```

## ORDER BY: sort the answer

```sql
SELECT title, price FROM books ORDER BY price DESC;
```

**Check (verified):**

```
title                      price
-------------------------  -----
Snow Crash                 16.99
Dune                       15.99
The Left Hand of Darkness  14.0
The Dispossessed           13.99
Neuromancer                13.5
The Hobbit                 12.99
Foundation                 11.99
A Wizard of Earthsea       10.99
```

`ASC` (ascending) is the default; `DESC` reverses it. You can sort
by multiple columns: `ORDER BY author, year` sorts by author, then
year within each author.

**Without ORDER BY, row order is not promised.** SQLite often
returns rows in insertion order, but that's a habit, not a rule. If
order matters to you — it usually does — say so with ORDER BY.

## LIMIT and OFFSET: take a slice

```sql
SELECT title, price FROM books ORDER BY price LIMIT 3;
```

**Check (verified):**

```
title                 price
--------------------  -----
A Wizard of Earthsea  10.99
Foundation            11.99
The Hobbit            12.99
```

```sql
SELECT title, price FROM books ORDER BY price LIMIT 3 OFFSET 3;
```

**Check (verified):**

```
title                      price
-------------------------  -----
Neuromancer                13.5
The Dispossessed           13.99
The Left Hand of Darkness  14.0
```

`LIMIT 3 OFFSET 3` skips the first three and takes the next three —
that's "page 2" of a three-per-page list.

## DISTINCT: remove duplicates

```sql
SELECT DISTINCT author FROM books ORDER BY author;
```

**Check (verified):**

```
author
-----------------
Frank Herbert
Isaac Asimov
J.R.R. Tolkien
Neal Stephenson
Ursula K. Le Guin
William Gibson
```

Eight books, six authors — the three Le Guin rows collapse to one.

## AS: rename a column

`AS` gives a result column a nicer name, and names the result of a
calculation:

```sql
SELECT title AS book_title, price * 0.9 AS sale_price FROM books ORDER BY sale_price LIMIT 3;
```

**Check (verified):**

```
book_title            sale_price
--------------------  ----------
A Wizard of Earthsea  9.891
Foundation            10.791
The Hobbit            11.691
```

SELECT isn't limited to stored columns — any expression works:

```sql
SELECT title, in_stock - 5 AS low_stock_warning FROM books WHERE in_stock < 5 ORDER BY in_stock;
```

**Check (verified):**

```
title             low_stock_warning
----------------  -----------------
Neuromancer       -5
Snow Crash        -2
The Dispossessed  -1
```

(How many below the reorder point of 5 each title sits. Negative
means below.)

## The shape of a SELECT

Almost every query you'll write follows this order:

```text
SELECT <columns or expressions>
FROM <table>
WHERE <row filter>
GROUP BY <grouping>      -- Grouping chapter
HAVING <group filter>    -- Grouping chapter
ORDER BY <sort>
LIMIT <how many> OFFSET <skip>;
```
(a schematic, not a runnable query — the clauses must appear in
this order)

Only `SELECT` and `FROM` are required; the rest are optional. The
clauses must appear in this order — `WHERE` before `ORDER BY`,
`ORDER BY` before `LIMIT`.

**Next:** [Changing Data](changing-data.md)
