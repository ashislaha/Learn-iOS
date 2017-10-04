# Learn-iOS

## Let's begin to learn iOS. We will explore the basics of iOS Technology. Like - Auto-layout, ARC, View, ViewControllers, Animations, Design Patterns, frameworks etc.. 


## 1. Do Auto-layout by code (not by story-boarding) : 
    
    -- Create a TopView with Half height of ViewController view.
    -- add a "tree" image inside top-view at the middle of top-view (centerX,centerY) and it's height and width are half of top-view.
    -- add a text-view with some attributed string.
    
## Coding 
    
        topView.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        imageView.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        textView.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        
        // Configure topview , it will be the half of entire view
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true    // leading space to view left
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true  // trailing space to view right
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true      // top space to view top layout
        topView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true // bottom to text view
        
        // configure ImageView : It will be middle of topview
        imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true  // center x of topview
        imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true  // center y of topview
        imageView.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.5).isActive = true  // half of topview height
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true   // width of imageview = height of imageview
        
        // configure text view : It will be bottom of topview
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true // leading
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true // trailing
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true // bottom
    
## Portrait Mode :
![1](https://user-images.githubusercontent.com/10649284/31081771-862e711c-a7aa-11e7-956b-933736f3a37c.png)
## Landscape Mode :
![2](https://user-images.githubusercontent.com/10649284/31081772-875dcc4a-a7aa-11e7-9432-31fe27d16e92.png)

## 2. JSON Parsing using Decodable Protocol :

### JSON URLS :
    struct JsonURL {
    static let singlePerson = "http://www.mocky.io/v2/59d30fed11000007044a05fd"
    static let multiplePersons = "http://www.mocky.io/v2/59d3108b11000017044a05ff"
    static let family = "http://www.mocky.io/v2/59d3120311000022044a0602"
    }


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

