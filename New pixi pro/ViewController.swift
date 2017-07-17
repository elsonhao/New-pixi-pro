//
//  ViewController.swift
//  New pixi pro
//
//  Created by 黃毓皓 on 2017/7/15.
//  Copyright © 2017年 ice elson. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController,FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLogin()
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.center = view.center
        fbLoginButton.delegate = self
        self.view.addSubview(fbLoginButton)
    }
    
    func checkLogin() {
        if FBSDKAccessToken.current() != nil{
            self.performSegue(withIdentifier: "appSegue", sender: self)
        }else{
            print("loggin to facebook error")
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        checkLogin()
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

