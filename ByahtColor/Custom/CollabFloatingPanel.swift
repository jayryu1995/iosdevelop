//
//  CollabFloatingPanel.swift
//  ByahtColor
//
//  Created by jaem on 8/7/24.
//

import Foundation
import FloatingPanel

class CollabFloatingPanel: FloatingPanelLayout {

    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        let screenHeight = UIScreen.main.bounds.height
        let fullInset = screenHeight * 0.05 // 5% of the screen height

        return [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.7, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }

}
