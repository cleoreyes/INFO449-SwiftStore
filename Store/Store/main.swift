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

    init() {
        self.currentReceipt = Receipt()
    }

    func scan(_ item: Item) {
        currentReceipt.add(item: item)
        print("Scanned item: \(item.name), price: \(Double(item.price()) / 100.00)")
    }

    func subtotal() -> Int {
        return currentReceipt.total()
    }

    func total() -> Receipt {
        let oldReceipt = currentReceipt
        currentReceipt = Receipt()
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

