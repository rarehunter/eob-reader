//
//  FirstViewController.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 12/30/16.
//  Copyright © 2016 Samuel Cheng. All rights reserved.
//

import UIKit

class RecentScansVC: UITableViewController {
    
    var items = [String]() // array of Table Cell titles
    var thumbnail_array = [UIImageView]() // array of thumbnails
    var detailVCArray = [UIViewController]() // array of view controllers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // register a cell to return
        tableView.register(ScanCell.self, forCellReuseIdentifier: "cellID")
        
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
        let scancell = tableView.dequeueReusableCell(withIdentifier: "scanCellTemplate", for: indexPath) as! ScanCell
        scancell.scanNameLabel.text = items[indexPath.row]
        scancell.thumbImageView.image = thumbnail_array[indexPath.row].image
        scancell.mytvc = self
        return scancell
    }
    
    // called when a cell is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let newChildVC = detailVCArray[indexPath.row]
        self.navigationController?.pushViewController(newChildVC, animated: true)
    }
    
    func insertCell(_ scanTitle : String, thumbnail : UIImageView) {
        items.append(scanTitle)
        thumbnail_array.append(thumbnail)
        tableView.reloadData()
    }
    
    // code to delete scan items
    func deleteCell(cell: UITableViewCell) {
        
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            items.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
            
            // don't forget to delete the new VC
            detailVCArray.remove(at: deletionIndexPath.row)
        }
        
    }
    
    // when the thumbnail image is tapped, it opens up to full screen 
    // and when that image is tapped, it goes back to thumbnail
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
        
    // code to display empty data label when there are no cell items
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // if there are scans to display...
        if items.count > 0 {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return 1
        }
        else { // otherwise, return 0, remove cell lines, and display a Label
            let rect = CGRect(x: 0,
                              y: 0,
                              width: tableView.bounds.size.width,
                              height: tableView.bounds.size.height)
            let noScanLabel: UILabel = UILabel(frame: rect)
            
            noScanLabel.text = "No Scans"
            noScanLabel.textColor = UIColor.gray
            noScanLabel.font = UIFont.boldSystemFont(ofSize: 24)
            noScanLabel.numberOfLines = 0
            noScanLabel.textAlignment = NSTextAlignment.center
            
            tableView.backgroundView = noScanLabel
            
            let subTitleLabel : UILabel = UILabel(frame: rect)
            subTitleLabel.frame.origin.y = 150
            subTitleLabel.text = "Start a scan below"
            subTitleLabel.textColor = UIColor.gray
            subTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            subTitleLabel.numberOfLines = 0
            subTitleLabel.textAlignment = NSTextAlignment.center

            let downArrowImage : UIImageView = UIImageView(image: #imageLiteral(resourceName: "down_arrow"))
            downArrowImage.frame.origin.y = UIScreen.main.bounds.height - self.tabBarController!.tabBar.frame.size.height - 90
            downArrowImage.frame.origin.x = UIScreen.main.bounds.width / 2 - 13
            downArrowImage.contentMode = .scaleAspectFit
            

            tableView.backgroundView?.addSubview(subTitleLabel)
            tableView.backgroundView?.addSubview(downArrowImage)
            
            tableView.separatorStyle = .none

            return 0
        }
    }
    

    
    // these next two functions are to handle the "swipe-left-delete" functionality
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            print("count: " + String(detailVCArray.count))
            print("Row " + String(indexPath.row))
            
            items.remove(at: indexPath.row)
            print("1")
            tableView.deleteRows(at: [indexPath], with: .automatic)
            print("2")
            tableView.reloadData()

            // don't forget to delete the new VC
            detailVCArray.remove(at: indexPath.row)
            
            print("count: " + String(detailVCArray.count))

        }
    }
}






