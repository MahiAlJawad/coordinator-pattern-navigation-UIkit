//
//  MainViewController.swift
//  coordinator_pattern_navigation-UIKit
//
//  Created by Mahi Al Jawad on 21/3/24.
//

import UIKit

class MainViewController: UIViewController {
    var viewModel: MainViewModel!
    
    static func makeViewController(with viewModel: MainViewModel) -> MainViewController {
        let viewController = UIStoryboard(name: "MainStoryboard",bundle: nil)
            .instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.navigationTitle
    }
    
    @IBAction func pushChildViewTapped(_ sender: Any) {
        viewModel.pushChildViewTapped()
    }
    
    @IBAction func presentChildViewTapped(_ sender: Any) {
        viewModel.presentChildViewTapped()
    }
    
    @IBAction func showAlertTapped(_ sender: Any) {
        viewModel.showAlertTapped()
    }
}
