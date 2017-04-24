//
//  ResultsCellTableViewCell.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 3/5/17.
//  Copyright © 2017 Samuel Cheng. All rights reserved.
//

import UIKit

class ResultsCell: UITableViewCell {

    var mytvc : ResultsVC?
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var introPara : UITextView!
    @IBOutlet weak var section_heading : UILabel!
    @IBOutlet weak var arrowImageView : UIImageView!
    @IBOutlet weak var pieChart : UIImageView!
    
    class var expandedHeight : CGFloat { get { return 420.0 } }
    class var defaultHeight : CGFloat { get { return 44.0 } }
    
    var frameAdded = false
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        section_heading.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func checkHeight() {
        introPara.isHidden = (frame.size.height < ResultsCell.expandedHeight)
    }

    func watchFrameChanges() {
        if(!frameAdded) {
            addObserver(self, forKeyPath: "frame", options: .new, context: nil)
            checkHeight()
        }
    }
    
    func ignoreFrameChanges() {
        if(frameAdded){
            removeObserver(self, forKeyPath: "frame")
        }
    }
    
    deinit {
        print("deinit called");
        ignoreFrameChanges()
    }
    
    // when our frame changes, check if the frame height is appropriate and make it smaller or bigger depending
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
}
