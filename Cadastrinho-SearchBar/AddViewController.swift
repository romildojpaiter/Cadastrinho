//
//  AddViewController.swift
//  Cadastrinho-SearchBar
//
//  Created by Danilo Altheman on 25/06/15.
//  Copyright © 2015 Quaddro - Danilo Altheman. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    let database = QSQLite3(path: NSHomeDirectory() + "/Documents/people.sqlite")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sql = "create table if not exists people (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, phone TEXT)"
        database.exec(sql)
        if !database.error.isEmpty {
            print(database.error)
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        let sql = String(format: "insert into people (name, email, phone) values ('%@', '%@', '%@')", arguments: [nameTextField.text!, emailTextField.text!, phoneTextField.text!])
        database.exec(sql)
        
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        
        if !database.error.isEmpty {
            let alert = UIAlertController(title: "Error", message: database.error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}
