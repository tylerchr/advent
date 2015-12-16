import Foundation
import CryptoSwift

// Day 4: The Ideal Stocking Stuffer
// http://adventofcode.com/day/4

// Make:
// xcrun -sdk macosx swiftc Day4.swift -import-objc-header Day4.h

// extension String {
// 	func md5() -> Array<UInt8> {
// 		// let context = UnsafeMutablePointer<CC_MD5_CTX>.alloc(1)
// 		// var digest = Array<UInt8>(count:Int(CC_MD5_DIGEST_LENGTH), repeatedValue:0)
// 		// CC_MD5_Init(context)
// 		// CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
// 		// CC_MD5_Final(&digest, context)
// 		// context.dealloc(1)
// 		// return digest
// 		return [UInt8]()
// 	}
// }

func hexStartsWithZeros(data: Array<UInt8>, zeros: Int) -> Bool {
	for idx in 0..<(zeros / 2) {
		if idx >= data.count || data[idx] != 0 {
			return false
		}
	}
	if zeros % 2 != 0 {
		let halfByte = zeros / 2
		if halfByte >= data.count || (data[halfByte] & 0xF0) != 0 {
			return false
		}
	}
	return true
}

func Day4(input: String?, args: [String]) {

	if args.count < 2 {
		print("USAGE: \(Process.arguments[0]) 4 - <zeros> \"key\"")
		exit(1)
	}

	let key = args[1]

	guard let zeros = Int(args[0]) else {
		print("USAGE: \(Process.arguments[0]) 4 - <zeros> \"key\"")
		exit(1)
	}

	print("Searching for \(zeros) leading zeros")

	var nonce: Int = 0
	for nonce = 0; !hexStartsWithZeros(CryptoSwift.Hash.md5([UInt8]("\(key)\(nonce)".utf8)).calculate(), zeros: zeros); nonce++ {
		if nonce % 50000 == 0 {
			print("...tested \(nonce) combinations so far")
		}
	}

	print("Discovered solution! nonce=\(nonce)")

}