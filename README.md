# Learn-iOS

## Let's begin to learn iOS. We will explore the basics of iOS Technology. Like - Auto-layout, ARC, View, ViewControllers, Animations, Design Patterns, frameworks etc.. 


## PROJECT 1 : Do Auto-layout by code (not by story-boarding) : 
    
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

## Explore CollectionView without storyboard designing :

LandScape Output :

![simulator screen shot - iphone 8 plus - 2017-10-29 at 12 35 38](https://user-images.githubusercontent.com/10649284/32141425-b4246f08-bca5-11e7-8108-26f26d068143.png)


### Step 1 : Register Views : 

    private func registerViews() {
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: Constants.cellID)
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.headerID)
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Constants.footerID)
    }
    
### Step 2 : Data Source :

    // UICollectionViewDataSource
    extension HomeCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        cell.dataModel = dataSource[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerID, for: indexPath)
            header.backgroundColor = .green
            return header
            
        } else if kind == UICollectionElementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.footerID, for: indexPath)
            footer.backgroundColor = .red
            return footer
            
        }
        return UICollectionReusableView()
    }
}


### Step 3 : Delegate and DelegateFlowLayout for positioning the cells and Supplementary views (like Header, Footer )
    
    // UICollectionViewDelegate
    extension HomeCollectionViewController  {
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           print("tapped : \(indexPath)")
        }
    }

    // UICollectionViewDelegateFlowLayout
    extension HomeCollectionViewController : UICollectionViewDelegateFlowLayout {
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: self.view.frame.width, height: view.frame.height)
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
         return CGSize(width: 0, height: 0)
     }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: 0, height: 0)
     }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 4
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 4
     }
    }


### Step 4 : Adding a Page Control using Stack View :

    // add a page control with prev and next button
    private var prevBtn : UIButton = {
        let button = UIButton()
        button.setTitle("Prev", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(prevBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private var nextBtn : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .blue
        pageControl.currentPageIndicatorTintColor = .red
        return pageControl
    }()
    
    private var controlStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()
    
    private func pageControlSetup() {
        
        pageControl.numberOfPages = dataSource.count
        controlStack.addArrangedSubview(prevBtn)
        controlStack.addArrangedSubview(pageControl)
        controlStack.addArrangedSubview(nextBtn)
        view.addSubview(controlStack)
        
        // add constraints
        controlStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4).isActive = true
        controlStack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4).isActive = true
        controlStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        controlStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }


### Step 5 : Adding Functionality of Next and Prev Button :

    @objc private func nextBtnTapped() {
        // change the page control
        let currentPage = pageControl.currentPage
        let nextPage = min(currentPage + 1, dataSource.count-1)
        pageControl.currentPage = nextPage
        
        // change the collection view next page
        let indexPath = IndexPath(item: nextPage, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func prevBtnTapped() {
        // change the page control
        let currentPage = pageControl.currentPage
        let nextPage = max(currentPage - 1, 0)
        pageControl.currentPage = nextPage
        
        // change the collection view next page
        let indexPath = IndexPath(item: nextPage, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

### Step 6 : While scrolling the collection view, update the page control :
    
    // scroll the collection view and update the page control at the same time
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / self.view.bounds.width)
        pageControl.currentPage = index
    }

![simulator screen shot - iphone 8 plus - 2017-10-29 at 12 35 38](https://user-images.githubusercontent.com/10649284/32141425-b4246f08-bca5-11e7-8108-26f26d068143.png)

## PROJECT 2. JSON Parsing using Decodable Protocol :

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

## PROJECT 3. Create A Book Libary App consuming JSON :

-- Focus on Parsing the JSON

-- Use of Filters, Map, Set, Search etc.

-- Please check the project for more.

## PROJECT 4 : Explore More On Collection View :

Please check the Project 1 where autolayout is done without storyboard with collection view.

### OverView : 

A collection view manages a ordered collection of data items and presents them using customisation layouts.

— Consists of following components : 1. collection view cell 2. Supplementary view (Header and footer view ).
— The main job of App is managing data associated with collection view cell. App will conform UICollectionViewDataSource protocol. Data can be organised in several sections. Each item is a UICollectionViewCell . 
— You can do insert, delete, rearrange of cells in collection view using delegate methods .

### Collection Views and Layout objects : 

A very import object associated with collection view is layout object which is a subclass of UICollectionViewLayout class. It is responsible for defining the positions of all cells and supplementary views inside collection view . In other sense, Layout object is a kind of data source which provides visual information instead of data.

— Normally define the Layout object while creating the collection view, you can change the layout object dynamically.

— Setting the layout property (collectionViewLayout) in collection view directly update the layout effect in collection view without animation.  If you want animation using this method :  
   
    func setCollectionViewLayout(UICollectionViewLayout, animated: Bool, completion: ((Bool) -> Void)? = nil)

—  If you want to change layout using Gestures , use InteractiveTransition methods. 

    func startInteractiveTransition(to: UICollectionViewLayout, completion: UICollectionViewLayoutInteractiveTransitionCompletion? = nil)
    func finishInteractiveTransition()  ( when the transition is finished )
    func cancelInteractiveTransition() 

### Create supplementary views and cells : 

When the collection view content is loaded first time, collection view asks it’s data source to give a visible cell.
— use dequeueReusableCell(withIdentifier : String) used for cell.
— use dequeueReusableSupplementaryView(withIdentifier : String ) used for supplementary view.

Before that you must register cell with an reusable identifier. 

### Reordering Items Interactively :

Collection view allows user to move items using gestures.  Normally the order is as per the data source.  But you can configure gesture recogniser to track the user interactions of a collection view item and update the item’s position.  

-- To Begin the interactive repositioning an item :  beginInteractiveMovementForItem(at :)

-- While the Gesture recogniser is tracking touch events ,  updateInteractiveMovementTargetPosition(_:)  is reporting to touch location . 

-- When you are done the tracking, call endInteractiveMovement() and update the collection view. OR call cancelInteractivemovement() to cancel 

## Ordering cells in Collection View using Gestures : 

    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(gesture:)))
        collectionView.addGestureRecognizer(longPress)
    }
    
    @objc private func longPress(gesture : UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let indexpath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { break }
            collectionView.beginInteractiveMovementForItem(at: indexpath)
            
        case .changed :
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            
        case .ended:
            collectionView.endInteractiveMovement()
            
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    // Interactive movements in UICollectionViewDataSource method : 
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        isInteractiveMode = true
        source = sourceIndexPath
        destination = destinationIndexPath
        // best way to do is to update the model so that next time while scrolling the collection view, it will not reset the items.
    }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        
        cell.model =  isInteractiveMode ? CellModel(imageName: "car_\(source.row+1)", imageTitle: "Car") : CellModel(imageName: "car_\(indexPath.row+1)", imageTitle: "Car")
        isInteractiveMode = false // once done user interactive
        return cell
    }


