//
//  main.swift
//  day03_swift
//
//  Created by Roman Peters on 03/12/2021.
//

import Foundation

let file = "input-3.txt"
var inputFile = ""
 
if let dir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
 
    let fileURL = dir.appendingPathComponent(file)
 
    do {
        inputFile = try String(contentsOf: fileURL, encoding: .utf8)
    } catch let error as NSError {
        print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
    }
}

var binaryNumbers: [String] = []
for line in inputFile.split(separator: "\n") {
    binaryNumbers.append(String(line))
}

var gammaRate: String = ""
var oneBits: Int = 0
for n in 0...binaryNumbers[0].count-1 {
    oneBits = 0
    for binNum in binaryNumbers {
        if binNum[binNum.index(binNum.startIndex, offsetBy: n)] == "1" {
            oneBits += 1
        }
    }
    if oneBits ==  binaryNumbers.count / 2 {
        print("Equal zero and one bits")
    } else if oneBits > binaryNumbers.count / 2 {
        gammaRate.append(contentsOf: "1")
    } else {
        gammaRate.append(contentsOf: "0")
    }
}

var epsilonRate: String = ""
for char in gammaRate {
    if char == "1" {
        epsilonRate.append(contentsOf: "0")
    } else {
        epsilonRate.append(contentsOf: "1")
    }
}

let gammaRateDecimal: Int = Int(gammaRate, radix: 2)!
let epsilonRateDecimal: Int = Int(epsilonRate, radix: 2)!
let result: Int = gammaRateDecimal * epsilonRateDecimal

print("Solution part 1: \(result)")

// part 2

func findCriteriaBitAt(index: Int, listOfBinaryNumbers: [String], mode: String) -> Int {
    var slice: String = ""
    for binNum in listOfBinaryNumbers {
        let indexBinary: String = String(binNum[binNum.index(binNum.startIndex, offsetBy: index)])
        slice.append(contentsOf: indexBinary)
    }
    let zeroesCount = slice.filter { $0 == "0" }.count
    let onesCount = slice.filter { $0 == "1" }.count
    // 0 more common than 1
    if zeroesCount > onesCount {
        if mode == "oxygen" {
            return 0
        } else {
            return 1
        }
    // 1 more common than 0
    } else if onesCount > zeroesCount {
        if mode == "oxygen" {
            return 1
        } else {
            return 0
        }
    // 1 and 0 equally common
    } else {
        if mode == "oxygen" {
            return 1
        } else {
            return 0
        }
    }
}

func removeCandidatesFrom(listOfBinaryNumbers: [String], index: Int, filter: String) -> [String] {
    var result: [String] = []
    for binNum in listOfBinaryNumbers {
        if String(binNum[binNum.index(binNum.startIndex, offsetBy: index)]) == filter {
            result.append(binNum)
        }
    }
    return result
}

var oxygenGeneratorRatingCandidates: [String] = binaryNumbers
var c02ScrubberRatingCandidates: [String] = binaryNumbers
var criteriaBit: String

var oxygenGeneratorRating: String = ""
var c02ScrubberRating: String = ""

for n in 0...binaryNumbers[0].count-1 {
    criteriaBit = String(findCriteriaBitAt(index: n, listOfBinaryNumbers: oxygenGeneratorRatingCandidates, mode: "oxygen"))
    oxygenGeneratorRatingCandidates = removeCandidatesFrom(listOfBinaryNumbers: oxygenGeneratorRatingCandidates, index: n, filter: criteriaBit)
    if oxygenGeneratorRatingCandidates.count == 1 {
        oxygenGeneratorRating = oxygenGeneratorRatingCandidates[0]
    }
    
    criteriaBit = String(findCriteriaBitAt(index: n, listOfBinaryNumbers: c02ScrubberRatingCandidates, mode: "c02"))
    c02ScrubberRatingCandidates = removeCandidatesFrom(listOfBinaryNumbers: c02ScrubberRatingCandidates, index: n, filter: criteriaBit)
    if c02ScrubberRatingCandidates.count == 1 {
        c02ScrubberRating = c02ScrubberRatingCandidates[0]
    }
}

let oxygenGeneratorRatingDecimal: Int = Int(oxygenGeneratorRating, radix: 2)!
let c02ScrubberRatingDecimal: Int = Int(c02ScrubberRating, radix: 2)!
let result_2: Int = oxygenGeneratorRatingDecimal * c02ScrubberRatingDecimal

print("Solution part 2: \(result_2)")
