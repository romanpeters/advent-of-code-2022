import Foundation

let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "test" // change to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ?
    URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}


func createGrid(inputFile: String) -> OctopusGrid {
    var grid: [[Int]] = []
    for line in inputFile.split(separator: "\n") {
        grid.append(String(line).compactMap{ $0.wholeNumberValue })
    }
    return OctopusGrid(grid_: grid)
}

class OctopusGrid {
    var octopi: [Octopus] = []
    var lookUpTable: [String:Int] = [:]
    var grid: [[Int]]
    var flashes: Int = 0
    var hasFlashed: [Int] = []
    
    public init(grid_: [[Int]]) {
        self.grid = grid_
        
        // set octopi
        for y in 0...grid.count-1 {
            for x in 0...grid[0].count-1 {
                self.octopi.append(Octopus(energyLevel: grid[y][x], x: x, y: y))
                lookUpTable["\(x).\(y)"] = lookUpTable.keys.count
            }
        }
        setNeighbors()
    }
    
    
        
    func setNeighbors() {
        // set neighbors
        var updatingOctopus: Octopus
        for y in 0...grid.count-1 {
            for x in 0...grid[0].count-1 {
                updatingOctopus = getOctopusAt(x: x, y: y)!
                updatingOctopus.neighbors = getNeighbors(x: x, y: y)
                setOctopus(octopus: updatingOctopus)
            }
        }
    }
    
    func getNeighbors(x: Int, y: Int) -> [Octopus] {
        var neighbors: [Octopus?] = []
        neighbors.append(getOctopusAt(x: x-1, y: y)) // left
        neighbors.append(getOctopusAt(x: x+1, y: y)) // right
        neighbors.append(getOctopusAt(x: x, y: y+1)) // up
        neighbors.append(getOctopusAt(x: x, y: y-1)) // down
        neighbors.append(getOctopusAt(x: x-1, y: y+1)) // left-up
        neighbors.append(getOctopusAt(x: x+1, y: y+1)) // right-up
        neighbors.append(getOctopusAt(x: x-1, y: y-1)) // left-down
        neighbors.append(getOctopusAt(x: x+1, y: y-1)) // right-down
        return neighbors.compactMap { $0 }
    }
    
    func getOctopusAt(x: Int, y: Int) -> Octopus? {
        if !lookUpTable.keys.contains("\(x).\(y)") {
            return nil
        }
        return octopi[lookUpTable["\(x).\(y)"]!]
    }
    
    func setOctopus(octopus: Octopus) {
        octopi[lookUpTable["\(octopus.x).\(octopus.y)"]!] = octopus
    }
    
    func increaseEnergy(octopus n: Int, by value: Int) {
        octopi[n].energyLevel += value
    }

    func resetEnergy(octopus n: Int) {
        octopi[n].energyLevel = 0
    }
    
    func triggerFlash() {
        while octopi.filter({ $0.energyLevel > 9 }).count > hasFlashed.count {
            for n in 0...octopi.count-1 {
                if octopi[n].energyLevel > 9 && !hasFlashed.contains(n) {
                    octopi[n].flash(grid: self)
                    hasFlashed.append(n)
                }
            }
        }
    }
}

class Octopus {
    var energyLevel: Int
    let x: Int
    let y: Int
    var neighbors: [Octopus] = []
    
    public init(energyLevel: Int, x: Int, y: Int) {
        self.energyLevel = energyLevel
        self.x = x
        self.y = y
    }
    
    func flash(grid: OctopusGrid) {
        grid.flashes += 1
        var neighbor: Octopus
        for octo in neighbors {
            neighbor = grid.getOctopusAt(x: octo.x, y: octo.y)!
            neighbor.energyLevel += 1
            grid.setOctopus(octopus: neighbor)
        }
    }
}


struct Controller {
    var octos: OctopusGrid
    
    mutating func step1() {
        for n in 0...octos.octopi.count-1 {
            octos.increaseEnergy(octopus: n, by: 1)
        }
    }
    
    mutating func step2() {
        octos.triggerFlash()
    }
    
    mutating func step3() {
        for n in octos.hasFlashed {
            octos.resetEnergy(octopus: n)
        }
        octos.hasFlashed = []
    }
}


var octopusGrid = createGrid(inputFile: inputFile)
var controller = Controller(octos: octopusGrid)

for _ in 1...100 {
    controller.step1()
    controller.step2()
    controller.step3()
}

print("Solution part 1 \(controller.octos.flashes)")


octopusGrid = createGrid(inputFile: inputFile)
controller = Controller(octos: octopusGrid)

var n = 0
while true {
    n += 1
    controller.step1()
    controller.step2()
    if controller.octos.hasFlashed.count == controller.octos.octopi.count {
        break
    }
    controller.step3()
}

print("Solution part 2: \(n)")

