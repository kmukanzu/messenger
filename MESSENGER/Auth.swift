//
//  auth.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 3/30/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.

import Foundation
import Firebase
import FirebaseDatabase
//
class auth : UIViewController {
    
    var firebase = FIRDatabase.database().reference()
    
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
    
    var alertController : UIAlertController?
    var newAccountAlert : UIAlertController?
    var emailVerificationAlert : UIAlertController?
    var signInAlert : UIAlertController?
    var resetPasswordAlert : UIAlertController?
    var passwordReset : UIAlertController?
    var passwordHasReset : UIAlertController?
    var signInError : UIAlertController?
    var signUpError : UIAlertController?
    
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
        
        newUser = BackendlessUser()
        
        signUpError = UIAlertController(title: "Sign up Error!", message: "Sign up using your university email address", preferredStyle: .Alert)
        let button = UIAlertAction(title: "Try again", style: .Cancel) { (action) -> Void in
            print("Ok button was pressed")
            self.presentViewController(self.newAccountAlert!, animated: true, completion: nil)
        }
        signUpError?.addAction(button)
        
        signInError = UIAlertController(title: "Sign in Error!", message: "Please check your credentials.", preferredStyle: .Alert)
        let okbutton = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            print("Ok button was pressed")
            self.presentViewController(self.signInAlert!, animated: true, completion: nil)
        }
        signInError?.addAction(okbutton)
        
        
        passwordHasReset = UIAlertController(title: "Password Reset Successful", message: "We've emailed you a temporary password.", preferredStyle: .Alert)
        let dismiss = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            print("Ok button was pressed")
            
            self.presentViewController(self.signInAlert!, animated: true, completion: nil)
            
        }
        passwordHasReset?.addAction(dismiss)
        
        passwordReset = UIAlertController(title: "Email", message: "Forgot your password? We'll email you a temporary password.", preferredStyle: .Alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print("Cancel button was pressed")
            self.presentViewController(self.signInAlert!, animated: true, completion: nil)
        }
        passwordReset?.addAction(cancelButton)
        
        passwordReset?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Email"
            textfield.text = ""
        })
        
        let alertActionForTextFieldss = UIAlertAction(title: "Reset", style: .Default) { (action) -> Void in
            print("Reset button was pressed")
            self.presentViewController(self.passwordHasReset!, animated: true, completion: nil)
            
            if let textFields = self.passwordReset?.textFields {
                let theTextFields = textFields as [UITextField]
                let emailTextField = theTextFields[0].text
                print("\(emailTextField)")
            }
        }
        
        passwordReset?.addAction(alertActionForTextFieldss)
        
        signInAlert = UIAlertController(title: "Sign in", message: "Please enter your email and password.", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Reset Password", style: .Default) { (action) -> Void in
            print("Reset password button was pressed")
            self.presentViewController(self.passwordReset!, animated: true, completion: nil)
            
        }
        signInAlert?.addAction(cancel)
        
        signInAlert?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Email"
            textfield.text = ""
        })
        
        signInAlert?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Password"
            textfield.text = ""
            textfield.secureTextEntry = true
        })
        
        let alertActionForTextFields = UIAlertAction(title: "Sign in", style: .Default) { (action) -> Void in
            
            if let textFields = self.signInAlert?.textFields {
                let theTextFields = textFields as [UITextField]
                let emailTextField = theTextFields[0].text
                print("\(emailTextField)")
                
                let passwordTextField = theTextFields[1].text
                print("\(passwordTextField)")
                
                if emailTextField != "" && passwordTextField != "" && emailTextField?.characters.indexOf("@") != nil && emailTextField?.characters.indexOf(".") != nil && emailTextField?.rangeOfString(".com") == nil && self.userName.rangeOfString(".") == nil {
                    
                    let university = self.getMainPart2(emailTextField!)
                    let dotEdu = self.getMainPart1(emailTextField!)
                    self.userUniversityID = university + dotEdu
                    
                    self.loginUser(emailTextField!, password: passwordTextField!)
                    
                } else {
                    
                    
                    
                    self.presentViewController(self.signInError!, animated: true, completion: nil)
                }
            }
        }
        
        signInAlert?.addAction(alertActionForTextFields)
        
        emailVerificationAlert = UIAlertController(title: "Email Verification", message: "We've sent you a confirmation email. Check your email and then proceed to Sign in.", preferredStyle: .Alert)
        let done = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            print("OK button was pressed")
            self.presentViewController(self.signInAlert!, animated: true, completion: nil)
        }
        
        emailVerificationAlert?.addAction(done)
        
        newAccountAlert = UIAlertController(title: "Sign up", message: "By tapping 'Sign up' you are agreeing to our terms & privacy policy.", preferredStyle: .Alert)
        
        let terms = UIAlertAction(title: "Terms & Privacy", style: .Default) { (action:UIAlertAction!) -> Void in
            print("terms button was pressed")
            
            //self.performSegueWithIdentifier("goToTerms", sender: self)
            
        }
        
        newAccountAlert?.addAction(terms)
        
        newAccountAlert?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Full Name"
            textfield.autocapitalizationType = UITextAutocapitalizationType.Words
            textfield.text = ""
        })
        
        newAccountAlert?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "University Email"
            textfield.text = ""
            
        })
        
        newAccountAlert?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Password"
            textfield.text = ""
            textfield.secureTextEntry = true
            
        })
        
        let alertActionForTextField = UIAlertAction(title: "Sign up", style: .Default) { (action) -> Void in
            
            //self.presentViewController(self.emailVerificationAlert!, animated: true, completion: nil)
            
            if let textFields = self.newAccountAlert?.textFields {
                let theTextFields = textFields as [UITextField]
                
                let fullNameTextField = theTextFields[0].text
                print("\(fullNameTextField)")
                
                let emailTextField = theTextFields[1].text
                print("\(emailTextField)")
                
                let passwordTextField = theTextFields[2].text
                print("\(passwordTextField)")
                
                let userPassword = passwordTextField
                
                if let range = emailTextField!.rangeOfString("@") {
                    
                    self.userName = emailTextField!.substringToIndex(range.startIndex)
                    print(self.userName)
                    
                }
                
                if fullNameTextField != "" && emailTextField != "" && passwordTextField != "" && emailTextField?.characters.indexOf("@") != nil && emailTextField?.characters.indexOf(".") != nil && emailTextField?.rangeOfString(".com") == nil {
                    
                    self.email = emailTextField
                    self.fullName = fullNameTextField
                    self.password = userPassword
                    
                    self.userEmail = emailTextField!
                    self.userFullName = fullNameTextField!
                    
                    let university = self.getMainPart2(emailTextField!)
                    let dotEdu = self.getMainPart1(emailTextField!)
                    self.userUniversityID = university + dotEdu
                    
                    self.resister(self.email!, fullName: self.fullName!, password: self.password!, universityID: self.userUniversityID ,avatarImage: self.avatarImage)
                    
                } else {
                    
                    self.presentViewController(self.signUpError!, animated: true, completion: nil)
                    
                }
            }
        }
        
        newAccountAlert?.addAction(alertActionForTextField)
        
        alertController = UIAlertController(title: "Hello", message: "What would you like to do?", preferredStyle: .Alert)
        
        let signInAction = UIAlertAction(title: "Sign in", style: .Default) { (action) -> Void in
            print("Sign in button was pressed")
            self.presentViewController(self.signInAlert!, animated: true, completion: nil)
        }
        let signUpAction = UIAlertAction(title: "Sign up", style: .Default) { (action) -> Void in
            print("Sign up button was pressed")
            
            self.presentViewController(self.newAccountAlert!, animated: true, completion: nil)
            
        }
        
        alertController?.addAction(signInAction)
        
        alertController?.addAction(signUpAction)
        
    }
    
    func resister(email: String, fullName: String, password: String, universityID: String, avatarImage: UIImage?){
        
        if avatarImage == nil {
            newUser?.setProperty("Avatar", object: "")
            
        }
        newUser?.setProperty("universityID", object: universityID)
        newUser?.email = email
        newUser?.name = fullName
        newUser?.password = password
        
        backendless.userService.registering(newUser, response: { (registeredUser : BackendlessUser!) -> Void in
            
            self.presentViewController(self.emailVerificationAlert!, animated: true, completion: nil)
            
            if let range = email.rangeOfString("@") {
            
            self.userName = email.substringToIndex(range.startIndex)
            print(self.userName)
            
            }
            self.firebase.child("Users").child(self.userUniversityID).child(self.userName).setValue(["fullName": self.userFullName, "userEmail" : self.userEmail])
            
            }) { (fault : Fault!) -> Void in
                print("\(fault)")
                
                self.presentViewController(self.signUpError!, animated: true, completion: nil)
        }
    }
    
    func loginUser (email: String, password: String){
        
        backendless.userService.login(email, password: password, response: { (user:BackendlessUser!) -> Void in
            
            self.performSegueWithIdentifier("goToMessages", sender: self)
            
            }) { (fault:Fault!) -> Void in
                print("\(fault)")
                
                self.presentViewController(self.signInError!, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        backendless.userService.setStayLoggedIn(true)
        
        currentUser = backendless.userService.currentUser
        
        if currentUser != nil {
            
            self.performSegueWithIdentifier("goToMessages", sender: self)
            
        } else {
            
            self.presentViewController(self.alertController!, animated: true, completion: nil)
        }
    }
}
