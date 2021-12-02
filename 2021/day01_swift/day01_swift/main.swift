//
//  main.swift
//  day01_swift
//
//  Created by Roman Peters on 01/12/2021.
//

import Foundation
 
let file = "input.txt"
 
var inputFile = ""
 
if let dir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
 
    let fileURL = dir.appendingPathComponent(file)
 
    do {
        inputFile = try String(contentsOf: fileURL, encoding: .utf8)
    } catch let error as NSError {
        print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        
    }
}
 
var lastLine: Int = 0
var increaseCounter: Int = 0

// read through input
for line in inputFile.split(separator: "\n") {
    let measure = Int(line) ?? 0
    // skip first
    if lastLine != 0 {
        // check if increased
        if measure > lastLine {
            increaseCounter += 1
        }
    }
    lastLine = measure
}

print("Solution part 1: \(increaseCounter)")


// part 2
var lines: [Int] = []
for line in inputFile.split(separator: "\n") {
    lines.append(Int(line) ?? 0)
}


var windowA: Int
var windowB: Int
var windowIncreaseCounter: Int = 0

for n in 0...lines.count-4 {
    windowA = lines[n] + lines[n+1] + lines[n+2]
    windowB = lines[n+1] + lines[n+2] + lines[n+3]
    if windowB > windowA {
        windowIncreaseCounter += 1
    }
}

print("Solution part 2: \(windowIncreaseCounter)")

