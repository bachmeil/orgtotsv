import std.file, std.path, std.regex, std.string;

Regex!char reDate = regex(`(?<=\s<)[0-9]{4}-[0-9]{2}-[0-9]{2}[ ][A-Z][a-z]{2}(?=>(\s|$))`);
Regex!char reTime = regex(`(?<=\s<)[0-9]{1,2}\:[0-9]{2} [ap]m(?=>(\s|$))`);

void main(string[] args) {
  string f = readText(args[1]);
  string[] tasks = "\n" ~ f.split("\n* ");
  string result;
  foreach(task; tasks) {
		if (task.startsWith("* ")) {
			task = task[2..$];
		}
		string[] tmp = task.split("\n");
		string desc = tmp[0];
		if (desc.strip != "") {
			result ~= desc.replace("\t", "\x1F") ~ "\t";
			auto date = matchFirst(desc, reDate);
			if (date.length > 0) {
				result ~= date.hit[0..10];
			}
			result ~= "\t";
			auto time = matchFirst(desc, reTime);
			if (time.length > 0) {
				result ~= time.hit;
			}
			result ~= "\t";
		}
		if (tmp.length > 1) {
			result ~= tmp[1..$].join("\x1E").replace("\t", "\x1F");
		}
		result ~= "\n";
  }
  std.file.write(args[1].setExtension("tsv"), result);
}
