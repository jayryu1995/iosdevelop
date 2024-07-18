//
//  CanvasView.swift
//  ByahtColor
//
//  Created by jaem on 2023/05/23.
//

import UIKit

class CanvasView: UIView {

    private var cropRect: CGRect?
    private var canvasSize: CGSize = .zero
    private let shapeLayer = CAShapeLayer()
    private var image: UIImage?
    private var points: [CGPoint] = []
    var drawImage: UIImage?
    var pointPath = UIBezierPath()

    // 뷰가 로드되거나 레이아웃이 변경될 때마다 호출되는 메서드

    override func layoutSubviews() {
        super.layoutSubviews()

        // 자체 사이즈 업데이트
        canvasSize = bounds.size

        // 제스처 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)

        var centerX: CGFloat!
        var centerY: CGFloat!
        var rectTop: CGPoint!
        var rectRight: CGPoint!
        var rectLeft: CGPoint!
        var rectBottom: CGPoint!

        centerX = canvasSize.width / 2
        centerY = canvasSize.height / 3

        // 상
        rectTop = CGPoint(x: centerX, y: centerY - 100)
        // 우
        rectRight = CGPoint(x: centerX + 80, y: centerY)
        // 좌
        rectLeft = CGPoint(x: centerX - 80, y: centerY)
        // 하
        rectBottom = CGPoint(x: centerX, y: centerY + 100)

        // 포인트 추가
        if points.isEmpty {

            addPoint(rectTop)
            addPoint(rectBottom)
            addPoint(rectLeft)
            addPoint(rectRight)

        }

    }

    // 이미지 그리기
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clearsContextBeforeDrawing = true
        drawCircleWithPoints(top: points[0], bottom: points[1], left: points[2], right: points[3])

    }

    // 좌표를 추가하는 메서드
    func addPoint(_ point: CGPoint) {
        points.append(point)

    }

    // 점 그리기
    private func drawPoint(_ point: CGPoint) {

        let radius: CGFloat = 5.0
        let circleRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        pointPath = UIBezierPath(ovalIn: circleRect)
        UIColor.blue.setFill()
        pointPath.fill()

    }

    // 원 그리기
    func drawCircleWithPoints(top: CGPoint, bottom: CGPoint, left: CGPoint, right: CGPoint) {

        let firstX = left.x
        let firstY = top.y
        let width = right.x - left.x
        let height = bottom.y - top.y

        // 사각형 그리기
        let circleRect = CGRect(x: firstX, y: firstY, width: width, height: height)
        cropRect = circleRect

        // 원 그리기
        let circlePath = UIBezierPath(ovalIn: circleRect)
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(hex: "#FF79C2").cgColor
        shapeLayer.lineWidth = 2.0

        layer.addSublayer(shapeLayer)
        for point in points {

            drawPoint(point)
        }
    }

    // 드래그를 위한 변수
    private var index: Int?
    private var dragCircle: Bool? = false

    // 사용자 입력 (드래그)을 처리하는 메서드
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {

        let location = gesture.location(in: self.superview)
        switch gesture.state {
        case .began:

            let x1 = points[0].x
            let y1 = points[2].y
            let x2 = points[1].x
            let y2 = points[3].y

            let centerX = (x1 + x2) / 2
            let centerY = (y1 + y2) / 2

            let centerXY = CGPoint(x: centerX, y: centerY)
            // 원 위치
            if distance(from: centerXY, to: location) < 30.0 {
                dragCircle = true

            } else {
                for i in 0..<points.endIndex where distance(from: points[i], to: location) < 20.0 {
                    index = i
                    break
                }
            }

        case.changed:
            // 원 위치 변경
            if dragCircle == true {

                let rect = CropRect(vx: location.x, vy: location.y)
                points[0] = CGPoint(x: location.x, y: rect!.minY)
                points[1] = CGPoint(x: location.x, y: rect!.maxY)
                points[2] = CGPoint(x: rect!.minX, y: location.y)
                points[3] = CGPoint(x: rect!.maxX, y: location.y)

            } else {
                // 원 크기 변경
                if index != nil {
                    // top
                    if index == 0 {
                        points[index!].y = location.y
                        let center = (points[0].y + points[1].y) / 2
                        points[2].y = center
                        points[3].y = center

                    } else if index == 1 {
                        // bottom
                        points[index!].y = location.y
                        let center = (points[0].y + points[1].y) / 2
                        points[2].y = center
                        points[3].y = center
                    } else if index == 2 {
                        // left
                        points[index!].x = location.x
                        let center = (points[2].x + points[3].x) / 2
                        points[0].x = center
                        points[1].x = center
                    } else if index == 3 {
                        // right
                        points[index!].x = location.x
                        let center = (points[2].x + points[3].x) / 2
                        points[0].x = center
                        points[1].x = center
                    }
                }

            }
            setNeedsDisplay()
        case.ended:
            dragCircle = false
            index = nil

        default:
            break
        }

    }

    // 좌표사이 거리 계산
    func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }

    // 원의 범위 만큼의 좌표로 사각형 리턴
    func CircleRect() -> CGRect? {
        var dy: CGFloat!
        var ry: CGFloat!
        if points[0].y < points[1].y {
            dy = points[0].y
            ry = points[1].y
        } else {
            dy = points[1].y
            ry = points[0].y
        }

        var dx: CGFloat!
        var rx: CGFloat!
        if points[2].x < points[3].x {
            dx = points[2].x
            rx = points[3].x
        } else {
            dx = points[3].x
            rx = points[2].x
        }

        // 가로세로 반대로 넣어줘야됨..
        let rect = CGRect(x: dx, y: dy, width: ry - dy, height: rx - dx)
        return rect
    }

    // 잘라낸 이미지 크기의 사각형 리턴
    func CropRect(vx: CGFloat, vy: CGFloat) -> CGRect? {
        // 중점 찾기

        var dy: CGFloat!
        var ry: CGFloat!
        var dx: CGFloat!
        var rx: CGFloat!
        // x y 좌표
        if points[0].y < points[1].y {
            dy = points[0].y
            ry = points[1].y
        } else {
            dy = points[1].y
            ry = points[0].y
        }

        if points[2].x < points[3].x {
            dx = points[2].x
            rx = points[3].x
        } else {
            dx = points[3].x
            rx = points[2].x
        }

        // 사각형 가로,세로 길이
        let width = rx - dx
        let height = ry - dy

        // 잘라낸 이미지의 중점 좌표에서 최소x,y값과의 차
        let centerX = (dx + rx) / 2 - dx
        let centerY = (dy + ry) / 2 - dy

        // 잘라낸 이미지 크기만큼의 사각형 생성(이미지뷰의 중점 기준으로 생성)
        let rect = CGRect(x: vx - centerX, y: vy - centerY, width: width, height: height)
        return rect
    }

    func cropInsideCircle(image: UIImage) -> UIImage? {
        // 원의 영역을 가져옵니다.
        guard let circleRect = self.CircleRect() else { return nil }

        // 가로와 세로의 크기를 올바르게 설정합니다.
        let correctCircleRect = CGRect(x: circleRect.origin.x, y: circleRect.origin.y, width: circleRect.height, height: circleRect.width)

        UIGraphicsBeginImageContextWithOptions(correctCircleRect.size, false, image.scale)
        defer { UIGraphicsEndImageContext() }

        // 원형 클리핑 영역 설정
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: correctCircleRect.size))
        circlePath.addClip()

        // 원본 이미지를 그립니다.
        let drawX = -correctCircleRect.origin.x
        let drawY = -correctCircleRect.origin.y
        image.draw(at: CGPoint(x: drawX, y: drawY))

        // 결과 이미지를 반환합니다.
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}
