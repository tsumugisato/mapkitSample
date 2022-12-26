//
//  AddViewController.swift
//  MapKitSample
//
//  Created by 藤田えりか on 2020/07/31.
//  Copyright © 2020 com.erica. All rights reserved.
//

import UIKit
import NCMB

class AddViewController: UIViewController ,UITextViewDelegate ,UITextFieldDelegate{
    
    var latitude : Double!
    var longitude : Double!
    
    @IBOutlet var postTextField: UITextField!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTextField.delegate = self
        postTextView.delegate = self
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    @IBAction func save(){
        let postObject = NCMBObject(className: "Map")
        postObject?.setObject(self.postTextField.text!, forKey: "text")
        postObject?.setObject(self.postTextView.text!, forKey: "subtext")
        postObject?.setObject(self.latitude, forKey: "latitude")
        postObject?.setObject(self.longitude, forKey: "longitude")
        
        postObject?.saveInBackground({ (error) in
            if error != nil{
                
            }else{
                //成功して戻る
                  self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    
}
