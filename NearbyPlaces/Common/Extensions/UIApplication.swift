//
//  UIApplication.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 31.05.2021.
//

import UIKit

extension UIApplication {

    class var safeAreaInsets: UIEdgeInsets? {
        shared.windows.first?.safeAreaInsets
    }

    class var bottomSafeArea: CGFloat {
        safeAreaInsets?.bottom ?? 0
    }
}
