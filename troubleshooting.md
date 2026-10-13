# Troubleshooting

SQL error messages are terse but honest: they name the problem and
usually point at the spot. Every message below is real output from
sqlite3 3.45.1 against the bookstore database.

## How to read an error message

```
Error: in prepare, no such column: titl
  SELECT titl FROM books;
         ^--- error here
```

Two parts: the complaint (`no such column: titl`) and a caret
showing where the parser gave up. Start at the caret, then look
*just before it* — the actual mistake is often the token before the
one flagged. (A missing comma after `title` would flag the *next*
word, for example.)

## Symptom → fix

| Symptom (real message) | Cause | Fix |
|---|---|---|
| `no such table: book` | Table name misspelled, or you're in the wrong database file | `.tables` to see what exists; check spelling (`book` vs `books`) |
| `no such column: titl` | Column name misspelled | `.schema books` to see the real column names |
| `near "FROM": syntax error` | Broken SQL just before FROM — e.g. a trailing comma (`SELECT title, FROM books;`) | Read the caret; remove the stray comma |
| `unrecognized token: "'Tolkien;"` | Unterminated string — the closing `'` is missing | Close the quote: `... = 'Tolkien';` |
| `ambiguous column name: id` | Both joined tables have `id`; the database can't tell which you mean | Qualify it: `books.id` or `sales.id` |
| `UNIQUE constraint failed: books.id` | INSERT reuses an existing primary key | Let the database assign the id — omit it from the INSERT |
| `datatype mismatch` | Text into an `INTEGER PRIMARY KEY` (`VALUES ('abc', ...)`) | Use an integer id, or omit the column |
| Query runs, returns nothing | WHERE is too strict — or you compared with `= NULL`, which never matches (see [NULLs](nulls.md)) | Loosen the WHERE; test each condition separately; use `IS NULL` |

The "returns nothing" case deserves emphasis because there's no
error to read — the query is *valid*, just *picky*:

```sql
SELECT title FROM books WHERE year = NULL;
```

**Check (verified):** runs clean, returns zero rows (not even a
header). The fix is `WHERE year IS NULL`. When a query returns less
than you expect, suspect NULLs first and an over-strict WHERE
second.

Another quiet one — SQLite won't stop you comparing a number
column to text; it just finds no match:

```sql
SELECT title FROM books WHERE in_stock = 'lots';
```

**Check (verified):** runs clean, returns zero rows. No error, no
warning. (`in_stock` holds numbers; `'lots'` matches none of
them.) If a WHERE on a numeric column returns nothing, check your
quotes.

## Debugging routine

1. **Read the message out loud.** It names the complaint; the
   caret names the neighborhood.
2. **Check names against `.schema`.** Typos in table/column names
   are the #1 cause.
3. **Halve the query.** Remove half the clauses; if it works, the
   bug is in the half you removed. Repeat.
4. **Run the WHERE as a SELECT.** For UPDATE/DELETE surprises,
   SELECT the same WHERE first and look at what it catches (the
   [safe pattern](changing-data.md)).
5. **Re-run `setup.sql`.** If experiments left the data in a weird
   state, reset and try again.

**Next:** [Glossary](glossary.md)
