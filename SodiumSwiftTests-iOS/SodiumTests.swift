//
//  SodiumTests.swift
//  SodiumTests
//
//  Created by Andrew Bradnan on 4/27/16.
//  Copyright © 2016 Whirlygig Ventures. All rights reserved.
//

import XCTest
@testable import SodiumSwift

class SodiumSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCellValue() {
        let s = StreamSink<Int>()
        let c = Cell<Int>(stream: s, initialValue: 1234)
        
        XCTAssert(c.ValueProperty == 1234, "testCellValue failed \(c.ValueProperty)")
        XCTAssert(c.sample() == 1234, "testCellValue failed \(c.sample())")
        s.send(5)
        XCTAssert(c.ValueProperty == 5, "testCellValue failed \(c.ValueProperty)")
        XCTAssert(c.sample() == 5, "testCellValue failed \(c.sample())")
        
    }

    func testLazyCellValue() {
        let s = StreamSink<Int>()
        let c = LazyCell<Int>(stream: s, initialValue: 1234)
        
        XCTAssert(c.sample() == 1234, "testCellValue failed \(c.sample())")
        s.send(5)
        XCTAssert(c.sample() == 5, "testCellValue failed \(c.sample())")
        
    }

    func testCellSinkSend() {
        let c = CellSink<Int>(1234)
        
        c.send(2345)
        
        let v = c.sample()
        
        XCTAssert(2345 == v, "testCellSinkSend() failed \(v)")
    }
    
    func testValue() {
        var out = Array<Int>()
        do {
            let c = CellSink<Int>(9)
            let l = Transaction.noThrowRun { () -> Listener in
                //Operational.value(c).listen({ out.append($0) })
                let stream = Transaction.apply{ c.value($0) }
                let l2 = stream.listen{
                    out.append($0)
                }
                //stream.unlisten()
                return l2
            }
            defer { l.unlisten() }
            
            c.send(2)
            c.send(7)
        }
        XCTAssert([9,2,7] == out, "testValue failed \(out)")
    }

    func testMap() {
        let c = CellSink<Int>(6)
        var out = Array<String>()
        do {
            let l = c.map{ $0.description }.listen{ out.append($0) }
            defer { l.unlisten() }
            c.send(8)
        }
        XCTAssert(["6","8"] == out, "testMap() failed \(out)")
    }

    func testValueThenMap() {
        let c = CellSink<Int>(9)
        var out = Array<Int>()
        
        do {
            let l = Transaction.run{ Operational.value(c).map{ $0 + 100}.listen{ out.append($0) }}!
            defer { l.unlisten() }
            
            c.send(2)
            c.send(7)
        }
        XCTAssert([109,102,107] == out, "testValueThenMap() failed \(out)")
    }
    
    func testValueThenMerge()
    {
        let c1 = CellSink<Int>(9)
        let c2 = CellSink<Int>(2)
        var out = Array<Int>()
        do {
            let l = Transaction.run{
                Operational.value(c1).merge(Operational.value(c2), f: {(x, y) in x + y}).listen{ out.append($0) }}!
            defer { l.unlisten() }

            c1.send(1)
            c2.send(4)
        }
        XCTAssert([11,1,4] == out, "testValueThenMerge() failed \(out)")
    }


    func testValueThenOnce() {
        let c = CellSink<Int>(9)
        var out = Array<Int>()
        
        do {
            let l = Transaction.run { Operational.value(c).once().listen{ out.append($0) }}!
            defer { l.unlisten() }
            c.send(2)
            c.send(7)
        }
        XCTAssert([9] == out, "testValueThenOnce() failed \(out)")
    }

    func testValueThenFilter()
    {
        let c = CellSink<Int>(9)
        var out = Array<Int>()

        do {
            let l = Transaction.run{ Operational.value(c).filter{ $0 % 2 != 0}.listen{ out.append($0) }}!
            defer { l.unlisten() }
            
            c.send(2)
            c.send(7)
        }
        XCTAssert([9,7] == out, "testValueThenFilter() failed \(out)")
    }
    
    func testValueThenLateListen()
    {
        let c = CellSink<Int>(9)
        var out = Array<Int>()
        let value = Operational.value(c)
        c.send(8)
        do {
            let l = value.listen{ out.append($0) }
            defer { l.unlisten() }
            c.send(2)
            c.send(7)
        }
        XCTAssert([2,7] == out, "testValueThenLateListen() failed \(out)")
    }
    
    func testHoldLazy() {
        let c = CellSink<Int>(666)
        
        let foo = Transaction.apply{ (trans: Transaction) in
                    c.stream().holdLazy(trans, lazy: c.sampleLazy(trans)) }
        
        let v = foo.sample()
        
        XCTAssert(666 == v, "testHoldLazy() failed \(v)")
    }
    
    func testMapLateListen()
    {
        let c = CellSink<Int>(6)
        var out = [String]()
        let cm = c.map{ $0.description }
        c.send(2)
        do {
            let l = cm.listen{
                out.append($0)
            }
            defer { l.unlisten() }
            c.send(8)
        }
        XCTAssert(["2","8"] == out, "testMapLateListen() failed \(out)")
    }
    
    func testLift()
    {
        let c1 = CellSink<Int>(1)
        let c2 = CellSink<Int64>(5)
        var out = Array<String>()
        do {
            let l = c1.lift(c2, f: {(x: Int, y: Int64) in x.description + " " + y.description}).listen{ out.append($0) }
            defer { l.unlisten() }
            c1.send(12)
            c2.send(6)
        }
        XCTAssert(["1 5", "12 5", "12 6"] == out, "testList() failed \(out)")
    }

    func testLift3()
    {
        let c1 = CellSink<Int>(1)
        let c2 = CellSink<Int64>(5)
        let c3 = CellSink<Int64>(6)
        var out = Array<String>()
        do {
            let lifted = c1.lift(c2, c3: c3, f: {(x: Int, y: Int64, z: Int64) in x.description + " " + y.description + " " + z.description})
            let l = lifted.listen{ out.append($0) }
            defer { l.unlisten() }
            c1.send(12)
            c2.send(6)
            c3.send(8)
        }
        XCTAssert(["1 5 6", "12 5 6", "12 6 6", "12 6 8"] == out, "testList3() failed \(out)")
    }

    func testLiftGlitch()
    {
        let c1 = CellSink<Int>(1)
        let c3 = c1.map{ $0 * 3 }
        let c5 = c1.map{ $0 * 5 }
        let c = c3.lift(c5, f: {(x, y) in x.description + " " + y.description})
        var out = Array<String>()
        do
        {
            let l = c.listen{ out.append($0) }
            defer { l.unlisten() }
            c1.send(2)
        }
        XCTAssert(["3 5", "6 10"] == out, "test() failed \(out)")
    }

    func testListen() {
        let c = CellSink<Int>(9)
        var out = [Int]()
        do {
            let l = c.listen { out.append($0) }
            defer { l.unlisten() }
            
            c.send(2)
            c.send(7)
        }
        XCTAssert([9,2,7] == out, "testListen failed")
    }

    func testListenOnce() {
        let c = CellSink<Int>(9)
        var out = [Int]()
        
        do {
            let l = Transaction.run{ Operational.value(c).listenOnce{ out.append($0) } }!
            defer { l.unlisten() }

            c.send(2)
            c.send(7)
        }
        XCTAssert([9] == out, "testListenOnce() failed; out = \(out)")
    }

    func testUpdates()
    {
        let c = CellSink<Int>(9)
        var out = Array<Int>()
        
        do {
            let l = Operational.updates(c).listen{ out.append($0) }
            defer { l.unlisten() }
            c.send(2)
            c.send(7)
        }
        XCTAssert([2,7] == out, "testUpdates() failed \(out)")
    }
    
    func testApply()
    {
        let cf = CellSink<(Int64)->String>({ (x:Int64) in "1 " + x.description})
        let ca = CellSink<Int64>(5)
        var out = Array<String>()
        
        do {
            let l = ca.apply(cf).listen{ out.append($0) }
            defer { l.unlisten() }
            cf.send({x in "12 " + x.description})
            ca.send(6)
        }
        XCTAssert(["1 5", "12 5", "12 6"] == out, "testApply() failed \(out)")
    }
    

    func testCellSink() {
        let x = CellSink<Int>(0)
        var out = [Int]()
        
        let l = x.listen{ out.append($0) }
        x.send(10)
        x.send(20)
        x.send(30)
        l.unlisten()
        XCTAssert([0,10,20,30] == out, "testCellSink() failed \(out)")
    }
    
    func testHoldCellListen() {
        let s = StreamSink<Int>()
        let c = s.hold(0)
        var out = [Int]()
        do {
            let l = c.listen {
                out.append($0)
            }
            
            defer { l.unlisten() }
            
            //s.send(2)
            //s.send(9)
        }
        XCTAssert([0] == out, "testHoldCellListen() failed \(out)")
    }

    func testHoldStreamListen() {
        let s = StreamSink<Int>()
        let c = s.hold(0)
        XCTAssert(0 == c.sample(), "testHoldStreamListen() sample after hold failed \(c.sample())")
        var out = [Int]()
        do {
            let l = s.listen { out.append($0) }
            defer { l.unlisten() }
            
            s.send(2)
            s.send(9)
        }
        XCTAssert([2,9] == out, "testHoldStreamListen() failed \(out)")
    }

    func testListenTwice() {
        let s = StreamSink<String>()
        var out = [String]()
        
        let l1 = s.listen{ out.append($0) }
        let l2 = s.listen{ out.append($0) }
        
        s.send("one")
        s.send("two")
        
        l1.unlisten()
        l2.unlisten()
        
        s.unlisten()
        
        XCTAssert(["one", "one", "two", "two"] == out, "testListenTwice() failed \(out)")
    }
    
    func testHoldUpdates() {
        let s = StreamSink<Int>()
        let c = s.hold(0)
        XCTAssert(0 == c.sample(), "testHoldUpdates() failed \(c.sample())")
        var out = [Int]()
        do {
            let s2 = Operational.updates(c)
            let l = s2.listen { out.append($0) }
            defer { l.unlisten() }
            
            s.send(2)
            s.send(9)
        }
        XCTAssert([2,9] == out, "testHoldUpdates() failed \(out)")
    }

    func testLiftFromSimultaneous()
    {
        let t = Transaction.run{() -> (CellSink<Int>,CellSink<Int>) in
            let localC1 = CellSink<Int>(3)
            let localC2 = CellSink<Int>(5)
        
            localC2.send(7)
            return (localC1, localC2)
        }!
        
        let c1 = t.0
        let c2 = t.1
        var out = Array<Int>()
        do
        {
            let l = c1.lift(c2, f: {(x, y) in x + y}).listen{ out.append($0) }
            defer { l.unlisten() }
        }
        XCTAssert([10] == out, "testLiftFromSimultaneous() failed \(out)")
    }
    
    func testHoldIsDelayed()
    {
        let s = StreamSink<Int>()
        let h = s.hold(0)
        let pair = s.snapshot(h, f: {(a, b) in a.description + " " + b.description})
        var out = Array<String>()
        do
        {
            let l = pair.listen{ out.append($0) }
            defer { l.unlisten() }
            s.send(2)
            s.send(3)
        }
        XCTAssert(["2 0", "3 2"] == out, "testHoldIsDelayed() failed \(out)")
    }
    
    func testTransaction() {
        var calledBack = [Bool](arrayLiteral: false)
        
        Transaction.run{ trans in
            trans.prioritized(INode.Null) { trans2 in
                calledBack[0] = true
            }
        }

        XCTAssert(true == calledBack[0], "testTransaction() failed")
    }

    func testCalmStream()
    {
        let s = StreamSink<Int>()
        var out = [Int]()
        do
        {
            let l = s.calm().listen{ out.append($0) }
            defer { l.unlisten() }
            s.send(2)
            s.send(2)
            s.send(4)
            s.send(4)
            s.send(2)
            s.send(4)
            s.send(4)
            s.send(2)
            s.send(2)
        }
        XCTAssert([2, 4, 2, 4, 2] == out, "testCalmStream() failed \(out)")
    }

    func testCalm()
    {
        let c = CellSink<Int>(2)
        var out = [Int]()
        do
        {
            let l = c.calm().listen{ out.append($0) }
            defer { l.unlisten() }
            c.send(2)
            c.send(2)
            c.send(2)
            c.send(4)
            c.send(4)
            c.send(2)
            c.send(4)
            c.send(4)
            c.send(2)
            c.send(2)
        }
        XCTAssert([2, 4, 2, 4, 2] == out, "testCalm() failed \(out)")
    }
    
    func testMapCalm()
    {
        let c = CellSink<Int>(2)
        var out = [Bool]()
        do
        {
            let l = c.map{ $0 % 2 == 0 }.calm().listen{ out.append($0) }
            //let l = c.calm().listen{ out.append($0) }
            defer { l.unlisten() }
            c.send(2)
            c.send(2)
            c.send(2)
            c.send(4)
            c.send(4)
            c.send(2)
            c.send(4)
            c.send(4)
            c.send(5)
            c.send(5)
        }
        XCTAssert([true, false] == out, "testMapCalm() failed \(out)")
    }

    /*

    [Test]
    func testSnapshot()
    {
    let c = CellSink<Int>(0)
    StreamSink<long> trigger = StreamSink<long>()
    Array<string> @out = Array<string>()
    using (trigger.Snapshot(c, (x, y) => x + " " + y).Listen{ out.append($0) })
    {
    defer { l.Unlisten() }

    trigger.send(100L)
    c.send(2)
    trigger.send(200L)
    c.send(9)
    c.send(1)
    trigger.send(300L)
}
    XCTAssert([] == out, "test() failed \(out)")
CollectionAssert.AreEqual(new[] { "100 0", "200 2", "300 1" }, @out)
}

[Test]

[Test]
public async Task TestListenOnceTask()
{
    let c = CellSink<Int>(9)
    Int result = await Transaction.Run(() => Operational.Value(c).ListenOnce())
    c.send(2)
    c.send(7)
    Assert.AreEqual(9, result)
}

[Test]
[Test]
[Test]
[Test]
[Test]
[Test]
[Test]
[Test]
[Test]
[Test]
[Test]
func testCalm2()
{
    let c = CellSink<Int>(2)
    Array<Int> @out = Array<Int>()
    using (Transaction.Run(() => c.Calm().Listen{ out.append($0) }))
    {
    defer { l.Unlisten() }
        c.send(4)
        c.send(2)
        c.send(4)
        c.send(4)
        c.send(2)
        c.send(2)
    }
    XCTAssert([] == out, "test() failed \(out)")
    CollectionAssert.AreEqual(new[] { 2, 4, 2, 4, 2 }, @out)
}

[Test]
[Test]
[Test]
[Test]
[Test]

*/
    struct Sc {
        let a: Character?
        let b: Character?
        let sw: Cell<Character>?
        
        init(_ a: Character? = nil, _ b: Character? = nil, _ sw: Cell<Character>? = nil) {
            self.a = a
            self.b = b
            self.sw = sw
        }
    }
    
    func testSwitchC() {
        let ssc = StreamSink<Sc>()
        // Split each field out of SB so we can update multiple behaviors in a
        // single transaction.
        let ca: Cell<Character> = ssc.map({s in s.a}).filterOptional().hold("A")
        let cb: Cell<Character> = ssc.map({s in s.b}).filterOptional().hold("a")
        let csw: Cell<Cell<Character>> = ssc.map({s in s.sw}).filterOptional().hold(ca)
        let co = Cell<Character>.switchC(csw)
        
        var xs = [Character]()
        let l = co.listen({xs.append($0)})
        defer { l.unlisten() }
        ssc.send(Sc(Optional.some("B"), Optional.some("B"), nil))
        ssc.send(Sc(Optional.some("C"), Optional.some("C"), Optional.some(cb)))
        ssc.send(Sc(Optional.some("D"), Optional.some("D"), nil))
        ssc.send(Sc(Optional.some("E"), Optional.some("E"), Optional.some(ca)))
        ssc.send(Sc(Optional.some("F"), Optional.some("F"), nil))
        ssc.send(Sc(nil, nil, Optional.some(cb)))
        ssc.send(Sc(nil, nil, Optional.some(ca)))
        ssc.send(Sc(Optional.some("G"), Optional.some("G"), Optional.some(cb)))
        ssc.send(Sc(Optional.some("H"), Optional.some("H"), Optional.some(ca)))
        ssc.send(Sc(Optional.some("I"), Optional.some("I"), Optional.some(ca)))
        let ys: [Character] = ["A", "B", "C", "D", "E", "F", "F", "F", "G", "H", "I"]
        XCTAssert(xs == ys)
    }

    private struct Sc2 {
        let c : CellSink<Int>
        init(_ n: Int) {
            self.c = CellSink<Int>(n)
        }
    }
    
    func testSwitchCSimultaneous() {
        let sc1 = Sc2(0)
        let csc = CellSink<Sc2>(sc1)
        let co  = Cell<Int>.switchC(csc.map({b in b.c}))
        var xs  = [Int]()
        let l   = co.listen({xs.append($0)})
        defer { l.unlisten() }
        let sc2 = Sc2(3)
        let sc3 = Sc2(4)
        let sc4 = Sc2(7)
        
        sc1.c.send(1)
        sc1.c.send(2)
        csc.send(sc2)
        sc1.c.send(3)
        sc2.c.send(4)
        sc3.c.send(5)
        csc.send(sc3)
        sc3.c.send(6)
        sc3.c.send(7)
        Transaction.runVoid({
                    sc3.c.send(2)
                    csc.send(sc4)
                    sc4.c.send(8)
                })
        sc4.c.send(9)
        let ys = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        XCTAssert(xs == ys, "test() failed xs = \(xs), ys = \(ys)")
    }
    
     private struct Ss {
        let a: Character
        let b: Character
        let sw: SodiumSwift.Stream<Character>?
     
        init(_ a: Character, _ b: Character, _ sw: SodiumSwift.Stream<Character>?) {
            self.a  = a
            self.b  = b
            self.sw = sw
        }
    }
    
    func testSwitchS() {
        let sss = StreamSink<Ss>()
        // Split each field out of SB so we can update multiple behaviors in a
        // single transaction.
        let sa  = sss.map({$0.a})
        let sb  = sss.map({$0.b})
        let csw = sss.map({$0.sw}).filterOptional().hold(sa)
        let so: SodiumSwift.Stream<Character>  = Cell<Character>.switchS(csw)
        var xs: [Character] = [Character]()
        
        func appendCharacter(_ c: Character) -> Void {
            xs.append(c)
        }

        let l = so.listen(handler: appendCharacter)
        //let l = so.listen({(c: Character) -> Void in xs.append(c)})
        sss.send(Ss("A", "a", nil))
        sss.send(Ss("B", "b", nil))
        sss.send(Ss("C", "c", Optional.some(sb)))
        sss.send(Ss("D", "d", nil))
        sss.send(Ss("E", "e", Optional.some(sa)))
        sss.send(Ss("F", "f", nil))
        sss.send(Ss("G", "g", Optional.some(sb)))
        sss.send(Ss("H", "h", Optional.some(sa)))
        sss.send(Ss("I", "i", Optional.some(sa)))
        
        l.unlisten()
        let ys: [Character] = ["A", "B", "C", "d", "e", "F", "G", "h", "I"]
        XCTAssert(xs == ys, "test() failed xs = \(xs)")
}
/*
private class Ss2
{
    public readonly StreamSink<Int> S = StreamSink<Int>()
}

[Test]
func testSwitchSSimultaneous()
{
    Ss2 ss1 = Ss2()
    CellSink<Ss2> css = CellSink<Ss2>(ss1)
    Stream<Int> so = css.map<Stream<Int>>(b => b.S).SwitchS()
    Array<Int> @out = Array<Int>()
    using (so.Listen{ out.append($0) })
    {
        defer { l.Unlisten() }
        Ss2 ss2 = Ss2()
        Ss2 ss3 = Ss2()
        Ss2 ss4 = Ss2()
        ss1.S.send(0)
        ss1.S.send(1)
        ss1.S.send(2)
        css.send(ss2)
        ss1.S.send(7)
        ss2.S.send(3)
        ss2.S.send(4)
        ss3.S.send(2)
        css.send(ss3)
        ss3.S.send(5)
        ss3.S.send(6)
        ss3.S.send(7)
        Transaction.RunVoid(() =>
            {
                ss3.S.send(8)
                css.send(ss4)
                ss4.S.send(2)
            })
        ss4.S.send(9)
    }
    XCTAssert([] == out, "test() failed \(out)")
    CollectionAssert.AreEqual(new[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }, @out)
}

[Test]
func testLiftList()
{
    IReadOnlyList<CellSink<Int>> cellSinks = Enumerable.Range(0, 50).Select(_ => CellSink<Int>(1)).ToArray()
    Cell<Int> sum = cellSinks.Lift(v => v.Sum())
    Array<Int> @out = Array<Int>()
    using (sum.Listen{ out.append($0) })
    {
        defer { l.Unlisten() }
        cellSinks[4].send(5)
        cellSinks[5].send(5)
        Transaction.RunVoid(() =>
            {
                cellSinks[9].send(5)
                cellSinks[17].send(5)
                cellSinks[41].send(5)
                cellSinks[48].send(5)
            })
    }
    XCTAssert([] == out, "test() failed \(out)")
    CollectionAssert.AreEqual(new[] { 50, 54, 58, 74 }, @out)
}

[Test]
func testLiftListLarge()
{
    IReadOnlyList<CellSink<Int>> cellSinks = Enumerable.Range(0, 500).Select(_ => CellSink<Int>(1)).ToArray()
    Cell<Int> sum = cellSinks.Lift(v => v.Sum())
    Array<Int> @out = Array<Int>()
    using (sum.Listen{ out.append($0) })
    {
        defer { l.Unlisten() }
        cellSinks[4].send(5)
        cellSinks[5].send(5)
        Transaction.RunVoid(() =>
            {
                cellSinks[9].send(5)
                cellSinks[17].send(5)
                cellSinks[41].send(5)
                cellSinks[48].send(5)
            })
    }
    XCTAssert([] == out, "test() failed \(out)")
    CollectionAssert.AreEqual(new[] { 500, 504, 508, 524 }, @out)
}

[Test]
func testLiftListLargeManyUpdates()
{
    IReadOnlyList<CellSink<Int>> cellSinks = Enumerable.Range(0, 500).Select(_ => CellSink<Int>(1)).ToArray()
    Cell<Int> sum = cellSinks.Lift(v => v.Sum())
    Array<Int> @out = Array<Int>()
    using (sum.Listen{ out.append($0) })
    {
        defer { l.Unlisten() }
        for (Int i = 0 i < 100 i++)
        {
            Int n = i
            cellSinks[n * 5].send(5)
            cellSinks[n * 5 + 1].send(5)
            Transaction.RunVoid(() =>
                {
                    cellSinks[n * 5 + 2].send(5)
                    cellSinks[n * 5 + 3].send(5)
                    cellSinks[n * 5 + 4].send(5)
                })
        }
    }
    IReadOnlyList<Int> expected = new[] { 500 }.Concat(Enumerable.Range(0, 100).SelectMany(n => new[] { 500 + 20 * n + 4, 500 + 20 * n + 8, 500 + 20 * n + 20 })).ToArray()
    XCTAssert([] == out, "test() failed \(out)")
    CollectionAssert.AreEqual(expected, @out)
}

[Test]
func testLiftListChangesWhileListening()
{
    IReadOnlyList<CellSink<Int>> cellSinks = Enumerable.Range(0, 50).Select(_ => CellSink<Int>(1)).ToArray()
    Cell<Int> sum = cellSinks.Lift(v => v.Sum())
    Array<Int> @out = Array<Int>()
    IListener l = Transaction.Run(() =>
    {
    cellSinks[4].send(5)
    IListener lLocal = sum.Listen{ out.append($0) }
    cellSinks[5].send(5)
    return lLocal
    })
    cellSinks[9].send(5)
    Transaction.RunVoid(() =>
    {
    cellSinks[17].send(5)
    cellSinks[41].send(5)
    cellSinks[48].send(5)
    })
    l.Unlisten()
    XCTAssert([] == out, "test() failed \(out)")
    CollectionAssert.AreEqual(new[] { 58, 62, 74 }, @out)
}

*/
}
