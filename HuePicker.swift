//
//  HuePicker.swift
//  ScribbleKeys
//
//  Created by Matthias Schlemm on 06/03/15.
//  Copyright (c) 2015 Sixpolys. All rights reserved.
//

import UIKit

class HuePicker: UIView {
    
    struct Pixel {
        var a:UInt8 = 255
        var r:UInt8
        var g:UInt8
        var b:UInt8
        init(a:UInt8, r:UInt8, g:UInt8, b:UInt8) {
            self.a = a
            self.r = r
            self.g = g
            self.b = b
        }
    }

    var h:Double = 40
    var image:UIImage?
    private var data:[Pixel]?
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func renderBitmap() {
        layer.zPosition = 2000
        if bounds.isEmpty {
            return
        }
        
        var width = UInt(bounds.width)
        var height = UInt(bounds.height)
        
        if  data == nil {
            data = [Pixel]()
        }

        var p = 0.0
        var q = 0.0
        var t = 0.0

        var i = 0
        var a:UInt8 = 255
        var double_v:Double = 0
        var double_s:Double = 0
        for hi in 0..<Int(bounds.width) {
            var double_h:Double = Double(hi) / 60
            var sector:Int = Int(floor(double_h))
            var f:Double = double_h - Double(sector)
            var f1:Double = 1.0 - f
            double_v = Double(1)
            double_s = Double(1)
            p = double_v * (1.0 - double_s) * 255
            q = double_v * (1.0 - double_s * f) * 255
            t = double_v * ( 1.0 - double_s  * f1) * 255
            
            
            switch(sector) {
            case 0:
                data!.insert(Pixel(a: a, r: UInt8(255), g: UInt8(t), b: UInt8(p)), atIndex: i)
            case 1:
                data!.insert(Pixel(a: a, r: UInt8(q), g: UInt8(255), b: UInt8(p)), atIndex: i)
            case 2:
                data!.insert(Pixel(a: a, r: UInt8(p), g: UInt8(255), b: UInt8(t)), atIndex: i)
            case 3:
                data!.insert(Pixel(a: a, r: UInt8(p), g: UInt8(q), b: UInt8(255)), atIndex: i)
            case 4:
                data!.insert(Pixel(a: a, r: UInt8(t), g: UInt8(p), b: UInt8(255)), atIndex: i)
            default:
                data!.insert(Pixel(a: a, r: UInt8(255), g: UInt8(p), b: UInt8(q)), atIndex: i)
            }
            i = hi
        }
        for v in 1..<Int(bounds.height) {
            
            for s in 0..<Int(bounds.width) {
                data!.insert(data![s], atIndex: v * Int(bounds.width) + s)
                
            }
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedFirst.rawValue)
        var d = data!
        let provider = CGDataProviderCreateWithCFData(NSData(bytes: &d, length: data!.count * sizeof(Pixel)))
        var cgimg = CGImageCreate(width, height, 8, 32, width * UInt(sizeof(Pixel)),
            colorSpace, bitmapInfo, provider, nil, true, kCGRenderingIntentDefault)
        
        
        image = UIImage(CGImage: cgimg)
        
    }
    
    override func drawRect(rect: CGRect) {
        if image == nil {
            renderBitmap()
        }
        if let img = image {
            img.drawInRect(rect)
        }
    }

}
