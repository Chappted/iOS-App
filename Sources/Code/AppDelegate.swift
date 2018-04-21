//
//  AppDelegate.swift
//  Chappted
//
//  Created by Cihat Gündüz on 26.05.17.
//  Copyright © 2017 Jamit Labs GmbH. All rights reserved.
//

import Imperio
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Stored Type Properties
    static var shared: AppDelegate?

    // MARK: - Stored Instance Properties
    var appCoordinator: AppCoordinator?

    // MARK: - Computed Instance Properties
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        AppDelegate.shared = self
        window?.makeKeyAndVisible()

        // setup global stuff
        Logger.shared.setup()
        Branding.shared.setupGlobalAppearance()

        // TODO - check here if onboarding needs to be dislpayed -> set onboarding coordinator as AppCoordinator
        appCoordinator = MenuCoordinator.shared
        //appCoordinator = LoginRegisterCoordinator.shared
        appCoordinator?.start()

        return true
    }
}
