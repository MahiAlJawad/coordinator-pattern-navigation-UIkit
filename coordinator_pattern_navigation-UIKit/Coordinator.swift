//
//  Coordinator.swift
//  coordinator_pattern_navigation-UIKit
//
//  Created by Mahi Al Jawad on 26/3/24.
//

import UIKit

protocol Coordinator {
    associatedtype Destination
    
    var navigationController: UINavigationController { get }
    
    func pushViewController(_ viewController: UIViewController)
    
    func presentViewController(_ viewController: UIViewController)
    
    func showAlert(title: String, message: String)
    
    func dismiss()
    
    func popViewController()
    
    func start(with destination: Destination)
}

extension Coordinator {
    func pushViewController(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentViewController(_ viewController: UIViewController) {
        let presentedNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(presentedNavigationController, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(.init(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
