//
//  PlaceDetailsView.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 31.05.2021.
//

import UIKit

class PlaceDetailsView: UIView {

    private enum Constants {
        static let offset: CGFloat = 16
    }

    let stackView = UIStackView()

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {

        configureBasicViews()
        backgroundColor = .clear
        addShadow(
            with: .gray,
            opacity: 1,
            radius: Constants.offset,
            offset: .zero
        )
    }

    private func configureBasicViews() {

        let containerView = UIView()
        containerView.backgroundColor = .white
        addSubview(containerView)
        containerView.layout { (builder) in
            builder.leading == leadingAnchor
            builder.trailing == trailingAnchor
            builder.top == topAnchor
            builder.bottom == bottomAnchor
        }

        containerView.roundCorners(
            corners: [.topLeft, .topRight],
            radius: Constants.offset
        )

        let pinView = UIView()
        pinView.backgroundColor = .init(red: 216, green: 216, blue: 216)
        containerView.addSubview(pinView)
        pinView.layout { (builder) in
            builder.top == topAnchor + Constants.offset / 2
            builder.centerX == centerXAnchor
            builder.width == 28
            builder.height == 4
        }
        pinView.setCornerRadius(2)

        stackView.axis = .vertical
        stackView.spacing = Constants.offset * 2
        containerView.addSubview(stackView)
        let bottomOffset = Constants.offset + UIApplication.bottomSafeArea
        stackView.layout { (builder) in
            builder.top == topAnchor + Constants.offset * 2
            builder.leading == leadingAnchor + Constants.offset
            builder.trailing == trailingAnchor - Constants.offset
            builder.bottom == bottomAnchor - (bottomOffset + Constants.offset * 4)
        }
    }

    func setupView(
        title: String,
        address: String,
        type: String,
        phone: String?,
        zip: String
    ) {
        let titleLabel = makeTitleLabel(title: title, type: type)

        let (addressStack, addressTitle, addressLabel) = ViewFactory.makeLabelStack(title: "Address", value: address)

        let isPhone = phone != nil && !phone!.isEmpty
        let (phoneStack, phoneTitle, phoneLabel) = ViewFactory.makeLabelStack(
            title: isPhone ? "Phone" : "Postal code",
            value: isPhone ? phone! : zip
        )

        let bodyStack = UIStackView(arrangedSubviews: [addressStack, phoneStack])
        bodyStack.axis = .vertical
        bodyStack.spacing = Constants.offset

        [titleLabel, addressLabel, addressTitle, phoneLabel, phoneTitle].forEach {
            $0.numberOfLines = 0
            $0.textColor = .black
        }
        [titleLabel, bodyStack].forEach {
            stackView.addArrangedSubview($0)
        }
        setNeedsLayout()
    }

    private func makeTitleLabel(title: String, type: String) -> UILabel {
        let titleLabel = UILabel()
        let subtitleString = ", \(type)"
        let titleString = "\(title)\(subtitleString)"
        let attrString = NSMutableAttributedString(
            string: titleString,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
            ]
        )
        if let range = titleString.range(of: subtitleString) {
            attrString.addAttribute(
                NSAttributedString.Key.font,
                value: UIFont.systemFont(ofSize: 17),
                range: NSRange(range, in: titleString))
        }
        titleLabel.attributedText = attrString
        return titleLabel
    }
}
