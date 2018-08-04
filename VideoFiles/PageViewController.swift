//
//  PageViewController.swift
//  Calories app
//
//  Created by Shreeja Kikkisetti on 8/3/18.
//  Copyright © 2018 Shreeja Kikkisetti. All rights reserved.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    //stores the page view controllers
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVC(viewController: "First"),self.newVC(viewController: "Second"), self.newVC(viewController: "Third"), self.newVC(viewController: "Fourth")]
    }()
    
    var pageControl = UIPageControl()
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        self.delegate = self
        configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    
    func configurePageControl() {
        //places the page control at the bottom of the screen
        pageControl = UIPageControl(frame: CGRect(x:0,y:UIScreen.main.bounds.maxY-50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.gray
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        self.view.addSubview(pageControl)
    }
    
    //returns a view controller from Tabs storyboard
    func newVC(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewController)
    }
    
    //returns the view controller before the current one (swiping left)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //check if we can get the current view controller index
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex-1
        //check if previousIndex is greater than or equal to 0 to check to make sure that the indicies are within the bounds of the orderedViewControllers array
        guard previousIndex >= 0 else {
            return nil
        }
        //check to see if there are any more view controllers
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
        
    }
    
    //returns the view controller after the current one (swiping right)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //check if we can get the current view controller index
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex+1
        
        guard orderedViewControllers.count != nextIndex else {
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func help() {
        //        print("Help button was pressed!")
        //        window = UIWindow(frame: UIScreen.main.bounds)
        //        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //        let viewController = storyboard.instantiateViewController(withIdentifier: "landingPage")
        //        window?.rootViewController = viewController
        //        window?.makeKeyAndVisible()
    }
    
    
    
}
