//
//  main.swift
//  day07_swift
//
//  Created by Roman Peters on 07/12/2021.
//

import Foundation

let filePath = URL(fileURLWithPath: "input.txt")
let inputFile: String = try! String(contentsOf: filePath, encoding: .utf8)

var crabPositions: [Int] = []
for crab in inputFile.split(separator: ",") {
    crabPositions.append(Int(crab.trimmingCharacters(in: .whitespacesAndNewlines))!)
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}

func findShortestEditDistance(crabPositions: [Int]) -> Int {
    var result: Int = -1
    var editDistances: [Int]
    
    for n in 0...crabPositions.max()! {
        editDistances = []
        for crab in crabPositions {
            if n < crab {
                editDistances.append(crab-n)
            } else if n == crab {
                editDistances.append(0)
            } else {
                editDistances.append(n-crab)
            }
        }
        
        if result == -1 {
            result = editDistances.sum()
        } else {
            if editDistances.sum() < result {
                result = editDistances.sum()
            }
        }
    }
    return result
}

print("Solution part 1: \(findShortestEditDistance(crabPositions: crabPositions))")

// part 2

func getEditDistanceMean(crabPositions: [Int]) -> Int {
    let meanCrab: Int = crabPositions.sum() / crabPositions.count
    var editDistances: [Int] = []

    for crab in crabPositions {
        
        // move left
        if meanCrab < crab {
            editDistances.append(Array(0...crab-meanCrab).sum())
            
        // move right
        } else if meanCrab > crab {
            editDistances.append(Array(0...meanCrab-crab).sum())
        }
    }
    return editDistances.sum()
}

print("Solution part 2: \(getEditDistanceMean(crabPositions: crabPositions))")
