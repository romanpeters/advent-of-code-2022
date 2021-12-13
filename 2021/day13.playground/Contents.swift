import Foundation

let input = CommandLine.arguments.last == "test" ? "test" : "input" // change "input" to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ?
    URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}

var dots: [(Int, Int)] = []
var folds: [String] = []

for line in inputFile.split(separator: "\n") {
    if line.contains(",") {
        dots.append((Int(line.split(separator: ",")[0])!, (Int(line.split(separator: ",")[1])!)))
    } else if line.contains("=") {
        folds.append(String(line.split(separator: " ")[line.split(separator: " ").count-1]))
    }
}


func paperSize(dots: [(Int, Int)]) -> (Int, Int) {
    let xMax = dots.sorted(by: { return $0.0 > $1.0 })[0].0
    let yMax = dots.sorted(by: { return $0.1 > $1.1 })[0].1
    return (xMax+1, yMax+1)
}


func foldHorizontal(paper: [[Int]], y: Int) -> [[Int]] {
    var foldA: [[Int]] = Array(paper[0...y-1])
    let foldB: [[Int]] = Array(paper[y+1...paper.count-1])
    
    for y in 0...foldB.count-1 {
        for x in 0...foldB[0].count-1 {
            foldA[foldA.count-1-y][x] += foldB[y][x]
        }
    }
    return foldA
}

func foldVertical(paper: [[Int]], x: Int) -> [[Int]] {
    var foldA: [[Int]] = []
    var foldB: [[Int]] = []
    
    for y_ in 0...paper.count-1 {
        foldA.append(Array(paper[y_][0...x-1]))
        foldB.append(Array(paper[y_][x+1...paper[0].count-1]))
    }
    
    for y in 0...foldB.count-1 {
        for x in 0...foldB[0].count-1 {
            foldA[y][foldA[0].count-1-x] += foldB[y][x]
        }
    }
    return foldA
}

func dotCount(paper: [[Int]]) -> Int {
    var count  = 0
    for line in paper {
        for dot in line {
            if dot > 0 {
                count += 1
            }
        }
    }
    return count
}


func partOne() -> Int {
    var paper: [[Int]] = Array(repeating: Array(repeating: 0, count: paperSize(dots: dots).0), count: paperSize(dots: dots).1)
    for coord in dots {
        paper[coord.1][coord.0] = 1
    }
    
    let fold = folds[0].split(separator: "=")
    if String(fold[0]) == "x" {
        paper = foldVertical(paper: paper, x: Int(fold[1])!)
    } else {
        paper = foldHorizontal(paper: paper, y: Int(fold[1])!)
    }

    return dotCount(paper: paper)
}

print("Solution part 1: \(partOne())")

// part 2

func printPaper(paper: [[Int]]) {
    var output: String
    for line in paper {
        output = ""
        for dot in line {
            if dot > 0 {
                output.append("#")
            } else {
                output.append(".")
            }
        }
        print(output)
    }
}

func partTwo() {
    var paper: [[Int]] = Array(repeating: Array(repeating: 0, count: paperSize(dots: dots).0), count: paperSize(dots: dots).1)
    for coord in dots {
        paper[coord.1][coord.0] = 1
    }
    
    for fold in folds {
        if String(fold.split(separator: "=")[0]) == "x" {
            paper = foldVertical(paper: paper, x: Int(fold.split(separator: "=")[1])!)
        } else {
            paper = foldHorizontal(paper: paper, y: Int(fold.split(separator: "=")[1])!)
        }
    }
    printPaper(paper: paper)
}

print("Solution part 2:")
partTwo()

