# Introduction

This program converts a particular type of org-mode file into tsv format
for further processing by tsv-utils (or any other program that works
with tsv files).

I wrote this to make it easy to run queries on my org-mode files holding
various lists of tasks, things to revisit in the future, etc. I haven't
found a better way to capture these lists than using org-mode in Emacs.
Having said that, org files are just text files that can be created/edited
in any text editor. It is therefore possible for you to use orgtotsv without
touching Emacs.

You can obviously query org files in Emacs. However, I don't always have
Emacs available, or maybe I don't want to limit myself to working in
Emacs (there are a lot of other things I might want to do with these
files). Moreover, org-mode can sometimes be unfriendly depending
on what you're trying to do, and it's not always well documented.

# Installation

There is really no installation. Just do the following:

```
dmd orgtotsv
```

and you're done. Any recent (last few years) version of dmd should work.
Although it hasn't been tested, it should work with recent versions of
LDC and GDC too.

# Example

Suppose you have a file named things.org:

```
* Eat breakfast <6:00 am>
* Buy groceries <2019-10-28 Mon> @home #essentials
- Pork chops
- Ham
- Bacon
- Steak
- Cheese
- Beer
- Wine
- Rum
- Vodka
* Read the Smith paper @office #research #reading
* Meet the plumber <2019-10-29 Tue> <11:30 am>
He needs to check the downstairs sink. It's been draining slowly for a
week now, even though I dumped a bottle of drain opener inside it.
* Eat dinner with Michael Howley #work #sales <2019-10-30 Wed> <7:30 pm>
Important points:
- We've won service awards.
- We have the lowest price.
- We can customize any of our products, and we're the only ones in this
    market that will do that.
```

There are a few things to note about this file. I might want to query
by context (items that start with `@`) or by tag (items that start with
`#`). Those appear in the task description. If I want to view all `@office`
tasks when I get to the office in the morning, I can use tsv-utils to
query the task description for items with an appropriate regex.

Some items have notes associated with them. I don't just want a reminder
to buy groceries. I want to be able to see my entire grocery list. The
notes will be hidden in org-mode by default, but they will appear as
regular lines in the .org file itself. orgtotsv will add the entire note
as a part of the task, after converting line feeds and tabs to the 
appropriate ascii control codes. The notes themselves can be written in
markdown format if you want. There is no need for the notes to be written
in org-mode format.

Some items have dates and/or times associated with them. I may want to
view all items with a date of today or tomorrow. orgtotsv will pull that
information out from each task description (the first line) and add them
to the tsv file. If one or both are not there, it will be blank.

Running

```
./orgtotsv things.org
```

prints the output to the screen. This example file and its output is
found in the repo. You can use

```
./orgtotsv things.org > things.tsv
```

to write the file to disk if that's what you need. It prints to stdout
because the intended use case is piping into tsv-utils. See the examples
folder for an example showing how to filter for all tasks due in the
next two days sorted by date.

The output is in four columns. Column 1 is the task description, column
2 is the date in YYYY-MM-DD format, column 3 is the time in HH:MM am or
H:MM am format, and column 4 is the note associated with that task.

This is the entirety of what orgtotsv does. The tsv file can then be
queried using tsv-utils. You will want to replace the control codes for
the unit separator (hex 1F) with `\t` and the record separator (hex 1E)
with `\n` in order to recover the original values of the notes.
