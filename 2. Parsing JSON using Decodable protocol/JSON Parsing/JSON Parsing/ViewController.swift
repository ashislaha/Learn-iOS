//
//  ViewController.swift
//  JSON Parsing
//
//  Created by Ashis Laha on 03/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

//JSON url
struct JsonURL {
    static let singlePerson = "http://www.mocky.io/v2/59d30fed11000007044a05fd"
    static let multiplePersons = "http://www.mocky.io/v2/59d3108b11000017044a05ff"
    static let family = "http://www.mocky.io/v2/59d3120311000022044a0602"
}

struct Person : Decodable { // Properties must be the same name as specified in JSON , else it will return nil
    var name : String?
    var surname : String?
    var age : Int?
    var married : String?
}

struct Family : Decodable {  // Properties must be the same name as specified in JSON , else it will return nil
    var family_member : Int?
    var family_title : String?
    var persons : [Person]
}

class ViewController: UIViewController {

    //MARK:- Parse a Single Person
    private func parseSinglePersonJSON() {
        guard let url = URL(string: JsonURL.singlePerson) else { return }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
             guard let data = data else { return }
            /*  // old approach :
             guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else { return }
             // create the model
             let person = Person(dictionary : jsonData)
             */
            guard let person = try? JSONDecoder().decode(Person.self, from: data) else { return }
            print("\n\n PERSON : \(person)")
        }
        session.resume()
    }
    
    //MARK:- Multiple Person
    private func parseMultiplePersons() {
        guard let url = URL(string: JsonURL.multiplePersons) else { return }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard let persons = try? JSONDecoder().decode([Person].self, from: data) else { return }
            print("\n\n PERSONS : \(persons)")
        }
        session.resume()
    }
    
    //MARK:- Parse Family
    private func parseFamily() {
        guard let url = URL(string: JsonURL.family) else { return }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard let family = try? JSONDecoder().decode(Family.self, from: data) else { return }
            print("\n\n FAMILY :  \(family)")
        }
        session.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseSinglePersonJSON()
        parseMultiplePersons()
        parseFamily()
    }
}

