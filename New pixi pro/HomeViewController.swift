//
//  HomeViewController.swift
//  New pixi pro
//
//  Created by 黃毓皓 on 2017/7/16.
//  Copyright © 2017年 ice elson. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Social

class HomeViewController: UIViewController,FBSDKLoginButtonDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let loginButton:FBSDKLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var profileImage: FBSDKProfilePictureView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageToShare: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        
        loginButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height - loginButton.frame.height)
        self.view.addSubview(loginButton)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        if FBSDKAccessToken.current() == nil{
            self.navigationController?.popViewController(animated: true)
        }else{
            displayName()
        }
    }
    
    func displayName(){
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,gender,first_name,last_name"])
        graphRequest.start { (graphConnectionRequest, result, error) in
            if error == nil{
                if let res = result as? [String:String]{
                  self.nameLabel.text = res["name"]
                }
                
            }else{
                print("error in fetch fb graph request")
            }
        }
    }
    
    @IBAction func sharePressed(_ sender: UIButton) {
        presentShare()
        
    }
    @IBAction func facebookPressed(_ sender: UIButton) {
        presentAlertController()
    }
    @IBAction func twitterPresssed(_ sender: UIButton) {
        presentAlertController()
    }
    
    func presentAlertController(){
        
        let alert = UIAlertController(title: "Media", message: "please choose the media", preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Camera", style: .default, handler:{ (alertAction) in
            print("camera is tapped")
        self.presentCamera()}
            
        )
        
        let galleryButton = UIAlertAction(title: "Gallery", style: .default, handler: { (alertAction) in
            print("gallery button is tapped")
            self.presentGallery()
        })
        
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel, handler: {(alertAction) in
        print("cancel button is tapped")})
        
        alert.addAction(cameraButton)
        alert.addAction(galleryButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func presentCamera(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePickerController.sourceType = .camera
        }else{
            let alert = UIAlertController(title: "error", message: "camera not available", preferredStyle: .alert)
            let button = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(button)
            present(alert, animated: true, completion: nil)
        }
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    func presentGallery(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePickerController.sourceType = .photoLibrary
        }else{
            let alert = UIAlertController(title: "error", message: "photo library not available", preferredStyle: .alert)
            let button = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(button)
            present(alert, animated: true, completion: nil)
        }
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if  let pickImage =  info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageToShare.image = pickImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    func presentShare(){
        if imageToShare.image == nil{
            let alert = UIAlertController(title: "error", message: "no image found", preferredStyle: .alert)
            let button = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(button)
            present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "choose site", message: "please select the site you want", preferredStyle: .actionSheet)
            
            let facebookButton = UIAlertAction(title: "facebook", style: .default, handler: { (alertAction) in
                let facebookViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookViewController?.add(self.imageToShare.image)
                self.present(facebookViewController!, animated: true, completion: nil)
            })
            
            let twitterButton = UIAlertAction(title: "Twitter", style: .default, handler: { (alertAction) in
                let twitterViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterViewController?.add(self.imageToShare.image)
                self.present(twitterViewController!, animated: true, completion: nil)
            })
            
            let cancelButton = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            
            alert.addAction(facebookButton)
            alert.addAction(twitterButton)
            alert.addAction(cancelButton)
            present(alert, animated: true, completion: nil)
        }
        
    }
    

   

}
