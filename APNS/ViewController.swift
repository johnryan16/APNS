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

    @IBOutlet weak var signInSelector: UISegmentedControl!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        
        //flip the bool
        isSignIn = !isSignIn
        
        // check the book & Set sign in & labels
        if  isSignIn {
            signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
        } else {
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
    
        //TODO: Do some form validation first
        
        if let email = emailTextField.text, let pass = passwordTextField.text {
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
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

}     // last brace of ViewController class

