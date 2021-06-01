//
//  UIView.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 31.05.2021.
//

import UIKit

extension UIView {

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }

    func setCornerRadius(_ radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }

    func addShadow(
        with color: UIColor,
        opacity: Float = 0.25,
        radius: CGFloat = 1.5,
        offset: CGSize = .zero,
        path: CGPath? = nil) {
        layer.addShadow(
            with: color,
            opacity: opacity,
            radius: radius,
            offset: offset,
            path: path
        )
    }
}

extension UIView {

    /// Disable translation of autoresizing mask into constraints and add as subviews.
    func addSubviewsToViewHierarchy(_ subviews: [UIView]) {
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }

    func pinSubview(_ subview: UIView, insets: NSDirectionalEdgeInsets = .zero) {
        addSubviewsToViewHierarchy([subview])
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.leading),
            subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.trailing),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
    }

    func pinSubviewToSafeAreaLayoutGuide(_ subview: UIView, insets: NSDirectionalEdgeInsets = .zero) {
        addSubviewsToViewHierarchy([subview])
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.leading),
            subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
            subview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: insets.trailing),
            subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom)
        ])
    }
}

extension CALayer {

    func addShadow(
        with color: UIColor,
        opacity: Float = 0.25,
        radius: CGFloat = 1.5,
        offset: CGSize = .zero,
        path: CGPath? = nil) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = opacity
        shadowOffset = offset
        shadowRadius = radius
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
        shadowPath = path
    }
}
