import Foundation

// Day 6: Probably a Fire Hazard
// http://adventofcode.com/day/6

if Process.arguments.count < 2 {
	print("USAGE: \(Process.arguments[0]) <inputfile>")
	exit(1)
}

func readInstructions(path: String) -> [String]? {
	do {
		let stringList = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
		let list = stringList.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
		return list.filter({ $0.characters.count > 0 })
	} catch {
		return nil
	}
}

let dimensions = 1000

struct Coordinate {
	var x: Int
	var y: Int

	init(_ c: String) {
		let p = c.componentsSeparatedByString(",")
		self.x = Int(p[0])!
		self.y = Int(p[1])!
	}
}

struct Instruction {
	var action: Action
	var c1: Coordinate
	var c2: Coordinate

	enum Action {
		case On
		case Off
		case Toggle
	}

	init(_ instruction: String) {

		print(instruction)

		var coordClause: String = ""
		if instruction.hasPrefix("turn on") {
			self.action = .On
			coordClause = instruction.substringFromIndex(instruction.startIndex.advancedBy(8))
		} else if instruction.hasPrefix("turn off") {
			self.action = .Off
			coordClause = instruction.substringFromIndex(instruction.startIndex.advancedBy(9))
		} else {
			self.action = .Toggle
			coordClause = instruction.substringFromIndex(instruction.startIndex.advancedBy(7))
		}

		let parts: [String] = coordClause.componentsSeparatedByString(" ")
		self.c1 = Coordinate(parts[0])
		self.c2 = Coordinate(parts[2])
	}
}

class LightGrid {

	var grid: Array<Array<Int>>
	var brightnessMode = false

	init(enableBrightness: Bool) {
		self.brightnessMode = enableBrightness
		self.grid = Array<Array<Int>>()
		for _ in 0..<dimensions {
			self.grid.append(Array(count: dimensions, repeatedValue: 0))
		}
	}

	func apply(i: Instruction) {
		for x in i.c1.x...i.c2.x {
			for y in i.c1.y...i.c2.y {
				switch i.action {
				case .On:
					if self.brightnessMode {
						self.grid[x][y] += 1
					} else {
						self.grid[x][y] = 1
					}
				case .Off:
					if self.brightnessMode {
						self.grid[x][y] = max(0, self.grid[x][y] - 1)
					} else {
						self.grid[x][y] = 0
					}
				case .Toggle:
					if self.brightnessMode {
						self.grid[x][y] += 2
					} else {
						self.grid[x][y] = abs(self.grid[x][y] - 1)
					}
				}
			}
		}
	}

	func brightness() -> Int {
		var luminance: Int = 0
		for x in 0..<dimensions {
			luminance += self.grid[x].reduce(0, combine: +)
		}
		return luminance
	}

}

guard let instructions = readInstructions(Process.arguments[1]) else {
	print("Failed to load instructions")
	exit(1)
}

var lightGrid = LightGrid(enableBrightness: false)
for i in instructions {
	lightGrid.apply(Instruction(i))
}
print("Total luminance: \(lightGrid.brightness())")