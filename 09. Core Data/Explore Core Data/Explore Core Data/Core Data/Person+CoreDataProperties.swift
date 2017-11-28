//
//  Person+CoreDataProperties.swift
//  Explore Core Data
//
//  Created by Ashis Laha on 06/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func personFetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var address: String?
    @NSManaged public var country: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: Int16
    @NSManaged public var apartment: NSSet?

}

// MARK: Generated accessors for apartment
extension Person {

    @objc(addApartmentObject:)
    @NSManaged public func addToApartment(_ value: Apartment)

    @objc(removeApartmentObject:)
    @NSManaged public func removeFromApartment(_ value: Apartment)

    @objc(addApartment:)
    @NSManaged public func addToApartment(_ values: NSSet)

    @objc(removeApartment:)
    @NSManaged public func removeFromApartment(_ values: NSSet)

}
