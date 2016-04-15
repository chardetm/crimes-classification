import std.algorithm;
import std.csv;
import std.stdio;
import std.conv;
import std.regex;
import std.array;

int main (string[] args) {
	assert(args.length == 2);
	auto file = File(args[1], "r");
	auto assocArr = file.byLine.joiner("\n").csvReader!(string[string])(null);
	
	if (assocArr.empty) return 0;
	auto keys = assocArr.front.keys;
	
	string[] lineArr;
	foreach (key; keys) {
		if (key == "Dates") {
			lineArr ~= "Year";
			lineArr ~= "Month";
			lineArr ~= "Day";
			lineArr ~= "Hour";
			lineArr ~= "Min";
			lineArr ~= "Sec";
		} else {
			lineArr ~= key;
		}
	}
	writeln(lineArr.joiner(","));
	
	foreach (record; assocArr) {
		lineArr.length = 0;
		foreach (key; keys) {
			auto val = record[key];
			
			if (key == "DayOfWeek") {
				if (val == "Monday") lineArr ~= "1";
				else if (val == "Tuesday") lineArr ~= "2";
				else if (val == "Wednesday") lineArr ~= "3";
				else if (val == "Thursday") lineArr ~= "4";
				else if (val == "Friday") lineArr ~= "5";
				else if (val == "Saturday") lineArr ~= "6";
				else if (val == "Sunday") lineArr ~= "7";
				else {
					stderr.writeln("Warning: unknown day of the week ", val, ", 0 written instead.");
					lineArr ~= "0";
				}
			
			} else if (key == "Dates") {
				// 2015-02-24 16:41:00
				auto splitted = splitter(val, regex("[- :]"));
				foreach (e; splitted)
					lineArr ~= e;
					
			} else {
				lineArr ~= val;
			}
		}
		foreach (ref e; lineArr) {
			if (e.canFind(',')) {
				e = "\""~e~"\"";
			}
		}
		writeln(lineArr.joiner(","));
    }
    
    return 0;
}
