# Your First Query

You'll use **SQLite**: a free database that lives in a single file
on your computer. No server, no account, no setup beyond installing
one small program. (Why SQLite — and what's special about it — is
in [SQLite](sqlite.md).)

## Install sqlite3

| System    | Command |
|-----------|---------|
| Mac       | Already installed. Open Terminal and type `sqlite3`. |
| Linux     | `sudo apt install sqlite3` (Debian/Ubuntu; use your distro's equivalent otherwise) |
| Windows   | `winget install SQLite.SQLite` in PowerShell, or download the tools ZIP from sqlite.org and put `sqlite3.exe` somewhere on your PATH |

Check it worked:

```bash
sqlite3 --version
```

**Check (verified):**

```
3.45.1 2024-01-30 16:01:20 e876e51a0ed5c5b3126f52e532044363a014bc594cfefa87ffb5b82257ccalt1 (64-bit)
```

Your version number may be newer — that's fine. Every example in
this guide was verified on 3.45.1.

## Build the bookstore

Download `setup.sql` from this guide's files into a folder, then:

```bash
sqlite3 bookstore.db < setup.sql
```

That creates `bookstore.db` — one file, one database — containing
two tables: `books` (8 books) and `sales` (10 sales). You can re-run
it anytime to reset; it drops the tables first.

Open the database and look around:

```bash
sqlite3 bookstore.db
sqlite> .tables
```

**Check (verified):**

```
books  sales
```

(`.tables` is a *dot-command* — an instruction to the sqlite3
program, not SQL. Dot-commands start with a dot; SQL never does.
More of them in [SQLite](sqlite.md).)

## Your first SELECT

At the `sqlite>` prompt:

```sql
SELECT title, author FROM books ORDER BY title;
```

**Check (verified):** (run with `sqlite3 -header -column
bookstore.db "SELECT title, author FROM books ORDER BY title;"`)

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

You just asked the database a question in English-shaped SQL:
"give me the title and author of every book, sorted by title." The
semicolon ends the statement — sqlite3 waits until it sees one.

Reading the query left to right: `SELECT` (what columns I want)
`FROM books` (which table) `ORDER BY title` (how to sort).
That's the skeleton of most queries you'll ever write.

One more, to prove the data is real and sortable:

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

The three cheapest books. `LIMIT 3` says "stop after three rows."

You're querying. The rest of the guide is variations on this
theme: choosing columns, filtering rows, and combining tables.

**Next:** [SELECT: Asking Questions](select.md)
