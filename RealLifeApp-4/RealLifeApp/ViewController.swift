//
//  ViewController.swift
//  RealLifeApp
//
//  Created by Evgenii Kamyshanov on 09.11.14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var currentData:[AnyObject]?
    
    func updateHeader(header:(String?, String?)) {
        self.nameLabel.text = header.0
        self.descriptionLabel.text = header.1
    }
    
    func updateData(entries:[AnyObject]) {
        self.currentData = entries
        self.table.reloadData()
    }

    ///
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// ==
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = currentData?.count {
            return count;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
            
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        }
        
        if let entry = self.currentData?[indexPath.row] as? CEntry {
            if let from = entry.fromName {
                if let via = entry.viaName {
                    cell?.textLabel.text = "\(from) via \(via)"
                } else {
                    cell?.textLabel.text = "\(from)"
                }
            }
            cell?.detailTextLabel?.text = entry.body?
        }
        
        return cell!
    }
    
}

