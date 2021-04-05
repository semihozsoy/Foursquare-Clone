//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Semih Özsoy on 4.04.2021.
//

import UIKit
import Parse

class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Parse'da obje oluşturup database'e kaydedebilmek için sınıf oluşturup
        // daha sonra o objeyi kullanmamız gerekiyor
        //Parse a veri kaydetme işlemi
        /*
        let parseObject = PFObject(className: "Fruits")
        
        parseObject["name"] = "banana"
        parseObject["calories"] = 150
        
        parseObject.saveInBackground { (success, error) in
            
            if error != nil {
                
                print(error?.localizedDescription)
                
            }else{
                print("uploaded")
            }
        }
    
        
        // Parse'dan veri çekmek için gerekli olan kod. findObjectsInBackground closure'ında enterladıktan sonra
        // gelen yapı objects bizim için dizideki bütün elemanları getiriyor
        
        let query = PFQuery(className: "Fruits")
        
        // wherekey ile yaptığımız arama bize spesifik olarak istediği şeyi getirtiyor
        
        //query.whereKey("name", equalTo: "apple")
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                print(error?.localizedDescription)
            }
            else{
                print(objects)
            }
        }
        
         */
        
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        // Giriş İşlemleri
        
        if nameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: nameText.text!, password: passwordText.text!) { (user, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", message: error?.localizedDescription ??  "Error")
                }
                else{
                    // Giriş yaptıktan sonra Segue yapıp diğer sayfaya geçmemiz gerekiyor
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }
        
        
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if nameText.text != "" && passwordText.text != "" {
            
            // Kullanıcı Oluşturma
            
            let user = PFUser()
            
            user.username = nameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { (success, error) in
                
                if error != nil {
                    // self ile yazmamızın sebebi closure icinde olmamızdan dolayı
                    self.makeAlert(titleInput: "Error", message: error?.localizedDescription ?? "Error!!")
                }
                else {
                    // Burda kullanıcı başarılı bir şekilde sign up olduysa onu diğer sayfaya yönlendiricez.
                    //Segue yapıcaz.
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }
        else{
            makeAlert(titleInput: "Error", message: "Username Or Password ??")
        }
        
    }
    
    func makeAlert(titleInput: String, message: String){
        let alert = UIAlertController(title: titleInput, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

