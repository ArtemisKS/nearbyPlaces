//
//  PlaceTableViewCell.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 01.06.2021.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    private enum Constants {
        static let offset: CGFloat = 16
    }

    var titleLabel = UILabel()
    private var addressLabel = UILabel()
    private var typeLabel = UILabel()
    private var phoneLabel = UILabel()
    private var phoneTitle = UILabel()
    private let stackView = UIStackView()
    private var bodyStack: UIStackView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .background

        stackView.axis = .vertical
        stackView.spacing = Constants.offset
        addSubview(stackView)
        stackView.layout { (builder) in
            builder.top == topAnchor + Constants.offset
            builder.leading == leadingAnchor + Constants.offset
            builder.trailing == trailingAnchor - Constants.offset
            builder.bottom == bottomAnchor - Constants.offset
        }
        setupUIElements()
    }

    private func setupUIElements() {
        titleLabel = UILabel()
        titleLabel.text = ""
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)

        let (addressStack, addressTitle, addressLabel) = ViewFactory.makeLabelStack(title: "Address", value: "")
        self.addressLabel = addressLabel

        let (typeStack, typeTitle, typeLabel) = ViewFactory.makeLabelStack(title: "Type", value: "")
        self.typeLabel = typeLabel

        let (phoneStack, phoneTitle, phoneLabel) = ViewFactory.makeLabelStack(
            title: "",
            value: ""
        )
        self.phoneTitle = phoneTitle
        self.phoneLabel = phoneLabel

        bodyStack = UIStackView(arrangedSubviews: [typeStack, phoneStack])
        bodyStack.axis = .vertical
        bodyStack.spacing = Constants.offset

        [titleLabel, addressLabel, addressTitle, typeTitle, typeLabel, phoneLabel, phoneTitle].forEach {
            $0.numberOfLines = 0
            $0.textColor = .white
        }

        [titleLabel, addressStack, bodyStack].forEach {
            stackView.addArrangedSubview($0)
        }
        bodyStack.isHidden = true
    }

    func setupCell(
        title: String,
        address: String,
        type: String,
        phone: String?,
        zip: String
    ) {
        titleLabel.text = title
        addressLabel.text = address
        typeLabel.text = type
        let isPhone = phone != nil && !phone!.isEmpty
        phoneTitle.text = isPhone ? "Phone" : "Postal code"
        phoneLabel.text = isPhone ? phone! : zip
    }

    func onCellTap(
        duration: TimeInterval,
        completion: @escaping () -> Void
    ) {
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModePaced,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: { [weak self] in
                    guard let self = self else { return }
                    self.bodyStack.alpha = self.bodyStack.isHidden ? 1 : 0
                    self.bodyStack.isHidden.toggle()
                })
            }, completion: { _ in
                completion()
            })
    }
}
