//
//  JMExtension+Color.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//  Copyright © 2022 JunMing. All rights reserved.
//

import Foundation

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    /// 随机颜色
    public class var jmRandColor: UIColor {
        let R = Int(arc4random_uniform(256))
        let G = Int(arc4random_uniform(256))
        let B = Int(arc4random_uniform(256))
        return jmRGB(R,G,B)
    }
    
    /// 颜色透明度
    public func jmComponent(_ alpha: CGFloat ) -> UIColor {
        return withAlphaComponent(alpha)
    }
    
    /// 字符串生成颜色
    public class func jmHexColor(_ hexStr: String ) -> UIColor{
        return UIColor(hex: hexStr)
    }
    
    /// 32位数字生成颜色 0xffff
    public class func jmRGBAValue(rgbValue: UInt32, alpha: CGFloat) -> UIColor {
        let red = (rgbValue & 0xFF0000) >> 16
        let green = (rgbValue & 0xFF0000) >> 16
        let blue = (rgbValue & 0xFF0000) >> 16
        return jmRGBA(Int(red), Int(green), Int(blue), alpha)
    }
    
    /// 32位数字生成颜色 0xffff
    public class func jmRGBValue(_ rgbValue: UInt32) -> UIColor{
        return UIColor.jmRGBAValue(rgbValue:rgbValue, alpha:1)
    }
    
    /// R、G、B、A生成颜色
    public class func jmRGBA(_ R: Int, _ G: Int, _ B: Int, _ A: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(Float(R) / 255.0), green: CGFloat(Float(G) / 255.0), blue: CGFloat(Float(B) / 255.0), alpha: A)
    }
    
    /// R、G、B生成颜色
    public class func jmRGB(_ R: Int, _ G: Int, _ B: Int) -> UIColor{
        return UIColor.jmRGBA(R,G,B,1)
    }
}
