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


## PROJECT 5 : TWITTER / YOUTUBE : 

I am trying to create the basic structure of twitter like cell using collection view with auto-layout.

### User cell : 
![simulator screen shot - iphone 8 plus - 2017-10-30 at 11 28 49](https://user-images.githubusercontent.com/10649284/32156812-8e7426c0-bd65-11e7-98e2-ae15c44e7b60.png)

### Tweet cell : 
![simulator screen shot - iphone 8 plus - 2017-10-30 at 11 30 55](https://user-images.githubusercontent.com/10649284/32156863-cfa1d106-bd65-11e7-9cc5-331e448ee7c9.png)

### Few basic reusability code :

### Anchoring between views : 

    extension UIView {
    
    func anchors(top : NSLayoutYAxisAnchor?, topConstants : CGFloat, left : NSLayoutXAxisAnchor?, leftConstants : CGFloat, bottom : NSLayoutYAxisAnchor?, bottomConstants : CGFloat, right : NSLayoutXAxisAnchor?,  rightConstants : CGFloat, heightConstants : CGFloat, widthConstants : CGFloat ) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topConstants).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftConstants).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: bottomConstants).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: rightConstants).isActive = true
        }
        if heightConstants > 0 {
            self.heightAnchor.constraint(equalToConstant: heightConstants).isActive = true
        }
        if widthConstants > 0 {
            self.widthAnchor.constraint(equalToConstant: widthConstants).isActive = true
        }
    }
    }

### User Cell : 

    class UserCell : UICollectionViewCell {
    
    var dataModel : User? {
        didSet {
            userProfilePic.image = UIImage(named :dataModel?.profileImageName ?? "")
            name.text = dataModel?.name
            username.text = dataModel?.username
            bio.text = dataModel?.bio
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // user profile picture
    private let userProfilePic  : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // name
    private let name : UILabel = {
        let label = UILabel()
        label.text = "name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // username
    private let username : UILabel = {
        let label = UILabel()
        label.text = "username"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // bio description
    private let bio : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    // follow button
    private let followBtn : UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.cyan.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(UIColor.cyan, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // seperator
    private let seperatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    
    private func viewSetup() {
        addSubview(userProfilePic)
        addSubview(name)
        addSubview(username)
        addSubview(bio)
        addSubview(followBtn)
        addSubview(seperatorView)
        layoutSetup()
    }
    
    private func layoutSetup() {
        // adding constraints
        
        // user profile
        userProfilePic.anchors(top: topAnchor, topConstants: 8, left: leftAnchor, leftConstants: 8, bottom: nil, bottomConstants: 0, right: nil, rightConstants: 0, heightConstants: 88, widthConstants: 88)
        
        // name
        name.anchors(top: topAnchor, topConstants: 8, left: userProfilePic.rightAnchor, leftConstants: 8, bottom: nil, bottomConstants: 0, right: followBtn.leftAnchor, rightConstants: 0, heightConstants: 0, widthConstants: 0)
        
        // username
        username.anchors(top: name.bottomAnchor, topConstants: 8, left: name.leftAnchor, leftConstants: 0, bottom: nil, bottomConstants: 0, right: name.rightAnchor, rightConstants: 0, heightConstants: 0, widthConstants: 0)
        
        // bio text
        bio.anchors(top: userProfilePic.bottomAnchor, topConstants: 8, left: leftAnchor, leftConstants: 8, bottom: bottomAnchor, bottomConstants: 0, right: rightAnchor, rightConstants: 0, heightConstants: 0, widthConstants: 0)
        
        // followBtn
        followBtn.anchors(top: topAnchor, topConstants: 8, left: nil, leftConstants: 0, bottom: nil, bottomConstants: 0, right: rightAnchor, rightConstants: -8, heightConstants: 30, widthConstants: 88)
        
        // seperator view
        seperatorView.anchors(top: nil, topConstants: 0, left: leftAnchor, leftConstants: 0, bottom: bottomAnchor, bottomConstants: 0, right: rightAnchor, rightConstants: 0, heightConstants: 1, widthConstants: 0)
    }
    }

### Stack View (Red-Green-Blue-Purple) : 

    // controls stack view
    private let stackView : UIStackView = {
        let redView = UIView()
        redView.backgroundColor = .red
        let icon1 = UIButton()
        icon1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        icon1.setImage(#imageLiteral(resourceName: "icon"), for: .normal)
        redView.addSubview(icon1)
        
        let greenView = UIView()
        greenView.backgroundColor = .green
        let icon2 = UIButton()
        icon2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        icon2.setImage(#imageLiteral(resourceName: "icon"), for: .normal)
        greenView.addSubview(icon2)
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        let icon3 = UIButton()
        icon3.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        icon3.setImage(#imageLiteral(resourceName: "icon"), for: .normal)
        blueView.addSubview(icon3)

        let purpleView = UIView()
        purpleView.backgroundColor = .purple
        let icon4 = UIButton()
        icon4.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        icon4.setImage(#imageLiteral(resourceName: "icon"), for: .normal)
        purpleView.addSubview(icon4)
        
        let stack = UIStackView(arrangedSubviews: [redView, greenView, blueView, purpleView])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()

### Anchoring Stack View :

    // stack view
    stackView.anchors(top: nil, topConstants: 0, left: leftAnchor, leftConstants: 0, bottom: bottomAnchor, bottomConstants: 0, right: rightAnchor, rightConstants: 0, heightConstants: 40, widthConstants: 0)
    

# PROJECT 5 : TABLE VIEW EXPLORE :

## (1). Resize Cell based on content and Expand cell dynamically: 

### (a) Resize cell based on content :
![simulator screen shot - iphone 7 - 2017-11-01 at 19 18 06](https://user-images.githubusercontent.com/10649284/32278154-bdd378c2-bf3a-11e7-9a90-6bb76da410e9.png)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registers()
        tableViewSetup()
    }
    
    private func registers() {
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.headerID)
        tableView.register(FooterView.self, forHeaderFooterViewReuseIdentifier: Constants.footerID)
    }
    
    private func tableViewSetup() {
        // resize based on content
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.reloadData()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }


### (b) Expand Cell on tapped of cell : 
![simulator screen shot - iphone 7 - 2017-11-01 at 19 18 19](https://user-images.githubusercontent.com/10649284/32278150-b932f7ac-bf3a-11e7-8ffe-16ac1c6829ff.png)

    extension HomeViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? UserCell else { return UITableViewCell() }
        cell.model = dataSource[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerID) as? HeaderView else{ return nil }
        header.viewSetup()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.footerID) as? FooterView else {return nil }
        footerView.viewSetup()
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}

    extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped : \(indexPath)")
        
        // expand cell while tapping the cell
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        
        // model
        dataSource[indexPath.row].isExpand = !dataSource[indexPath.row].isExpand
        dataSource[indexPath.row].more =  dataSource[indexPath.row].isExpand ? Constants.desc3 : "More to tapped"
        cell.model = dataSource[indexPath.row] // update the view
        
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}








