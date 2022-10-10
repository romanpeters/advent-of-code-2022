import Foundation

func printSep(step: String) {
    print("\u{001B}[2J")
    print(String(repeating: "-", count: 80))
    print(String(repeating: ">", count: 10), step)
    print(String(repeating: "-", count: 80))
}


func runAllTests() {
    var examplePackage: Packet

    printSep(step: "example 1")
    let example1 = "D2FE28"
    assert(Packet(inputBits: largeHexToBinaryArray(hexInput: example1)).value == 2021)

    printSep(step: "example 2")
    let example2 = "38006F45291200"
    assert(Packet(inputBits: largeHexToBinaryArray(hexInput: example2)).subPackets.count == 2)
    
    printSep(step: "example 3")
    let example3 = "EE00D40C823060"
    examplePackage = Packet(inputBits: largeHexToBinaryArray(hexInput: example3))
    assert(examplePackage.subPackets[0].value == 1)
    assert(examplePackage.subPackets[1].value == 2)
    assert(examplePackage.subPackets[2].value == 3)
    
    printSep(step: "example 4")
    let example4 = "8A004A801A8002F478"
    assert(calculateVersionSum(packet: Packet(inputBits: largeHexToBinaryArray(hexInput: example4))) == 16)
    
    
    printSep(step: "example 5")
    let example5 = "620080001611562C8802118E34"
    assert(calculateVersionSum(packet: Packet(inputBits: largeHexToBinaryArray(hexInput: example5))) == 12)

    printSep(step: "example 6")
    let example6 = "C0015000016115A2E0802F182340"
    assert(calculateVersionSum(packet: Packet(inputBits: largeHexToBinaryArray(hexInput: example6))) == 23)

    printSep(step: "example 7")
    let example7 = "A0016C880162017C3686B18A3D4780"
    assert(calculateVersionSum(packet: Packet(inputBits: largeHexToBinaryArray(hexInput: example7))) == 31)
    
    print("All tests passed")
}



