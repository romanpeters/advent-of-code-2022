import Foundation

let input = "input"  // change to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ? URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
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

