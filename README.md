# EWMA / SwiftSmoothSequence
Swift Struct implementing Smooth Sequence of generic values in two different method

1) struct SequenceSmoother<Element> implement classic circular buffer technique
2) struct EWMA<Element> implement Exponentially Weighted Moving Average algorithm

Useful for smoothing sequences like accelerometer data or image detection position

# How to install it?

This is a Swift 3.x Package usable with Swift Package Manager on both iOS, macOS and Linux

In order to use it in your Swift project please include the following line in your Swift Package references:

	.Package(url: "https://github.com/JacopoMangiavacchi/SwiftSmoothSequence", majorVersion: 0)


# EWMA Example Usage

Here is some sample code to smooth a sequence of CGPoint

    import Foundation
    import SwiftSmoothSequence

    func cgPointAdd(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }

    func cgPointMultiply(_ a: CGPoint, _ r: Float) -> CGPoint {
        return CGPoint(x: a.x * CGFloat(r), y: a.y * CGFloat(r))
    }

    var smoother = EWMA<CGPoint>(smooth: 0.8, addFunc: cgPointAdd, multiplyFunc: cgPointMultiply)

    for i in 0..<10 {
        let cgPoint = CGPoint(x: CGFloat(i), y: CGFloat(i))
        let smoothedCGPoint = smoother.smooth(cgPoint)

        print("original: (x: \(cgPoint.x), y: \(cgPoint.y)) - smoothed: (x: \(smoothedCGPoint.x), y: \(smoothedCGPoint.y))")
    }


# SequenceSmoother Example Usage

Here is some sample code to smooth a sequence of CGPoint

    import Foundation
    import SwiftSmoothSequence

    func cgPointAdd(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }

    func cgPointDivide(_ a: CGPoint, _ i: Int) -> CGPoint {
        return CGPoint(x: a.x / CGFloat(i), y: a.y / CGFloat(i))
    }

    var smoother = SequenceSmoother<CGPoint>(cacheSize: 4, emptyElement:CGPoint(x: 0, y: 0), addFunc: cgPointAdd, divideFunc: cgPointDivide)

    for i in 0..<10 {
        let cgPoint = CGPoint(x: CGFloat(i), y: CGFloat(i))
        let smoothedCGPoint = smoother.smooth(cgPoint)

        print("original: (x: \(cgPoint.x), y: \(cgPoint.y)) - smoothed: (x: \(smoothedCGPoint.x), y: \(smoothedCGPoint.y))")
    }


