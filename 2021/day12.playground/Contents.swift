import Foundation

let input = CommandLine.arguments.last == "test" ? "test" : "input" // change "input" to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ?
    URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}


class Node {
    let name: String
    let isSmall: Bool
    
    public init(name: String) {
        self.name = name
        self.isSmall = name.lowercased() == name ? true : false
    }
}


class Edge {
    let nodes: (Node, Node)
    
    public init(nodes: (Node, Node)) {
        self.nodes = nodes
    }
    
    func other(name: String) -> Node? {
        // returns the opposite node
        if name == nodes.0.name {
            return nodes.1
        }
        if name == nodes.1.name {
            return nodes.0
        }
        return nil
    }
}


class Map {
    var start: Node? = nil
    var stop: Node? = nil
    var nodes: [Node] = []
    var edges: [Edge] = []
    
    func addConnection(nodeA: Node, nodeB: Node) {
        var existingNode: Node?
        for newNode in [nodeA, nodeB] {
            existingNode = getNode(name: newNode.name)
            if existingNode == nil {
                switch(newNode.name) {
                case "start":
                    start = newNode
                case "stop":
                    stop = newNode
                default:
                    nodes.append(newNode)
                }
            }
        }
        edges.append(Edge(nodes: (nodeA, nodeB)))
    }
    
    func getNode(name: String) -> Node? {
        return nodes.first(where: { $0.name == name } )
    }
    
    func getEdges(nodeName: String) -> [Edge] {
        return edges.filter( { $0.nodes.0.name == nodeName || $0.nodes.1.name == nodeName } )
    }
    
    func printMap() {
        for edge in edges {
            print("\(edge.nodes.0.name)-\(edge.nodes.1.name)")
        }
    }
}


struct Path {
    var nodes: [Node]
    var isComplete: Bool = false
    var tinyCaveVisitLimitReached: Bool = false
    
    func printPath() {
        print(nodes.map( { $0.name } ))
    }
    
    func visitedNode(name: String) -> Int {
        return nodes.filter({ $0.name == name }).count
    }
}

func walk(map: Map, tinyCaveVisits: Int = 1) -> [Path] {
    // Breadth-first path traversal
    
    var paths: [Path] = []
    var path: Path
    
    // get the edges from start
    for edge in map.getEdges(nodeName: "start") {
        path = Path(nodes: [map.start!, edge.other(name: "start")!])
        paths.append(path)
    }
    
    var newPaths: [Path]
    var newNode: Node
    var name: String
    
    // get the other edges
    while paths.filter( { $0.isComplete == false } ).count > 0  {
        newPaths = []
        for n in 0...paths.count-1 {
            if !paths[n].isComplete {
                name = paths[n].nodes.last!.name
                for edge in map.getEdges(nodeName: name) {
                    path = paths[n]
                    newNode = edge.other(name: name)!
                    
                    if !(newNode.isSmall &&
                        path.visitedNode(name: newNode.name) >= 1 &&
                        path.tinyCaveVisitLimitReached) { // skip tiny caves which have been visited too much
                        
                        if !(newNode.isSmall && path.visitedNode(name: newNode.name) >= tinyCaveVisits) {  // skip tiny caves above the limit
                            
                            // add path
                            path.nodes.append(newNode)
                        
                            if (newNode.isSmall && path.visitedNode(name: newNode.name) == tinyCaveVisits) &&
                                path.tinyCaveVisitLimitReached == false {
                                path.tinyCaveVisitLimitReached = true
                            }
                            if path.nodes.last!.name == "end" {
                                path.isComplete = true
                            }
                            if path.nodes.last!.name != "start" {
                                newPaths.append(path)
                            }
                        }
                    }
                }
            }
        }
        newPaths += paths.filter( { $0.isComplete == true } )  // add completed paths
        paths = newPaths  // continue with the new list of paths
    }
    return paths
}


func partOne(inputFile: String) {
    let map = Map()
    let paths: [Path]
    
    // Add nodes and edges to map
    for line in inputFile.split(separator: "\n") {
        map.addConnection(nodeA: Node(name: String(line.split(separator: "-")[0])),
                          nodeB: Node(name: String(line.split(separator: "-")[1])))
    }
    
    paths = walk(map: map)
    print("Solution part 1: \(paths.count)")
}

partOne(inputFile: inputFile)


// part 2

func partTwo(inputFile: String) {
    let map = Map()
    let paths: [Path]
    
    for line in inputFile.split(separator: "\n") {
        map.addConnection(nodeA: Node(name: String(line.split(separator: "-")[0])),
                          nodeB: Node(name: String(line.split(separator: "-")[1])))
    }

    paths = walk(map: map, tinyCaveVisits: 2)
    print("Solution part 2: \(paths.count)")
}

partTwo(inputFile: inputFile)
