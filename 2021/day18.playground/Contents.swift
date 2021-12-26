import Foundation

let input = CommandLine.arguments.last == "test" ? "test" : "input" // change "input" to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ?
    URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}

// parsing
let parsedSnailfishnumbersArray = inputFile.split(separator: "\n").map({ String($0) })


func addSnailfishNumbers(snailfishNumbers: [String]) -> String {
    var reducedSnailfishNumber = ""
    for snailfishNumber in snailfishNumbers {
        if reducedSnailfishNumber == "" {
            reducedSnailfishNumber = snailfishNumber
        } else {
            reducedSnailfishNumber = addTwoSnailfishNumbers(snailfishNumberLeft: reducedSnailfishNumber, snailfishNumberRight: snailfishNumber)
        }
    }
    return reducedSnailfishNumber
}

func addTwoSnailfishNumbers(snailfishNumberLeft: String, snailfishNumberRight: String) -> String {
    /*
     To add two snailfish numbers, form a pair from the left and right parameters of the addition operator.
     
     There's only one problem: snailfish numbers must always be reduced, and the process of adding two snailfish numbers can result in snailfish
     numbers that need to be reduced.
     */
    var reducedSnailfishNumber = "[\(snailfishNumberLeft),\(snailfishNumberRight)]"

    
    var didExplode: Bool = false
    var didSplit: Bool = false
    while true {
        (reducedSnailfishNumber, didExplode) = explodeLeftmost(snailfishNumber: reducedSnailfishNumber)
        
        
        if didExplode {
            continue  // keep on exploding
        }
        (reducedSnailfishNumber, didSplit) = splitLeftmost(snailfishNumber: reducedSnailfishNumber)
        
        
        if !didExplode && !didSplit {
            
            
            break
        }
    }
    return reducedSnailfishNumber
}

func unpairSnailfishNumber(snailfishNumber: String) -> (String, String) {
    let charactersInner = String(snailfishNumber[snailfishNumber.range(of: #"(?<=\[)(.*)(?=\])"#, options: .regularExpression)!])
        .map({ Character(extendedGraphemeClusterLiteral: $0 )})  // characters between outer brackets
    var nestingLevel = 1
    var x: String = ""
    var y: String = ""
    if charactersInner.first != "[" {  // left is regular number
        for (i, char) in charactersInner.enumerated() {
            if char == "," {
                x = String(charactersInner[0...i-1])
                y = String(charactersInner[i+1...charactersInner.count-1])
                break
            }
        }
    } else {
        for (i, char) in charactersInner.enumerated() {
            if char == "[" {nestingLevel+=1} else if char == "]" {nestingLevel-=1}
            if nestingLevel == 1 { // root level
                x = String(charactersInner[0...i])
                y = String(charactersInner[i+2...charactersInner.count-1])
                break
            }
        }
    }
    assert(x.filter { $0 == "[" }.count == x.filter { $0 == "]" }.count)
    assert(y.filter { $0 == "[" }.count == y.filter { $0 == "]" }.count)
    return (x, y)
}


func explodeLeftmost(snailfishNumber: String) -> (String, Bool) {
    /*
     If any pair is nested inside four pairs, the leftmost such pair explodes.
     
     To explode a pair, the pair's left value is added to the first regular number to the left of the exploding pair (if any),
     and the pair's right value is added to the first regular number to the right of the exploding pair (if any).
     Exploding pairs will always consist of two regular numbers. Then, the entire exploding pair is replaced with the regular number 0.
     */
    let characters = snailfishNumber.map({ Character(extendedGraphemeClusterLiteral: $0 )})
    
    // check nestinglevel
    var nestingLevel = -1
    var leftFromExploding: String = ""
    var explodingPair: String = ""
    var rightFromExploding: String = ""
    for (i, char) in characters.enumerated() {
        if char == "[" {nestingLevel+=1} else if char == "]" {nestingLevel-=1}
        if nestingLevel == 4 {
            
            leftFromExploding = String(characters[0...i-1])
            explodingPair = getPairAtIndex(snailfishNumber: snailfishNumber, index: i)
            rightFromExploding = String(characters[i+explodingPair.count...characters.count-1])
            break
        }
    }
    if nestingLevel != 4 {  // no explosion here, carry on
        return (snailfishNumber, false)
    }
    
    assert(leftFromExploding + explodingPair + rightFromExploding == snailfishNumber)
    assert(explodingPair.filter({ $0 == "[" }).count == 1 && explodingPair.filter({ $0 == "]" }).count == 1)
    
    var explodingX: String
    var explodingY: String
    (explodingX, explodingY) = unpairSnailfishNumber(snailfishNumber: explodingPair)
    
    var result = ""
    // the pair's left value is added to the first regular number to the left of the exploding pair (if any)
    var added: Bool = false
    var strNum = ""
    for strchar in leftFromExploding.map({ String($0) }).reversed() {
        if Int(strchar) != nil && added == false {
            strNum = strchar + strNum
        } else {
            if strNum != "" && added == false {
                result = strchar + String(Int(strNum)! + Int(explodingX)!) + result
                added = true
            } else {
                result = strchar + result
            }
        }
    }
    result = result + "0" // the entire exploding pair is replaced with the regular number 0
    // the pair's right value is added to the first regular number to the right of the exploding pair (if any)
    added = false
    strNum = ""
    for strchar in rightFromExploding.map({ String($0) }) {
        if Int(strchar) != nil && added == false {
            strNum += strchar
        } else {
            if strNum != "" && added == false {
                result += String(Int(strNum)! + Int(explodingY)!) + strchar
                added = true
            } else {
                result += strchar
            }
        }
    }
    return (result, true)
}

func getPairAtIndex(snailfishNumber: String, index: Int) -> String {
    assert(snailfishNumber.first == "[")  // a pair starts with [
    var pair: String = ""
    var characters = snailfishNumber.map({ Character(extendedGraphemeClusterLiteral: $0 )})
    characters = Array(characters[index...characters.count-1])
    
    var nestingLevel = 0
    for (i, char) in characters.enumerated() {
        if char == "[" {nestingLevel+=1} else if char == "]" {nestingLevel-=1}
        if nestingLevel == 0 {
            pair = String(characters[0...i])
            break
        }
    }
    return pair
}
 
func splitLeftmost(snailfishNumber: String) -> (String, Bool) {
    /*
     If any regular number is 10 or greater, the leftmost such regular number splits.
     
     To split a regular number, replace it with a pair; the left element of the pair should be the regular number divided by two and rounded down,
     while the right element of the pair should be the regular number divided by two and rounded up.
     For example, 10 becomes [5,5], 11 becomes [5,6], 12 becomes [6,6], and so on.
     */
    let over10Regex = #"\d{2,}"#
    var result = snailfishNumber
    let regexMatch = result.range(of: over10Regex, options: .regularExpression)
    if regexMatch == nil {
        return (result, false)
    }
    
    let num = Int(String(result[regexMatch!]))!
    let leftVal = Int(num / 2)
    let rightVal = Int((num / 2) + num % 2)
    let splitByNum = result.components(separatedBy: String(num))
    result = splitByNum[0] + "[\(leftVal),\(rightVal)]" + splitByNum[1...splitByNum.count-1].joined(separator: String(num))
    return (result, true)
}

func calculateMagnitude(snailfishNumber: String) -> Int {
    /*
     The magnitude of a pair is 3 times the magnitude of its left element plus 2 times the magnitude of its right element.
     The magnitude of a regular number is just that number.
     */
    var result = snailfishNumber
    let pairNumberRegEx = #"(\[\d+,\d+])"#
    var regexMatch = result.range(of: pairNumberRegEx, options: .regularExpression)
    var innerPair: String
    var left: String
    var right: String
    while regexMatch != nil {
        innerPair = String(result[regexMatch!])
        (left, right) = unpairSnailfishNumber(snailfishNumber: innerPair)
        result = result.replacingOccurrences(of: innerPair, with: String((Int(left)!*3) + (Int(right)!*2)))
        regexMatch = result.range(of: pairNumberRegEx, options: .regularExpression)
    }
    return Int(result)!
}

func partOne() -> Int {
    let reduced = addSnailfishNumbers(snailfishNumbers: parsedSnailfishnumbersArray)
    return calculateMagnitude(snailfishNumber: reduced)
}

print("Solution part 1:", partOne())

// part 2

func partTwo() -> Int {
    var highScore = 0
    var magnitude: Int
    for sn1 in parsedSnailfishnumbersArray {
        for sn2 in parsedSnailfishnumbersArray {
            if sn1 != sn2 {
                magnitude = calculateMagnitude(
                    snailfishNumber: addTwoSnailfishNumbers(snailfishNumberLeft: sn1, snailfishNumberRight: sn2))
                if magnitude > highScore {
                    highScore = magnitude
                }
            }
        }
    }
    return highScore
}

print("Solution part 2:", partTwo())

