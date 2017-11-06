//
//  JSON_Parser.swift
//  Flipkart_Book_Library
//
//  Created by Ashis Laha on 12/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import Foundation

//MARK:- Book model
struct Book : Decodable { // Properties must be the same name as specified in JSON , else it will return nil
    var id : String
    var book_title : String
    var author_name : String
    var genre : String
    var publisher : String
    var author_country : String
    var sold_count : Int
    var image_url : String
}

//MARK:- Constants
struct Constants {
    static let author = "author"
    static let genre = "genre"
    static let country = "country"
}

class Parser {
    
    static let url = "http://www.mocky.io/v2/59df0d520f00005e05173a79" // URL for JSON
    
    //MARK:- Books parsing
    static func parseJSON(completionBlock : @escaping ([Book])->()) {
        
        guard let url = URL(string: Parser.url) else { return }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard let books = try? JSONDecoder().decode([Book].self, from: data) else { return }
            completionBlock(books)
        }
        session.resume()
    }
    
    static func createModifiedModel(books : [Book] , completionBlock : ([(name : String, tag : String)])->() ) {
        
        // map all
        let authors = books.map { $0.author_name }
        let genres = books.map { $0.genre }
        let countries = books.map{ $0.author_country }

        // put it into a Set to reduce the multiple occurance
        let uniqueAuthors = Array(Set(authors))
        let uniqueGenres = Array(Set(genres))
        let uniqueCountries = Array(Set(countries))
        
        // create the result sets
        var results : [(name : String, tag : String)] = []
        for each in uniqueAuthors { results.append((name: each,tag: Constants.author)) }
        for each in uniqueGenres { results.append((name: each,tag: Constants.genre)) }
        for each in uniqueCountries { results.append((name: each,tag: Constants.country)) }
        
        completionBlock(results)
    }
    
    // searchTag may be "author_name"/"author_country"/"genre"
    static func getModel(books : [Book], tagName : String, searchName : String ) -> [Book] {
        switch tagName {
        case Constants.author:   return books.filter{ $0.author_name == searchName }
        case Constants.country : return books.filter { $0.author_country == searchName }
        case Constants.genre :   return books.filter{ $0.genre == searchName }
        default: return []
        }
    }
}
