//
//  redVC.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 3/2/17.
//  Copyright © 2017 Samuel Cheng. All rights reserved.
//

import UIKit

class redVC: UIViewController {

    @IBOutlet weak var piechart : UIImageView!
    
    var refRecentScans : RecentScansVC!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    @IBAction func backButton() {
        print("going back")
        presentingViewController?.dismiss(animated: true, completion: nil)

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
    
    
    @IBAction func processingTest() {
        

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
        
//        DispatchQueue.global(qos: .background).async {
//            print("Processing")
//            self.doProcessing()
//        }
        
//        if let viewController = presentingViewController {
//            // This block will dismiss both current and a view controller presenting current
//            viewController.dismiss(animated: true, completion: nil)
//        }
//        else {
//            // This block will dismiss only current view controller
//            self.dismiss(animated: true, completion: nil)
//        }

    }
    
    func doProcessing() {
        
        // Instantiate the Table View Controller that the info will be on
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dvc") as! ResultsVC
        
        detailVC.view.backgroundColor = UIColor.white
        
        
        let main_string1 = "You may be billed for $93.29.\n(If you already paid a $30.00 copay/coinsurance, you only owe $63.29.)\n\nOn 12/06/2016, you visited Dr. Scott Lampert for ophthalmology services.  Ophthalmology deals with eye diseases, surgery, and treatments."
        let string_to_color1 = "You may be billed for $93.29."
        let string_to_color2 = "(If you already paid a $30.00 copay/coinsurance, you only owe $63.29.)"
        
        let rest_of_string1 = "On 12/06/2016, you visited Dr. Scott Lampert for ophthalmology services.  Ophthalmology deals with eye diseases, surgery, and treatments.\n\n\n"
        let range1 = (main_string1 as NSString).range(of: string_to_color1)
        let range2 = (main_string1 as NSString).range(of: string_to_color2)
        let range3 = (main_string1 as NSString).range(of: rest_of_string1)
        
        
        let image1Attachment = NSTextAttachment()
        
        
        image1Attachment.image = self.resizeImage(image: #imageLiteral(resourceName: "payment_vis"), targetSize: CGSize(width: 300, height: 300))
        let image1String = NSAttributedString(attachment: image1Attachment)

        var attributedString = NSMutableAttributedString(string: main_string1)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range1)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: range1)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range2)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: range2)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: range3)
        attributedString.append(image1String)

        detailVC.contentParagraphs.append(attributedString)
        
        let main_string2 = "CPT 92014 - Ophthalmological services: medical examination and evaluation\n\nCPT 92134 - Retina scanning computerized ophthalmic diagnostic imaging, posterior segment"
    
        attributedString = NSMutableAttributedString(string: main_string2)
        let range5 = (main_string2 as NSString).range(of: main_string2)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: range5)
        
        detailVC.contentParagraphs.append(attributedString)
        

        
        let main_string4 = "Is there a charge that doesn’t look right?\n\nCall BlueCross BlueShield directly (it is open now) : 800-579-8022, option 1.\n\nYour claim number is: 2016343BK6056."
        let string_to_color4 = "it is open now"
        let range4 = (main_string4 as NSString).range(of: string_to_color4)
        let main_range4 = (main_string4 as NSString).range(of: main_string4)
        attributedString = NSMutableAttributedString(string: main_string4)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.27, green:0.70, blue:0.00, alpha:1.0) , range: range4)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: main_range4)
        detailVC.contentParagraphs.append(attributedString)
        
        
        // REMOVE THIS WHEN YOU COPY IT BACK OVER
        refRecentScans.insertCell("Scan", thumbnail: UIImageView())

        // assign the detailViewController to the array of VCs in Recent Scans tab
        refRecentScans.detailVCArray.append(detailVC)
        
        print("Done processing")


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
    
    func sFunc_imageFixOrientation(img:UIImage) -> UIImage {
        
        
        // No-op if the orientation is already correct
        if (img.imageOrientation == UIImageOrientation.up) {
            print("it's fine...")
            return img;
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransform.identity
        
        if (img.imageOrientation == UIImageOrientation.left
            || img.imageOrientation == UIImageOrientation.leftMirrored) {
            print("it's left")
            transform = transform.translatedBy(x: img.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        }
        
        if (img.imageOrientation == UIImageOrientation.right
            || img.imageOrientation == UIImageOrientation.rightMirrored) {
            print("it's right")
            transform = transform.translatedBy(x: 0, y: img.size.height);
            transform = transform.rotated(by: CGFloat(-M_PI_2));
        }
        
        if (img.imageOrientation == UIImageOrientation.leftMirrored
            || img.imageOrientation == UIImageOrientation.rightMirrored) {
            print("right mirrored")
            transform = transform.translatedBy(x: img.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx:CGContext = CGContext(data: nil, width: Int(img.size.width), height: Int(img.size.height),
                                      bitsPerComponent: img.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: img.cgImage!.colorSpace!,
                                      bitmapInfo: img.cgImage!.bitmapInfo.rawValue)!
        
        ctx.concatenate(transform)
        
        print(img.imageOrientation)
        
        if (img.imageOrientation == UIImageOrientation.left
            || img.imageOrientation == UIImageOrientation.leftMirrored
            || img.imageOrientation == UIImageOrientation.right
            || img.imageOrientation == UIImageOrientation.rightMirrored
            ) {
            
            print("in here")
            ctx.draw(img.cgImage!, in: CGRect(x:0,y:0,width:img.size.height,height:img.size.width))
            
        } else {
            print("in here 2")
            ctx.draw(img.cgImage!, in: CGRect(x:0,y:0,width:img.size.width,height:img.size.height))
        }
        
        
        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)
        
        print("H: " + imgEnd.size.height.description)
        print("W: " + imgEnd.size.width.description)
        
        return imgEnd
    }


}
