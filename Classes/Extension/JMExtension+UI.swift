//
//  JMExtension+UI.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import UIKit
import SnapKit

public extension UIView {
    /// 快捷添加分割线
    func addLineToView(color:UIColor = .groupTableViewBackground, _ closure: (_ make: ConstraintMaker) -> Void) {
        let line = UIView()
        line.backgroundColor = color
        addSubview(line)
        line.snp.makeConstraints { closure($0)}
    }
}

extension UILabel {
    /// 配置字符串
    public func jmConfigLabel(alig: NSTextAlignment = .left,font:UIFont?,color:UIColor = UIColor.gray) {
        self.numberOfLines = 0
        self.textColor = color
        self.font = font
        self.textAlignment = alig
    }
}

@objc public extension UIImage {
    class func bundleImage(name: String) -> UIImage? {
        func findBundle(_ bundleName:String,_ podName:String) -> Bundle? {
            if var bundleUrl = Bundle.main.url(forResource: "Frameworks", withExtension: nil) {
                bundleUrl = bundleUrl.appendingPathComponent(podName)
                bundleUrl = bundleUrl.appendingPathExtension("framework")
                if let bundle = Bundle(url: bundleUrl),let url = bundle.url(forResource: bundleName, withExtension: "bundle") {
                    return Bundle(url: url)
                }
                return nil
            }
            return nil
        }
                
        if let bundle = findBundle("MsgResource", "NetMessage") {
            let scare = UIScreen.main.scale
            let imaName = String(format: "%@@%dx.png", name, Int(scare))
            if let imagePath = bundle.path(forResource: imaName, ofType: nil) {
                return UIImage(contentsOfFile: imagePath)
            }
            return nil
        }
        return nil
    }
    
    // 142, 42
    func resizable(isLeft: Bool) -> UIImage {
        let h = size.height
        let edge = UIEdgeInsets(top: h - 10, left: isLeft ? 40 : 0, bottom: h, right: isLeft ? 0 : 40)
        return resizableImage(withCapInsets: edge, resizingMode: .stretch)
    }
}

// MARK: -- UIViewController --
@objc public extension UIViewController {
    /// push
    func push(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// pop
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    /// present
    func present(_ vc: UIViewController, style: UIModalPresentationStyle = .fullScreen) {
        vc.modalPresentationStyle = style
        present(vc, animated: true, completion: nil)
    }
    
    /// dismiss
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

public extension Dictionary {
    /// JSON字符串转字典
    func jSONString() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

public extension String {
    // 判断是否是空字符串
    var isBlank: Bool {
        let trimmedStr = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
    
    var intValue: Int? {
        return Int(self)
    }
    
    var image: UIImage? {
        if let bundle = Bundle.resouseBundle {
            return UIImage(named: self, in: bundle, compatibleWith: nil)
        }else {
            return nil
        }
    }
    
    /// 颜色
    var color: UIColor {
        return UIColor(rgba: self)
    }
    
    /// JSON字符串转字典
    func tojSONObjc() -> Dictionary <String, Any>? {
        if let jsonData:Data = self.data(using: .utf8) {
            if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
                return dict as? Dictionary <String, Any>
            }
        }
        return nil
    }
    
    /// 字符串的匹配范围 方法一
    ///
    /// - Parameters:
    /// - matchStr: 要匹配的字符串
    /// - Returns: 返回所有字符串范围
    @discardableResult
    func matchStrRange(_ matchStr: String) -> [NSRange] {
        var allLocation = [Int]() //所有起点
        let matchStrLength = (matchStr as NSString).length  //currStr.characters.count 不能正确统计表情

        let arrayStr = self.components(separatedBy: matchStr)//self.componentsSeparatedByString(matchStr)
        var currLoc = 0
        arrayStr.forEach { currStr in
            currLoc += (currStr as NSString).length
            allLocation.append(currLoc)
            currLoc += matchStrLength
        }
        allLocation.removeLast()
        return allLocation.map { NSRange(location: $0, length: matchStrLength) } //可把这段放在循环体里面，同步处理，减少再次遍历的耗时
    }
    
    /// 匹配字体设置字体和大小
    /// - Parameters:
    /// - matchTarget: 要匹配的字符串
    /// - font: 设置匹配后字体
    /// - color: 设置匹配字体颜色
    func getAttrStr(matchTarget: String, font: UIFont = UIFont.jmRegular(10), color: UIColor = UIColor.red) -> NSMutableAttributedString {
        let attriStr = NSMutableAttributedString(string: self)
        for range in self.matchStrRange(matchTarget) {
            attriStr.attributedSubstring(from: range)
            attriStr.addAttribute(.foregroundColor, value: color, range: range)
            attriStr.addAttribute(.font, value: font as Any, range: range)
        }
        return attriStr
    }
}

@objc public extension UITableView {
    func scrollToBottom() {
        let deadline = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            let row = self.numberOfRows(inSection: 0) - 1
            if row > 1 {
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: row, section: 0)
                    self.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
    }
}

public extension Double {
    /// 时间戳字符串格式化
    func tspString(_ format: String = "yyyy/MM/dd HH:mm:ss") -> String {
        let date = Date(timeIntervalSince1970: self)
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        return dfmatter.string(from: date)
    }
}

extension UIColor {
    /// 菜单背景颜色
    public static var menuBkg: UIColor {
        return UIColor.jmRGBValue(0xF0F8FF)
    }
    
    /// 菜单背景颜色
    public static var menuTintColor: UIColor {
        return UIColor(rgba: "#979797")
    }
    
    /// 菜单背景颜色
    public static var menuTextColor: UIColor {
        return UIColor.gray
    }
    
    /// 菜单背景颜色
    public static var charterTextColor: UIColor {
        return UIColor.jmRGB(50, 50, 50)
    }
    
    /// 菜单选中颜色
    public static var menuSelColor: UIColor {
        return UIColor(rgba: "#FF655F")
    }

    convenience init(rgba: String, grad: CGFloat = 0.0) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index = rgba.index(rgba.startIndex, offsetBy: 1)
            let hex = String(rgba[index...])
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                    break
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                    break
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                    break
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                    break
                default:
                    Logger.error("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
                    break
                }
            } else {
                Logger.error("Scan hex error")
            }
        } else {
            Logger.error("Invalid RGB string, missing '#' as prefix", terminator: "")
        }
        let gradF = grad / 255.0
        
        self.init(red: red - gradF, green: green - gradF, blue: blue - gradF, alpha: alpha)
    }
    
    func hexString(_ includeAlpha: Bool) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (includeAlpha == true) {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
    
    func highlightColor() -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: 0.30, brightness: 1, alpha: alpha)
        } else {
            return self;
        }
    }
    
    /**
     Returns a lighter color by the provided percentage
     :param: lighting percent percentage
     :returns: lighter UIColor
     */
    func lighterColor(_ percent : Double) -> UIColor {
        return colorWithBrightnessFactor(CGFloat(1 + percent));
    }
    
    /**
     Returns a darker color by the provided percentage
     
     :param: darking percent percentage
     :returns: darker UIColor
     */
    func darkerColor(_ percent : Double) -> UIColor {
        return colorWithBrightnessFactor(CGFloat(1 - percent));
    }
    
    /**
     Return a modified color using the brightness factor provided
     
     :param: factor brightness factor
     :returns: modified color
     */
    func colorWithBrightnessFactor(_ factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }
}

func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
