//
//  ChildViewModel.swift
//  coordinator_pattern_navigation-UIKit
//
//  Created by Mahi Al Jawad on 26/3/24.
//

import Foundation

class ChildViewModel {
    enum PresentationType {
        case pushed
        case presented
    }
    
    enum Event {
        case doneButtonTapped
        case cancelButtonTapped
        case backButtonTapped
    }
    
    let viewTitle = "Child View"
    
    let handleEvent: (Event) -> Void
    let presentationType: PresentationType
    
    init(presentationType: PresentationType, handleEvent: @escaping (Event) -> Void) {
        self.handleEvent = handleEvent
        self.presentationType = presentationType
    }
    
    func doneButtonTapped() {
        handleEvent(.doneButtonTapped)
    }
    
    func cancelButtonTapped() {
        handleEvent(.cancelButtonTapped)
    }
    
    func backButtonTapped() {
        handleEvent(.backButtonTapped)
    }
}
