import Foundation

let input = CommandLine.arguments.last == "test" ? "test" : "input" // change "input" to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ?
    URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}

func getPipes(inputFile: String) -> [[String]] {
    var pipes: [[String]] = []
    var pipe: [String] = []
    for line in inputFile.split(separator: "\n") {
        for point in line.split(separator: " ") {
            if point != "->" {
                pipe.append(String(point))
            }
        }
        pipes.append(pipe)
        pipe = []
    }
    return pipes
}

func calcMatrixSize(pipes: [[String]]) -> [Int] {
    var matrix_x: Int = 0
    var matrix_y: Int = 0
    var x: Int
    var y: Int
    for pipe in pipes {
        for points in pipe {
            x = Int(points.split(separator: ",")[0])!
            y = Int(points.split(separator: ",")[1])!
            if x > matrix_x {
                matrix_x = x
            }
            if y > matrix_y {
                matrix_y = y
            }
        }
    }
    return [matrix_x+1, matrix_y+1]
}

func getPipePoints(pipe: [String], vertical: Bool) -> [[Int]] {
    var points: [[Int]] = []
    var x1: Int = Int(pipe[0].split(separator: ",")[0])!
    var y1: Int = Int(pipe[0].split(separator: ",")[1])!
    var x2: Int = Int(pipe[1].split(separator: ",")[0])!
    var y2: Int = Int(pipe[1].split(separator: ",")[1])!
    var z: Int  // temp var holder
    
    // switch direction if necessary
    if x1 > x2 || y1 > y2 {
        z = x1
        x1 = x2
        x2 = z
        
        z = y1
        y1 = y2
        y2 = z
    }
    
    // horizontal
    if x1 == x2 {
        for y in y1...y2 {
            points.append([x1, y])
        }
    
    // vertical
    } else if y1 == y2 {
        for x in x1...x2 {
            points.append([x, y1])
        }
        
    } else {
        if vertical {
            // direction left to right
            if x1 > x2 {
                z = x1
                x1 = x2
                x2 = z
                
                z = y1
                y1 = y2
                y2 = z
            }
            // downward
            if y1 > y2 {
                for d in 0...x2-x1 {
                    points.append([x1+d, y1-d])
                }
            // upward
            } else {
                for d in 0...x2-x1 {
                    points.append([x1+d, y1+d])
                }
            }
        }
    }
    return points
}

func countOverlap(matrix: [[Int]]) -> Int {
    var overlapCount: Int = 0
    for row in matrix {
        for cell in row {
            if cell > 1 {
                overlapCount += 1
            }
        }
    }
    return overlapCount
}

// get pipes
let pipes = getPipes(inputFile: inputFile)

// create empty matrix
var matrix = Array(repeating: Array(repeating: 0, count: calcMatrixSize(pipes: pipes)[0]), count: calcMatrixSize(pipes: pipes)[1])

// calculate points
for pipe in pipes {
    for point in getPipePoints(pipe: pipe, vertical: false) {
        matrix[point[1]][point[0]] += 1
    }
}

var result: Int = countOverlap(matrix: matrix)
print("Result part 1: \(result)")


// part 2

// create empty matrix
var matrix_2 = Array(repeating: Array(repeating: 0, count: calcMatrixSize(pipes: pipes)[0]), count: calcMatrixSize(pipes: pipes)[1])

// calculate points
for pipe in pipes {
    for point in getPipePoints(pipe: pipe, vertical: true) {
        matrix_2[point[1]][point[0]] += 1
    }
}

var result_2: Int = countOverlap(matrix: matrix_2)
print("Result part 2: \(result_2)")
