//
//  AgreementVC.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 1/29/17.
//  Copyright © 2017 Samuel Cheng. All rights reserved.
//

import UIKit

class AgreementVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var agreementText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func agreeAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "tabmodvc")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()

    }

    @IBAction func disagreeAction(_ sender: Any) {
        
        // show the alert window
        let alertController = UIAlertController(title: "Cannot Proceed", message: "By not agreeing to the terms, you cannot continue using the EOB Reader application.", preferredStyle: .alert)
        
        let actionOK = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            //This is called when the user presses the OK button.
            print("You've pressed the OK button");
        }
        

        alertController.addAction(actionOK)
        
        //Present the alert controller
        self.present(alertController, animated: true, completion: nil)
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
