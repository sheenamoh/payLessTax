//
//  ViewController.swift
//  PayLessTax
//
//  Created by Sheena Moh on 18/07/2016.
//  Copyright © 2016 SMoh. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: ReusableKeyboardViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTapped()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    @IBAction func onLoginBtnClicked(sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if let user = user {
                User.signIn(user.uid)
                self.performSegueWithIdentifier("LoginSegue", sender: sender)
                
            } else {
                let controller = UIAlertController(title: "Error", message: (error?.localizedDescription), preferredStyle: .Alert)
                let dismissBtn = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                controller.addAction(dismissBtn)
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func resetPassword(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Reset password", message: "Please fill in your email", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (cardOwnertextField) -> Void in
            cardOwnertextField.placeholder = "Email Address"
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let emailtextField = alert.textFields![0] as UITextField
            if self.emailTextField.text != nil{
                self.resetEmailPassword(emailtextField.text!)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(ACTION) -> Void in
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func resetEmailPassword(email:String){
        FIRAuth.auth()?.sendPasswordResetWithEmail(email) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let alertController = UIAlertController(title: "Success", message: "Reset password instructions had been send to \(email)", preferredStyle: .Alert)
    
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
                print("New password")
            }
        }
    }
    
    @IBAction func backToLogin (segue: UIStoryboardSegue) {
        
    }
    
}

