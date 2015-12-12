import Foundation

// Day 5: Doesn't He Have Intern-Elves For This?
// http://adventofcode.com/day/5

if Process.arguments.count < 2 {
	print("USAGE: \(Process.arguments[0]) <inputfile>")
	exit(1)
}

func readStrings(path: String) -> [String]? {
	do {
		let stringList = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
		return stringList.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
	} catch {
		return nil
	}
}

guard let strings = readStrings(Process.arguments[1]) else {
	print("File \(Process.arguments[1]) does not exist")
	exit(1)
}

extension String {

	func isNice1() -> Bool {
		let threeVowels = (self.rangeOfString(".*[aeiou].*[aeiou].*[aeiou].*", options: .RegularExpressionSearch) != nil)
		let hasBannedSubstring = ["ab", "cd", "pq", "xy"].reduce(false, combine: {
				if self.containsString($1) {
					return true
				}
			return $0
		})
		return threeVowels && self.containsDoubleCharacter(0) && !hasBannedSubstring
	}

	func isNice2() -> Bool {
		return self.containsDoubleCharacterPair() != nil && self.containsDoubleCharacter(1)
	}

	func containsDoubleCharacterPair() -> String? {
		for idx in 0..<self.characters.count-3 {
			let currentIndex = self.startIndex.advancedBy(idx)
			let pair = self.substringWithRange(Range<String.Index>(start: currentIndex, end: currentIndex.advancedBy(2)))
			let remain = self.substringFromIndex(currentIndex.advancedBy(2))
			if remain.containsString(pair) {
				return pair
			}
		}
		return nil
	}

	func containsDoubleCharacter(separation: Int) -> Bool {
		for (idx, c) in self.characters.enumerate() {
			if idx <= separation {
				continue
			}
			if c == self[self.startIndex.advancedBy(idx - 1 - separation)] {
				return true
			}
		}
		return false
	}
}

print("\(strings.filter({ $0.isNice1() }).count) strings are nice under original rules")
print("\(strings.filter({ $0.isNice2() }).count) strings are nice under new rules")
