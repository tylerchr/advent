import Foundation

// Day 7: Some Assembly Required
// http://adventofcode.com/day/7

extension String {
	func match(regex: String) -> [String]? {
		do {
			let re = try NSRegularExpression(pattern: regex, options: .CaseInsensitive)
			let matches = re.matchesInString(self, options: .Anchored, range: NSRange(location: 0, length: self.utf16.count))
			if matches.count > 0 {
				var m: [String] = []
				for idx in 1..<matches[0].numberOfRanges {
					m.append((self as NSString).substringWithRange(matches[0].rangeAtIndex(idx)))
				}
				return m
			}
			return nil
		} catch {
			return nil
		}
	}
}

protocol Input {
	func read(board: Wireboard) -> UInt16
}

struct ConstantInput: Input {
	var value: UInt16
	init(_ v: UInt16) {
		self.value = v
	}
	func read(board: Wireboard) -> UInt16 {
		return self.value
	}
}

struct PassthroughInput: Input {
	var source: String
	init(_ src: String) {
		self.source = src
	}
	func read(board: Wireboard) -> UInt16 {
		return board.read(source)
	}
}

struct NegativeInput: Input {
	var source: Input
	func read(board: Wireboard) -> UInt16 {
		return ~self.source.read(board)
	}
}

struct BooleanInput: Input {

	var a: Input
	var b: Input
	var operation: Operation

	enum Operation {
		case And
		case Or
	}

	func read(board: Wireboard) -> UInt16 {
		switch self.operation {
		case .And:
			return self.a.read(board) & self.b.read(board)
		case .Or:
			return self.a.read(board) | self.b.read(board)
		}
	}
}

struct ShiftInput: Input {

	var source: Input
	var direction: Direction
	var magnitude: UInt16

	enum Direction {
		case Left
		case Right
	}

	func read(board: Wireboard) -> UInt16 {
		switch self.direction {
		case .Left:
			return self.source.read(board) << self.magnitude
		case .Right:
			return self.source.read(board) >> self.magnitude
		}
	}
}

struct Wire {
	var name: String
	var source: Input
}

class Wireboard {

	var board: [String: Input]

	private var memo: [String: UInt16]

	init() {
		self.board = Dictionary<String, Input>()
		self.memo = Dictionary<String, UInt16>()
	}

	func reset() {
		self.memo.removeAll(keepCapacity: false)
	}

	func read(wire: String) -> UInt16 {

		// read memoized value
		if let v = self.memo[wire] {
			return v
		}

		if let input = self.board[wire] {
			let r = input.read(self)
			self.memo[wire] = r
			return r
		}
		print("Error: unknown wire \"\(wire)\"")
		return 0
	}

	func set(wire: String, source: Input) {
		self.board[wire] = source
	}

}

func Parse(input: String) -> Wire? {

	guard let matches = input.match("^(.*) -> ([a-z]+)$") else {
		return nil
	}

	let sink = matches[1]
	if let parts = matches[0].match("^(\\d+)$") {
		return Wire(name: sink, source: ConstantInput(UInt16(parts[0])!))
	} else if let parts = matches[0].match("^([a-z]+)$") {
		return Wire(name: sink, source: PassthroughInput(parts[0]))
	} else if let parts = matches[0].match("^(\\d+) AND ([a-z]+)$") {
		return Wire(name: sink, source: BooleanInput(a: ConstantInput(UInt16(parts[0])!), b: PassthroughInput(parts[1]), operation: .And))
	} else if let parts = matches[0].match("^([a-z]+) AND ([a-z]+)$") {
		return Wire(name: sink, source: BooleanInput(a: PassthroughInput(parts[0]), b: PassthroughInput(parts[1]), operation: .And))
	} else if let parts = matches[0].match("^([a-z]+) OR ([a-z]+)$") {
		return Wire(name: sink, source: BooleanInput(a: PassthroughInput(parts[0]), b: PassthroughInput(parts[1]), operation: .Or))
	} else if let parts = matches[0].match("^NOT ([a-z]+)$") {
		return Wire(name: sink, source: NegativeInput(source: PassthroughInput(parts[0])))
	} else if let parts = matches[0].match("^([a-z]+) LSHIFT (\\d+)$") {
		return Wire(name: sink, source: ShiftInput(source: PassthroughInput(parts[0]), direction: .Left, magnitude: UInt16(parts[1])!))
	} else if let parts = matches[0].match("^([a-z]+) RSHIFT (\\d+)$") {
		return Wire(name: sink, source: ShiftInput(source: PassthroughInput(parts[0]), direction: .Right, magnitude: UInt16(parts[1])!))
	}

	return nil
}

func Day7(input: String?, args: [String]) {

	if args.count < 1 {
		print("USAGE: \(Process.arguments[0]) 7 <inputfile> <wire>")
		exit(1)
	}

	guard let rawInstructions = input else {
		print("USAGE: \(Process.arguments[0]) 7 <inputfile> <wire>")
		exit(1)
	}

	let list = rawInstructions.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
	let instructions = list.filter({ $0.characters.count > 0 })

	let wireboard = Wireboard()
	for i in instructions {
		if let wire = Parse(i) {
			wireboard.set(wire.name, source: wire.source)
		} else {
			print("Problem reading \"\(i)\"")
		}
	}

	// for (wire, input) in wireboard.board {
	// 	print("\(wire): \(wireboard.read(wire))")
	// }

	let wire = args[0]

	// Part 1
	print("[Part 1] \(wire) => \(wireboard.read(wire))")

	// Part 2
	wireboard.board["b"] = ConstantInput(wireboard.read(wire))
	wireboard.reset()
	print("[Part 2] \(wire) => \(wireboard.read(wire))")

}
