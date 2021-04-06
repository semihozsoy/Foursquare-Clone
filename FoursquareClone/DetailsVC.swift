//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Semih Özsoy on 4.04.2021.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var chosenPlaceId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     let query = PFQuery(className: "places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                print(objects)
            }
        }
        
    }
    

   

}
