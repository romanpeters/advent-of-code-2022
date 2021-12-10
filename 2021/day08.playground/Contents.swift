import Foundation

let input = "input"  // change to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ? URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}

var inputData: [[String]:[String]] = [:]
var uniqueSignalPatterns: [String]
var outputValues: [String]
for line in inputFile.split(separator: "\n") {
    uniqueSignalPatterns = line.split(separator: "|")[0].split(separator: " ").map { String($0) }
    outputValues = line.split(separator: "|")[1].split(separator: " ").map { String($0) }
    inputData[uniqueSignalPatterns] = outputValues
}

func count1478(inputData: [[String]:[String]]) -> Int {
    var result: Int = 0
    let filter: [Int] = [2, 4, 3, 7]  //  1  4  7  8
    for (_, values) in inputData {
        for outputValue in values {
            if filter.contains(outputValue.count) {
                result += 1
            }
        }
    }
    return result
}

print("Solution part 1: \(count1478(inputData: inputData))")

// part 2

func checkIf(pattern: String, contains: String) -> Bool {
    for char in contains {
        if !pattern.contains(char) {
            return false
        }
    }
    return true
}

func numberOfCharsInCommon(pattern: String, otherPattern: String) -> Int {
    var result: Int = 0
    for char in pattern {
        if otherPattern.contains(char) {
            result += 1
        }
    }
    return result
}

func decodeOutputValues(inputData: [[String]:[String]]) -> [[String]:Int] {
    var result: [[String]:Int] = [:]
    var encodedValues: [String]
    var strDecodedOutput: String
    var translation: [Int:String]
    var unknownEncodedValues: Set<String>

    func updateTranslation(number: Int, translatesTo encoding: String) {
        translation[number] = String(encoding.sorted())
        unknownEncodedValues.remove(encoding)
    }
    
    
    for (signalPatterns, outputValues) in inputData {
        encodedValues = signalPatterns + outputValues
        translation = Dictionary()
        unknownEncodedValues = Set<String>(encodedValues)
        
        // decode 1  7  4  8
        // decodable by length
        for encodedValue in encodedValues {
            switch(encodedValue.count) {
            case 2:
                updateTranslation(number: 1, translatesTo: encodedValue)
            case 3:
                updateTranslation(number: 7, translatesTo: encodedValue)
            case 4:
                updateTranslation(number: 4, translatesTo: encodedValue)
            case 7:
                updateTranslation(number: 8, translatesTo: encodedValue)
            default:
                unknownEncodedValues.insert(String(encodedValue.sorted()))
            }
        }
     
        while !unknownEncodedValues.isEmpty {
            for key in translation.keys {
                switch(key) {
                case 1:
                    // decode 3 using 1
                    // decode 6 using 1
                    // decode 0 using 1 and 9
                    // decode 9 using 1 and 0
                    for encodedValue in unknownEncodedValues {
                        if encodedValue.count == 5 {   // 2  3  5
                            if checkIf(pattern: encodedValue, contains: translation[1]!) {
                                updateTranslation(number: 3, translatesTo: encodedValue)
                            }
                        } else if encodedValue.count == 6 {  // 0  6  9
                            if !checkIf(pattern: encodedValue, contains: translation[1]!) {  // 6
                                updateTranslation(number: 6, translatesTo: encodedValue)
                            } else if translation.keys.contains(9) {  // 0
                                updateTranslation(number: 0, translatesTo: encodedValue)
                            } else if translation.keys.contains(0) {  // 9
                                updateTranslation(number: 9, translatesTo: encodedValue)
                            }
                        }
                    }
                case 2:
                    // decode 5 using 2 and 3
                    // decode 3 using 2 and 5
                    for encodedValue in unknownEncodedValues {
                        if encodedValue.count == 5 {   // 3  5
                            if translation.keys.contains(3) {  // 5
                                updateTranslation(number: 5, translatesTo: encodedValue)
                                break
                            }
                            if translation.keys.contains(5) {  // 3
                                updateTranslation(number: 3, translatesTo: encodedValue)
                                break
                            }
                        }
                    }
                case 3:
                    continue
                case 4:
                    // decode 2 using 4
                    // decode 9 using 4
                    for encodedValue in unknownEncodedValues {
                        if encodedValue.count == 5 {   // 2  3  5
                            if numberOfCharsInCommon(pattern: encodedValue, otherPattern: translation[4]!) == 2 { // 2
                                updateTranslation(number: 2, translatesTo: encodedValue)
                            }
                        } else if encodedValue.count == 6 {  // 0  6  9
                            if checkIf(pattern: encodedValue, contains: translation[4]!) {  // 9
                                updateTranslation(number: 9, translatesTo: encodedValue)
                            }
                        }
                    }
                case 5:
                    continue
                case 6:
                    continue
                case 7:
                    // decode 3 using 7
                    // decode 6 using 7
                    for encodedValue in unknownEncodedValues {
                        if encodedValue.count == 5 {   // 2  3  5
                            if checkIf(pattern: encodedValue, contains: translation[7]!) {  // 3
                                updateTranslation(number: 3, translatesTo: encodedValue)
                            }
                        } else if encodedValue.count == 6 {  // 0  6  9
                            if !checkIf(pattern: encodedValue, contains: translation[7]!) {  // 6
                                updateTranslation(number: 6, translatesTo: encodedValue)
                            }
                        }
                    }
                    
                default:
                    continue
                }
                
                // TODO, if only 1 remaining -> map to missing translation
                
            }
        }
        
        // format translated output
        strDecodedOutput = ""
        for val in outputValues {
            for (key, translationValue) in translation {
                if String(val.sorted()) == translationValue {
                    strDecodedOutput += String(key)
                }
            }
        }
        
        if strDecodedOutput.count != 4 {
            print("Something went wrong, extend the switch case")
        
        }
        result[outputValues] = Int(strDecodedOutput)
    }
    return result
}

let decodedValues = decodeOutputValues(inputData: inputData)
var resultSum = 0
for (_, value) in decodedValues {
    resultSum += value
}

print("Solution part 2: \(resultSum)")
