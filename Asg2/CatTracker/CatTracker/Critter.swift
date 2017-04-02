//
//  Critter.swift
//  CatTracker
//
//  Created by 1155032539 on 11/3/2017.
//  Copyright © 2017 1155032539. All rights reserved.
//

import UIKit

class Critter : NSObject, NSCoding {
    //MARK: Properties
    var name: String?
    var photo: UIImage?
    var details: String?
    //MARK: Initialization
    init?(name: String?, photo: UIImage?, details: String?) {
        if (name?.isEmpty)! {
            return nil
        }
        self.name = name
        self.photo = photo
        self.details = details
    }
    
    func encode(with aCoder: NSCoder) {
        if let name = self.name {
            aCoder.encode(name, forKey: "name")
        }
        if let photo = self.photo {
            if let imageData = UIImagePNGRepresentation(photo) {
                aCoder.encode(imageData, forKey: "image")
            }
        }
        if let details = self.details {
            aCoder.encode(details, forKey: "details")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        if let imageData = aDecoder.decodeObject(forKey: "image") as? NSData {
           self.photo = UIImage(data: imageData as Data)
        }
        self.details = aDecoder.decodeObject(forKey: "details") as? String
    }
    
    
    
}

