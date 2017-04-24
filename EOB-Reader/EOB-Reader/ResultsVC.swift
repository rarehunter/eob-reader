//
//  ResultsVC.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 3/4/17.
//  Copyright © 2017 Samuel Cheng. All rights reserved.
//

import UIKit

class ResultsVC: UITableViewController {

//    @IBOutlet weak var introPara : UITextView!    
    
    var section_heading = [String]() // array of Table Cell section headings
    var selectedIndexPath : IndexPath?
    var contentParagraphs = [NSMutableAttributedString]() // array of content paragraphs
    
//    @IBOutlet weak var titleLabel : UILabel! // title label
    
    let eobTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.backgroundColor = UIColor(red:0.00, green:0.47, blue:0.76, alpha:1.0)
        label.text = "Scan Results"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var eobTitleConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.eobTitleLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.eobTitleLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.eobTitleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.eobTitleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register a cell to return
        tableView.register(ResultsCell.self, forCellReuseIdentifier: "cellID")
        
        // iOS 10 - 49 pts for tab bar, 64 points for nav bar
//        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(49, 0, 64, 0);        
//        self.tableView.contentInset = adjustForTabbarInsets;
//        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
        
        
//        self.edgesForExtendedLayout = []
//        self.extendedLayoutIncludesOpaqueBars = false
//        self.automaticallyAdjustsScrollViewInsets = false
    

        section_heading.append("Summary")
        section_heading.append("Services Performed")
        section_heading.append("Questions?")
        
        // this removes the extra empty cells in the table view
        tableView.tableFooterView = UIView()
        
        // make it so that the first cell is expanded
        selectedIndexPath = IndexPath(row: 0, section: 0)
    }
    
//    override func viewDidLayoutSubviews() {
//        tableView.frame = CGRect.init(x: 0,
//                                          y: 64,
//                                          width: UIScreen.main.bounds.width,
//                                          height: UIScreen.main.bounds.height - 113)
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section_heading.count
    }
    
    // return the actual view for the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultcell = tableView.dequeueReusableCell(withIdentifier: "resultCellTemplate", for: indexPath) as! ResultsCell
        resultcell.section_heading.text = section_heading[indexPath.row]

        resultcell.arrowImageView.image = #imageLiteral(resourceName: "forward_arrow")
        resultcell.introPara.attributedText = contentParagraphs[indexPath.row]
        
        resultcell.mytvc = self
        return resultcell
    }
    
    // when a cell is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        
        // the row is already selected, then we want to collapse the cell
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else { // otherwise, we expand that cell
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<IndexPath> = []
        
        // only add a previous one if it exists
        if let previous = previousIndexPath {
            indexPaths.append(previous)
        }
        if let current = selectedIndexPath {
            indexPaths.append(current)
        }
        
        // reload the specific rows
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! ResultsCell).watchFrameChanges()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! ResultsCell).ignoreFrameChanges()

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return ResultsCell.expandedHeight
            /*
            if selectedIndexPath?.row == 0 {
                print("0")
                return 420.0
            }
            else if selectedIndexPath?.row == 1 {
                print("1")
                return 200.0
            }
            else {
                print("other")
                return 300.0
            }
            */
        }
        else {
            return ResultsCell.defaultHeight
        }
    }
}
