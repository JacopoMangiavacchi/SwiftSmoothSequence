//
//  SequenceSmoother.swift
//  SwiftSmoothSequence
//
//  Created by Jacopo Mangiavacchi on 20/06/2017.
//  Copyright © 2017 Jacopo. All rights reserved.
//
import Foundation

public struct SequenceSmoother<Element> {
    public typealias elementAddFunc = (Element, Element) -> Element
    public typealias elementDivideFunc = (Element, Int) -> Element
    
    fileprivate var cache = [Element]()
    fileprivate var maxCacheSize = 5
    fileprivate var currentPos = 0
    fileprivate var emptyElement: Element!
    fileprivate var addFunc: elementAddFunc!
    fileprivate var divideFunc: elementDivideFunc!
    
    
    public init(cacheSize: Int = 5, emptyElement:Element, addFunc: @escaping elementAddFunc, divideFunc: @escaping elementDivideFunc) {
        self.maxCacheSize = cacheSize
        self.currentPos = 0
        self.emptyElement = emptyElement
        self.addFunc = addFunc
        self.divideFunc = divideFunc
    }
    
    public mutating func resetCache() {
        currentPos = 0
        cache = [Element]()
    }
    
    public mutating func smooth(_ value: Element) -> Element {
        if cache.count < maxCacheSize {
            cache.append(value)
        }
        else {
            cache[currentPos] = value
        }
        
        currentPos = (currentPos + 1) % maxCacheSize
        
        //Return Average
        return divideFunc(cache.reduce(emptyElement, addFunc), cache.count)   //cache.reduce(0, +) / cache.count
    }
}
