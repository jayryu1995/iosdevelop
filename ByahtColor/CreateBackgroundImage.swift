import UIKit

class CreateBackgroundImage {

    // 단색 배경
    func drawSingleWholeBackground(size: CGSize, color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            let path = UIBezierPath(rect: CGRect(origin: .zero, size: size))
            color.setFill()
            path.fill()

            // 가운데 원 모양을 투명하게 그립니다.
            let circleCenter = CGPoint(x: size.width / 2.0, y: size.height / 1.8)
            let width = circleCenter.x
            let height = circleCenter.y
            let originX = circleCenter.x - (width/2.0)
            let originY = circleCenter.y - (height/1.8)
            let rect = CGRect(x: originX, y: originY, width: width, height: height)
            let transparentCirclePath = UIBezierPath(ovalIn: rect)
            UIColor.clear.setFill()
            transparentCirclePath.fill()
            transparentCirclePath.fill(with: .clear, alpha: 1.0)
        }
        return image
    }

    // 2색
    func drawTwoWholeColorBackground(size: CGSize, colors: [UIColor]) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { ctx in
            let halfWidth = size.width / 2

            // 첫 번째 색상으로 왼쪽 반을 채웁니다.
            ctx.cgContext.setFillColor(colors[0].cgColor)
            let rect1 = CGRect(x: 0, y: 0, width: halfWidth, height: size.height)
            ctx.cgContext.fill(rect1)

            // 두 번째 색상으로 오른쪽 반을 채웁니다.
            if colors.count > 1 {
                ctx.cgContext.setFillColor(colors[1].cgColor)
                let rect2 = CGRect(x: halfWidth, y: 0, width: halfWidth, height: size.height)
                ctx.cgContext.fill(rect2)
            }

            // 가운데 원 모양을 투명하게 그립니다.
            let circleCenter = CGPoint(x: size.width / 2.0, y: size.height / 1.8)
            let width = circleCenter.x
            let height = circleCenter.y
            let originX = circleCenter.x - (width/2.0)
            let originY = circleCenter.y - (height/1.8)
            let rect = CGRect(x: originX, y: originY, width: width, height: height)
            let transparentCirclePath = UIBezierPath(ovalIn: rect)
            UIColor.clear.setFill()
            transparentCirclePath.fill()
            transparentCirclePath.fill(with: .clear, alpha: 1.0)
        }

        return image
    }

    // 3가지색 카메라 배경
    func drawThreeWholeColorBackground(size: CGSize, colors: [UIColor]) -> UIImage? {
        guard colors.count >= 3 else { return nil }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            // Define the rectangle areas.
            let topRect = CGRect(x: 0, y: 0, width: size.width, height: size.height / 2)
            let bottomLeftRect = CGRect(x: 0, y: size.height / 2, width: size.width / 2, height: size.height / 2)
            let bottomRightRect = CGRect(x: size.width / 2, y: size.height / 2, width: size.width / 2, height: size.height / 2)

            // Set colors and fill each rectangle.
            ctx.cgContext.setFillColor(colors[0].cgColor)
            ctx.cgContext.fill(topRect)

            ctx.cgContext.setFillColor(colors[1].cgColor)
            ctx.cgContext.fill(bottomLeftRect)

            ctx.cgContext.setFillColor(colors[2].cgColor)
            ctx.cgContext.fill(bottomRightRect)

            // 가운데 원 모양을 투명하게 그립니다.
            let circleCenter = CGPoint(x: size.width / 2.0, y: size.height / 1.8)
            let width = circleCenter.x
            let height = circleCenter.y
            let originX = circleCenter.x - (width/2.0)
            let originY = circleCenter.y - (height/1.8)
            let rect = CGRect(x: originX, y: originY, width: width, height: height)
            let transparentCirclePath = UIBezierPath(ovalIn: rect)
            UIColor.clear.setFill()
            transparentCirclePath.fill()
            transparentCirclePath.fill(with: .clear, alpha: 1.0)
        }
    }

    // 4색 배경
    func drawFourWholeColorBackground(size: CGSize, array: [UIColor]) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { ctx in
            let colorArray: [UIColor] = array

            let halfWidth = size.width / 2
            let halfHeight = size.height / 2

            let rect1 = CGRect(x: 0, y: 0, width: halfWidth, height: halfHeight)
            let rect2 = CGRect(x: halfWidth, y: 0, width: halfWidth, height: halfHeight)
            let rect3 = CGRect(x: 0, y: halfHeight, width: halfWidth, height: halfHeight)
            let rect4 = CGRect(x: halfWidth, y: halfHeight, width: halfWidth, height: halfHeight)

            let rectArray = [rect1, rect2, rect3, rect4]

            for index in 0...colorArray.endIndex-1 {
                // Draw rectangles with respective colors
                ctx.cgContext.setFillColor(colorArray[index].cgColor)
                ctx.cgContext.fill(rectArray[index])

            }

            // 가운데 원 모양을 투명하게 그립니다.
            let circleCenter = CGPoint(x: size.width / 2.0, y: size.height / 1.8)
            let width = circleCenter.x
            let height = circleCenter.y
            let originX = circleCenter.x - (width/2.0)
            let originY = circleCenter.y - (height/1.8)
            let rect = CGRect(x: originX, y: originY, width: width, height: height)
            let transparentCirclePath = UIBezierPath(ovalIn: rect)
            UIColor.clear.setFill()
            transparentCirclePath.fill()
            transparentCirclePath.fill(with: .clear, alpha: 1.0)

        }

        return image
    }
    // 16가지 색 배경
    func drawSixteenWholeBackground(size: CGSize, array: [UIColor]) -> UIImage {
        let width = size.width
        let height = size.height
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { _ in
            let colorArray: [UIColor] = array
            var i = 0
            var j = 1

            for index in 0...colorArray.endIndex-1 {
                let path = UIBezierPath()

                if index < 4 {
                    // 위쪽 가로선 그리기
                    path.move(to: CGPoint(x: width * CGFloat(i)/4.0, y: 0))
                    path.addLine(to: CGPoint(x: width * CGFloat(j)/4.0, y: 0))
                    i += 1
                    j += 1

                } else if index < 8 {
                    // 오른쪽 세로
                    if index == 4 {
                        i = 0
                        j = 1
                    }
                    // 오른쪽 세로선 그리기
                    path.move(to: CGPoint(x: width, y: height * CGFloat(i)/4.0))
                    path.addLine(to: CGPoint(x: width, y: height * CGFloat(j)/4.0))
                    i += 1
                    j += 1

                } else if index < 12 {
                    if index == 8 {
                        i = 0
                        j = 1
                    }
                    // 아래쪽 가로선 그리기
                    path.move(to: CGPoint(x: width * CGFloat(4-i)/4.0, y: height))
                    path.addLine(to: CGPoint(x: width * CGFloat(4-j)/4.0, y: height))
                    i += 1
                    j += 1

                } else {
                    if index == 12 {
                        i = 0
                        j = 1
                    }
                    // 왼쪽 세로선 그리기
                    path.move(to: CGPoint(x: 0, y: height * CGFloat(4-i)/4.0))
                    path.addLine(to: CGPoint(x: 0, y: height * CGFloat(4-j)/4.0))
                    i += 1
                    j += 1

                }

                // 팔각별의 중심점에 선 그리기
                path.addLine(to: CGPoint(x: width/2, y: height/2))
                path.close()

                // 해당 인덱스에 해당하는 색으로 채우기
                colorArray[index].setFill()
                path.fill()

                // 가운데 원 모양을 투명하게 그립니다.
                let circleCenter = CGPoint(x: size.width / 2.0, y: size.height / 1.8)
                let width = circleCenter.x
                let height = circleCenter.y
                let originX = circleCenter.x - (width/2.0)
                let originY = circleCenter.y - (height/1.8)
                let rect = CGRect(x: originX, y: originY, width: width, height: height)
                let transparentCirclePath = UIBezierPath(ovalIn: rect)
                UIColor.clear.setFill()
                transparentCirclePath.fill()
                transparentCirclePath.fill(with: .clear, alpha: 1.0)
            }

        }
        return image
    }

    // 이미지 가운데 투명하게 만들기
    func drawWholeImage(size: CGSize, image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let newImage = renderer.image { context in

            // 먼저 전체 이미지를 그립니다.
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

            // 그 다음 가운데 원 모양을 투명하게 그립니다.
            let circleCenter = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            let width = circleCenter.x
            let height = circleCenter.y
            let originX = circleCenter.x - (width/2.0)
            let originY = circleCenter.y - (height/2.0)
            let rect = CGRect(x: originX, y: originY, width: width, height: height)
            let transparentCirclePath = UIBezierPath(ovalIn: rect)

            // 현재의 그래픽 컨텍스트에서 클리핑 영역으로 원을 설정합니다.
            transparentCirclePath.addClip()

            // 클리핑 영역(즉, 원)을 투명한 색상으로 채웁니다.
            context.cgContext.setBlendMode(.clear)
            context.cgContext.setFillColor(UIColor.clear.cgColor)
            context.cgContext.fillEllipse(in: rect)
        }

        return newImage
    }

    // 채워진 배경 //

    // 단색 배경 그리기
    func drawSingleColorBackground(size: CGSize, color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            let path = UIBezierPath(rect: CGRect(origin: .zero, size: size))
            color.setFill()
            path.fill()
        }
        return image
    }

    // 두가지 색
    func drawTwoColorBackground(size: CGSize, colors: [UIColor]) -> UIImage {
        // 올바른 색상 수를 가지고 있는지 확인합니다.
        guard colors.count >= 2 else {
            fatalError("Colors array needs at least two colors to create a two color background.")
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            // 두 개의 사각형을 정의합니다: 왼쪽 및 오른쪽
            let leftRect = CGRect(x: 0, y: 0, width: size.width / 2, height: size.height)
            let rightRect = CGRect(x: size.width / 2, y: 0, width: size.width / 2, height: size.height)

            // 왼쪽 사각형에 첫 번째 색상을 채웁니다.
            ctx.cgContext.setFillColor(colors[0].cgColor)
            ctx.cgContext.fill(leftRect)

            // 오른쪽 사각형에 두 번째 색상을 채웁니다.
            ctx.cgContext.setFillColor(colors[1].cgColor)
            ctx.cgContext.fill(rightRect)
        }

        return image
    }
    // 3가지 색
    func createThreePartColoredImage(size: CGSize, colors: [UIColor]) -> UIImage? {
        guard colors.count >= 3 else { return nil }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            // Define the rectangle areas.
            let topRect = CGRect(x: 0, y: 0, width: size.width, height: size.height / 2)
            let bottomLeftRect = CGRect(x: 0, y: size.height / 2, width: size.width / 2, height: size.height / 2)
            let bottomRightRect = CGRect(x: size.width / 2, y: size.height / 2, width: size.width / 2, height: size.height / 2)

            // Set colors and fill each rectangle.
            ctx.cgContext.setFillColor(colors[0].cgColor)
            ctx.cgContext.fill(topRect)

            ctx.cgContext.setFillColor(colors[1].cgColor)
            ctx.cgContext.fill(bottomLeftRect)

            ctx.cgContext.setFillColor(colors[2].cgColor)
            ctx.cgContext.fill(bottomRightRect)
        }
    }

    // 4가지 색 배경
    func drawFourColorBackground(size: CGSize, array: [UIColor]) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { ctx in
            let colorArray: [UIColor] = array

            let halfWidth = size.width / 2
            let halfHeight = size.height / 2

            let rect1 = CGRect(x: 0, y: 0, width: halfWidth, height: halfHeight)
            let rect2 = CGRect(x: halfWidth, y: 0, width: halfWidth, height: halfHeight)
            let rect3 = CGRect(x: 0, y: halfHeight, width: halfWidth, height: halfHeight)
            let rect4 = CGRect(x: halfWidth, y: halfHeight, width: halfWidth, height: halfHeight)

            let rectArray = [rect1, rect2, rect3, rect4]

            for index in 0...colorArray.endIndex-1 {
                // Draw rectangles with respective colors
                ctx.cgContext.setFillColor(colorArray[index].cgColor)
                ctx.cgContext.fill(rectArray[index])

            }

        }

        return image
    }

    // 16가지 색 배경
    func drawSixteenBackground(size: CGSize, array: [UIColor]) -> UIImage {
        let width = size.width
        let height = size.height
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { _ in
            let colorArray: [UIColor] = array
            var i = 0
            var j = 1

            for index in 0...colorArray.endIndex-1 {
                let path = UIBezierPath()

                if index < 4 {
                    // 위쪽 가로선 그리기
                    path.move(to: CGPoint(x: width * CGFloat(i)/4.0, y: 0))
                    path.addLine(to: CGPoint(x: width * CGFloat(j)/4.0, y: 0))
                    i += 1
                    j += 1

                } else if index < 8 {
                    // 오른쪽 세로
                    if index == 4 {
                        i = 0
                        j = 1
                    }
                    // 오른쪽 세로선 그리기
                    path.move(to: CGPoint(x: width, y: height * CGFloat(i)/4.0))
                    path.addLine(to: CGPoint(x: width, y: height * CGFloat(j)/4.0))
                    i += 1
                    j += 1

                } else if index < 12 {
                    if index == 8 {
                        i = 0
                        j = 1
                    }
                    // 아래쪽 가로선 그리기
                    path.move(to: CGPoint(x: width * CGFloat(4-i)/4.0, y: height))
                    path.addLine(to: CGPoint(x: width * CGFloat(4-j)/4.0, y: height))
                    i += 1
                    j += 1

                } else {
                    if index == 12 {
                        i = 0
                        j = 1
                    }
                    // 왼쪽 세로선 그리기
                    path.move(to: CGPoint(x: 0, y: height * CGFloat(4-i)/4.0))
                    path.addLine(to: CGPoint(x: 0, y: height * CGFloat(4-j)/4.0))
                    i += 1
                    j += 1

                }

                // 팔각별의 중심점에 선 그리기
                path.addLine(to: CGPoint(x: width/2, y: height/2))
                path.close()

                // 해당 인덱스에 해당하는 색으로 채우기
                colorArray[index].setFill()
                path.fill()

            }

        }
        return image
    }

}
