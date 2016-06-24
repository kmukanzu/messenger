//
//  CreateAccount.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/31/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class CreateAccount : UITableViewController {
    
    //var firebase = FIRDatabase.database().reference()
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    
    
    
    var backendless = Backendless.sharedInstance()
    
    var newUser: BackendlessUser?
    var currentUser: BackendlessUser?
    
    var email: String?
    var fullName: String?
    var password: String?
    var universityID: String?
    var universityName: String?
    var avatarImage: UIImage?
    
    var userEmail = String()
    var userFullName = String()
    var userPassword = String()
    var userUniversityName = String()
    var userUniversityID = String()
    var userName = String()
    
    var emailVerificationAlert : UIAlertController?
    var signInAlert : UIAlertController?
    var resetPasswordAlert : UIAlertController?
    var passwordReset : UIAlertController?
    var passwordHasReset : UIAlertController?
    var signUpError : UIAlertController?
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func signInAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("createToSignIn", sender: self)
    }
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountOutlet: UIButton!
    
    @IBAction func termsPrivacyAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("createAccountToTerms", sender: self)
    }
    @IBAction func createAccountAction(sender: AnyObject) {
        
        self.view.userInteractionEnabled = false
        createAccountOutlet.enabled = false
        
        if emailTextField.text != "" && fullNameTextField.text != "" && passwordTextField.text != "" && emailTextField.text?.characters.indexOf("@") != nil && emailTextField.text!.characters.indexOf(".") != nil && emailTextField.text?.rangeOfString(".com") == nil && emailTextField.text?.rangeOfString(".net") == nil{
            
            self.activityIndicator.startAnimating()
            
            self.email = emailTextField.text
            self.fullName = fullNameTextField.text
            self.password = passwordTextField.text
            
            self.userEmail = emailTextField.text!
            self.userFullName = fullNameTextField.text!
            
            let university = self.getMainPart2(emailTextField.text!)
            let dotEdu = self.getMainPart1(emailTextField.text!)
            self.userUniversityID = university + dotEdu
            
            self.register(self.email!, fullName: self.fullName!, password: self.password!, universityID: self.userUniversityID, avatarImage: self.avatarImage)
            
        } else {
            
            self.presentViewController(signUpError!, animated: true, completion: nil)
            
        }
        
    }
    
    func getMainPart2(s: String) -> String {
        var v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        v?.removeLast()
        
        return (v!.last)!
    }
    
    func getMainPart1(s: String) -> String {
        let v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        
        return (v!.last)!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "goToSignedUp" {
            let signInVC = segue.destinationViewController as! signedUp
        
            signInVC.usersEmail = email!
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
            backendless.userService.setStayLoggedIn(true)
            
            currentUser = backendless.userService.currentUser
            
            if currentUser != nil {
                
                self.performSegueWithIdentifier("goToMessages", sender: self)
                
            } else {
        
        self.fullNameTextField.becomeFirstResponder()
                
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileIcon.image = UIImage(named: "profile.png")
        self.emailIcon.image = UIImage(named: "email.png")
        self.passwordIcon.image = UIImage(named: "lock.png")
        
        newUser = BackendlessUser()
        
        passwordTextField.secureTextEntry = true
        fullNameTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.autocorrectionType = .No
        
        signUpError = UIAlertController(title: "Sign up Error!", message: "Sign up using your university email address", preferredStyle: .Alert)
        let button = UIAlertAction(title: "Try again", style: .Cancel) { (action) -> Void in
            print("Ok button was pressed")
            //self.presentViewController(self.newAccountAlert!, animated: true, completion: nil)
            
            self.view.userInteractionEnabled = true
            self.createAccountOutlet.enabled = true
        }
        signUpError?.addAction(button)
        
        let activityInd =  UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let barButton = UIBarButtonItem(customView: activityInd)
        self.navigationItem.setLeftBarButtonItem(barButton, animated: true)
        activityInd.color = UIColor.lightGrayColor()
        
        self.activityIndicator = activityInd
        
    }
    
    func register(email: String, fullName: String, password: String, universityID: String, avatarImage: UIImage?){
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        if avatarImage == nil {
            newUser?.setProperty("Avatar", object: "")
            
        }
        newUser?.setProperty("universityID", object: universityID)
        newUser?.email = email
        newUser?.name = fullName
        newUser?.password = password
        
        backendless.userService.registering(newUser, response: { (registeredUser : BackendlessUser!) -> Void in
            
            self.performSegueWithIdentifier("goToSignedUp", sender: self)
            
            }) { (fault : Fault!) -> Void in
                print("\(fault)")
                
                self.activityIndicator.stopAnimating()
                self.presentViewController(self.signUpError!, animated: true, completion: nil)
                
        }
    }
}