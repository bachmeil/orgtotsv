# Examples

See the Makefile for the commands.

`make example1` will execute the first example. It prints the conversion
to the screen.

`make example2` executes the second example. It pipes the output to
tsv-filter to capture all tasks due in the next two days. tsv-select
puts the date in the first column. sort orders the tasks in ascending
order of due date. A second call to tsv-select returns only the task
description.

Note that this example does not show how to convert the ascii control
codes for record separator back to line feed or unit separator back to
tab.
