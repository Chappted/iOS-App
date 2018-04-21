//
//  ViewController.swift
//  Chappted
//
//  Created by Cihat Gündüz on 26.05.17.
//  Copyright © 2017 Jamit Labs GmbH. All rights reserved.
//

import Imperio
import UIKit

class PageViewController: UIViewController, Coordinatable {
    // MARK: - Coordinatable Protocol Implemenation
    enum Action {
        case didSelectIndex(type: Int)
    }

    var coordinate: ((Action) -> Void)!

    // MARK: - Stored Instance Properties
    let dataProvider = DataProvider<PageViewCtrlViewModel>()


    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: setup table view controllers here
    }
}

