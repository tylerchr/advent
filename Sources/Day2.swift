import Foundation

// Day 2: I Was Told There Would Be No Math
// http://adventofcode.com/day/2

struct Present {

	var length, width, height: Int

	init(l: Int, w: Int, h: Int) {
		self.length = l
		self.width = w
		self.height = h
	}

	var area: Int {
		get {
			let s1 = 2 * self.length * self.width
			let s2 = 2 * self.length * self.height
			let s3 = 2 * self.width * self.height
			return s1 + s2 + s3
		}
	}

	var slack: Int {
		get {
			let s1 = 2 * self.length * self.width
			let s2 = 2 * self.length * self.height
			let s3 = 2 * self.width * self.height
			return min(s1, s2, s3) / 2
		}
	}

	var ribbon: Int {
		get {
			let sum = self.length + self.width + self.height - max(self.length, self.width, self.height)
			return 2 * sum + (self.length * self.width * self.height)
		}
	}

}

func Day2(input: String?, args: [String]) {

	guard let presentsList = input else {
		print("USAGE: \(Process.arguments[0]) 2 <inputfile>")
		return
	}

	var presents: [Present] = []
	let all_dims = presentsList.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
	for dim in all_dims {
		let dims = dim.componentsSeparatedByString("x")
		if dims.count == 3 {
			presents.append(Present(l: Int(dims[0])!, w: Int(dims[1])!, h: Int(dims[2])!))
		}
	}

	let area = presents.reduce(0, combine: {$0 + $1.area + $1.slack})
	print("The elves need \(area) sq ft of wrapping paper!")

	let ribbon = presents.reduce(0, combine: {$0 + $1.ribbon})
	print("...and \(ribbon) feet of ribbon.")

}

