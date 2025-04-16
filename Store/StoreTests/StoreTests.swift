//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {
    
    var register = Register()
    
    override func setUpWithError() throws {
        register = Register()
    }
    
    override func tearDownWithError() throws { }
    
    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())
        
        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        NSLog(receipt.output())
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())
        
        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    // Implemented Coupon extra credit
    // Checks that discount is applied to Apple
    func testAppleDiscount() {
        register.scan(Item(name: "Apple", priceEach: 100))
        
        XCTAssertEqual(85, register.subtotal())
    }
    
    // Checks that discount is only applied to Apple once
    func testAppleDiscountAppliedOnlyOnce() {
        register.scan(Item(name: "Apple", priceEach: 100))
        register.scan(Item(name: "Apple", priceEach: 100))
        
        XCTAssertEqual(185, register.subtotal())
    }
    
    func testDiscountNotAppliedToInvalidItems() {
        register.scan(Item(name: "Matcha", priceEach: 100000))
        XCTAssertEqual(100000, register.subtotal())
    }
    
    // extra credit: tests for 2 for 1
    func testTwoForOne() {
        register.addPricingScheme(TwoForOneScheme(itemName: "Beans (8oz Can)"))
        
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
    }

    func testTwoForOneNotAppliedWithFewerItems() {
        register.addPricingScheme(TwoForOneScheme(itemName: "Beans (8oz Can)"))
        
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        
        XCTAssertEqual(199 * 2, register.subtotal())
    }

    func testTwoForOneMultipleTimes() {
        register.addPricingScheme(TwoForOneScheme(itemName: "Beans (8oz Can)"))
        
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))

        XCTAssertEqual(199 * 4, register.subtotal())
    }

    // extra credit: implemeted tested for group purchase discount
    func testBasicGroupedPurchaseDiscount() {
        register.addPricingScheme(GroupedPurchaseScheme(itemName: "Ketchup", pairedItemName: "Beer"))
        
        register.scan(Item(name: "Heinz Ketchup", priceEach: 300))
        register.scan(Item(name: "Craft Beer", priceEach: 700))
        
        let totalBeforeDiscount = 300 + 700
        let expectedDiscount = Int(Double(totalBeforeDiscount) * 0.1)
        let expectedSubtotal = totalBeforeDiscount - expectedDiscount
        
        XCTAssertEqual(register.subtotal(), expectedSubtotal)
    }
}
