//
//  Branding.swift
//  Chappted
//
//  Created by Cihat Gündüz on 26.05.17.
//  Copyright © 2017 Jamit Labs GmbH. All rights reserved.
//

import UIKit

class Branding {
    // MARK: - Stored Type Properties
    static let shared = Branding()
    private let customFont = UIFont(name: "Rubik-Medium", size: 16)

    // MARK: - Instance Methods
    func setupGlobalAppearance() {
        UIView.appearance().tintColor = UIColor(named: .accent)
    }

    private func setupNavigationBarAppearance() {
        let navBarAppearance = UINavigationBar.appearance()

        let titleTextAttributes = [
            NSAttributedStringKey.font: customFont?.withSize(26) ?? UIFont.systemFont(ofSize: 26),
            NSAttributedStringKey.foregroundColor: Color(named: .primary)
        ]

        navBarAppearance.titleTextAttributes = titleTextAttributes
        navBarAppearance.backItem?.backBarButtonItem?.title = ""
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.tintColor = .white
        navBarAppearance.barTintColor = UIColor(named: .secondary)
        navBarAppearance.isTranslucent = false
    }
}
