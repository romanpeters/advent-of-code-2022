import Foundation

let input = CommandLine.arguments.last == "test" ? "test" : "input" // change "input" to "test" for example data
let inputPath  = FileManager.default.fileExists(atPath: "Resources/\(input).txt") ?
    URL(fileURLWithPath: "Resources/\(input).txt") : Bundle.main.url(forResource: input, withExtension: "txt")!
guard let inputFile = try? String(contentsOf: inputPath, encoding: .utf8) else {
    fatalError("Cannot read \(input) file \(inputPath)")
}

func hexToBinaryArray(hexInput: String) -> [Int] {
    let binary: String = String(Int(hexInput, radix: 16)!, radix: 2)
    let leadingZeros = String(repeating: "0", count: (hexInput.count * 4) - binary.count)
    return String(leadingZeros + binary).compactMap({$0.wholeNumberValue})
}

// an int can only hold so much
func largeHexToBinaryArray(hexInput: String) -> [Int] {
    var binaryArray = [Int]()
    for c in hexInput {
        binaryArray += hexToBinaryArray(hexInput: String(c))
    }
    return binaryArray
}

func binaryArrayToDecimal(binaryInput: [Int]) -> Int {
    return Int(binaryInput.map { String($0) }.joined(), radix: 2)!
}


extension Array {
    // split arrays in equal parts using .chunked(size: Int)
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


func parsePackets(binaryInput: [Int], maxPackets: Int? = nil) -> ([Packet], [Int]) {
    // instantiates Packet() classes from binary, used to set sub-packets
    var remainingBinary: [Int] = binaryInput
    var packets: [Packet] = []
    var packet: Packet
    // continues until no relevant trailing bits
    while !remainingBinary.isEmpty {
        packet = Packet(inputBits: remainingBinary)
        packets.append(packet)
        remainingBinary = packet.trailingBits
        if remainingBinary.reduce(.zero, +) == 0 {  // trailing 0 bits can be ignored
            remainingBinary = []
        }
        if maxPackets != nil {
            if packets.count == maxPackets {
                break
            }
        }
    }
    return (packets, remainingBinary)
}


class Packet {
    let bits: [Int]
    let version: Int
    let typeID: Int
    var value: Int?
    var trailingBits: [Int] = []
    var lengthTypeId: Int?
    var subPackets: [Packet] = []
    
    init(inputBits: [Int]) {
        self.bits = inputBits
        self.version = binaryArrayToDecimal(binaryInput: Array(bits[0...2]))
        self.typeID = binaryArrayToDecimal(binaryInput: Array(bits[3...5]))
        if self.typeID != 4 {  // packet is an operator, set sub-packets
            self.lengthTypeId = bits[6]
            self.setSubPackets()
        }
        self.setValue()
    }
    
    func setSubPackets() {
        if lengthTypeId == 0 {
            // total length in bits of the sub-packets contained by this packet
            let totalLengthSubPackets: Int = binaryArrayToDecimal(binaryInput: Array(self.bits[7...21]))
            let indexEnd = 22+totalLengthSubPackets-1
            let subPacketsBinary: [Int] = Array(bits[22...indexEnd])
            assert(subPacketsBinary.count == totalLengthSubPackets)

            // it's important to set the trailing bits, so they might be parsed as well
            if bits.count-1 > indexEnd {
                self.trailingBits = Array(bits[indexEnd+1...bits.count-1])
            }
            
            self.subPackets += parsePackets(binaryInput: subPacketsBinary).0
            
        } else {
            assert(lengthTypeId == 1)
            // number of sub-packets immediately contained by this packet
            let numberOfSubPackets = binaryArrayToDecimal(binaryInput: Array(self.bits[7...17]))
            let subPacketsBinary: [Int] = Array(bits[18...bits.count-1])
            let parseResult = parsePackets(binaryInput: subPacketsBinary, maxPackets: numberOfSubPackets)
            self.trailingBits = parseResult.1
            self.subPackets += parseResult.0
        }
    }
    
    func setValue() {
        
        func getLiteralValue() -> Int {
            let groups = Array(bits[6...bits.count-1]).chunked(into: 5)
            var literalValueBits: [Int] = []
            for (i, group) in groups.enumerated() {
                literalValueBits += Array(group[1...4])
                if group[0] == 0 {
                    if groups.count-1 > i {
                        self.trailingBits = groups[i+1...groups.count-1].reduce([], +)
                    }
                    break
                }
            }
            return binaryArrayToDecimal(binaryInput: literalValueBits)
        }
        
        switch(self.typeID) {
        case 0: // sum packet
            self.value = subPackets.map( {Int($0.value!)} ).reduce(0, +)
        case 1: // product packet
            self.value = subPackets.map( {Int($0.value!)} ).reduce(1, *)
        case 2: // minimum packet
            self.value = subPackets.map( {Int($0.value!)} ).min()
        case 3: // maximum packet
            self.value = subPackets.map( {Int($0.value!)} ).max()
        case 4: // literal packet
            self.value = getLiteralValue()
        case 5: // greater than packet
            let packValues = subPackets.map( {Int($0.value!)} )
            self.value = packValues[0] > packValues[1] ? 1 : 0
        case 6: // less than packet
            let packValues = subPackets.map( {Int($0.value!)} )
            self.value = packValues[0] < packValues[1] ? 1 : 0
        case 7:
            let packValues = subPackets.map( {Int($0.value!)} )
            self.value = packValues[0] == packValues[1] ? 1 : 0
        default:
            break
        }
    }
}

func calculateVersionSum(packet: Packet) -> Int {
    // gathers all sub-packets and sums their .version
    var allPackets: [Packet] = [packet]
    var subPackets: [Packet] = packet.subPackets
    var newSubPackets: [Packet]
    
    while !subPackets.isEmpty {
        newSubPackets = []
        for sp in subPackets {
            allPackets.append(sp)
            newSubPackets += sp.subPackets
        }
        subPackets = newSubPackets
    }
    return allPackets.map( {$0.version} ).reduce(0, +)
}

func partOne() -> Int {
    let binaryArray = largeHexToBinaryArray(hexInput: inputFile)
    return calculateVersionSum(packet: Packet(inputBits: binaryArray))
}

print("Solution part 1:", partOne())

// part 2

func partTwo() -> Int {
    let binaryArray = largeHexToBinaryArray(hexInput: inputFile)
    return Packet(inputBits: binaryArray).value!
}

print("Solution part 2:", partTwo())
