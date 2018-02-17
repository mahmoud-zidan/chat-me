//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()   // show the progress icon or sign
        
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: {
            (user,error) in
        
            if error != nil{
                
                let alert = UIAlertController(title: "Registration", message: "Error during Registeration , Please Enter your data correcly ", preferredStyle: .alert)
                
                let restartAction = UIAlertAction(title: "Continue", style: .cancel, handler:{
                    (UIAlertAction) in
                        self.passwordTextfield.text! = ""
                        self.emailTextfield.text! = ""

                })
                
                alert.addAction(restartAction)
                
                self.present(alert ,animated: true, completion: nil)
                
            }
            else{
                
                let alert = UIAlertController(title: "Registration", message: "Registeration Successfuly, Do you want to continue ?", preferredStyle: .alert)
                
                let restartAction = UIAlertAction(title: "Continue", style: .default, handler: {
                    (UIAlertAction) in
                    self.performSegue(withIdentifier: "goToChat", sender: self)

                })
                    
                alert.addAction(restartAction)
                
                self.present(alert ,animated: true, completion: nil)
                
                
            }
        
        
        SVProgressHUD.dismiss()

        
        
    })
  }
}
