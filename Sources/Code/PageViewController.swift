//
//  ViewController.swift
//  Chappted
//
//  Created by Cihat Gündüz on 26.05.17.
//  Copyright © 2017 Jamit Labs GmbH. All rights reserved.
//

import SnapKit
import UIKit

protocol PageViewControllerDelegate: class {
    func pageViewController(_ pageViewController: PageViewController, didChangeCurrentPageIndex currentPageIndex: Int)
}

class PageViewController: UIViewController {
    // MARK: - Stored Instance Properties
    private var pageViewController: UIPageViewController!
    private var segmentedControl: UISegmentedControl!

    private(set) var currentPageIndex: Int = 0 {
        didSet {
            updateNavigationItems()
            updateSegmentedControl()
            delegate?.pageViewController(self, didChangeCurrentPageIndex: currentPageIndex)
        }
    }

    private var nextPageIndex: Int?

    weak var delegate: PageViewControllerDelegate?

    let pageProvider = DataProvider<[UIViewController]>()

    // MARK: - Computed Instance Properties
    var currentViewController: UIViewController? {
        guard currentPageIndex < pageProvider.data.count else { return nil }

        return pageProvider.data[currentPageIndex]
    }

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue

//        configureBackBarButtonItem()
        setupSegmentedControl()
        setupSegmentedControlAppearance()
        setupPageViewController()
        setupSeparatorView()

        pageProvider.onDataChanged { [unowned self] viewControllers in
            self.currentPageIndex = 0
            self.pageViewController.setViewControllers(viewControllers.first.map { [$0] }, direction: .forward, animated: false, completion: nil)
            self.segmentedControl.removeAllSegments()
            viewControllers.forEach { viewController in
                _ = viewController.view
                self.segmentedControl.insertSegment(withTitle: viewController.navigationItem.title, at: self.segmentedControl.numberOfSegments, animated: false)
            }

            self.segmentedControl.selectedSegmentIndex = 0
            self.updateNavigationItems()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateSegmentedControl()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateSegmentedControl()
    }

    // MARK: - Instance Methods
    private func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: nil)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControlValue(_:)), for: .valueChanged)

        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.equalTo(view.snp.leading).offset(16)
            maker.trailing.equalTo(view.snp.trailing).offset(-16)
        }
    }

    private func setupSegmentedControlAppearance() {
        let clearImage = UIGraphicsImageRenderer(bounds: CGRect(width: 3, height: 3)).image { _ in }
        let normalTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.gray.withAlphaComponent(0.8),
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]
        let highlightedTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.gray.withAlphaComponent(0.4),
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]
        let selectedTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]

        segmentedControl.setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(#imageLiteral(resourceName: "segmentedControlDivider"), for: .selected, barMetrics: .default)
        segmentedControl.setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(clearImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .selected, barMetrics: .default)
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(highlightedTextAttributes, for: .highlighted)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentedControl.tintColor = UIColor(named: .secondary)
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        addChildViewController(pageViewController)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.frame = UIEdgeInsetsInsetRect(view.bounds, UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0))
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { maker in
            maker.top.equalTo(segmentedControl.snp.bottom)
            maker.leading.equalTo(view.snp.leading)
            maker.trailing.equalTo(view.snp.trailing)
            maker.bottom.equalTo(view.snp.bottom)
        }

        pageViewController.didMove(toParentViewController: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }

    private func setupSeparatorView() {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(separatorView)
        view.bringSubview(toFront: separatorView)
        separatorView.snp.makeConstraints { maker in
            maker.height.equalTo(0.5)
            maker.leading.equalTo(view.snp.leading)
            maker.trailing.equalTo(view.snp.trailing)
            maker.bottom.equalTo(segmentedControl.snp.bottom)
        }
    }

    private func updateNavigationItems() {
        let viewController = pageProvider.data?[currentPageIndex]
        navigationItem.leftBarButtonItems = viewController?.navigationItem.leftBarButtonItems
        navigationItem.rightBarButtonItems = viewController?.navigationItem.rightBarButtonItems
    }

    func updateSegmentedControl() {
        guard let viewControllers = pageProvider.data, segmentedControl.numberOfSegments == viewControllers.count else { return }

        viewControllers.enumerated().forEach { index, viewController in
            self.segmentedControl.setTitle(viewController.navigationItem.title, forSegmentAt: index)
        }
    }

    // MARK: - Actions
    @objc
    private func didChangeSegmentedControlValue(_ segmentedControl: UISegmentedControl) {
        guard let data = pageProvider.data else { return }

        let direction: UIPageViewControllerNavigationDirection = segmentedControl.selectedSegmentIndex < currentPageIndex ? .reverse : .forward

        if currentPageIndex != segmentedControl.selectedSegmentIndex {
            currentPageIndex = segmentedControl.selectedSegmentIndex
            pageViewController.setViewControllers([data[currentPageIndex]], direction: direction, animated: true, completion: nil)
            updateNavigationItems()
            updateSegmentedControl()
        }
    }
}

// MARK: - UIPageViewControllerDataSource Protocol Implementation
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let data = pageProvider.data, let index = data.index(of: viewController), index > data.startIndex else { return nil }

        return data[data.index(before: index)]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let data = pageProvider.data, let index = data.index(of: viewController), index + 1 < data.endIndex else { return nil }

        return data[data.index(after: index)]
    }
}

// MARK: - UIPageViewControllerDelegate Protocol Implementation
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers.first, let index = pageProvider.data?.index(of: viewController) {
            nextPageIndex = index
        } else {
            nextPageIndex = nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let index = nextPageIndex, completed {
            currentPageIndex = index
            segmentedControl.selectedSegmentIndex = index
        }

        nextPageIndex = nil
    }
}
