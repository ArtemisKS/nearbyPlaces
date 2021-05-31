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
