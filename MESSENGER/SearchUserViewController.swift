//
//  SearchUserViewController.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/2/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

protocol ChooseUserDelegate {
    
    func CreateChatroom(withUser: BackendlessUser)
}

class SearchUserViewController : UITableViewController, UISearchResultsUpdating {
    
    var users: [BackendlessUser] = []
    var filteredUsers : [BackendlessUser] = []
    
    var delegate: ChooseUserDelegate!
    
    var selectedUser = String()
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        loadUsers()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        self.filteredUsers = self.users.filter { (user: BackendlessUser) -> Bool in
          
            if user.name.lowercaseString.containsString(self.searchController.searchBar.text!.lowercaseString) {
            
                return true
                
            } else {
            
                return false
                
            }
            
        }
        
        self.resultsController.tableView.reloadData()
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
        
            return users.count
            
        } else {
            
            return self.filteredUsers.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if tableView == self.tableView {
            
            let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
            
        } else {
            
            let filteredUser = filteredUsers[indexPath.row]
            
            cell.textLabel?.text = filteredUser.name
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == self.tableView {

        let user = users[indexPath.row]
        
        delegate.CreateChatroom(user)
            
        } else {
            
            let filteredUser = filteredUsers[indexPath.row]
            delegate.CreateChatroom(filteredUser)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
        searchController.active = false
        //searchController.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
    }
    
    func loadUsers() {
        
        let whereClause = "objectId != '\(backendless.userService.currentUser.objectId)'"
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) -> Void in
            
            self.users = users.data as! [BackendlessUser]
            
            self.tableView.reloadData()
            
            
            }) { (fault : Fault!) -> Void in
                print("Error, couldnt retrive users: \(fault)")
        }
    }
}