//
//  MainViewModel.swift
//  coordinator_pattern_navigation-UIKit
//
//  Created by Mahi Al Jawad on 24/3/24.
//

import Foundation

class MainViewModel {
    enum Event {
        case pushChildViewTapped
        case presentChildViewTapped
        case showAlertTapped
    }
    
    let navigationTitle = "Main View"
    
    let handleEvent: (Event) -> Void
    
    init(handleEvent: @escaping (Event) -> Void) {
        self.handleEvent = handleEvent
    }
    
    func pushChildViewTapped() {
        handleEvent(.pushChildViewTapped)
    }
    
    func presentChildViewTapped() {
        handleEvent(.presentChildViewTapped)
    }
    
    func showAlertTapped() {
        handleEvent(.showAlertTapped)
    }
}
