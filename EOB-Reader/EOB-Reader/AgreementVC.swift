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

    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
