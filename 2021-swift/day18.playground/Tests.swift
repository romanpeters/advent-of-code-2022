import Foundation

func testExplosions() {
    print("Testing explosions...")
    assert(explodeLeftmost(snailfishNumber: "[[[[[9,8],1],2],3],4]").0 == "[[[[0,9],2],3],4]")
    assert(explodeLeftmost(snailfishNumber: "[7,[6,[5,[4,[3,2]]]]]").0 == "[7,[6,[5,[7,0]]]]")
    assert(explodeLeftmost(snailfishNumber: "[[6,[5,[4,[3,2]]]],1]").0 == "[[6,[5,[7,0]]],3]")
    assert(explodeLeftmost(snailfishNumber: "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]").0 == "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")
    assert(explodeLeftmost(snailfishNumber: "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]").0 == "[[3,[2,[8,0]]],[9,[5,[7,0]]]]")
    print("Exploding tests passed")
}

func testSplits() {
    print("Testing splits...")
    assert(splitLeftmost(snailfishNumber: "[[[[0,7],4],[15,[0,13]]],[1,1]]").0 == "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]")
    assert(splitLeftmost(snailfishNumber: "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]").0 == "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]")
    print("Split tests passed")
}

func testAdditions() {
    print("Testing additions...")
    let example1 = """
[1,1]
[2,2]
[3,3]
[4,4]
""".split(separator: "\n").map({ String($0) })
    assert(addSnailfishNumbers(snailfishNumbers: example1) == "[[[[1,1],[2,2]],[3,3]],[4,4]]")
    
    let example2 = """
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
""".split(separator: "\n").map({ String($0) })
    assert(addSnailfishNumbers(snailfishNumbers: example2) == "[[[[3,0],[5,3]],[4,4]],[5,5]]")

    let example3 = """
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
[6,6]
""".split(separator: "\n").map({ String($0) })
    assert(addSnailfishNumbers(snailfishNumbers: example3) == "[[[[5,0],[7,4]],[5,5]],[6,6]]")
    
    let example4 = """
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
""".split(separator: "\n").map({ String($0) })
    assert(addSnailfishNumbers(snailfishNumbers: example4) == "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
    
    let example5 = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
""".split(separator: "\n").map({ String($0) })
    assert(addSnailfishNumbers(snailfishNumbers: example5) == "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]")

    print("Addition tests passed")
}
