//
//  JMExtension+Utils.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//  Copyright © 2022 JunMing. All rights reserved.
//

import Foundation

extension UIFont {
    public var medium: UIFont {
        if let font = UIFont(name: "PingFangSC-Medium", size: 23) {
            return font
        }
        return UIFont.systemFont(ofSize: 23)
    }
    
    public class func jmRegular(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Regular", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    public class func jmAvenir(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Avenir-Light", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    public class func jmMedium(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Medium", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    public class func jmBold(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Helvetica-Bold", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}

extension Int {
    /// 获取随机数
    public static func jmRandom(from: Int, to: Int) -> Int {
        guard from < to else { fatalError("`from` MUST be less than `to`") }
        let delta = UInt32(to + 1 - from)
        return from + Int(arc4random_uniform(delta))
    }
    
    /// 数字转时间
    public var jmCurrentTime: String {
        if self > 3600 {
            return "\(self/3600)时\(self/60%60)分\(self%60)秒"
        }
        
        if self > 60 && self < 3600 {
            return "\(self/60)分\(self%60)秒"
        }
        
        if self < 60 {
            return "\(self)秒"
        }
        return ""
    }
}

extension CGRect {
    public static func Rect(_ x: CGFloat,_ y: CGFloat,_ width: CGFloat,_ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    public static func Rect(_ width: CGFloat,_ height: CGFloat) -> CGRect {
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
}

extension Double {
    /// date
    public var jmDate: Date {
        return Date(timeIntervalSince1970: self)
    }
}

extension Date {
    /// 时间戳字符串
    public static func jmCreateTspString() -> String {
        let tmp = Date(timeIntervalSinceNow: 0).timeIntervalSince1970
        return String(tmp).components(separatedBy: ".")[0]
    }
    /// 当前时间戳
    public static var jmCurrentTime: TimeInterval {
        return Date(timeIntervalSinceNow: 0).timeIntervalSince1970
    }
    
    public func jmIsToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
}
