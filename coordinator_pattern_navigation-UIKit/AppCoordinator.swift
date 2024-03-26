//
//  AppCoordinator.swift
//  coordinator_pattern_navigation-UIKit
//
//  Created by Mahi Al Jawad on 24/3/24.
//

import UIKit

protocol Coordinator {
    associatedtype Destination
    
    var navigationController: UINavigationController { get }
    
    func pushViewController(_ viewController: UIViewController)
    
    func presentViewController(_ viewController: UIViewController)
    
    func showAlert(title: String, message: String)
    
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
}

class AppCoordinator: Coordinator {
    let navigationController = UINavigationController()
    
    // add other destinations
    enum Destination {
        case mainView
    }
    
    func start(with destination: Destination = .mainView) {
        switch destination {
        case .mainView:
            pushViewController(mainViewController)
        }
    }
}

// MARK: MainView events

extension AppCoordinator {
    private func handleEvent(_ event: MainViewModel.Event) {
        switch event {
        case .pushChildViewTapped:
            pushViewController(childViewController)
        case .presentChildViewTapped:
            presentViewController(childViewController)
        case .showAlertTapped:
            showAlert(title: "Dummy Alert", message: "Dummy message for alert")
        }
    }
    
    var mainViewController: MainViewController {
        .makeViewController(
            with: .init(handleEvent: handleEvent)
        )
    }
}

extension AppCoordinator {
    var childViewController: ChildViewController {
        .makeViewController(with: .init())
    }
}
