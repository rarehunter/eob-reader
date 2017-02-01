//
//  OpenCameraViewController.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 1/18/17.
//  Copyright © 2017 Samuel Cheng. All rights reserved.
//

import UIKit

class TabModVC: UITabBarController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        let resultsIndex = 2
//        
//        if item == (self.tabBar.items! as [UITabBarItem])[resultsIndex] {
//            let cameraVC : CameraViewController = segue.destinationViewController as! CameraViewController
//            CameraViewController.delegate = self
//        }
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        //  Set camera index to the index on your tabbar
//        let cameraIndex = 1
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
