//
//  SequenceSmoother.swift
//  SwiftSmoothSequence
//
//  Created by Jacopo Mangiavacchi on 20/06/2017.
//  Copyright © 2017 Jacopo. All rights reserved.
//
import Foundation


// Buffer method
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



// Exponentially weighted moving average
public struct EWMA<Element> {
    public typealias elementAddFunc = (Element, Element) -> Element
    public typealias elementMultiplyFunc = (Element, Float) -> Element
    
    fileprivate var last: Element?
    fileprivate var smooth: Float!
    fileprivate var addFunc: elementAddFunc!
    fileprivate var multiplyFunc: elementMultiplyFunc!
    
    
    public init(smooth: Float = 0.9, addFunc: @escaping elementAddFunc, multiplyFunc: @escaping elementMultiplyFunc) {
        self.smooth = smooth
        self.addFunc = addFunc
        self.multiplyFunc = multiplyFunc
    }
    
    public mutating func reset() {
        last = nil
    }
    
    public mutating func smooth(_ value: Element) -> Element {
        if let l = last {
            // Formula: St = aXt + (1-a)St-1
            // (smooth * value) + ((1.0-smooth) * l)
            last = addFunc(multiplyFunc(value, smooth), multiplyFunc(l, 1.0-smooth))    
            return last!
        }
        else {
            last = value
            return value
        }
    }
}