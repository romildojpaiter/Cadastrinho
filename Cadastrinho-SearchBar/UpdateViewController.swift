//
//  UpdateViewController.swift
//  Cadastrinho-SearchBar
//
//  Created by Danilo Altheman on 26/06/15.
//  Copyright © 2015 Quaddro - Danilo Altheman. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {
    var id: Int!
    var name: String!, email: String!, phone: String!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
        let database = QSQLite3(path: NSHomeDirectory() + "/Documents/people.sqlite")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = name
        emailTextField.text = email
        phoneTextField.text = phone
    }
    
    @IBAction func update(sender: AnyObject) {
        let sql = String(format: "update people set name = '%@', email = '%@', phone = '%@' where id = %i", arguments: [nameTextField.text!, emailTextField.text!, phoneTextField.text!, id])

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
