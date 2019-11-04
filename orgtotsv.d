import std.file, std.path, std.regex, std.stdio, std.string;

Regex!char reDate = regex(`(?<=\s<)[0-9]{4}-[0-9]{2}-[0-9]{2}[ ][A-Z][a-z]{2}(?=>(\s|$))`);
Regex!char reTime = regex(`(?<=\s<)[0-9]{1,2}\:[0-9]{2} [ap]m(?=>(\s|$))`);

void main(string[] args) {
  string f = readText(args[1]);
  string[] tasks = "\n" ~ f.split("\n* ");
  string[] tsvdata;
  foreach(task; tasks) {
		string result;
		/* Skip a task if it's blank - could happen at the beginning or end
		 * of the file, or with strange input */
		if (task.strip == "") {
			continue;
		}
		/* This can only happen on the first line */
		if (task.startsWith("* ")) {
			task = task[2..$];
		}
		/* In case there's a note, only pull metadata from the description */
		string[] tmp = task.strip.split("\n");
		string desc = tmp[0];
		result ~= desc.replace("\t", "\x1F") ~ "\t";
		auto date = matchFirst(desc, reDate);
		/* In case there's no date */
		if (date.length > 0) {
			result ~= date.hit[0..10];
		}
		result ~= "\t";
		auto time = matchFirst(desc, reTime);
		/* In case there's no time */
		if (time.length > 0) {
			result ~= time.hit;
		}
		result ~= "\t";
		/* Handle the note if there is one */
		if (tmp.length > 1) {
			if (tmp[1].strip != "") {
				result ~= tmp[1..$].join("\x1E").replace("\t", "\x1F");
			}
		}
		tsvdata ~= result;
  }
  writeln(tsvdata.join("\n"));
}
