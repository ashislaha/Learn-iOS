//
//  ViewController.swift
//  Slide Menu
//
//  Created by Ashis Laha on 03/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var slideView: UIView! // container view
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    private var isMenuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        leadingConstraint.constant = -slideView.bounds.width
        menuSetup()
    }
    
    private let menu : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "hamburger"), for: .normal)
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func menuTapped() {
        print("menu tapped")
        isMenuOpen = !isMenuOpen
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.leadingConstraint.constant = self.isMenuOpen ? 0 : -self.slideView.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func menuSetup() {
        view.addSubview(menu)
        
        NSLayoutConstraint.activate([
            menu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menu.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            menu.heightAnchor.constraint(equalToConstant: 44),
            menu.widthAnchor.constraint(equalToConstant: 44)
         ])
    }
}

