//
//  MenuCoordinator.swift
//  Chappted
//
//  Created by Vitalij Saponenko on 21.04.18.
//  Copyright © 2018 Jamit Labs GmbH. All rights reserved.
//

import Imperio
import UIKit

class MenuCoordinator: AppCoordinator {
    // MARK: - Stored Type Properties
    static let shared = MenuCoordinator()

    // MARK: - Stored Instance Properties
    private lazy var pageViewController = PageViewController()

    // MARK: - Computed Instance Properties
    override var mainViewController: UIViewController {
        return pageViewController
    }

    // MARK: - Instance Methods
    override func start() {
        super.start()

        pageViewController.dataProvider.changeData { viewModel in
            viewModel = pageViewController(title: l10n.HomeTab.title)
        }

        pageViewController.coordinate = { [unowned self] action in
            switch action {
            case let .didSelectIndex(type):
                self.handleSelectedTabBarItem(type: type)
            }
        }

        AppDelegate.shared?.window!.rootViewController = pageViewController
    }
}
