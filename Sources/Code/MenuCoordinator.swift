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
    private lazy var openChallengesViewController = StoryboardScene.ChallengesTableViewController.openChallengesTableViewController.instantiate()
    private lazy var activeChallengesViewController = StoryboardScene.ChallengesTableViewController.activeChanllengesTableViewController.instantiate()
	
    // MARK: - Computed Instance Properties
    override var mainViewController: UIViewController {
        return pageViewController
    }

    // MARK: - Instance Methods
    override func start() {
        super.start()

        pageViewController.pageProvider.changeData { viewControllers in
            viewControllers = [self.openChallengesViewController, self.activeChallengesViewController]
        }

        setupOpenChanllengesViewCtrl()
        setupActiveChanllengesViewCtrl()

        AppDelegate.shared?.window!.rootViewController = pageViewController
    }

    // MARK: - Instance Methods
    private func setupOpenChanllengesViewCtrl() {
        openChallengesViewController.title = "Challenges"
    }

    private func setupActiveChanllengesViewCtrl() {
        activeChallengesViewController.title = "Accepted"
    }
}
