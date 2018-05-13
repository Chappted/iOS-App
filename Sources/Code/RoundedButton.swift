//
//  RoundedButton.swift
//  Chappted
//
//  Created by Vitalij Saponenko on 13.05.18.
//  Copyright © 2018 Jamit Labs GmbH. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    // MARK: - IBInspectables
    @IBInspectable var cornerRadius: CGFloat = -1.0
    @IBInspectable var borderEnable: Bool = false
    @IBInspectable var borderColor: UIColor = .white
    @IBInspectable var borderWidth: CGFloat = -1.0
    @IBInspectable var shadowEnable: Bool = false
    @IBInspectable var shadowColor: UIColor = .clear
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    @IBInspectable var shadowRadius: CGFloat = 0.0
    @IBInspectable var shadowOpacity: CGFloat = 1.0

    // MARK: - Instance Methods
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.size.height / 2
        titleLabel?.textAlignment = .center
        if borderEnable {
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
        }

        if shadowEnable {
            setupButtonShadow()
        } else {
            clipsToBounds = true
        }
    }

    private func setupButtonShadow() {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowOffset = shadowOffset
        layer.masksToBounds = false
    }
}
