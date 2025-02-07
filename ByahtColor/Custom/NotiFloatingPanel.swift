//
//  NotiFloatingPanel.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/19.
//

import FloatingPanel

class NotiFloatingPanel: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .full
    
    init(requiredHeight: CGFloat, screenHeight: CGFloat) {
        
        // 필요한 높이에 따라 초기 상태 결정
        self.initialState = requiredHeight > screenHeight * 0.7 ? .full : .half
        
    }
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        let screenHeight = UIScreen.main.bounds.height
        let fullInset = screenHeight * 0.05 // 5% of the screen height
        let fullAnchor = FloatingPanelLayoutAnchor(absoluteInset: fullInset, edge: .top, referenceGuide: .safeArea)
        let halfAnchor = FloatingPanelLayoutAnchor(fractionalInset: 0.8, edge: .bottom, referenceGuide: .safeArea)
        
        return [
            .full: fullAnchor,
            .half: halfAnchor // 기존 상태 유지
        ]
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 1.0
    }
    
    
}
