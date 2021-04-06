//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Semih Özsoy on 5.04.2021.
//

// SINGLETON STRUCTURE

import Foundation
import UIKit

class PlaceModel {
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var longitude = ""
    var latitude = ""
    
    
    private init(){}
    
    
    
    
}
