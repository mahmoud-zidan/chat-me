//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright Mahmoud Ismaeil Atito. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    // Declare instance variables here
    var MessageArray:[Message] = [Message]()
    
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTableView.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tableViewTapped))
        
        messageTableView.addGestureRecognizer(tapGesture)
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName:"MessageCell" ,bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retriveMessages()
        messageTableView.separatorStyle = .none
            }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
  
  
    cell.senderUsername.text! = MessageArray[indexPath.row].sender
    cell.messageBody.text! = MessageArray[indexPath.row].message
    
    cell.avatarImageView.image = UIImage(named : "egg")
    
    if cell.senderUsername.text! == (Auth.auth().currentUser?.email)! as String{
        cell.avatarImageView.backgroundColor = UIColor.flatMint()
        cell.messageBackground.backgroundColor = UIColor.flatBlue()
    }
    else{
        cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
        cell.messageBackground.backgroundColor = UIColor.flatRed()
    }
    
    
      return cell
    }
   
//    //TODO: Declare numberOfRowsInSection here:
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return MessageArray.count
    }
    
    
    //TODO: Declare tableViewTapped here:
    func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
            print("begin")
            
        }

    }
    
    //TODO: Declare textFieldDidEndEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        //TODO: Send the message to Firebase and save it in our database
        let messagesDB = Database.database().reference().child("Messages")
        
        let MessagesDictionary = ["Sender":Auth.auth().currentUser?.email!,"MessageBody":messageTextfield.text!]
        
        messagesDB.childByAutoId().setValue(MessagesDictionary)
            {
            (error , ref)in
        
            if error != nil {
                print(error)
            }
            else{
                print("Message Saved Successfuly")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                
                self.messageTextfield.text! = ""
            }
        
        
        }
        
        
        
    }
    
    func retriveMessages() {
        let MessageDB = Database.database().reference().child("Messages")
        
        MessageDB.observe(.childAdded, with: {
            (snapshot) in
            let snapshopValue = snapshot.value as! Dictionary<String, String>
            let Text = snapshopValue["MessageBody"]!
            let sender = snapshopValue["Sender"]!
            
            let message = Message()
            message.sender = sender
            message.message = Text
            
          self.MessageArray.append(message)
            
          self.configureTableView()
          self.messageTableView.reloadData()
        })
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do{
            
            try Auth.auth().signOut()
            
        }
        catch{
            print(error)
        }
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil
        
            else{
                print("There is not a view controller")
                return
            }
        
    }
    


}
