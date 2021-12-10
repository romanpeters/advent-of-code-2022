import Foundation

let input = "input"  // change to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ? URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}

var commands: [String] = []
for line in inputFile.split(separator: "\n") {
    commands.append(String(line))
}

var horizontalPosition: Int = 0
var depthPosition: Int = 0

for command in commands {
    let instruct = command.components(separatedBy: " ")
    
    switch instruct[0] {
    case "forward":
        horizontalPosition += Int(instruct[1])!
    case "down":
        depthPosition += Int(instruct[1])!
    case "up":
        depthPosition -= Int(instruct[1])!
    default:
        print("something went wrong")
    }
}

let result: Int = horizontalPosition * depthPosition
print("Solution part 1: \(result)")

// part 2

var aim: Int = 0
horizontalPosition = 0
depthPosition = 0

for command in commands {
    let instruct = command.components(separatedBy: " ")
    
    switch instruct[0] {
    case "forward":
        horizontalPosition += Int(instruct[1])!
        depthPosition += aim * Int(instruct[1])!
    case "down":
        aim += Int(instruct[1])!
    case "up":
        aim -= Int(instruct[1])!
    default:
        print("something went wrong")
    }
}

let result_2: Int = horizontalPosition * depthPosition
print("Solution part 2: \(result_2)")
