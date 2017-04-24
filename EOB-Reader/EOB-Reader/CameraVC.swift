//
//  CameraVC.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 3/1/17.
//  Copyright © 2017 Samuel Cheng. All rights reserved.
//

import UIKit
import AVFoundation
import TesseractOCR


class CameraVC: UIViewController, AVCapturePhotoCaptureDelegate, G8TesseractDelegate {

    // this is where the camera feed from the phone is going to be displayed
    @IBOutlet var cameraView : UIView!
    
    // stillPicture is what we show as the picture taken, frozen on the screen
    @IBOutlet weak var stillPicture : UIImageView!
    
    var refRecentScans : RecentScansVC!
    var refAbout : AboutVC!
    var tabBarLevel : TabModVC!
    
    // these are the white brackets that the EOB should be in
    @IBOutlet weak var brackets : UIImageView!
    
    var shutterButton : UIButton = UIButton.init(type: .custom)
    var backButton : UIButton = UIButton.init(type: .custom)
    var deleteButton : UIButton = UIButton.init(type: .custom)
    var processButton : UIButton = UIButton.init(type: .custom)
    
    // manages capture activity and coordinates the flow of data from input devices to capture outputs.
    var capture_session = AVCaptureSession()
    
    // a capture output for use in workflows related to still photography.
    var session_output = AVCapturePhotoOutput()
    
    // preview layer that we will have on our view so users can see the photo we took
    var preview_layer = AVCaptureVideoPreviewLayer()
    
    var processingDone = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the shutter button
        // and put it on the screen
        shutterButton.layer.borderColor = UIColor.white.cgColor
        shutterButton.layer.borderWidth = 6.0
        shutterButton.clipsToBounds = true
        shutterButton.addTarget(self, action: #selector(shutterButtonPressed), for: .touchUpInside)
        self.view.insertSubview(shutterButton, aboveSubview: cameraView)
        
        // put the back button on the screen
        backButton.setImage(#imageLiteral(resourceName: "back_arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.insertSubview(backButton, aboveSubview: cameraView)
        
        // put the corner border brackets on the screen
        brackets.image = #imageLiteral(resourceName: "bracket_border")
        self.view.insertSubview(brackets, aboveSubview: cameraView)
        
        // put the placeholder of where the taken image will be on the screen
        self.view.insertSubview(stillPicture, aboveSubview: brackets)
        
        // put the delete button "X" on the screen and make it hidden first
        deleteButton.setImage(#imageLiteral(resourceName: "delete_white"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        self.view.insertSubview(deleteButton, aboveSubview: stillPicture)
        deleteButton.isEnabled = false
        deleteButton.isHidden = true
        
        // put the "Use this photo" button on the screen and make it hidden first
        processButton.setTitle("Use Photo", for: .normal)
        processButton.setTitleColor(UIColor.white, for: .normal)
        processButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        processButton.backgroundColor = UIColor(red:0.98, green:0.21, blue:0.25, alpha:1.0)
        processButton.titleLabel?.numberOfLines = 2
        processButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        processButton.titleLabel?.textAlignment = NSTextAlignment.center
        processButton.titleLabel?.baselineAdjustment = .alignCenters
        processButton.layer.shadowColor = UIColor.black.cgColor
        processButton.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        processButton.layer.shadowRadius = 5
        processButton.layer.shadowOpacity = 0.7
        processButton.addTarget(self, action: #selector(processButtonPressed), for: .touchUpInside)
        self.view.insertSubview(processButton, aboveSubview: stillPicture)
        processButton.isEnabled = false
        processButton.isHidden = true
    }

    // get the camera feed onto the camera view
    // prep everything up before the view appears
    override func viewWillAppear(_ animated: Bool) {
        
        // get the back camera on the iPhone
        let back_camera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        
        // feed everything from our back_camera into the capture session
        do {
            let input = try AVCaptureDeviceInput(device: back_camera)
            if capture_session.canAddInput(input) {
                capture_session.addInput(input)
                
                // output is either a video or JPG
                
                // add our output to capture session
                if capture_session.canAddOutput(session_output) {
                    capture_session.addOutput(session_output)
                    capture_session.startRunning()
                    
                    // take session output and apply it to our application
                    preview_layer = AVCaptureVideoPreviewLayer(session: capture_session)
                    
                    // add gravity, fill up the whole scene by aspect ratio
                    preview_layer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    
                    ////////////
                    // there's something in here about Outputsettings to JPG
                    ///////////
                    
                    
                    preview_layer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                    cameraView.layer.addSublayer(preview_layer)
                    
                    preview_layer.position = CGPoint(x: self.cameraView.frame.width / 2,
                                                     y: self.cameraView.frame.height / 2)
                    
                    preview_layer.bounds = cameraView.frame
                }
            }
        }
        catch {
            print("Camera Error")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        backButton.frame = CGRect.init(x: 15, y: 35, width: 30, height: 30)
        
        shutterButton.frame = CGRect.init(x: self.view.bounds.width / 2 - 35,
                                          y: self.view.bounds.height - 90,
                                          width: 70,
                                          height: 70)
        
        shutterButton.layer.cornerRadius = 0.5 * shutterButton.bounds.size.width
        
        deleteButton.frame = CGRect.init(x: 15, y:35, width: 30, height: 30)
        
        
        processButton.frame = CGRect.init(x: self.view.bounds.width - 90,
                                       y: self.view.bounds.height - 90,
                                       width: 70,
                                       height: 70)
        
        processButton.layer.cornerRadius = 0.5 * processButton.bounds.size.width
    }

    
    // code for when the "<" button is pressed
    // we want it to go back to the previous view (tabbarcontroller)
    func backButtonPressed() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // code for when the "X" button is pressed
    // we want to remove the still image but keep the camera view active
    func deleteButtonPressed() {

        stillPicture?.image = nil
        
        // show the back button, hide the "X" button
        deleteButton.isEnabled = false
        deleteButton.isHidden = true
        backButton.isEnabled = true
        backButton.isHidden = false
        
        // hide the "Use this photo" button
        processButton.isEnabled = false
        processButton.isHidden = true
        
        // show the shutter button
        shutterButton.isEnabled = true
        shutterButton.isHidden = false
        
    }
    
    func displaySpinningGear() {
        
        print("display spinning gear")
        // show the alert window box
        let activityAlertController = UIAlertController(title: "Processing", message: "Please wait while the photo is being processed.", preferredStyle: .alert)
        
        //create an activity indicator
        let indicator = UIActivityIndicatorView(frame: activityAlertController.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        //add the activity indicator as a subview of the alert controller's view
        activityAlertController.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()
        
        print("start animating")

        self.present(activityAlertController, animated: true, completion: nil)
        

    }
    
    // code for when the "Use this Photo" button is pressed
    func processButtonPressed() {

        // Get the current date time
        let current_date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm:ss"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let date_result = formatter.string(from: current_date)
        
        // add a cell and give it a default name
        refRecentScans.insertCell("Scan "  + date_result, thumbnail: stillPicture)
        
        // this code block here is to asynchronously run the processing job
        // while the activity indicator gear spins
        
        
        self.displaySpinningGear()
        DispatchQueue.main.async {
            self.doProcessing()
        }

        /*
        
        DispatchQueue.global(qos: .background).async {
            print("Processing")
            self.doProcessing() // run in background
            
            DispatchQueue.main.async {
                self.displaySpinningGear()
            }
        }
        
        while processingDone {
            if let viewController = self.presentingViewController {
                // This block will dismiss both current and a view controller presenting current
                viewController.dismiss(animated: true, completion: nil)
            }
            else {
                // This block will dismiss only current view controller
                self.dismiss(animated: true, completion: nil)
            }
        }

*/
        if let viewController = self.presentingViewController {
            // This block will dismiss both current and a view controller presenting current
            viewController.dismiss(animated: true, completion: nil)
        }
        else {
            // This block will dismiss only current view controller
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    func doProcessing() {
        // create a tesseract constant and initialize it to the english language
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.delegate = self
            
            // Rotate taken picture
            let orig_image = stillPicture.image!
        
            
//            let im = UIImage(named:"picture")!
//            let r = UIGraphicsImageRenderer(size:
//                CGSize(width: im.size.height, height: im.size.width))
//            let outim = r.image { _ in
//                let con = UIGraphicsGetCurrentContext()!
//                con.translateBy(x: 0, y: im.size.width)
//                con.rotate(by: -.pi/2)
//                im.draw(at: .zero)
//            }
//            let iv = UIImageView(image:outim)
//            self.view.addSubview(iv)
            
            
            
//            let new_image_canvas = UIGraphicsImageRenderer(size: CGSize(width: orig_image.size.height,
//                                                                        height: orig_image.size.width))
//            let new_image = new_image_canvas.image { _ in
//                let curr_context = UIGraphicsGetCurrentContext()!
//                curr_context.translateBy(x: 0, y: orig_image.size.width)
//                curr_context.rotate(by: -.pi/2)
////                curr_context.translateBy(x: 0, y: -orig_image.size.width)
////                orig_image.draw(at: CGPoint(x: 0, y: orig_image.size.width))
//                orig_image.draw(at: .zero)
//            }
            
            
            let topLeftImage : UIImage = topLeftCrop(screenshot: stillPicture.image!)
//            let centerImage : UIImage = centerHorizCrop(screenshot: new_image)
            
            tesseract.image = topLeftImage.g8_grayScale()
            tesseract.recognize()

            
            let regexp = "((ALREADY PAID | NOT ALR | PROVIDER MAY | READY | MAY BILL | BILL YOU | PAID)((.|\\n)*))(( \\d+)(\\.+|-+)(\\d\\d))"
            
            // our goal is capture group 3, "h" in "ha"
            let regex = try! NSRegularExpression(pattern: regexp)
            let result = regex.matches(in:tesseract.recognizedText, range:NSMakeRange(0, tesseract.recognizedText.utf16.count))
            if result.count != 0 {
                let capture_group = result[0].rangeAt(4)
                print(capture_group)
            }
            
            
            // check if some substring is in the recognized text
            print("Trying to recognize text")
//            if let range = tesseract.recognizedText.range(of:regexp, options: .regularExpression) {
//                let result = tesseract.recognizedText.substring(with:range)
//                print()
//
//            }
            
            
            // Instantiate the Table View Controller that the info will be on
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dvc") as! ResultsVC
            
            detailVC.view.backgroundColor = UIColor.white
            
//            detailVC.view.translatesAutoresizingMaskIntoConstraints = false
//            detailVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
//            detailVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -49).isActive = true
//            detailVC.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//            detailVC.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            
            /*
            let main_string1 = "You may be billed for $26.09.\n(If you already paid $26.09 coinsurance, you owe nothing.)\n\nOn 01/19/2017, you visited Dr. Felix Gonzalez for MRI/MRA-Extremity services.  MRI/MRA-Extremity deals with imaging and scanning various limbs of the body.\n\n"
            let string_to_color1 = "You may be billed for $26.09."
            let string_to_color2 = "(If you already paid $26.09 coinsurance, you owe nothing.)"
            let rest_of_string1 = "On 01/19/2017, you visited Dr. Felix Gonzalez for MRI/MRA-Extremity services.  MRI/MRA-Extremity deals with imaging and scanning various limbs of the body."
            */
            
            let main_string1 = "You may be billed for $93.29.\n(If you already paid a $30.00 copay/coinsurance, you only owe $63.29.)\n\nOn 12/06/2016, you visited Dr. Scott Lampert for ophthalmology services.  Ophthalmology deals with eye diseases, surgery, and treatments.\n\n"
            let string_to_color1 = "You may be billed for $93.29."
            let string_to_color2 = "(If you already paid a $30.00 copay/coinsurance, you only owe $63.29.)"
            
            let rest_of_string1 = "On 12/06/2016, you visited Dr. Scott Lampert for ophthalmology services.  Ophthalmology deals with eye diseases, surgery, and treatments."
            
            
            let range1 = (main_string1 as NSString).range(of: string_to_color1)
            let range2 = (main_string1 as NSString).range(of: string_to_color2)
            let range3 = (main_string1 as NSString).range(of: rest_of_string1)
            
            
            let image1Attachment = NSTextAttachment()
            
            
            image1Attachment.image = self.resizeImage(image: #imageLiteral(resourceName: "payment_vis_2"), targetSize: CGSize(width: 300, height: 300))
            let image1String = NSAttributedString(attachment: image1Attachment)
            
            var attributedString = NSMutableAttributedString(string: main_string1)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range1)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: range1)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range2)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: range2)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: range3)
            attributedString.append(image1String)
            
            detailVC.contentParagraphs.append(attributedString)
            
//            let main_string2 = "CPT 73221 - Magnetic resonance (eg, proton) imaging, any joint of upper extremity; without contrast material(s)"
            let main_string2 = "CPT 92014 - Ophthalmological services: medical examination and evaluation\n\nCPT 92134 - Retina scanning computerized ophthalmic diagnostic imaging, posterior segment"
            
            attributedString = NSMutableAttributedString(string: main_string2)
            let range5 = (main_string2 as NSString).range(of: main_string2)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: range5)
            
            
            
            detailVC.contentParagraphs.append(attributedString)
            
            
            
            let main_string4 = "Is there a charge that doesn’t look right?\n\nCall BlueCross BlueShield directly (it is open now) : 800-579-8022, option 1.\n\nYour claim number is: 2017045CG7444."
            let string_to_color4 = "it is open now"
            let range4 = (main_string4 as NSString).range(of: string_to_color4)
            let main_range4 = (main_string4 as NSString).range(of: main_string4)
            attributedString = NSMutableAttributedString(string: main_string4)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.27, green:0.70, blue:0.00, alpha:1.0) , range: range4)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: main_range4)
            detailVC.contentParagraphs.append(attributedString)
            
            
            
            // assign the detailViewController to the array of VCs in Recent Scans tab
            refRecentScans.detailVCArray.append(detailVC)
            
            refAbout.transferImg = tesseract.image
//            refAbout.transferImg2 = centerImage
            refAbout.transferText = tesseract.recognizedText
            print("processing done")
            
            processingDone = true;
            
        }
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func topLeftCrop(screenshot: UIImage) -> UIImage {
        print("top left crop")
        let finalImage : UIImage
        
        //let crop_section = CGRect(x: 590.0, y: 280.0, width: 950.0, height: 550.0)
        //let crop_section = CGRect(x: 270.0, y: 130.0, width: 485.0, height: 275.0)
        let crop_section = CGRect(x: 0, y: 0, width: screenshot.size.height, height: screenshot.size.width)
        
        let cg_image = screenshot.cgImage?.cropping(to: crop_section)
        finalImage = UIImage(cgImage: cg_image!)
        
        
        return finalImage
    }
    
    func topRightCrop(screenshot: UIImage) -> UIImage {
        let finalImage : UIImage
        
        let crop_section = CGRect(x: 1500.0, y: 280.0, width: 1850.0, height: 800.0)
        
        let cg_image = screenshot.cgImage?.cropping(to: crop_section)
        finalImage = UIImage(cgImage: cg_image!)
        
        
        return finalImage
    }
    
    func centerHorizCrop(screenshot: UIImage) -> UIImage {
        let finalImage : UIImage
        
        let crop_section = CGRect(x: 590.0, y: 900.0, width: 3300.0, height: 400.0)
        
        let cg_image = screenshot.cgImage?.cropping(to: crop_section)
        finalImage = UIImage(cgImage: cg_image!)
        
        
        return finalImage
    }

    
    
    
    func shutterButtonPressed() {
        
        let photoPixelFormatType = kCVPixelFormatType_32BGRA

        let rawPixType = session_output.availableRawPhotoPixelFormatTypes.first?.uint32Value
        
        // 24-bit only contains RGB components and the alpha channel is missing
        // using uncompressed format
        // if you want compressed format, you need to set "AVVideoCodecKey" with a
        // photo codec type ("png, jpg")
//        let settings = AVCapturePhotoSettings(rawPixelFormatType: rawPixType!, processedFormat: [kCVPixelBufferPixelFormatTypeKey as String : photoPixelFormatType])
        let settings = AVCapturePhotoSettings()
        
                        //format: [kCVPixelBufferPixelFormatTypeKey as String : photoPixelFormatType])
        
        // thumbnail
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160,
                             ]
        settings.previewPhotoFormat = previewFormat
        
        
        flashScreen()
        
        // get the actual video feed and take a photo from that feed
        session_output.capturePhoto(with: settings, delegate: self)
        

    }
    
    func flashScreen() {
        
        // check if there is a view and then set the bounds of the view to the flash view
        if let wnd = self.view{
            
            let v = UIView(frame: wnd.bounds)
            v.backgroundColor = UIColor.white
            v.alpha = 1
            
            wnd.addSubview(v)
            
            // first set the animation duration at 1 second
            // after that start the animation by setting the alpha to 0
            // after the animation is done, remove the view from its superview.
            UIView.animate(withDuration: 0.7, animations: { v.alpha = 0.0 }, completion: {
                (finished : Bool) in v.removeFromSuperview()
            })
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
 
    
//    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingRawPhotoSampleBuffer rawSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//        
//        guard let rawSampleButtfer = rawSampleBuffer else { return }
//        
//        if let dataImage = AVCapturePhotoOutput.dngPhotoDataRepresentation(forRawSampleBuffer: rawSampleButtfer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
//        
//                // this is the image that the user has taken!
//                let takenImage : UIImage = UIImage(data: dataImage)!
//        
//                // assign the image to the stillPicture to be displayed on the screen
//                stillPicture?.image = takenImage
//            
//                // remove the shutter button
//                shutterButton.isHidden = true
//                shutterButton.isEnabled = false
//            
//                // show the "X" button, hide the back button
//                deleteButton.isEnabled = true
//                deleteButton.isHidden = false
//                backButton.isEnabled = false
//                backButton.isHidden = true
//        
//                // show the "Use this photo" button
//                processButton.isEnabled = true
//                processButton.isHidden = false
//        } else {
//            print("Error setting up photo capture")
//        }
    
        
        func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer sampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        
        // take the session output, get the buffer, and create an image from that buffer
        if let sampleBuffer = sampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer){
            
            // this is the image that the user has taken!
            let takenImage : UIImage = UIImage(data: dataImage)!
            
            // assign the image to the stillPicture to be displayed on the screen
            stillPicture?.image = takenImage
            
            // remove the shutter button
            shutterButton.isHidden = true
            shutterButton.isEnabled = false
            
            // show the "X" button, hide the back button
            deleteButton.isEnabled = true
            deleteButton.isHidden = false
            backButton.isEnabled = false
            backButton.isHidden = true
            
            // show the "Use this photo" button
            processButton.isEnabled = true
            processButton.isHidden = false
            
        } else {
            print("Error setting up photo capture")
        }

    }

    
    //func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

 
        
//    }
}
