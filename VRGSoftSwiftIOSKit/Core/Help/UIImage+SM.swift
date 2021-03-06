//
//  UIImage+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/18/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public extension SMWrapper where Base: UIImage {
    
    static func imageWith(color aColor: UIColor, size aSize: CGSize) -> UIImage? {
        
        let rect: CGRect = CGRect(origin: CGPoint(), size: aSize)
        UIGraphicsBeginImageContext(rect.size)
        
        let context: CGContext?  =  UIGraphicsGetCurrentContext()

        context?.setFillColor(aColor.cgColor)
        context?.fill(rect)
        
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func tintedImageWith(color aColor: UIColor) -> UIImage? {
        
        var result: UIImage?
        
        let scale: CGFloat = base.scale
        let size: CGSize = CGSize(width: scale*base.size.width, height: scale*base.size.height)
        UIGraphicsBeginImageContext(size)
        
        let context: CGContext? = UIGraphicsGetCurrentContext()

        context?.translateBy(x: 0.0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        let rect: CGRect = CGRect(origin: CGPoint.zero, size: size)
        context?.setBlendMode(CGBlendMode.normal)
        
        if let cgI: CGImage = base.cgImage {
            
            context?.draw(cgI, in: rect)
        }
        
        context?.setBlendMode(CGBlendMode.sourceIn)
        context?.setFillColor(aColor.cgColor)
        context?.fill(rect)
        
        if let image: CGImage = context?.makeImage() {
            
            result = UIImage(cgImage: image, scale: scale, orientation: base.imageOrientation)
        }
        
        return result
    }
    
    static func resizableImageWith(color aColor: UIColor) -> UIImage? {
        
        let image: UIImage? = imageWith(color: aColor, size: CGSize(width: 1, height: 1))?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: UIImage.ResizingMode.stretch)
        return image
    }
    
    var roundedImage: UIImage? {
        
        let rect: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: base.size)
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        UIBezierPath(roundedRect: rect, cornerRadius: base.size.height).addClip()
        base.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func dataJPEGWithkBSize(aKbSize: Int) -> Data? {
        
        let maxCompression: CGFloat = 0.1
        let maxFileSize: Int = aKbSize*1024
        
        var compression: CGFloat = 1.0
        
        var data: Data? = base.jpegData(compressionQuality: compression)
        
        while let length: Int = data?.count, length > maxFileSize, compression > maxCompression {
            
            compression -= 0.05
            data = base.jpegData(compressionQuality: compression)
        }
        
        data = base.jpegData(compressionQuality: compression+0.02)
        
        return data
    }
    
    func fixedOrientation() -> UIImage? {
        
        if base.imageOrientation == .up {
            
            return base
        }
        
        var transform: CGAffineTransform = .identity
        
        switch base.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: base.size.width, y: base.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: base.size.width, y: 0)
            transform = transform.rotated(by: .pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: base.size.height)
            transform = transform.rotated(by: -.pi/2)
        case .up, .upMirrored:
            break
        @unknown default: break
            
        }
        
        switch base.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: base.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: base.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default: break

        }
        
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context: CGContext = CGContext(data: nil, width: Int(UInt(base.size.width)), height: Int(UInt(
            base.size.height)), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }
        
        context.concatenate(transform)
        
        if let cgI: CGImage = base.cgImage {
            
            switch base.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                context.draw(cgI, in: CGRect(x: 0, y: 0, width: base.size.height, height: base.size.width))
            default:
                context.draw(cgI, in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
            }
        }
        
        guard let cgImage: CGImage = context.makeImage() else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}


extension UIImage: SMCompatible { }
