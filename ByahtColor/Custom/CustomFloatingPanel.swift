//
//  CustomFloatingPanel.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/19.
//

import FloatingPanel

class CustomFloatingPanel: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 80.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.0, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }

}
