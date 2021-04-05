//
//  AddPlaceVC.swift
//  FoursquareClone
//
//  Created by Semih Özsoy on 4.04.2021.
//

import UIKit

class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placeNameText: UITextField!
    
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeAtAtmosphere: UITextField!
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Kullanıcının bir şeye tıklayabilir mi ya da tıklarsa ne olacak gibi aksiyonları vermek için bu kodları yazıyoruz
        
        placeImageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        placeImageView.addGestureRecognizer(gestureRecognizer)
        
    }
    

    
    // seçildikten sonra ne olacağına karar verdiğimiz kısım burası
    // didfinishpicking diye yazdığımızda bu fonksiyon gelecek
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        placeImageView.image = info[.originalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if placeTypeText != nil && placeAtAtmosphere != nil && placeNameText != nil {
            
            if let chooseImage = placeImageView.image{
                
                // singleton yapısının kullanımı
                
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameText.text!
                placeModel.placeType = placeTypeText.text!
                placeModel.placeAtmosphere = placeAtAtmosphere.text!
                placeModel.placeImage = chooseImage
            
        }
        performSegue(withIdentifier: "toMapVC", sender: nil)
        }
        else {
            
            let alert = UIAlertController(title: "Error", message: "name or type or atmosphere ??", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
}
    
    
    @objc func chooseImage(){
        
        // fotoğrafı seçmek için gereken kodları burda yazdık
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker , animated: true, completion: nil)
        
    }
        
        
    
}


