import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRUtils {
    static let context = CIContext()
    static let filter = CIFilter.qrCodeGenerator()
    
    static func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            // Scale up the image for better quality
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
