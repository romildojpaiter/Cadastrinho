//
//  ViewController.swift
//  Cadastrinho-SearchBar
//
//  Created by Danilo Altheman on 25/06/15.
//  Copyright © 2015 Quaddro - Danilo Altheman. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    let database = QSQLite3(path: NSHomeDirectory() + "/Documents/people.sqlite")
    
    var records: [[String: AnyObject]] = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "update", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath: NSIndexPath = sender as! NSIndexPath
        print(segue.destinationViewController)
        let controller = segue.destinationViewController as! UpdateViewController
        
        controller.id = records[indexPath.row]["id"] as! Int
        controller.name = records[indexPath.row]["name"] as! String
        controller.email = records[indexPath.row]["email"] as! String
        controller.phone = records[indexPath.row]["phone"] as! String
    }

    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = records[indexPath.row]["name"] as? String
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let id =  records[indexPath.row]["id"] as! Int
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let query = "delete from people where id = \(id)"
            database.exec(query)
            update()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("Update", sender: indexPath)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let query = String(format: "select * from people where name like '%%%@%%'", arguments: [searchText])
        print("\(query)")
        records = database.query(query)
        tableView.reloadData()
    }
    
    // MARK: - Custom Methods
    func update() {
        let query = "select * from people"
        records = database.query(query)
        self.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    @IBAction func edit(sender: UIBarButtonItem) {
        if tableView.editing {
            tableView.setEditing(false, animated: true)
            sender.tintColor = UIColor.blueColor()
        }
        else {
            tableView.setEditing(true, animated: true)
            sender.tintColor = UIColor.redColor()
        }
    }
    
}

