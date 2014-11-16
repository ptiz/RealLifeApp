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
    
    var currentFeed:Feed?
    
    func updateData(feed:Feed) {
        
        self.nameLabel.text = feed.name
        self.descriptionLabel.text = feed.theDescription
            
        self.currentFeed = feed
        self.table.reloadData()
    }

    // MARK: - table
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// ==
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = currentFeed?.entries.count {
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
        
        if let entry = self.currentFeed?.entries[indexPath.row] as? Entity {
            if let from = entry.from? {
                if let via = entry.via? {
                    cell?.textLabel.text = "\(from.name) via \(via.name)"
                } else {
                    cell?.textLabel.text = "\(from.name)"
                }
            }
            cell?.detailTextLabel?.text = entry.body?
        }
        
        return cell!
    }
    
}

