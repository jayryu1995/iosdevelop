//
//  File.swift
//  ByahtColor
//
//  Created by jaem on 2023/09/13.
//

import AVFoundation
import CoreVideo
import MLKit
import UIKit

/// Defines UI-related utilitiy methods for vision detection.
public class UIUtilities {

    // MARK: - Public
    public static func addFilter(
        path: UIBezierPath,
        color: UIColor,
        to view: UIView
    ) -> CAShapeLayer {
        // CAShapeLayer를 생성합니다.
        let shapeLayer = CAShapeLayer()

        // shapeLayer의 path를 설정합니다.
        shapeLayer.path = path.cgPath

        // shapeLayer의 색상을 설정합니다.

        let hex: String = String(color.hexString!)

        if hex != "#DCDCDC"{
            shapeLayer.fillColor = color.withAlphaComponent(0.25).cgColor

            // view의 레이어에 shapeLayer를 추가합니다.
            view.layer.addSublayer(shapeLayer)
        }
        return shapeLayer
    }

    public static func addLipFilter(
        path: UIBezierPath,
        color: UIColor,
        to view: UIView
    ) -> CAShapeLayer {
        // CAShapeLayer를 생성합니다.
        let shapeLayer = CAShapeLayer()

        // shapeLayer의 path를 설정합니다.
        shapeLayer.path = path.cgPath

        // shapeLayer의 색상을 설정합니다.

        let hex: String = String(color.hexString!)

        if hex != "#DCDCDC"{
            shapeLayer.fillColor = color.withAlphaComponent(0.37).cgColor

            // view의 레이어에 shapeLayer를 추가합니다.
            view.layer.addSublayer(shapeLayer)
        }
        return shapeLayer

    }

    public static func imageOrientation(
        fromDevicePosition devicePosition: AVCaptureDevice.Position = .back
    ) -> UIImage.Orientation {
        var deviceOrientation = UIDevice.current.orientation
        if deviceOrientation == .faceDown || deviceOrientation == .faceUp
            || deviceOrientation
            == .unknown {
            deviceOrientation = currentUIOrientation()
        }
        switch deviceOrientation {
        case .portrait:
            return devicePosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return devicePosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return devicePosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return devicePosition == .front ? .upMirrored : .down
        case .faceDown, .faceUp, .unknown:
            return .up
        @unknown default:
            fatalError()
        }
    }
    public static func addCircle(
        atPoint point: CGPoint,
        to view: UIView,
        color: UIColor,
        radius: CGFloat
    ) {
        let divisor: CGFloat = 2.0
        let xCoord = point.x - radius / divisor
        let yCoord = point.y - radius / divisor
        let circleRect = CGRect(x: xCoord, y: yCoord, width: radius, height: radius)
        guard circleRect.isValid() else { return }
        let circleView = UIView(frame: circleRect)
        circleView.layer.cornerRadius = radius / divisor
        circleView.alpha = Constants.circleViewAlpha
        circleView.backgroundColor = color
        circleView.isAccessibilityElement = true
        circleView.accessibilityIdentifier = Constants.circleViewIdentifier
        view.addSubview(circleView)
    }
    private static func currentUIOrientation() -> UIDeviceOrientation {
        let deviceOrientation = { () -> UIDeviceOrientation in
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:
                return .landscapeRight
            case .landscapeRight:
                return .landscapeLeft
            case .portraitUpsideDown:
                return .portraitUpsideDown
            case .portrait, .unknown:
                return .portrait
            @unknown default:
                fatalError()
            }
        }
        guard Thread.isMainThread else {
            var currentOrientation: UIDeviceOrientation = .portrait
            DispatchQueue.main.sync {
                currentOrientation = deviceOrientation()
            }
            return currentOrientation
        }
        return deviceOrientation()
    }
    public static func createUIImage(
        from imageBuffer: CVImageBuffer,
        orientation: UIImage.Orientation
    ) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage, scale: Constants.originalScale, orientation: orientation)
    }

    public static func createImageBuffer(from image: UIImage) -> CVImageBuffer? {
      guard let cgImage = image.cgImage else { return nil }
      let width = cgImage.width
      let height = cgImage.height

        print("createImageBuffer size : \(width),\(height)")
      var buffer: CVPixelBuffer?
      CVPixelBufferCreate(
        kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, nil,
        &buffer)
      guard let imageBuffer = buffer else { return nil }

      let flags = CVPixelBufferLockFlags(rawValue: 0)
      CVPixelBufferLockBaseAddress(imageBuffer, flags)
      let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
      let context = CGContext(
        data: baseAddress, width: width, height: height, bitsPerComponent: 8,
        bytesPerRow: bytesPerRow, space: colorSpace,
        bitmapInfo: (CGImageAlphaInfo.premultipliedFirst.rawValue
          | CGBitmapInfo.byteOrder32Little.rawValue))

      if let context = context {
        let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)
        CVPixelBufferUnlockBaseAddress(imageBuffer, flags)
        return imageBuffer
      } else {
        CVPixelBufferUnlockBaseAddress(imageBuffer, flags)
        return nil
      }
    }

    // 배경제거 (원본코드와 다름) //
    public static func applySegmentationMask(
        mask: SegmentationMask, to imageBuffer: CVImageBuffer,
        backgroundColor: UIColor?, foregroundColor: UIColor?
    ) {
        assert(
            CVPixelBufferGetPixelFormatType(imageBuffer) == kCVPixelFormatType_32BGRA,
            "Image buffer must have 32BGRA pixel format type")

        let width = CVPixelBufferGetWidth(mask.buffer)
        let height = CVPixelBufferGetHeight(mask.buffer)

        assert(CVPixelBufferGetWidth(imageBuffer) == width, "Width must match")
        assert(CVPixelBufferGetHeight(imageBuffer) == height, "Height must match")

        if backgroundColor == nil && foregroundColor == nil {
            return
        }

        let writeFlags = CVPixelBufferLockFlags(rawValue: 0)
        CVPixelBufferLockBaseAddress(imageBuffer, writeFlags)
        CVPixelBufferLockBaseAddress(mask.buffer, CVPixelBufferLockFlags.readOnly)

        let maskBytesPerRow = CVPixelBufferGetBytesPerRow(mask.buffer)
        var maskAddress =
            CVPixelBufferGetBaseAddress(mask.buffer)!.bindMemory(
                to: Float32.self, capacity: maskBytesPerRow * height)

        let imageBytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        var imageAddress = CVPixelBufferGetBaseAddress(imageBuffer)!.bindMemory(
            to: UInt8.self, capacity: imageBytesPerRow * height)

        for _ in 0..<height {
            for col in 0..<width {
                let pixelOffset = col * Constants.bgraBytesPerPixel
                let alphaOffset = pixelOffset + 3

                let maskValue: CGFloat = CGFloat(maskAddress[col])
                let backgroundRegionRatio: CGFloat = 1.0 - maskValue

                // 배경인 경우 알파 채널을 0으로 설정하여 투명하게 만듭니다.
                if backgroundRegionRatio > 0.5 {
                    imageAddress[alphaOffset] = 0
                }
            }

            imageAddress += imageBytesPerRow / MemoryLayout<UInt8>.size
            maskAddress += maskBytesPerRow / MemoryLayout<Float32>.size
        }

        CVPixelBufferUnlockBaseAddress(imageBuffer, writeFlags)
        CVPixelBufferUnlockBaseAddress(mask.buffer, CVPixelBufferLockFlags.readOnly)
    }

}

private enum Constants {
    static let circleViewAlpha: CGFloat = 0.7
    static let rectangleViewAlpha: CGFloat = 0.3
    static let shapeViewAlpha: CGFloat = 0.3
    static let rectangleViewCornerRadius: CGFloat = 10.0
    static let maxColorComponentValue: CGFloat = 255.0
    static let originalScale: CGFloat = 1.0
    static let bgraBytesPerPixel = 4
    static let circleViewIdentifier = "MLKit Circle View"
    static let lineViewIdentifier = "MLKit Line View"
    static let rectangleViewIdentifier = "MLKit Rectangle View"
}

// MARK: - Extension

extension CGRect {
    /// Returns a `Bool` indicating whether the rectangle's values are valid`.
    func isValid() -> Bool {
        return
        !(origin.x.isNaN || origin.y.isNaN || width.isNaN || height.isNaN || width < 0 || height < 0)
    }
}
