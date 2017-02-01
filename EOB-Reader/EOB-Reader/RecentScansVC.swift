//
//  FirstViewController.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 12/30/16.
//  Copyright © 2016 Samuel Cheng. All rights reserved.
//

import UIKit

class RecentScansVC: UITableViewController {
    
    var items = ["Item 1", "Item 2", "Item 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // register a cell to return
        tableView.register(ScanCell.self, forCellReuseIdentifier: "cellID")
        
        // commented out code for an "Insert-cells" button
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Insert", style: .plain, target: self, action: #selector(RecentScansVC.insertCell))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // return the actual view for the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scancell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! ScanCell
        scancell.nameLabel.text = items[indexPath.row]
        scancell.mytvc = self
        return scancell
    }
    
    func insertCell(_ scanTitle : String) {
        items.append(scanTitle)
        tableView.reloadData()
    }
    
    // code to delete scan items
    func deleteCell(cell: UITableViewCell) {
        
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            items.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
        
    }
}

// custom class for each cell containing scan results
class ScanCell: UITableViewCell {
    
    var mytvc : RecentScansVC?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Sample Item"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(ScanCell.handleAction), for: .touchUpInside)
        
        // specify constraints with Auto Layout system
        // span the left edge to the right edge with v0 where v0 is nameLabel
        // push the label 16 px from the left edge
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[label]-8-[button(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["label" : nameLabel, "button" : actionButton]))
        
        // specify vertical constraints
        addConstraint(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[label]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["label" : nameLabel])[0])
        
        addConstraint(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[button]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["button" : actionButton])[0])


    }
    
    func handleAction() {
        mytvc?.deleteCell(cell: self)
    }
}







