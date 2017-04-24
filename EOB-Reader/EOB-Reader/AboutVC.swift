//
//  ResultsViewController.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 1/18/17.
//  Copyright © 2017 Samuel Cheng. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var tempImageShow : UIImageView!
    @IBOutlet weak var tempImageShow2 : UIImageView!
    
    @IBOutlet weak var tesseractDump : UITextView!
    
    var transferImg : UIImage? = nil
    var transferImg2 : UIImage? = nil
    var transferText : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        resultsTextField.isEditable = false
        tempImageShow.contentMode = UIViewContentMode.scaleAspectFit
        
        tempImageShow.image = transferImg
//        tempImageShow2.image = transferImg2
        tesseractDump.text = transferText
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if(result_data != nil) {
//            resultsTextField.text = result_data
//        }
//        else {
//            resultsTextField.text = ""
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func forwardButton() {
        let redvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "redVC") as! redVC
        
        let tempNavVC = self.tabBarController?.viewControllers![0] as! UINavigationController
        let scanVCRef = tempNavVC.viewControllers[0] as! RecentScansVC

        // pass tabbarcontroller to redVC somehow
        redvc.refRecentScans = scanVCRef
        
        self.present(redvc, animated: true, completion: nil)
    }
    
    @IBAction func testViewController() {
        let detailViewController = UIViewController()
        detailViewController.view.backgroundColor = UIColor.white
        detailViewController.edgesForExtendedLayout = [];

        let bcbs_blue : UIColor = UIColor(red:0.00, green:0.47, blue:0.76, alpha:1.0)

        let eobTitleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints =  false
            label.backgroundColor = bcbs_blue
            label.text = "Scan Results"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textColor = UIColor.white
            return label
        }()

        let eobTitleConstraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: eobTitleLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: eobTitleLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: eobTitleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: eobTitleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        ]

        detailViewController.view.addSubview(eobTitleLabel)
        detailViewController.view.addConstraints(eobTitleConstraints)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
