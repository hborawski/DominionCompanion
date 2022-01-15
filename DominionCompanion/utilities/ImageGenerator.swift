import UIKit
enum ImageGeneratorError: Error {
    case failed
}
class ImageGenerator {
    static let shared = ImageGenerator()
    
    enum Axis {
        case vertical
        case horizontal
    }

    func combineImages(_ images: [UIImage], on axis: Axis = .horizontal) -> UIImage? {
        guard images.count > 0 else { return nil }
        defer { UIGraphicsEndImageContext() }
        let height = axis == .horizontal ? (images.map(\.size.height).reduce(0, max)) : images.map(\.size.height).reduce(0, +)
        let width = axis == .horizontal ? images.map(\.size.width).reduce(0, +) : images.map(\.size.width).reduce(0, max)
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        for i in 0..<images.count {
            let image = images[i]
            let width = image.size.width
            let height = image.size.height
            let drawArea = CGRect(x: xOffset, y: yOffset, width: width, height: height)
            images[i].draw(in: drawArea)
            if axis == .horizontal {
                xOffset += width
            } else {
                yOffset += height
            }
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
