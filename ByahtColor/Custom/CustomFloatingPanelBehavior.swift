//
//  CustomFloatingPanelBehavior.swift
//  ByahtColor
//
//  Created by jaem on 2/6/25.
//
import FloatingPanel
class CustomFloatingPanelBehavior: FloatingPanelBehavior {
    func allowsRubberBanding(for edge: UIRectEdge) -> Bool {
        return true
    }

    func shouldProjectMomentum(_ fpc: FloatingPanelController, for proposedTargetPosition: FloatingPanelPosition) -> Bool {
        // 아주 작은 움직임에도 hidden 상태로 이동
        return true
    }
    
    func momentumProjectionRate(for fpc: FloatingPanelController) -> CGFloat {
        // 패널이 아래로 끌어당겨질 때 빠르게 반응
        return 0.5
    }
}
