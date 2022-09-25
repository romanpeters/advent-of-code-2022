import Foundation

let input = CommandLine.arguments.last == "test" ? "test" : "input" // change "input" to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ?
    URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}

var target: [String: Int] = [:]
let regexX = inputFile.range(of: #"(?<=x=)(.*)(?=,)"#, options: .regularExpression)  // between "=x" and ","
let regexY = inputFile.range(of: #"(?<=y=)(.*)"#, options: .regularExpression)       // after "y="
target["x1"] = Int(inputFile[regexX!].components(separatedBy: "..")[0])
target["x2"] = Int(inputFile[regexX!].components(separatedBy: "..")[1])
target["y1"] = Int(inputFile[regexY!].components(separatedBy: "..")[0])
target["y2"] = Int(inputFile[regexY!].components(separatedBy: "..")[1])


class Matrix {
    var _storage: [Int: [Int: Int]] = [:]

    func fill(value: Int, x1: Int, x2: Int, y1: Int, y2: Int) {
        for x in [x1, x2].min()!...[x1, x2].max()! {
            for y in [y1, y2].min()!...[y1, y2].max()! {
                set(x: x, y: y, value: value)
            }
        }
    }
    
    func set(x: Int, y: Int, value: Int) {
        if _storage[x] == nil {
            _storage[x] = [:]
        }
        _storage[x]![y] = value
    }
    
    func get(x: Int, y: Int) -> Int? {
        return _storage[x]?[y]
    }
}

struct Probe {
    var x: Int
    var y: Int
    var xVelocity: Int
    var yVelocity: Int
}

func nextStep(probe: Probe) -> Probe {
    var newPosition = probe
    newPosition.x += probe.xVelocity
    newPosition.y += probe.yVelocity
    if probe.xVelocity != 0 {
        newPosition.xVelocity = probe.xVelocity > 0 ? (newPosition.xVelocity - 1) : (newPosition.xVelocity + 1)
    }
    newPosition.yVelocity -= 1
    return newPosition
}

func probeHits(xVelocity: Int, yVelocity: Int, matrix: Matrix) -> Bool {
    var probe = Probe(x: 0, y:0, xVelocity: xVelocity, yVelocity: yVelocity)
    while true {
        probe = nextStep(probe: probe)
        if matrix.get(x: probe.x, y: probe.y) ?? 0 == 1 {
            // hits
            return true
        }
        if probe.xVelocity == 0 && probe.x < target["x1"]! {
            // not far enough
            return false
        }
        if probe.x > target["x2"]! {
            // too far
            return false
        }
        if probe.y < target["y1"]! && probe.y < target["y2"]! {
            // too low
            return false
        }
    }
}

func maxHeight(xVelocity: Int, yVelocity: Int, matrix: Matrix) -> Int {
    var probe = Probe(x: 0, y:0, xVelocity: xVelocity, yVelocity: yVelocity)
    var maxY = 0
    while true {
        probe = nextStep(probe: probe)
        if probe.y > maxY {
            maxY = probe.y
        } else {
            break
        }
    }
    return maxY
}

let matrix = Matrix()
matrix.fill(value: 1, x1: target["x1"]!, x2: target["x2"]!, y1: target["y1"]!, y2: target["y2"]!)  // fill target area with 1's

func partOne() -> Int {
    var totalMaxHeight = 0
    
    // math is hard, brute-force is easy
    var mHeight: Int
    // todo: ranges are overfitted to the input, should be calculated based on the target
    for yVelocity in 0...100 {  // y-velocity needs to be positive to get a high height
        for xVelocity in 0...100 {
            if probeHits(xVelocity: xVelocity, yVelocity: yVelocity, matrix: matrix) {
                mHeight = maxHeight(xVelocity: xVelocity, yVelocity: yVelocity, matrix: matrix)
                if mHeight > totalMaxHeight {
                    totalMaxHeight = mHeight
                }
            }
        }
    }
    return totalMaxHeight
}

print("Solution part 1:", partOne())

// part 2

func partTwo() -> Int {
    var hits = 0
    // todo: ranges are overfitted to the input, should be calculated based on the target
    for yVelocity in -500...500 {
        for xVelocity in 0...500{
            if probeHits(xVelocity: xVelocity, yVelocity: yVelocity, matrix: matrix) {
                hits += 1
            }
        }
    }
    return hits
}

print("Solution part 2:", partTwo())
