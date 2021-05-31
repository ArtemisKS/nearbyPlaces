//
//  UIColor.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 29.05.2021.
//

import UIKit

extension UIColor {

    // MARK: - Custom Initializers

    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        let threshold = 255

        assert(red >= 0 && red <= threshold, "Invalid red component")
        assert(green >= 0 && green <= threshold, "Invalid green component")
        assert(blue >= 0 && blue <= threshold, "Invalid blue component")
        assert(alpha >= 0.0 && alpha <= 1.0, "Invalid alpha component")

        self.init(
            red: CGFloat(red) / CGFloat(threshold),
            green: CGFloat(green) / CGFloat(threshold),
            blue: CGFloat(blue) / CGFloat(threshold),
            alpha: alpha
        )
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

    class var background: UIColor {
        return UIColor(red: 22/255.0, green: 14/255.0, blue: 83/255.0, alpha: 1)
    }
}
