import Foundation

let input = CommandLine.arguments.last == "test" ? "test" : "input" // change "input" to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ?
    URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}

let polymerTemplate: String = String(inputFile.split(separator: "\n").first!)
let pairInsertionRules: [String] = inputFile.split(separator: "\n").filter( {$0.contains(">") } ).map { String($0) }
let rules: [String:Character] = Dictionary(uniqueKeysWithValues: pairInsertionRules.map({ (String($0.split(separator: " ")[0]), Character(String($0.split(separator: " ")[2]))) }))

extension StringProtocol {  // give me python-like string index: string[i]
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

func insertRules(rules: [String:Character], into polymer: String) -> String {
    var pair: String
    var mutation: String
    var polymerParts = polymer.map { String($0) }
    
    for i in 1...polymer.count-1 {
        // for pair in polymer
        pair = String(polymer[i-1]) + String(polymer[i])
        mutation = polymer
        mutation.insert(rules[pair]!, at: mutation.index(mutation.startIndex, offsetBy: i))
        polymerParts[i-1] += String(mutation[i])
    }
    return polymerParts.joined(separator: "")
}

func getCounter(polymer: String) -> [Character:Int] {
    var counter = [Character: Int]()
    for c in polymer {
        counter[c] = (counter[c] ?? 0) + 1
    }
    return counter
}

func calculateScore(counter: [Character:Int]) -> Int {
    let maxCount = counter.reduce(counter.first!) { $1.1 > $0.1 ? $1 : $0 }.value
    let minCount = counter.reduce(counter.first!) { $1.1 < $0.1 ? $1 : $0 }.value
    return maxCount - minCount
}

func partOne() -> Int {
    var polymer = polymerTemplate
    
    for _ in 1...10 {
        polymer = insertRules(rules: rules, into: polymer)
    }
    let counter = getCounter(polymer: polymer)
    return calculateScore(counter: counter)
}

print("Solution part 1:", partOne())

// part 2

func insertRulesUsingADictionary(rules: [String:Character], into polymer: String, steps: Int) -> [Character: Int] {
    var polymerPairs = Dictionary(uniqueKeysWithValues: rules.map({ ($0.key, 0) }))  // dict to keep track of the polymer pairs
    var characterCount = getCounter(polymer: polymer)                                // dict to keep track of the count of each character
    var pair: String
    
    // add the first pairs
    for i in 0...polymer.count-1 {
        if i > 0 {
            pair = String(polymer[i-1]) + String(polymer[i])
            polymerPairs[pair]! += 1
        }
    }
    
    var newPair: String
    var newChar: Character
    for _ in 1...steps {
        for (key, value) in polymerPairs {
            if value > 0 {
                // add left-side pair
                newPair = String(key[0]) + String(rules[key]!)
                polymerPairs[newPair]! += value
                
                // add right-side pair
                newPair = String(rules[key]!) + String(key[1])
                polymerPairs[newPair]! += value
                
                // remove previous pairs
                polymerPairs[key]! -= value
                
                // update character count
                newChar = rules[key]!
                characterCount[newChar] = (characterCount[newChar] ?? 0) + value
            }
        }
    }
    return characterCount
}

func partTwo() -> Int {
    let counter = insertRulesUsingADictionary(rules: rules, into: polymerTemplate, steps: 40)
    return calculateScore(counter: counter)
}

print("Solution part 2:", partTwo())
