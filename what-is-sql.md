# What Is SQL?

**The one-sentence version:** SQL is the language you use to ask a
database questions ("which books are in stock?") and to tell it to
change things ("this book now costs $19.99").

## The database, in plain terms

A **database** is an organized collection of information that a
program can search, sort, and update quickly. Inside, data lives in
**tables**. A table is a grid:

| id | title        | author          | price |
|----|--------------|-----------------|-------|
| 1  | The Hobbit   | J.R.R. Tolkien  | 12.99 |
| 2  | Dune         | Frank Herbert   | 15.99 |

The vocabulary is small and worth learning exactly:

- **Table** — one grid, one kind of thing. A bookstore has a `books`
  table and a `sales` table.
- **Row** — one horizontal line: a single thing (one book).
- **Column** — one vertical slice: one fact about every thing
  (every book has a title).
- **Key** — a column (or columns) that uniquely identifies a row.
  The **primary key** of the books table is `id`: no two books share
  id 1. A **foreign key** is a column in one table that points at the
  primary key of another — `sales.book_id` points at `books.id`,
  saying "this sale was for that book." Keys are how tables connect
  to each other. ([Glossary](glossary.md) collects all these terms.)

## The spreadsheet analogy (and where it breaks)

A table looks like a spreadsheet, and "rows and columns" is exactly
the right mental image to start with. The analogy breaks in three
places:

1. **Scale.** A spreadsheet groans at a hundred thousand rows; a
   database doesn't notice. Databases are built to search millions
   of rows fast.
2. **Rules.** A database can enforce that every sale points to a
   real book, that prices are numbers, that ids are unique. A
   spreadsheet lets you type anything anywhere.
3. **Sharing.** Dozens of programs can read and write a database at
   once without stepping on each other. A spreadsheet is one file,
   one editor at a time, if you're lucky.

## What SQL is for

SQL does four jobs, and you'll meet all four in this guide:

- **Ask questions** — `SELECT` pulls rows out. "Which books cost
  less than $14?" That's a query.
- **Add rows** — `INSERT` puts new data in.
- **Change rows** — `UPDATE` edits what's there.
- **Remove rows** — `DELETE` takes rows out.

Asking questions is the job you'll do most. Even people who never
change data — analysts, reporters, the curious — live in `SELECT`.

## What SQL is not

- **Not a programming language** in the usual sense. You don't tell
  it *how* to find the answer step by step; you describe *what* you
  want and the database figures out the fastest way. (That "fastest
  way" part is what [Indexes](indexes.md) is about.)
- **Not one single thing.** The core is standardized, but every
  database adds its own extras. This guide sticks to the core, so
  what you learn works in SQLite, Postgres, MySQL, and most others.
- **Not the database itself.** SQL is the *language*; SQLite,
  Postgres, and MySQL are *programs* that understand it. This guide
  uses [SQLite](sqlite.md) because it's free, needs no server, and
  lives in one file.

## The shape of the guide

You'll build a tiny bookstore database, learn to ask it questions
(`SELECT`), change its data safely, combine tables
([Joins](joins.md)), summarize with [Grouping](grouping.md), handle
the tricky [NULL](nulls.md) value, and read error messages without
fear. By the end, "show me total sales per author, cheapest first"
will be a sentence you can write.

**Next:** [Your First Query](your-first-query.md)
