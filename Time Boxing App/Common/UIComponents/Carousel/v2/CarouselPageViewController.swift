//
//  CarouselPageViewController.swift
//  Time Boxing App
//
//  Created by Julio Perez on 7/07/22.
//

import Foundation
import UIKit

protocol CarouselPageDelegate {
    func onPageChanged(_ page : Int, _ vc: UIViewController, _ view: UIView)
}

class CarouselPageViewController: UIPageViewController {
    fileprivate var items: [UIViewController] = []
    private var data : [CarouselData] = loginCarousel
    var carouselDelegate : CarouselPageDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        decoratePageControl()
        populateItems()
        if let firstViewController = items.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func decoratePageControl() {
        let pc = UIPageControl.appearance(whenContainedInInstancesOf: [CarouselPageViewController.self])
        pc.currentPageIndicatorTintColor = .orange
        pc.pageIndicatorTintColor = .gray
    }
    
    private func populateItems() {
        for obj in data {
            let c = createCarouselItemControler(obj.text, obj.image)
            items.append(c)
        }
    }
    
    private func createCarouselItemControler(_ titleText: String?, _ image: UIImage?) -> UIViewController {
        let c = UIViewController()
        c.view = CarouselItem(title, image)
        return c
    }
}

extension CarouselPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return items.last
        }
        
        guard items.count > previousIndex else {
            return nil
        }
        
        return items[previousIndex]
    }
    
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex else {
            return items.first
        }
        
        guard items.count > nextIndex else {
            return nil
        }
        return items[nextIndex]
    }
    
    
    func presentationCount(for _: UIPageViewController) -> Int {
        return items.count
    }
    
    func presentationIndex(for _: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = items.firstIndex(of: firstViewController) else {
            return 0
        }
        return firstViewControllerIndex
    }
}

extension CarouselPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let index = items.firstIndex(of: currentVC) else { return }
        self.carouselDelegate?.onPageChanged(index, currentVC, currentVC.view)
        
    }
    
}
