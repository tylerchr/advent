import Foundation

// Day 3: Perfectly Spherical Houses in a Vacuum
// http://adventofcode.com/day/3

func ==(lhs: Location, rhs: Location) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

struct Location: Hashable {
	var x: Int
	var y: Int

	var hashValue: Int {
		get {
			return "\(self.x)\(self.y)".hashValue
		}
	}
}

func Day3(input: String?, args: [String]) {

	if args.count < 2 {
		print("USAGE: \(Process.arguments[0]) 1 - \"^>v<\" [Yes|No]")
		exit(1)
	}

	let directions = args[0]
	print("Path: \(directions)")

	var locs = Set<Location>()

	if args[1] == "Yes" {

		// Robo-Santa mode

		var santaLocation = Location(x: 0, y: 0)
		var roboSantaLocation = Location(x: 0, y: 0)

		locs.insert(Location(x: 0, y: 0))
		locs.insert(Location(x: 0, y: 0))

		for (idx, instruction) in directions.characters.enumerate() {

			if idx % 2 == 0 {

				switch instruction {
				case "^":
					santaLocation.y += 1
				case "v":
					santaLocation.y -= 1
				case "<":
					santaLocation.x -= 1
				case ">":
					santaLocation.x += 1
				default:
					print("Lost!")
				}

				locs.insert(santaLocation)

			} else {

				switch instruction {
				case "^":
					roboSantaLocation.y += 1
				case "v":
					roboSantaLocation.y -= 1
				case "<":
					roboSantaLocation.x -= 1
				case ">":
					roboSantaLocation.x += 1
				default:
					print("Lost!")
				}

				locs.insert(roboSantaLocation)

			}

		}

		print("Santa delivered presents to \(locs.count) houses!")

	} else {

		var currentLocation = Location(x: 0, y: 0)

		// Deliver a present to (0, 0) first
		locs.insert(Location(x: 0, y: 0))

		for instruction in directions.characters {
			switch instruction {
			case "^":
				currentLocation.y += 1
			case "v":
				currentLocation.y -= 1
			case "<":
				currentLocation.x -= 1
			case ">":
				currentLocation.x += 1
			default:
				print("Lost!")
			}

			locs.insert(currentLocation)
		}

		print("Santa delivered presents to \(locs.count) houses!")

	}

}