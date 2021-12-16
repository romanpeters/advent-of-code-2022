import Foundation

let input = CommandLine.arguments.last == "test" ? "test" : "input" // change "input" to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ?
    URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}

struct Matrix<KeyElem:Hashable, Value> {
    var _storage: [KeyElem:[KeyElem:Value]] = [:]
    
    subscript(x:KeyElem, y:KeyElem) -> Value? {
        get {
            return _storage[x]?[y]
        }
        set(val) {
            if _storage[x] == nil {
                _storage[x] = [:]
            }
            _storage[x]![y] = val
        }
    }
    
    func getYs() -> [KeyElem] {
        return Array(self._storage.keys)
    }
}

// input parsing
var inputMatrix = Matrix<Int,Int>()
for (y, line) in inputFile.split(separator: "\n").enumerated() {
    for (x, cell) in line.compactMap({$0.wholeNumberValue}).enumerated() {
        inputMatrix[x,y] = cell
    }
}

func adjacentCoordinates(x: Int, y: Int) -> [(Int, Int)] {
    return [(x-1, y+0), (x+0, y-1), (x+0, y+1), (x+1, y+0)]
}

func calculateDistances(matrix: Matrix<Int,Int>, distanceRisks: Matrix<Int,Int>) -> Matrix<Int, Int> {
    var distanceRisks = distanceRisks
    var newRisk: Int
    let max: Int = matrix.getYs().max()!
    for x in 0...max {
        for y in 0...max {
            for coord in adjacentCoordinates(x: x, y: y) {
                if matrix[coord.0, coord.1] != nil {
                    newRisk = (distanceRisks[x, y] ?? 0) + matrix[coord.0, coord.1]!
                    if newRisk < (distanceRisks[coord.0, coord.1] ?? Int.max) {
                        distanceRisks[coord.0, coord.1] = newRisk
                    }
                }
            }
        }
    }
    return distanceRisks
}

func getLowestTotalRiskPath(matrix: Matrix<Int,Int>) -> Int {
    let max: Int = matrix.getYs().max()!
    
    var distanceRisks = Matrix<Int, Int>()
    var distanceRisksRecount = Matrix<Int, Int>()
    
    distanceRisks = calculateDistances(matrix: matrix, distanceRisks: distanceRisks)
    
    // iterate until no changes
    while true {
        distanceRisksRecount = calculateDistances(matrix: matrix, distanceRisks: distanceRisks)
        if distanceRisks[max, max]! == distanceRisksRecount[max, max]! {
            break
        } else {
            distanceRisks = distanceRisksRecount
        }
    }
    return distanceRisks[max, max]!
}


func partOne() -> Int {
    return getLowestTotalRiskPath(matrix: inputMatrix)
}

print("Solution part 1:", partOne())

// part 2

func transformMap(matrix: Matrix<Int, Int>) -> Matrix<Int, Int> {
    var largeMatrix = Matrix<Int,Int>()
    let maxSmall: Int = matrix.getYs().max()!

    // horizontal
    var nx: Int
    for n in 0...4 {
        for y in 0...maxSmall {
            for x in 0...maxSmall {
                nx = x+(n*(maxSmall+1))
                largeMatrix[nx,y] = matrix[x, y]! + n
                if largeMatrix[nx,y]! > 9 {
                    largeMatrix[nx,y]! -= 9
                }
            }
        }
    }
    
    // vertical
    let maxLarge: Int = largeMatrix.getYs().max()!
    var ny: Int
    for n in 1...3 {
        for y in 0...maxLarge {
            for x in 0...maxLarge {
                ny = y+(n*(maxSmall+1))
                largeMatrix[x,ny] = largeMatrix[x,y]! + n
                if largeMatrix[x,ny]! > 9 {
                    largeMatrix[x,ny]! -= 9
                }
            }
        }
    }
    return largeMatrix
}

func partTwo() -> Int {
    let largeMatrix = transformMap(matrix: inputMatrix)
    return getLowestTotalRiskPath(matrix: largeMatrix)
}

print("Solution part 2:", partTwo())

