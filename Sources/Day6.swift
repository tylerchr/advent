import Foundation

// Day 6: Probably a Fire Hazard
// http://adventofcode.com/day/6

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

let dimensions = 1000

func Day6(input: String?, args: [String]) {

	guard let rawInstructions = input else {
		print("USAGE: \(Process.arguments[0]) 6 <inputfile> <brightness: [Yes|No]>")
		exit(1)
	}

	if args.count < 1 {
		print("USAGE: \(Process.arguments[0]) 6 <inputfile> <brightness: [Yes|No]>")
		exit(1)
	}

	let brightnessMode = args[0] == "Yes"
	print("Brightness mode: \(brightnessMode)")

	let list = rawInstructions.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
	let instructions = list.filter({ $0.characters.count > 0 })

	let lightGrid = LightGrid(enableBrightness: brightnessMode)
	for i in instructions {
		lightGrid.apply(Instruction(i))
	}
	print("Total luminance: \(lightGrid.brightness())")
}
