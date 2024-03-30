//
//  AppCoordinator.swift
//  coordinator_pattern_navigation-UIKit
//
//  Created by Mahi Al Jawad on 24/3/24.
//

import UIKit

class AppCoordinator: Coordinator {
    let navigationController = UINavigationController()
    
    // AppCoordinator deals with only single Coordinator started from `SceneDelegate`.
    // In complex applications if there are multilevel hierarchy of views
    // then Destination will deal with multiple destination cases.
    // From different places different `destination` might be started
    enum Destination {
        case rootView
    }
    
    func start(with destination: Destination = .rootView) {
        switch destination {
        case .rootView:
            pushViewController(mainViewController)
        }
    }
}

// MARK: Handle MainView events

extension AppCoordinator {
    private func handleEvent(_ event: MainViewModel.Event) {
        switch event {
        case .pushChildViewTapped:
            pushViewController(childViewController(presentationType: .pushed))
        case .presentChildViewTapped:
            presentViewController(childViewController(presentationType: .presented))
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

// MARK: Handle ChildView events

extension AppCoordinator {
    private func handleEvent(_ event: ChildViewModel.Event) {
        switch event {
        case .doneButtonTapped, .cancelButtonTapped:
            dismiss()
        case .backButtonTapped:
            popViewController()
        }
    }
    
    private func childViewController(presentationType: ChildViewModel.PresentationType) -> ChildViewController {
        .makeViewController(with: .init(
            presentationType: presentationType,
            handleEvent: handleEvent
        ))
    }
}
