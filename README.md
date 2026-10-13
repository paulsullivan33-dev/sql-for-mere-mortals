# SQL for Mere Mortals

**SQL** (Structured Query Language, pronounced "sequel" or
"S-Q-L" — both are fine) is the language you use to ask a database
questions and to change what it stores. Nearly every app you've ever
used — your bank, your library, the store down the street — keeps
its records in a database, and SQL is how people read and write
those records.

This guide teaches you to ask questions of a real database from
chapter one, using a tiny bookstore dataset you'll build yourself.
No CS degree required. Ideas first, then real queries with real
output.

## What this guide covers

- **What a database is** — tables, rows, columns, keys
- **Your first query** — installing SQLite, building the sample
  bookstore
- **SELECT** — asking for columns, filtering rows, sorting,
  limiting
- **Changing data** — INSERT, UPDATE, DELETE, and transactions
- **Joins** — combining two tables into one answer
- **Grouping** — COUNT, SUM, AVG, and GROUP BY
- **NULLs** — the "we don't know" value and why it's tricky
- **Indexes** — what makes queries fast
- **SQLite** — the free database this guide uses
- **Troubleshooting** — reading error messages, fixing the common
  ones

## What it doesn't cover

Window functions, stored procedures, user/permission management,
Postgres or MySQL administration, and database performance tuning.
Those are real skills; they're just beyond this guide's scope. What
you learn here transfers directly — the SQL in these chapters runs
on almost every database system.

## How to use this guide

Every SQL example was executed against real sqlite3 3.45.1 before
shipping — outputs are real. Build the sample database once with
`setup.sql` (see [Your First Query](your-first-query.md)) and run
each example yourself. **Check:** blocks show verified output.
**Careful:** marks statements that change or destroy data.

## Chapters

1. [What Is SQL?](what-is-sql.md)
2. [Your First Query](your-first-query.md)
3. [SELECT: Asking Questions](select.md)
4. [Changing Data](changing-data.md)
5. [Joins: Combining Tables](joins.md)
6. [Grouping and Aggregates](grouping.md)
7. [NULLs](nulls.md)
8. [Indexes](indexes.md)
9. [SQLite](sqlite.md)
10. [Troubleshooting](troubleshooting.md)
11. [Glossary](glossary.md)

*Written to the [nine-point writing standard](criteria.md) shared by
every guide in this series.*
