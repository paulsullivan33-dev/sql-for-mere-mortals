# NULLs

**NULL** means "we don't know" — not zero, not an empty string, not
"none." The Dispossessed's year is NULL because the year wasn't
recorded, not because it was published in year zero. Treating NULL
as a value is the single most common source of SQL surprises, so
this chapter is short and worth reading twice.

## IS NULL, not = NULL

To find the unknown values, use `IS NULL`:

```sql
SELECT title, year FROM books WHERE year IS NULL;
```

**Check (verified):**

```
title             year
----------------  ----
The Dispossessed
```

The natural-looking version returns *nothing* — the output is
literally empty, not even a header row:

```sql
SELECT title FROM books WHERE year = NULL;
```

**Check (verified):**

```
```

This is not a bug. `= NULL` asks "is this unknown value equal to
that unknown value?" — and the answer to any comparison involving
an unknown is "unknown," which `WHERE` treats as "no." So `= NULL`
never matches, not even NULL itself. The rule: **always `IS NULL`
or `IS NOT NULL`, never `= NULL`.**

```sql
SELECT title, year FROM books WHERE year IS NOT NULL ORDER BY year;
```

**Check (verified):**

```
title                      year
-------------------------  ----
The Hobbit                 1937
Foundation                 1951
Dune                       1965
A Wizard of Earthsea       1968
The Left Hand of Darkness  1969
Neuromancer                1984
Snow Crash                 1992
```

## COALESCE: a stand-in for the unknown

`COALESCE` returns its first non-NULL argument — "use this, unless
it's unknown, then use that":

```sql
SELECT title, COALESCE(CAST(year AS TEXT), 'year unknown') AS year
FROM books
ORDER BY title;
```

**Check (verified):**

```
title                      year
-------------------------  ------------
A Wizard of Earthsea       1968
Dune                       1965
Foundation                 1951
Neuromancer                1984
Snow Crash                 1992
The Dispossessed           year unknown
The Hobbit                 1937
The Left Hand of Darkness  1969
```

(Perfect for reports: the reader sees "year unknown" instead of a
blank.) It takes any number of arguments and picks the first one
that isn't NULL.

## NULL in aggregates: silently skipped

```sql
SELECT COUNT(year) AS years_known FROM books;
```

**Check (verified):**

```
years_known
-----------
7
```

Seven, not eight — `COUNT(year)` counts known years only, while
`COUNT(*)` counts rows. `SUM`, `AVG`, `MIN`, `MAX` all skip NULLs
the same way. An average over the known values is usually what you
want; just remember the unknown ones weren't counted.

## NULL in ORDER BY: first, in SQLite

```sql
SELECT title, year FROM books ORDER BY year LIMIT 4;
```

**Check (verified):**

```
title             year
----------------  ----
The Dispossessed
The Hobbit        1937
Foundation        1951
Dune              1965
```

SQLite sorts NULLs before everything else in ascending order
(other databases differ — some put them last). Flip to `DESC`:

```sql
SELECT title, year FROM books ORDER BY year DESC LIMIT 4;
```

**Check (verified):**

```
title                      year
-------------------------  ----
Snow Crash                 1992
Neuromancer                1984
The Left Hand of Darkness  1969
A Wizard of Earthsea       1968
```

NULLs sink to the bottom in descending order. If your top-10 list
looks short, a NULL may be hiding at the far end.

## The three rules, taped to the monitor

1. **NULL means "unknown"** — never zero, never empty string.
2. **Test with `IS NULL` / `IS NOT NULL`** — `= NULL` never matches
   anything.
3. **Aggregates skip NULLs; ORDER BY sorts them first** (in
   SQLite) — check both when results look off.

**Next:** [Indexes](indexes.md)
