//
//  Apartment+CoreDataProperties.swift
//  Explore Core Data
//
//  Created by Ashis Laha on 06/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//
//

import Foundation
import CoreData


extension Apartment {

    @nonobjc public class func apartmentFetchRequest() -> NSFetchRequest<Apartment> {
        return NSFetchRequest<Apartment>(entityName: "Apartment")
    }

    @NSManaged public var address: String?
    @NSManaged public var name: String?
    @NSManaged public var person: Person?

}
