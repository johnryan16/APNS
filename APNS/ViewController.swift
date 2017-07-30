//
//  ViewController.swift
//  APNS
//
//  Created by John Ryan on 7/23/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class ViewController: UIViewController {

   
    @IBOutlet weak var signingInSelector: UISegmentedControl!
    @IBOutlet weak var signingInLabel: UILabel!
    @IBOutlet weak var emailsTextField: UITextField!
    @IBOutlet weak var passwordsTextField: UITextField!
    @IBOutlet weak var signingInButton: UIButton!
    
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signingInSelectorChanged(_ sender:  UISegmentedControl) {
        
        //flip the bool
        isSignIn = !isSignIn
        
        // check the book & Set sign in & labels
        if  isSignIn {
            signingInLabel.text = "Sign In"
            signingInButton.setTitle("Sign In", for: .normal)
        } else {
            signingInLabel.text = "Register"
            signingInButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func signingInButtonTapped(_ sender: UIButton) {
    
        //TODO: Do some form validation first
        
        if let email = emailsTextField.text, let pass = passwordsTextField.text {
          //Check if sign in or register
            if isSignIn {
                //sign in user with firebase
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    // check that user isn't nil
                    if let u = user {
                        //user found, go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    } else {
                        //Error: Check error & show message
                    }
                })
                
            } else {
                //register user with firebase
                
                Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                    if let u = user {
                        //User found, go to homescreen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    } else {
                        //Error: Check error, show message
                    }
                })
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       //Dismiss keyboard when view is tapped on
        emailsTextField.resignFirstResponder()
        passwordsTextField.resignFirstResponder()
    }

}     // last brace of ViewController class

