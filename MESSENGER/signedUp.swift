//
//  signedUp.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/11/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class signedUp : UITableViewController {
    
    var firebase = FIRDatabase.database().reference()
    
    var backendless = Backendless.sharedInstance()
    
    var newUser: BackendlessUser?
    var currentUser: BackendlessUser?
    
    var activityIndicator = UIActivityIndicatorView()
    
    var email: String?
    var fullName: String?
    var password: String?
    var universityID: String?
    var universityName: String?
    var avatarImage: UIImage?
    
    var usersEmail = String()
    
    var signUpError : UIAlertController?
    var emailVerificationAlert : UIAlertController?
    
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFIeld: UITextField!
    
    @IBAction func signInButton(sender: AnyObject) {
        
        self.view.userInteractionEnabled = false
        
        if emailTextField != "" && passwordTextFIeld != "" && emailTextField.text!.characters.indexOf("@") != nil && emailTextField.text!.characters.indexOf(".") != nil && emailTextField.text!.rangeOfString(".com") == nil {
            
            self.email = emailTextField.text
            self.password = passwordTextFIeld.text
            
            self.activityIndicator.startAnimating()
            
            loginUser(email!, password: password!)
            
            //UIApplication.sharedApplication().registerForRemoteNotifications()
            
        } else {
            
            self.activityIndicator.stopAnimating()
            presentViewController(signUpError!, animated: true, completion: nil)
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.passwordTextFIeld .becomeFirstResponder()
        self.presentViewController(emailVerificationAlert!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailIcon.image = UIImage(named: "email.png")
        self.passwordIcon.image = UIImage(named: "lock.png")
        
        self.emailTextField.text = usersEmail
        
        self.navigationItem.hidesBackButton = true
        
        
        passwordTextFIeld.secureTextEntry = true
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.autocorrectionType = .No
        
        let activityInd =  UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let barButton = UIBarButtonItem(customView: activityInd)
        self.navigationItem.setLeftBarButtonItem(barButton, animated: true)
        activityInd.color = UIColor.lightGrayColor()
        
        self.activityIndicator = activityInd
        
        signUpError = UIAlertController(title: "Sign in Error!", message: "Sign up using your university email address", preferredStyle: .Alert)
        let button = UIAlertAction(title: "Try again", style: .Cancel) { (action) -> Void in
            
            self.view.userInteractionEnabled = true
            
        }
        signUpError?.addAction(button)
        
        emailVerificationAlert = UIAlertController(title: "Email Verification", message: "We've sent you a confirmation email. Check your email and then proceed to Sign in.", preferredStyle: .Alert)
        let done = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            print("OK button was pressed")
            
        }
        
        emailVerificationAlert?.addAction(done)
        
        
    }
    
    func loginUser (email: String, password: String) {
        
        backendless.userService.login(email, password: password, response: { (user:BackendlessUser!) -> Void in
            
            registerUserDeviceId()
            
            self.performSegueWithIdentifier("goToMessages", sender: self)
            
        }) { (fault:Fault!) -> Void in
            print("\(fault)")
            
            self.presentViewController(self.signUpError!, animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
        }
    }
}