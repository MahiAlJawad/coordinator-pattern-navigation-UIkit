//
//  ChildViewController.swift
//  coordinator_pattern_navigation-UIKit
//
//  Created by Mahi Al Jawad on 26/3/24.
//

import UIKit

class ChildViewController: UIViewController {
    var viewModel : ChildViewModel!
    @IBOutlet weak var label: UILabel!
    
    static func makeViewController(with viewModel: ChildViewModel) -> ChildViewController {
        let viewController = UIStoryboard(name: "ChildViewStoryboard",bundle: nil)
            .instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = viewModel.viewTitle
        setupNavigationItems()
    }
    
    private func setupNavigationItems() {
        navigationItem.title = viewModel.viewTitle
        
        switch viewModel.presentationType {
        case .pushed:
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonAction))
            navigationItem.leftBarButtonItem = backButton
        case .presented:
            // Contains Done button and Cancel button in presented view
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonAction))
            navigationItem.rightBarButtonItem = doneButton
            navigationItem.leftBarButtonItem = cancelButton
        }
    }
    
    @objc private func doneButtonAction() {
        viewModel.doneButtonTapped()
    }
    
    @objc private func cancelButtonAction() {
        viewModel.cancelButtonTapped()
    }
    
    @objc private func backButtonAction() {
        viewModel.backButtonTapped()
    }
}
