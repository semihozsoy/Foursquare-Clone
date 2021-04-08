//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Semih Özsoy on 4.04.2021.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

   getDataFromParse()
        
        detailsMapView.delegate = self
        
        
    }
    
    func getDataFromParse() {
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
                
                //OBJECTS
                
                   if objects != nil {
                       if objects!.count > 0 {
                           let chosenPlaceObject = objects![0]
                           
                           if let placeName = chosenPlaceObject.object(forKey: "name") as? String {
                               self.detailsNameLabel.text = placeName
                               
                           }
                           if let placeType = chosenPlaceObject.object(forKey: "type") as? String {
                               self.detailsTypeLabel.text = placeType
                               
                           }
                           if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String {
                               self.detailsAtmosphereLabel.text = placeAtmosphere
                               
                           }
                           
                           if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                               if let placeLatitudeDouble = Double(placeLatitude) {
                                   self.chosenLatitude = placeLatitudeDouble
                               }
                           }
                           if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String {
                               if let placeLongitudeDouble = Double(placeLongitude){
                                   self.chosenLongitude = placeLongitudeDouble
                               }
                           }
                           if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                               imageData.getDataInBackground { (data, error) in
                                   
                                   if error == nil {
                                       if data != nil{
                                        self.detailsImageView.image = UIImage(data: data!)
                                       }
                                   }
                               }
                           }
                        // MAPS 'E AKTARMA KISMI
                        
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        
                        let region = MKCoordinateRegion(center: location, span: span)
                        
                        self.detailsMapView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        
                        annotation.coordinate = location
                        annotation.title = self.detailsNameLabel.text!
                        annotation.subtitle = self.detailsTypeLabel.text!
                        self.detailsMapView.addAnnotation(annotation)
                        
                           
                       }
                   }
               }
           }
    }
    
    //Adding navigation
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    // bu fonksiyon bize bir detail kısmı cıkaracak o kısımda bizi alıp navigasyona götürüyor
    // güncel yerim nerdeyse oraya arabayla nasıl giderim bana bunu gösteriyor
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && chosenLatitude != 0.0 {
            
            let requestLocation = CLLocation(latitude: chosenLatitude, longitude: chosenLongitude)
            
            // koordinatlar ve yerler arasındaki bilgiyi bize verecek
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
   

}
