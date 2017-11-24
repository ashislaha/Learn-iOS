//
//  OlaLensIntroPage.swift
//  Explore Direction
//
//  Created by Ashis Laha on 13/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

protocol ShowOlaLensIntroDelegate : class {
    func allowCameraClicked()
}

@available(iOS 11.0, *)
class OlaLensIntroPageViewController : UIViewController {

    var delegate : ShowOlaLensIntroDelegate?
    
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: "lensintro")
        }
    }
    
    @IBOutlet private weak var cameraOutlet: UIButton! {
        didSet {
            cameraOutlet.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet private weak var header : UILabel!
    @IBOutlet private weak var desc: UITextView!
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allowCamera(_ sender: UIButton) {
        if let delegate = delegate {
            dismiss(animated: true, completion: {
                 delegate.allowCameraClicked()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

