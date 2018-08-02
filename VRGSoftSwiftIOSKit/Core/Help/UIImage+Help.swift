//
//  UIImage+Help.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/18/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

extension UIImage
{
    open class func imageWith(color aColor: UIColor, size aSize: CGSize) -> UIImage?
    {
        let rect: CGRect = CGRect(origin: CGPoint(), size: aSize)
        UIGraphicsBeginImageContext(rect.size)
        
        let context: CGContext?  =  UIGraphicsGetCurrentContext()

        context?.setFillColor(aColor.cgColor)
        context?.fill(rect)
        
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    open func sm_tintedImageWith(color aColor: UIColor) -> UIImage?
    {
        var result: UIImage?
        
        let scale: CGFloat = self.scale
        let size: CGSize = CGSize(width: scale*self.size.width, height: scale*self.size.height)
        UIGraphicsBeginImageContext(size)
        
        let context: CGContext? = UIGraphicsGetCurrentContext()

        context?.translateBy(x: 0.0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        context?.setBlendMode(CGBlendMode.normal)
        
        if let cgI: CGImage = cgImage
        {
            context?.draw(cgI, in: rect)
        }
        
        context?.setBlendMode(CGBlendMode.sourceIn)
        context?.setFillColor(aColor.cgColor)
        context?.fill(rect)
        if let image: CGImage = context?.makeImage()
        {
            result = UIImage(cgImage: image, scale: scale, orientation: self.imageOrientation)
        }
        
        return result
    }
    
    open class func resizableImageWith(color aColor: UIColor) -> UIImage?
    {
        let image: UIImage? = imageWith(color: aColor, size: CGSize(width: 1, height: 1))?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: UIImageResizingMode.stretch)
        return image
    }
    
    open var roundedImage: UIImage?
    {
        let rect: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        UIBezierPath(roundedRect: rect, cornerRadius: self.size.height).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    open func dataJPEGWithkBSize(aKbSize: Int) -> Data?
    {
        let maxCompression: CGFloat = 0.1
        let maxFileSize: Int = aKbSize*1024
        
        var compression: CGFloat = 1.0
        
        var data: Data? = UIImageJPEGRepresentation(self, compression)
        
        while let length: Int = data?.count, length > maxFileSize, compression > maxCompression
        {
            compression -= 0.05
            data = UIImageJPEGRepresentation(self, compression)
        }
        
        data = UIImageJPEGRepresentation(self, compression+0.02)
        
        return data
    }
    
    open func fixedOrientation() -> UIImage?
    {
        if imageOrientation == .up
        {
            return self
        }
        
        var transform: CGAffineTransform = .identity
        
        switch imageOrientation
        {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi/2)
        case .up, .upMirrored:
            break
        }
        
        switch imageOrientation
        {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context: CGContext = CGContext(data: nil, width: Int(UInt(size.width)), height: Int(UInt(
            size.height)), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }
        
        context.concatenate(transform)
        
        if let cgI: CGImage = cgImage
        {
            switch imageOrientation
            {
            case .left, .leftMirrored, .right, .rightMirrored:
                context.draw(cgI, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            default:
                context.draw(cgI, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
        }
        
        guard let cgImage: CGImage = context.makeImage() else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
