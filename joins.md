# Joins: Combining Tables

## Why two tables instead of one wide one?

You *could* store every sale as one giant row: book title, author,
price, sale date, quantity, all together. The problem: the title
"Foundation" would be repeated in every sale row, and if you ever
fixed a typo in it, you'd have to fix every copy. Split the data
instead:

- `books`: one row per book — title, author, price, stock.
- `sales`: one row per sale — *which* book, date, quantity.

Each fact lives in exactly one place. The `book_id` column in
`sales` is a **foreign key**: it holds the `id` (**primary key**) of
a row in `books`, linking the two tables. A **join** follows those
links to reassemble a combined answer.

## INNER JOIN: only matches

"Show each sale with the book's title":

```sql
SELECT books.title, sales.sale_date, sales.quantity
FROM books
INNER JOIN sales ON sales.book_id = books.id
ORDER BY sales.sale_date;
```

**Check (verified):**

```
title                      sale_date   quantity
-------------------------  ----------  --------
The Hobbit                 2026-10-01  2
Dune                       2026-10-01  1
The Hobbit                 2026-10-03  1
Foundation                 2026-10-04  3
Neuromancer                2026-10-05  1
A Wizard of Earthsea       2026-10-06  2
Dune                       2026-10-08  2
Snow Crash                 2026-10-09  1
The Left Hand of Darkness  2026-10-10  1
The Hobbit                 2026-10-12  1
```

The `ON` clause is the matching rule: a sale row pairs with the
book row whose `id` equals the sale's `book_id`. `INNER` means keep
only rows that match on *both* sides. Notice The Dispossessed is
absent — it has no sales, so there's nothing to pair it with.

Table aliases (`b`, `s`) keep this readable, and plain `JOIN` means
`INNER JOIN`:

```sql
SELECT b.title, s.sale_date, s.quantity
FROM books b
JOIN sales s ON s.book_id = b.id
ORDER BY s.sale_date;
```

**Check (verified):** (same 10 rows)

```
title                      sale_date   quantity
-------------------------  ----------  --------
The Hobbit                 2026-10-01  2
Dune                       2026-10-01  1
The Hobbit                 2026-10-03  1
Foundation                 2026-10-04  3
Neuromancer                2026-10-05  1
A Wizard of Earthsea       2026-10-06  2
Dune                       2026-10-08  2
Snow Crash                 2026-10-09  1
The Left Hand of Darkness  2026-10-10  1
The Hobbit                 2026-10-12  1
```

## LEFT JOIN: keep everything on the left

"Show *every* book, with its sales if it has any":

```sql
SELECT b.title, s.sale_date, s.quantity
FROM books b
LEFT JOIN sales s ON s.book_id = b.id
ORDER BY b.title, s.sale_date;
```

**Check (verified):**

```
title                      sale_date   quantity
-------------------------  ----------  --------
A Wizard of Earthsea       2026-10-06  2
Dune                       2026-10-01  1
Dune                       2026-10-08  2
Foundation                 2026-10-04  3
Neuromancer                2026-10-05  1
Snow Crash                 2026-10-09  1
The Dispossessed
The Hobbit                 2026-10-01  2
The Hobbit                 2026-10-03  1
The Hobbit                 2026-10-12  1
The Left Hand of Darkness  2026-10-10  1
```

Eleven rows this time. The Dispossessed appears with empty
sale columns — `LEFT JOIN` keeps every row from the left table
(`books`) even when nothing on the right matches, filling the
missing side with [NULL](nulls.md).

That makes LEFT JOIN the tool for "find the ones with no match":

```sql
SELECT b.title
FROM books b
LEFT JOIN sales s ON s.book_id = b.id
WHERE s.id IS NULL;
```

**Check (verified):**

```
title
----------------
The Dispossessed
```

"Which books have never sold?" Join everything, then keep the rows
where the right side came back NULL.

## Joining across sales for totals

Because the join reassembles the full picture, you can compute
across both tables — here, the money each sale brought in:

```sql
SELECT s.sale_date, b.title, s.quantity, b.price * s.quantity AS line_total
FROM sales s
JOIN books b ON b.id = s.book_id
ORDER BY s.sale_date
LIMIT 5;
```

**Check (verified):**

```
sale_date   title        quantity  line_total
----------  -----------  --------  ----------
2026-10-01  The Hobbit   2         25.98
2026-10-01  Dune         1         15.99
2026-10-03  The Hobbit   1         12.99
2026-10-04  Foundation   3         35.97
2026-10-05  Neuromancer  1         13.5
```

Note the direction flipped: `FROM sales s JOIN books b` with `ON
b.id = s.book_id`. The left/right choice is yours — what reads
naturally for the question.

## The three joins at a glance

| Join | Keeps | Use when |
|------|-------|----------|
| `INNER JOIN` (or `JOIN`) | Only rows that match on both sides | "sales *with* their book titles" |
| `LEFT JOIN` | All left-table rows, matches where they exist | "all books, *even* ones with no sales" |
| `RIGHT JOIN` | All right-table rows, matches where they exist | Rarely needed — swap the table order and use LEFT JOIN instead |
| `FULL JOIN` | All rows from both tables | "everything from both sides, matched where possible" |

An honest limit worth knowing early: joins multiply rows. One book
with three sales produces three joined rows — that's correct, but it
surprises people when they then COUNT the rows and get "too many."
[Grouping](grouping.md) handles that next.

**Next:** [Grouping and Aggregates](grouping.md)
