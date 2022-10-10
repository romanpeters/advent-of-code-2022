import Foundation

let input = CommandLine.arguments.last == "test" ? "test" : "input" // change "input" to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ?
    URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}

var crabPositions: [Int] = []
for crab in inputFile.split(separator: ",") {
    crabPositions.append(Int(crab.trimmingCharacters(in: .whitespacesAndNewlines))!)
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}

func findShortestEditDistance(crabPositions: [Int]) -> Int {
    var result: Int = -1
    var editDistances: [Int]
    
    for n in 0...crabPositions.max()! {
        editDistances = []
        for crab in crabPositions {
            if n < crab {
                editDistances.append(crab-n)
            } else if n == crab {
                editDistances.append(0)
            } else {
                editDistances.append(n-crab)
            }
        }
        
        if result == -1 {
            result = editDistances.sum()
        } else {
            if editDistances.sum() < result {
                result = editDistances.sum()
            }
        }
    }
    return result
}

print("Solution part 1: \(findShortestEditDistance(crabPositions: crabPositions))")

// part 2

func getEditDistanceMean(crabPositions: [Int]) -> Int {
    let meanCrab: Int = crabPositions.sum() / crabPositions.count
    var editDistances: [Int] = []

    for crab in crabPositions {
        
        // move left
        if meanCrab < crab {
            editDistances.append(Array(0...crab-meanCrab).sum())
            
        // move right
        } else if meanCrab > crab {
            editDistances.append(Array(0...meanCrab-crab).sum())
        }
    }
    return editDistances.sum()
}

print("Solution part 2: \(getEditDistanceMean(crabPositions: crabPositions))")
