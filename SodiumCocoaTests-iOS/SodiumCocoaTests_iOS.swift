//
//  SodiumCocoaTests_iOS.swift
//  SodiumCocoaTests-iOS
//
//  Created by Liang on 11/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import XCTest
import SodiumSwift
import SodiumCocoa

class SodiumCocoaTests_iOS: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
   
    func testRefs() {
        let refs = MemReferences()
        doTest(refs)
        
        sleep(5)
        XCTAssert(refs.count() == 0, "refs is still \(refs.count())")
    }
    
    func doTest(_ refs: MemReferences) {
        let clear = SButton("Clear", refs: refs)
        clear.frame = CGRect(x: 50,y: 30,width: 100,height: 30)
        clear.setTitle("clear", for: .normal)
        clear.setTitleColor(UIColor.blue, for: .normal)
        
        let sClearIt = clear.tap.map { _ in "" }
        //let sClearIt = Stream<String>()
        let text = STextField(s: sClearIt, text: "Hello", refs: refs)
        text.text = "Hello2"
        text.frame = CGRect(x: 10,y: 50,width: 100,height: 20)
    }
}
