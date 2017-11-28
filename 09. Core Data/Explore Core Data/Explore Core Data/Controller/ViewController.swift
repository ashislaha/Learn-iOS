//
//  ViewController.swift
//  Explore Core Data
//
//  Created by Ashis Laha on 06/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        saveData()
        retrieveData()
    }

}

extension ViewController {
    
    func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // save an Entity of Person into sqlite
        if let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as? Person , let newApartment = NSEntityDescription.insertNewObject(forEntityName: "Apartment", into: context) as? Apartment {
            person.name = "Ashis"
            person.address = "Bangalore"
            person.country = "India"
            
            newApartment.name = "Laha Nibas"
            newApartment.address = "Bangalore"
            
            person.apartment = NSSet(object: newApartment)
            newApartment.person = person
            try? context.save()
        }
    }
    
    func retrieveData() {
        print("Retrieve Results")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // fetching Persons
        let personRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        personRequest.returnsObjectsAsFaults = false
        let result = try? context.fetch(personRequest)
        for data in result as! [Person] {
            print(data)
        }
        
        // fetching Apartment
        let apartmentReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Apartment")
        apartmentReq.returnsObjectsAsFaults = false
        let apartments = try? context.fetch(apartmentReq)
        for data in apartments as! [Apartment] {
            print(data)
        }
    }
}




