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
        navigationItem.title = viewModel.viewTitle
        label.text = viewModel.viewTitle
    }
}
