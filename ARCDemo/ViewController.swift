//
//  ViewController.swift
//  ARCDemo
//
//  Created by 賴弋威 on 2018/11/1.
//  Copyright © 2018 賴弋威. All rights reserved.
//


//MARK: ARC -> https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
import UIKit

class ViewController: UIViewController {

    var reference1: Person?
    var reference2: Person?
    var reference3: Person?
    override func viewDidLoad() {
        super.viewDidLoad()
        //*****The ARC just for Reference Type ,not Work in Value Type**
        arcQuickSample()
        arcRetainCycle()
    }
    
    func arcQuickSample() {
        // when one instance alloc , there is a memoery address to store their value and property
        reference1 = Person(name: "Kobe") // one reference create to reference to Person memoery address (count: 1)
        reference2 = reference1 //reference to reference1's memoery address (count: 2)
        reference3 = reference1 //reference to reference1's memoery address (count: 3)
        // now we have three strong reference count
        reference1 = nil //cancel reference1's memoery address (count: 2)
        reference2 = nil //cancel reference1's memoery address (count: 1)
        //now ARC does not deallocate because there is one reference is not broken
        print(reference3?.name)// now we still get kobe
        reference3 = nil //cancel reference1's memoery address (count: 0)
        //now we get ARC dealloc
    }
    
    func arcRetainCycle() {
        var john: Person?
        var unit4A: Apartment?
        john = Person(name: "John")
        unit4A = Apartment(unit: "4A")
        //now we have a strong referece (john to Person instance) and a strong reference (unit4A to Apartment instance)
        john!.apartment = unit4A;
        unit4A!.tenant = john
        //now the Person instance and the Apartment instance also have a strong reference to each other
        john = nil
        unit4A = nil
        // here will not print deinit becauese retain cycle
    }
}

//MARK: Demo class
class Person {
    let name: String
    var apartment: Apartment?
    init(name: String) {
        self.name = name
        print("init Person")
    }
    
    deinit {
        print("deinit Person\(name)")
    }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person?
    deinit {
        print("Apartemnt deinit\(unit)")
    }
}
