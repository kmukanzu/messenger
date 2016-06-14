//
//  deleteAccount.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/11/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class deleteAccount : UITableViewController {
    
    @IBOutlet weak var passwordIcon: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordIcon.image = UIImage(named: "lock.png")
        
    }
}