//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}

// extra credit: implemented 2 for 1 scheme
protocol PricingScheme {
    var itemName: String { get }
    func applyDiscount(items: [SKU]) -> Int
}

class TwoForOneScheme: PricingScheme {
    var itemName: String
    
    init(itemName: String) {
        self.itemName = itemName
    }
    
    func applyDiscount(items: [SKU]) -> Int {
        let matchingItems = items.filter { $0.name == itemName }
        
        let freeItemCount = matchingItems.count / 3
        
        if freeItemCount > 0 && !matchingItems.isEmpty {
            return freeItemCount * matchingItems[0].price()
        } else {
            return 0
        }
    }
}

class Item: SKU {
    let name: String
    var priceEach: Int

    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }

    func price() -> Int {
        return priceEach
    }
}

class Receipt {
    var itemList: [SKU] = []
    var discount: Coupon

    init() {
        self.itemList = []
        self.discount = Coupon()
    }

    func add(item: Item) {
        let hasApple = itemList.contains(where: { $0.name == "Apple" })
        print(hasApple)
        if !hasApple && item.name == "Apple" {
                let newPrice = discount.applyDiscount(item)
                print(newPrice)
                item.priceEach = newPrice
        }
        itemList.append(item)
    }

    func total() -> Int {
        return itemList.reduce(0) { $0 + $1.price() }
    }

    func items() -> [SKU] {
        return itemList
    }

    func output() -> String {
        var output = "Receipt:\n"
        for item in itemList {
            output += "\(item.name): $\(Double(item.price()) / 100.00)\n"
        }
        output += "------------------\n"
        output += "TOTAL: $\(Double(total()) / 100.0)"
        return output
    }
}

class Register {
    private var currentReceipt: Receipt
    private var pricingSchemes: [PricingScheme]

    init() {
        self.currentReceipt = Receipt()
        self.pricingSchemes = []
    }
    
    func addPricingScheme(_ scheme: PricingScheme) {
        pricingSchemes.append(scheme)
    }

    func scan(_ item: Item) {
        currentReceipt.add(item: item)
        print("Scanned item: \(item.name), price: \(Double(item.price()) / 100.00)")
    }

    func subtotal() -> Int {
        let baseTotal = currentReceipt.total()
        
        let discount = pricingSchemes.reduce(0) { totalDiscount, scheme in
            totalDiscount + scheme.applyDiscount(items: currentReceipt.items())
        }
        
        return baseTotal - discount
    }

    func total() -> Receipt {
        let oldReceipt = currentReceipt
        currentReceipt = Receipt()
        pricingSchemes = []
        return oldReceipt
    }
}

class Coupon {
    var discount: Double

    init() {
        self.discount = 0.85
    }

    func applyDiscount(_ item: Item) -> Int {
        return Int(Double(item.price()) * discount)
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

