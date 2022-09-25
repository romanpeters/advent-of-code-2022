import Foundation

let input = CommandLine.arguments.last == "test" ? "test" : "input" // change "input" to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ?
    URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}

var bingoNumbers: [Int] = []
var bingoBoards: [[[Int]]] = []

for n in inputFile.split(separator: "\n")[0].split(separator: ",") {
    bingoNumbers.append(Int(n)!)
}

var board: [[Int]] = []
var row: [Int] = []
let lines = inputFile.split(separator: "\n")[1..<inputFile.split(separator: "\n").count]
for line in lines {
    for n in line.split(separator: " ") {
        row.append(Int(n)!)
    }
    board.append(row)
    row = []
    
    if board.count == 5 {
        bingoBoards.append(board)
        board = []
    }
}

func drawNumber(number: Int) {
    for i in 0...bingoBoards.count-1 {
        for j in 0...bingoBoards[i].count-1 {
            for k in 0...bingoBoards[i][j].count-1 {
                if bingoBoards[i][j][k] == number {
                    if bingoBoards[i][j][k] == 0 {
                        bingoBoards[i][j][k] = -1
                    } else {
                        bingoBoards[i][j][k] = bingoBoards[i][j][k] * -1
                    }
                }
            }
        }
    }

    
}

var winningScore: Int = 0
var completedPerRow: Int = 0
var completedPerColumn: Int = 0

func checkWinning(lastNumber: Int) -> Bool {
    var column: [Int] = []
    for i in 0...bingoBoards.count-1 {
        
        // check rows
        for row in bingoBoards[i] {
            completedPerRow = 0
            for num in row {
                if num < 0 {
                    completedPerRow += 1
                }
            }
            if completedPerRow == 5 {
                setWinningScore(board: bingoBoards[i], multiplier: lastNumber)
                bingoBoards.remove(at: i)
                return true
            }
        }
        
        // check columns
        for n in 0...bingoBoards[i][0].count-1 {
            completedPerColumn = 0
            column = []
            for row in bingoBoards[i] {
                column.append(row[n])
            }
            for num in column {
                if num < 0 {
                    completedPerColumn += 1
                }
            }
            if completedPerColumn == 5 {
                setWinningScore(board: bingoBoards[i], multiplier: lastNumber)
                bingoBoards.remove(at: i)
                return true
            }
            
            
        }
    }
    return false
}

func setWinningScore(board: [[Int]], multiplier: Int) {
    var points: Int = 0
    for row in board {
        for num in row {
            if num > 0 {
                points += num
            }
        }
    }
    if points > 0 {
        winningScore = points * multiplier
    }
}

for n in bingoNumbers {
    drawNumber(number: n)
    checkWinning(lastNumber: n)
    if winningScore > 0 {
        print("Solution part 1: \(winningScore)")
        break
    }
}

// part 2
// some hacky stuff below, 'cause I didn't feel like changing the funcs from part 1
for n in bingoNumbers {
    if bingoBoards.count > 1 {
        drawNumber(number: n)
        for _ in 0...10 {
            checkWinning(lastNumber: n)
        }
    } else {
        for i in 0...bingoBoards[0].count-1 {
            for j in 0...bingoBoards[0][i].count-1 {
                if bingoBoards[0][i][j] == n {
                    bingoBoards[0][i][j] = bingoBoards[0][i][j] * -1
                }
            }
        }
        if checkWinning(lastNumber: n) {
            break
        }
    }
}

print("Solution part 2: \(winningScore)")
