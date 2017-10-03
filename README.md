# Learn-iOS

## Let's begin to learn iOS. We will explore the basics of iOS Technology. Like - Auto-layout, ARC, View, ViewControllers, Animations, Design Patterns, frameworks etc.. 


## 1. Do Auto-layout by code (not by story-boarding) : 
    
    -- Create a TopView with Half height of ViewController view.
    -- add a "tree" image inside top-view at the middle of top-view (centerX,centerY) and it's height and width are half of top-view.
    -- add a text-view with some attributed string.
    
## Portrait Mode :
![1](https://user-images.githubusercontent.com/10649284/31081771-862e711c-a7aa-11e7-956b-933736f3a37c.png)
## Landscape Mode :
![2](https://user-images.githubusercontent.com/10649284/31081772-875dcc4a-a7aa-11e7-9432-31fe27d16e92.png)

## 2. JSON Parsing using Decodable Protocol :

### Model will be like : 
    struct Person : Decodable { // Properties must be the same name as specified in JSON , else it will return nil
     var name : String?
     var surname : String?
     var age : Int?
     var married : String?
    }
    
### Model Parsing :

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

### Output :
    PERSON : Person(name: Optional("Ashis"), surname: Optional("Laha"), age: Optional(28), married: Optional("YES"))

    PERSONS : [JSON_Parsing.Person(name: Optional("Ashis"), surname: Optional("Laha"), age: Optional(28), married: Optional("YES")),   JSON_Parsing.Person(name: Optional("Barnali"), surname: Optional("Laha"), age: Optional(27), married: Optional("YES"))]
   
    FAMILY :  Family(family_member: Optional(10), family_title: Optional("Laha Family"), persons: [JSON_Parsing.Person(name: Optional("Ashis"), surname: Optional("Laha"), age: Optional(28), married: Optional("YES")), JSON_Parsing.Person(name: Optional("Barnali"), surname: Optional("Laha"), age: Optional(27), married: Optional("YES")), JSON_Parsing.Person(name: Optional("Aheli"), surname: Optional("Lahe"), age: nil, married: nil)])

## Check the others parsing in repo.

