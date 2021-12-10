import Foundation

guard let inputFile = try? String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!, encoding: .utf8) else {
    fatalError("Cannot read file input.txt")
}

var heightMap: [[Int]] = []
var row: [Int]
for line in inputFile.split(separator: "\n") {
    row = []
    for height in line {
        row.append(Int(String(height))!)
    }
    heightMap.append(row)
}

func getAdjacent(direction: String, from location: (y: Int, x: Int), in heightMap: [[Int]]) -> (Int, Int)? {
    var coords: (Int, Int) = location
    switch(direction) {
    case "up":
        if coords.0 == 0 {
            return nil
        }
        coords.0 -= 1
    case "down":
        if coords.0 == heightMap.count-1 {
            return nil
        }
        coords.0 += 1
    case "left":
        if coords.1 == 0 {
            return nil
        }
        coords.1 -= 1
    case "right":
        if coords.1 == heightMap[0].count-1 {
            return nil
        }
        coords.1 += 1
    default:
        print("Invalid direction")
    }
    return coords
}

func isLowestPoint(point: (y: Int, x: Int), in heightMap: [[Int]]) -> Bool {
    var adjacentPoint: (Int, Int)?
    for direction in ["up", "down", "left", "right"] {
        adjacentPoint = getAdjacent(direction: direction, from: (point.y, point.x), in: heightMap)
        if adjacentPoint != nil {
            if heightMap[adjacentPoint!.0][adjacentPoint!.1] <= heightMap[point.y][point.x] {
                return false
        
            }
        }
    }
    return true
}

var lowestPoints: [(Int, Int)] = []
for y in 0...heightMap.count-1 {
    for x in 0...heightMap[0].count-1 {
        if isLowestPoint(point: (y, x), in: heightMap) {
            lowestPoints.append((y, x))
        }
    }
}

func calculateRiskLevelSum(points: [(Int, Int)], in heightMap: [[Int]]) -> Int {
    var riskLevelSum: Int = 0
    for point in points {
        riskLevelSum += heightMap[point.0][point.1] + 1
    }
    return riskLevelSum
}

print("Solution part 1: \(calculateRiskLevelSum(points: lowestPoints, in: heightMap))")


struct Point {
    let y: Int
    let x: Int
    let height: Int
    let isLowest: Bool
    var visited: Bool = false
    
    func getID() -> String {
        return "\(y).\(x)"
    }
}

struct Basin {
    let lowestPoint: Point
    var points: [Point]
    
    func getCount() -> Int {
        return self.points.count
    }
}


var pointCollection: [Point] = []
var basins: [Basin] = []
var currentPoint: Point


for y in 0...heightMap.count-1 {
    for x in 0...heightMap[0].count-1 {
        currentPoint = Point(y:y, x:x, height: heightMap[y][x], isLowest: isLowestPoint(point: (y, x), in: heightMap))
        pointCollection.append(currentPoint)
        if currentPoint.isLowest {
            currentPoint.visited = true
            basins.append(Basin(lowestPoint: currentPoint, points: [currentPoint]))
        }
    }
}


func findLowest(from point: Point) -> Point {
    var resultPoint: Point = point
    
    func next(point: Point) -> Point {
        var adjacentCoords: (Int, Int)?
        var adjacentPoints: [Point] = []
        var nextPoint: Point
        
        for direction in ["up", "down", "left", "right"] {
            adjacentCoords = getAdjacent(direction: direction, from: (point.y, point.x), in: heightMap)
            if adjacentCoords != nil {
                adjacentPoints.append(Point(y: adjacentCoords!.0, x: adjacentCoords!.1, height: heightMap[adjacentCoords!.0][adjacentCoords!.1], isLowest: isLowestPoint(point: adjacentCoords!, in: heightMap)))
            }
        }
        nextPoint = adjacentPoints[0]
        for point in adjacentPoints {
            if point.height < nextPoint.height {
                nextPoint = point
            }
        }
        return nextPoint
    }
    
    while resultPoint.isLowest == false {
        resultPoint = next(point: resultPoint)
    }
    
    return resultPoint
}

var flowsTo: Point
for n in 0...pointCollection.count-1 {
    if !pointCollection[n].visited {
        pointCollection[n].visited = true
        if pointCollection[n].height != 9 && !pointCollection[n].isLowest {
            flowsTo = findLowest(from: pointCollection[n])
            for i in 0...basins.count-1 {
                if basins[i].lowestPoint.getID() == flowsTo.getID() {
                    basins[i].points.append(pointCollection[n])
                }
            }
        }
    }
}

var result: Int = 1
for basin in basins.sorted(by: { $0.getCount() > $1.getCount() })[...2]  {
    print(basin.getCount())
    result *= basin.getCount()
}
print("Solution part 2: \(result)")

