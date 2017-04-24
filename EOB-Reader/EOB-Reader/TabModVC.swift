//
//  OpenCameraViewController.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 1/18/17.
//  Copyright © 2017 Samuel Cheng. All rights reserved.
//

import UIKit

class TabModVC: UITabBarController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let center_button : UIButton = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this is done to prevent the user from being able to go back to the "AgreementVC"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // disable the dummy center tab bar item from being clicked on
        // this was done in the Storyboard interface builder
        
        // set the raised center button on the tab bar
        center_button.setImage(#imageLiteral(resourceName: "camera_orange"), for: .normal)
        center_button.backgroundColor = UIColor.white
        center_button.layer.borderColor = UIColor(red:0.38, green:0.37, blue:0.37, alpha:1.0).cgColor
        center_button.layer.borderWidth = 1
        center_button.addTarget(self, action: #selector(openCameraAction), for: .touchUpInside)

        self.view.insertSubview(center_button, aboveSubview: self.tabBar)
        

    }

    // actual layout and position of the raised center button
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        center_button.frame = CGRect.init(x: self.tabBar.center.x - 32,
                                          y: self.view.bounds.height - 74,
                                          width: 64,
                                          height: 64)
        
        center_button.layer.cornerRadius = 32
        
    }
    
    func openCameraAction() {
        
        let cvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraVC") as! CameraVC
        
        let tempNavVC = self.viewControllers![0] as! UINavigationController // recent scans tab
        let scanVCRef = tempNavVC.viewControllers[0] as! RecentScansVC
        let tempNavVC2 = self.viewControllers![2] as! UINavigationController // about tab
        let aboutRef = tempNavVC2.viewControllers[0] as! AboutVC
        
        // pass tabbarcontroller to camera VC
        // this will be used to call the "insertCells" method
        // so that a cell can be added after processing
        cvc.refRecentScans = scanVCRef
        cvc.refAbout = aboutRef
        cvc.tabBarLevel = self

        
        self.present(cvc, animated: true, completion: {
            // Before we let the user actually take a picture
            // we make sure they see the instructions
            let instructionController = UIAlertController(title: "Photo Instructions", message: "Follow these instructions to ensure a quality scan.", preferredStyle: .alert)
            
            let actionDone = UIAlertAction(title: "Done", style: .cancel)  {(action:UIAlertAction) in
                //This is called when the user presses the done button.
                print("You've pressed the done button");
            }
            
            let insPageVC : UIPageViewController = InstructionsPageVC()
            
            //Add the buttons
            instructionController.addAction(actionDone)
            
            // set the size of the content view controller
            insPageVC.preferredContentSize.height = 240
            
            // configure the Page View Controller as the content view controller
            instructionController.setValue(insPageVC, forKey: "contentViewController")
            
            //Present the instruction controller
            cvc.present(instructionController, animated: true, completion: nil)
        })
        
    }
    
    // Add a delegate in order to tell the app to get the chosen image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let pickedImage : UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
        };
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        let resultsIndex = 2
//        
//        if item == (self.tabBar.items! as [UITabBarItem])[resultsIndex] {
//            let cameraVC : CameraViewController = segue.destinationViewController as! CameraViewController
//            CameraViewController.delegate = self
//        }
//    }


//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        //  Set camera index to the index on your tabbar
//        let cameraIndex = 3
//        
//        if item == (self.tabBar.items! as [UITabBarItem])[cameraIndex] {
//            //  Call Camera
//            
//            // Check if the camera is available on the device as a source type
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//                
//                // declare a variable of image picker controller
//                let imagePicker = UIImagePickerController()
//                
//                // set its delegate, set its source type
//                imagePicker.delegate = self
//                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//                
//                // tell our image picker to not edit a captured picture
//                // which means that we won’t get the black screen with
//                // a square frame right after taking a photo.
//                imagePicker.allowsEditing = false
//                
//                // present the camera controller, it will show up from the
//                // bottom of the screen, which is the default iOS animation
//                // for opening new screens.
//                self.present(imagePicker, animated: true, completion: nil)
//                
//            }
//        }
//    }
}
