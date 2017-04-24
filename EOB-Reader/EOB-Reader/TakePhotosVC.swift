//
//  CameraViewController.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 12/30/16.
//  Copyright © 2016 Samuel Cheng. All rights reserved.
//

import UIKit
import TesseractOCR


class CameraViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, G8TesseractDelegate {


    @IBAction func takePhoto1(_ sender: Any) {
        // Check if the camera is available on the device as a source type
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            // declare a variable of image picker controller
            let imagePicker = UIImagePickerController()
            
            // set its delegate, set its source type
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            
            // tell our image picker to not edit a captured picture
            // which means that we won’t get the black screen with
            // a square frame right after taking a photo.
            imagePicker.allowsEditing = false
            
            // present the camera controller, it will show up from the
            // bottom of the screen, which is the default iOS animation
            // for opening new screens.
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPageAction(_ sender: Any) {
//        let imageView = UIImageView()
//        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
//        view.addSubview(imageView)
        
        print("adding...")
        let newtext = UITextView()

        newtext.frame = CGRect(x: 18, y: 50, width: 100, height: 40)

        view.addSubview(newtext)

    }

    
    // Add a delegate in order to tell the app to get the chosen image and place
    // it into the image view we've placed on the main screen.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage2 : UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            pickedImage1.contentMode = .scaleAspectFit
//            pickedImage1.image = pickedImage2
        };
    
        self.dismiss(animated: true, completion: nil)
    }        

        
    @IBAction func processAction(_ sender: UIBarButtonItem) {
        let tempNavVC = self.tabBarController!.viewControllers![0] as! UINavigationController
        let scanVCRef = tempNavVC.viewControllers[0] as! RecentScansVC
        
        print ("processing")
//        if(scanNameText.text == "") {
//            scanVCRef.insertCell("New Scan")
//        }
//        else {
//            scanVCRef.insertCell((scanNameText?.text)!)
//        }
    }
        //        // create a tesseract constant and initialize it to the english language
        //        if let tesseract = G8Tesseract(language: "eng") {
        //            tesseract.delegate = self
        //            tesseract.image = pickedImage1.image
        //            tesseract.recognize()
        //
        //
        //
        ////            let secondTab = self.tabBarController?.viewControllers?[2] as! ResultsViewController
        ////            secondTab.result_data = tesseract.recognizedText
        //        }
    

    
    

    
    
//    // outlet for open photo library button
//    @IBAction func photoLibraryAction(_ sender: UIButton) {
//        // Check if the device is able to access a photo library
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
//            
//            // declare another image picker's variable for later use
//            let imagePicker = UIImagePickerController()
//            
//            // set its delegate, set its source type (the camera roll)
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//            
//            // set the property that allows us to edit our picked image as
//            // true, which means that we will get a black window with a square
//            // frame where we can zoom, move and crop our photo.
//            imagePicker.allowsEditing = true
//            
//            // present the photo library controller with a standard animation
//            // from the bottom of the screen
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }
    
//    @IBAction func saveAction(_ sender: UIButton) {
//        // Declare a variable for our image and compress it to 0.6 quality
//        // (value from 0.0 to 1.0)
//        let imageData = UIImageJPEGRepresentation(pickedImage1.image!, 0.6)
//        
//        // Create a new UIImage and pass it the data previously made into it
//        let compressedJPGImage = UIImage(data: imageData!)
//        
//        // Simple method to save our picture into camera roll
//        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
//        
//        saveNotice()
//    }
//    
//    
//    // Display message notifying user that photo was successfully saved.
////    func saveNotice() {
////        let alertController = UIAlertController(title: "Image Saved!", message: "Your picture was successfully saved.", preferredStyle: .alert)
////        
////        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
////        alertController.addAction(defaultAction)
////        
////        present(alertController, animated: true, completion: nil)
////    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition Progress \(tesseract.progress) %" )
    }
}

