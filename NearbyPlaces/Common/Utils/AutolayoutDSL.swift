//
//  AutolayoutDSL.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 31.05.2021.
//

import UIKit

public protocol LayoutAnchor {
    func constraint(equalTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
}

public protocol LayoutDimension: LayoutAnchor {
    func constraint(equalToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint
}

protocol AnyLayoutAnchorBox {
    func unbox<T: LayoutAnchor>() -> T?

    func constraint(equalTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint
}

struct ConcreteLayoutAnchorBox<Base: LayoutAnchor>: AnyLayoutAnchorBox {
    var base: Base

    init(_ base: Base) {
        self.base = base
    }

    func unbox<T: LayoutAnchor>() -> T? {
        return (self as AnyLayoutAnchorBox as? ConcreteLayoutAnchorBox<T>)?.base
    }

    func constraint(equalTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint {
        return base.constraint(equalTo: anchor.unbox()!, constant: constant)
    }

    func constraint(greaterThanOrEqualTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint {
        return base.constraint(greaterThanOrEqualTo: anchor.unbox()!, constant: constant)
    }

    func constraint(lessThanOrEqualTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint {
        return base.constraint(lessThanOrEqualTo: anchor.unbox()!, constant: constant)
    }
}

public struct AnyLayoutAnchor {
    private var box: AnyLayoutAnchorBox

    public init<T: LayoutAnchor>(_ box: T) {
        self.box = ConcreteLayoutAnchorBox(box)
    }
}

extension AnyLayoutAnchor: LayoutAnchor {
    public func constraint(equalTo anchor: AnyLayoutAnchor, constant: CGFloat) -> NSLayoutConstraint {
        return box.constraint(equalTo: anchor.box, constant: constant)
    }

    public func constraint(greaterThanOrEqualTo anchor: AnyLayoutAnchor, constant: CGFloat) -> NSLayoutConstraint {
        return box.constraint(greaterThanOrEqualTo: anchor.box, constant: constant)
    }

    public func constraint(lessThanOrEqualTo anchor: AnyLayoutAnchor, constant: CGFloat) -> NSLayoutConstraint {
        return box.constraint(lessThanOrEqualTo: anchor.box, constant: constant)
    }
}

extension NSLayoutAnchor: LayoutAnchor {}

extension NSLayoutDimension: LayoutDimension {}

public struct LayoutProperty<Anchor: LayoutAnchor> {
    fileprivate let anchor: Anchor
}

public struct DimensionProperty<Anchor: LayoutDimension> {
    let width: LayoutProperty<Anchor>
    let height: LayoutProperty<Anchor>
}

public class LayoutBuilder {
    public lazy var leading = property(with: view.leadingAnchor)
    public lazy var trailing = property(with: view.trailingAnchor)
    public lazy var top = property(with: view.topAnchor)
    public lazy var bottom = property(with: view.bottomAnchor)
    public lazy var width = property(with: view.widthAnchor)
    public lazy var height = property(with: view.heightAnchor)
    public lazy var centerX = property(with: view.centerXAnchor)
    public lazy var centerY = property(with: view.centerYAnchor)
    public lazy var firstBaseline = property(with: view.firstBaselineAnchor)
    public lazy var lastBaseline = property(with: view.lastBaselineAnchor)

    public lazy var edges = properties(with: view.edgesAnchor)
    public lazy var center = properties(with: view.centerAnchor)
    public lazy var size = DimensionProperty(width: width, height: height)

    private let view: UIView

    init(view: UIView) {
        self.view = view
    }

    private func property<Anchor: LayoutAnchor>(with anchor: Anchor) -> LayoutProperty<Anchor> {
        return LayoutProperty(anchor: anchor)
    }

    private func properties<Anchor: LayoutAnchor>(with anchors: [Anchor]) -> [LayoutProperty<Anchor>] {
        return anchors.map { LayoutProperty(anchor: $0) }
    }
}

public extension LayoutProperty {
    func equal(to otherAnchor: Anchor, offset constant: CGFloat = 0) {
        anchor.constraint(equalTo: otherAnchor,
                          constant: constant).isActive = true
    }

    func greaterThanOrEqual(
        to otherAnchor: Anchor,
        offset constant: CGFloat = 0
    ) {
        anchor.constraint(greaterThanOrEqualTo: otherAnchor,
                          constant: constant).isActive = true
    }

    func lessThanOrEqual(
        to otherAnchor: Anchor,
        offset constant: CGFloat = 0
    ) {
        anchor.constraint(lessThanOrEqualTo: otherAnchor,
                          constant: constant).isActive = true
    }
}

public extension LayoutProperty where Anchor: LayoutDimension {
    func equal(toConstant constant: CGFloat) {
        anchor.constraint(equalToConstant: constant).isActive = true
    }

    func greaterThanOrEqual(toConstant constant: CGFloat) {
        anchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }

    func lessThanOrEqual(toConstant constant: CGFloat) {
        anchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
    }
}

extension UIView {
    public func layout(using builder: (LayoutBuilder) -> Void) {
        self.translatesAutoresizingMaskIntoConstraints = false
        builder(LayoutBuilder(view: self))
    }

    public var edgesAnchor: [AnyLayoutAnchor] {
        return [
            AnyLayoutAnchor(topAnchor),
            AnyLayoutAnchor(leadingAnchor),
            AnyLayoutAnchor(bottomAnchor),
            AnyLayoutAnchor(trailingAnchor)
        ]
    }

    public var centerAnchor: [AnyLayoutAnchor] {
        return [AnyLayoutAnchor(centerXAnchor), AnyLayoutAnchor(centerYAnchor)]
    }

    public var sizeAnchor: [NSLayoutDimension] {
        return [widthAnchor, heightAnchor]
    }
}

public func + <Anchor: LayoutAnchor>(lhs: Anchor, rhs: CGFloat) -> (Anchor, CGFloat) {
    return (lhs, rhs)
}

public func - <Anchor: LayoutAnchor>(lhs: Anchor, rhs: CGFloat) -> (Anchor, CGFloat) {
    return (lhs, -rhs)
}

public func == <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: (Anchor, CGFloat)) {
    lhs.equal(to: rhs.0, offset: rhs.1)
}

public func == <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: Anchor) {
    lhs.equal(to: rhs)
}

public func == <Anchor: LayoutDimension>(lhs: LayoutProperty<Anchor>, rhs: CGFloat) {
    lhs.equal(toConstant: rhs)
}

public func == <Anchor: LayoutDimension>(lhs: DimensionProperty<Anchor>, rhs: CGSize) {
    lhs.width.equal(toConstant: rhs.width)
    lhs.height.equal(toConstant: rhs.height)
}

public func == <Anchor: LayoutDimension>(lhs: DimensionProperty<Anchor>, rhs: [Anchor]) {
    assert(rhs.count == 2, "Layout anchors count must be 2")
    lhs.width.equal(to: rhs[0])
    lhs.height.equal(to: rhs[1])
}

public func == <Anchor: LayoutAnchor>(lhs: [LayoutProperty<Anchor>], rhs: [Anchor]) {
    assert(lhs.count == rhs.count, "Layout properties count must equal to anchors count")
    zip(lhs, rhs).forEach { $0.equal(to: $1) }
}

public func >= <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: (Anchor, CGFloat)) {
    lhs.greaterThanOrEqual(to: rhs.0, offset: rhs.1)
}

public func >= <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: Anchor) {
    lhs.greaterThanOrEqual(to: rhs)
}

public func >= <Anchor: LayoutDimension>(lhs: LayoutProperty<Anchor>, rhs: CGFloat) {
    lhs.greaterThanOrEqual(toConstant: rhs)
}

public func <= <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: (Anchor, CGFloat)) {
    lhs.lessThanOrEqual(to: rhs.0, offset: rhs.1)
}

public func <= <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: Anchor) {
    lhs.lessThanOrEqual(to: rhs)
}

public func <= <Anchor: LayoutDimension>(lhs: LayoutProperty<Anchor>, rhs: CGFloat) {
    lhs.lessThanOrEqual(toConstant: rhs)
}
