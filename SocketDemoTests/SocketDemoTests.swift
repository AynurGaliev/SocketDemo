//
//  SocketDemoTests.swift
//  SocketDemoTests
//
//  Created by Aynur Galiev on 15.января.2017.
//  Copyright © 2017 Aynur Galiev. All rights reserved.
//

import XCTest
@testable import SocketDemo

class SocketDemoTests: XCTestCase {
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    let date = NSDate.init()
    
    override func setUp() {
        super.setUp()
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {

        self.measure {
            let _ = self.dateFormatter
        }

    }
    
//    func testPerformanceDateFormatter() {
//        
//        var dateString: String? = nil
//        self.measure {
//            for _ in 0..<1000 {
//                dateString = self.dateFormatter.string(from: self.date as Date)
//            }
//        }
//        print(dateString)
//    }
//    
//    func testPerformanceExtension() {
//        
//        var dateString: String? = nil
//        
//        self.measure {
//            for _ in 0..<1000 {
//                dateString = self.date.iso8601String()
//            }
//        }
//        
//        print(dateString)
//    }
    
}
