import Foundation

// Day 8: Matchsticks
// http://adventofcode.com/day/8

extension String {

	var escapedCount: Int {
		get {
			var chars: Int = 0
			for var idx = self.startIndex; idx != self.endIndex; idx = idx.successor() {
				if self[idx] == "\\" {
					idx = idx.successor()
					if self[idx] == Character("x") {
						idx = idx.successor().successor()
					}
				}
				chars += 1
			}
			return chars - 2
		}
	}

	var escaped: String {
		get {
			var chars = [Character]([Character("\"")])
			for var idx = self.startIndex; idx != self.endIndex; idx = idx.successor() {
				if self[idx] == Character("\"") {
					chars.append(Character("\\"))
				} else if self[idx] == Character("\\") {
					chars.append(Character("\\"))
				}
				chars.append(self[idx])
			}
			chars.append(Character("\""))
			return String(chars)
		}
	}

}

func Day8(input: String?, args: [String]) {

	guard let rawStrings = input else {
		print("USAGE: \(Process.arguments[0]) 8 <inputfile>")
		return
	}

	var differencePartA: Int = 0
	var differencePartB: Int = 0
	let strings = rawStrings.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
	for string in strings {
		differencePartA += (string.characters.count - string.escapedCount)
		differencePartB += (string.escaped.characters.count - string.characters.count)
	}

	print("Difference (Part A): \(differencePartA)")
	print("Difference (Part B): \(differencePartB)")
}