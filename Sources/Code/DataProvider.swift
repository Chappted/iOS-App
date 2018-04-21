//  TurnerApp
//
//  Created by Cihat Gündüz on 27.08.17.
//  Copyright © 2017 Flinesoft. All rights reserved.
//

import Foundation

/// A data wrapper which informs its initializer about any data changes.
public class DataProvider<DataType> {
    typealias DataChangedClosure = (DataType) -> Void

    // MARK: - Stored Instance Properties
    /// The data to be informed about if it changes.
    public private(set) var data: DataType!

    /// The actions to take on the initializer side if a data changes occurs.
    private var dataChangedClosure: DataChangedClosure?

    // MARK: - Initializers
    /// Sets the closure to be called each time changes are made to the underlying data.
    func onDataChanged(_ dataChangedClosure: @escaping DataChangedClosure) {
        self.dataChangedClosure = dataChangedClosure

        if let data = data {
            dataChangedClosure(data)
        }
    }

    // MARK: - Instance Methods
    /// Changes the existing data within the given closure and informs the initializer about the changes.
    ///
    /// - Parameters:
    ///   - changeClosure: The closure which changes the existing data.
    func changeData(_ changeClosure: (inout DataType!) -> Void) {
        changeClosure(&data)

        guard let data = data else { fatalError("Initial call to `changeData(_:)` did not assign a non-nil object to data parameter") }
        dataChangedClosure?(data)
    }

    /// Sets the closure to be called each time changes are made to the underlying data.
    func onDataChanged<ViewType: AnyObject>(update view: ViewType, _ closure: @escaping (ViewType, DataType) -> Void) {
        dataChangedClosure = { [weak view] data in
            guard let view = view else { return }

            closure(view, data)
        }

        if let data = data {
            dataChangedClosure?(data)
        }
    }
}
