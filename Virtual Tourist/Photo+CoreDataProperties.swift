//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Fernando Geraldo Mantoan on 03/04/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var data: NSData?
    @NSManaged public var flickrId: String?
    @NSManaged public var flickrUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var pin: Pin?

}
