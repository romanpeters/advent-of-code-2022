import Foundation

guard let inputFile = try? String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!, encoding: .utf8) else {
    fatalError("Cannot read file input.txt")
}

func checkSyntax(line: String) -> (Character?, [Character]) {
    // checks a line for errors
    // returns (illegal character if there is one & array of missing characters remaining)
    var expectedBrackets: [Character] = []
    
    for char in line {
        switch(char) {
        case "(":
            expectedBrackets.append(")")
        case "[":
            expectedBrackets.append("]")
        case "{":
            expectedBrackets.append("}")
        case "<":
            expectedBrackets.append(">")
        case ")":
            if expectedBrackets.last != char {
                return (char, expectedBrackets)
            } else {
                expectedBrackets.removeLast()
            }
        case "]":
            if expectedBrackets.last != char {
                return (char, expectedBrackets)
            } else {
                expectedBrackets.removeLast()
            }
        case "}":
            if expectedBrackets.last != char {
                return (char, expectedBrackets)
            } else {
                expectedBrackets.removeLast()
            }
        case ">":
            if expectedBrackets.last != char {
                return (char, expectedBrackets)
            } else {
                expectedBrackets.removeLast()
            }
        default:
            print("Illegal char: \(char)")
        }
    }
    return (nil, expectedBrackets.reversed())
}


func calculateHighScore(text: String) -> Int {
    var highScore: Int = 0
    for line in text.split(separator: "\n") {
        switch(checkSyntax(line: String(line)).0) {
        case ")":
            highScore += 3
        case "]":
            highScore += 57
        case "}":
            highScore += 1197
        case ">":
            highScore += 25137
        default:
            continue
        }
    }
    return highScore
}

print("Solution part 1: \(calculateHighScore(text: inputFile))")

// part 2

func calculateScoreFor(remainingChars: [Character]) -> Int {
    var highScore: Int = 0
    for char in remainingChars {
        highScore *= 5
        switch(char) {
        case ")":
            highScore += 1
        case "]":
            highScore += 2
        case "}":
            highScore += 3
        case ">":
            highScore += 4
        default:
            print("Illegal char")
        }
    }
    return highScore
}

func calculateScoreUnfinishedLine(text: String) -> Int {
    var allScores: [Int] = []
    var syntaxOutput: (Character?, [Character])
    for line in text.split(separator: "\n") {
        syntaxOutput = checkSyntax(line: String(line))
        if syntaxOutput.0 == nil {
            allScores.append(calculateScoreFor(remainingChars: syntaxOutput.1))
        }
    }
    return allScores.sorted()[(allScores.count/2)]
}

print("Solution part 2: \(calculateScoreUnfinishedLine(text: inputFile))")

