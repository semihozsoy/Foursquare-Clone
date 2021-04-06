//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Semih Özsoy on 4.04.2021.
//

import UIKit
import Parse

class PlacesVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Buton ekleme navigation bar için gerekli olan bir buton ekleme
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
    
        getDataFromParse()
    }
    
    func getDataFromParse(){
        // Parse'dan data çekmek için bunları uyguladık
        
        let query = PFQuery(className: "places")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            } else {
                if objects != nil {
                    
                    for object in objects! {
                        
                        self.placeIdArray.removeAll(keepingCapacity: false)
                        self.placeNameArray.removeAll(keepingCapacity: false)
                        
                        if let placeName = object.object(forKey: "name") as? String {
                            
                            if let placeId = object.objectId {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                        
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    

    @objc func addButtonClicked(){
        
        // Segue yapmamız gerekiyor
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
    

    @objc func logoutButtonClicked(){
        
        PFUser.logOutInBackground { (error) in
            
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }
            else {
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPlaceId = selectedPlaceId
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return placeNameArray.count
     
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
        
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    


    

}
