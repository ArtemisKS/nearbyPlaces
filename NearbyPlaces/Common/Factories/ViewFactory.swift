//
//  LabelFactory.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 01.06.2021.
//

import UIKit

enum ViewFactory {

    //    swiftlint:disable:next large_tuple
    static func makeLabelStack(title: String, value: String) -> (
        labelStack: UIStackView,
        titleLabel: UILabel,
        bodyLabel: UILabel
    ) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        let bodyLabel = UILabel()
        bodyLabel.text = value
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 8
        return (labelStack, titleLabel, bodyLabel)
    }
}
