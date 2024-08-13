//
//  CollabFloatingPanel.swift
//  ByahtColor
//
//  Created by jaem on 8/7/24.
//

import FloatingPanel

class CollabFloatingPanel: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState
    private let selectedState: FloatingPanelState?

    init(selectedState: FloatingPanelState? = nil) {
        self.selectedState = selectedState
        self.initialState = selectedState ?? .half // 기본 초기 상태는 .half
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        let screenHeight = UIScreen.main.bounds.height
        let fullInset = screenHeight * 0.05 // 5% of the screen height

        let allAnchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
            .full: FloatingPanelLayoutAnchor(absoluteInset: fullInset, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.7, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.6, edge: .bottom, referenceGuide: .safeArea)
        ]

        if let state = selectedState {
            var filteredAnchors = [state: allAnchors[state]!]
            if state != initialState {
                filteredAnchors[initialState] = allAnchors[initialState]
            }
            return filteredAnchors
        } else {
            return allAnchors
        }
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}
