//
//  BaseViewController.swift
//  Reciplease_Project
//
//  Created by Wandianga hassane on 11/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayAlert(title: String, message: String? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

class ContentViewController: UIViewController {
    
    func loadContent() {
        let loadingVC = LoadingViewController()
    }
}
