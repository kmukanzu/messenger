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
    
    var universityID = String()
    
    var users: [BackendlessUser] = []
    var filteredUsers : [BackendlessUser] = []
    
    var delegate: ChooseUserDelegate!
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    func getMainPart2(s: String) -> String {
        var v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        v?.removeLast()
        
        return (v!.last)!
    }
    
    func getMainPart1(s: String) -> String {
        let v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        
        return (v!.last)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        let email = backendless.userService.currentUser.email
        let university = self.getMainPart2(email)
        let dotEdu = self.getMainPart1(email)
        self.universityID = university + dotEdu
        
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
        searchController.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func loadUsers() {
        
        let whereClause = "objectId != '\(backendless.userService.currentUser.objectId)' AND UniversityID = '\(self.universityID)'"
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let queryOptions = QueryOptions()
        queryOptions.sortBy = ["name"]
        dataQuery.queryOptions = queryOptions
        
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) -> Void in
            
            self.users = users.data as! [BackendlessUser]
            
            self.tableView.reloadData()
            
            
            }) { (fault : Fault!) -> Void in
                print("Error, couldnt retrive users: \(fault)")
        }
    }
}