import Foundation

typealias Challenge = ((String?, [String]) -> ())

let challenges: [Challenge] = [
	Day1,
	Day2,
	Day3,
	Day4,
	Day5,
	Day6,
	Day7,
]

func loadInput(path: String) -> String? {
	do {
		let stringList = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
		return stringList
	} catch {
		return nil
	}
}

if Process.arguments.count < 3 {
	print("USAGE: \(Process.arguments[0]) <day> <inputfile> [...]")
	exit(1)
}

guard let day = Int(Process.arguments[1]) else {
	print("Invalid day \(Process.arguments[1])")
	exit(1)
}

if day <= challenges.count {

	let challenge = challenges[day - 1]

	var input: String?
	if Process.arguments[2] != "-" {
		input = loadInput(Process.arguments[2])
	}

	// remaining arguments
	let args = Array(Process.arguments[3..<Process.arguments.count])

	print("Executing Challenge \(day)")

	challenge(input, args)

}
