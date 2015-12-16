import Darwin

// Day 1: Not Quite Lisp
// http://adventofcode.com/day/1

let directions = "(()()("

func Day1(input: String?, args: [String]) {

	if args.count < 1 {
		print("USAGE: \(Process.arguments[0]) 1 - \"()()()))\"")
		exit(1)
	}

	var floor = 0
	var basement = false
	for (idx, char) in args[0].characters.enumerate() {
		if char == "(" {
			floor += 1
		} else if char == ")" {
			floor -= 1
		} else {
			print("Not a real thing: \(char)")
		}

		if floor < 0 && !basement{
			print("Entered basement (\(floor)) at step \(idx + 1)")
			basement = true
		}
	}

	print("Directions \"\(directions)\" lead to floor \(floor)")

}