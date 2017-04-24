//
//  InstructionsPageVCViewController.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 2/28/17.
//  Copyright © 2017 Samuel Cheng. All rights reserved.
//

import UIKit

class InstructionsPageVC: UIPageViewController, UIPageViewControllerDelegate {
    
    // array to reference the view controllers we want to page through
    // must be lazy var because Storyboard is not instantiated at the very beginning
    private(set) lazy var VCArray: [UIViewController] = {
        return [self.newStepViewController(step: "step1"),
                self.newStepViewController(step: "step2"),
                self.newStepViewController(step: "step3")]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // we are managing the data source and delegate protocols
        dataSource = self
        self.delegate = self
        
        // load up the first step VC
        if let firstViewController = VCArray.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
    }
    
    // prevent a black bar showing the PageControl dots at the bottom
    // make the background the same as the background of the active view controller
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // for each view controller
        for view in self.view.subviews {
            
            // if it's the main view area, set it to the bounds of the device screen
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl { // otherwise, if it's part of the dots
                view.backgroundColor = UIColor.clear // make the background transparent
            }
        }
    }
    
    // function to instantiate and return the next step VC
    // used to populate orderedViewControllers array
    private func newStepViewController(step: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(step)VC")
    }
    
}

extension InstructionsPageVC: UIPageViewControllerDataSource {
    
    // implementing required data source function to specify which VC comes before
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // assign the current view controller that you are working with
        // (find out where you are positioned in the array)
        guard let viewControllerIndex = VCArray.index(of: viewController) else {
            return nil // if we cannot do this assignment
        }
        
        // assign what the previous index is
        let previousIndex = viewControllerIndex - 1
        
        // check if the previousIndex is not less than 0
        // otherwise loop around
        guard previousIndex >= 0 else {
            return VCArray.last
        }
        
        // check if the previous Index is not past the length of the array
        // otherwise exit out
        guard VCArray.count > previousIndex else {
            return nil
        }
        
        return VCArray[previousIndex]
    }
    
    // implementing required data source function to specify which VC comes after
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // assign the current view controller that you are working with
        // (find out where you are positioned in the array)
        guard let viewControllerIndex = VCArray.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let VCArrayCount = VCArray.count
        
        // check if the nextIndex is less than the array size
        // otherwise exit out
        guard nextIndex < VCArrayCount else {
            return VCArray.first
        }
        
        guard VCArrayCount > nextIndex else {
            return nil
        }
        
        return VCArray[nextIndex]
    }
    
    // code to set up the dots that show which page you are on
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArray.count
    }
    
    // code to return
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        // find the current index of the UIViewController that we're presenting
        guard let firstVC = viewControllers?.first,
            
            let firstVCIndex = VCArray.index(of: firstVC) else {
                
            // if we're unable to find this particular UIViewController
            return 0
        }
        
        return firstVCIndex
    }
    
    
}








