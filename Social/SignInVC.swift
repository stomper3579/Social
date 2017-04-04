//
//  ViewController.swift
//  Social
//
//  Created by Tyler Brady on 3/28/17.
//  Copyright © 2017 Tyler Brady. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper


class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("going straight to segue")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("unable to auth with FB - \(error)")
            }
            else if result?.isCancelled == true {
                print("user cancelled FB auth")
            }
            else {
                print("FB Auth Success")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
            
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("unable to auth with Firebase - \(error)")
            }
            else {
                print("successful auth with Firebase")
                if let user = user {
                    self.completeSignin(id: user.uid)
                }
            }
        })
    }
    
  
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if(error == nil) {
                    print("sign in with email successful")
                    if let user = user {
                        self.completeSignin(id: user.uid)
                    }
                }
                else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if(error != nil) {
                            print("Unable to email auth with firebase - \(error)")
                        } else {
                            print("created new email user with firebase")
                            if let user = user {
                                self.completeSignin(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    
    func completeSignin(id: String) {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("keychain result is: \(saveSuccessful)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}













