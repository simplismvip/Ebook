//
//  JMExtension+Bundle.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/30.
//

import Foundation

extension Bundle {
    static var bundle: Bundle? {
        if let budl = Bundle(for: JMReadPageContrller.self).path(forResource: "Resours", ofType: "bundle") {
            return Bundle(path: budl)
        }else {
            return nil
        }
    }

    // 定义一个静态变量arrowImage，用于获取图片文件：“arrow.png”。
    static var arrowImage: UIImage? {
        if let bundle = bundle?.path(forResource: "arrow@2x", ofType: "png") {
            return UIImage(contentsOfFile: bundle)?.withRenderingMode(.alwaysTemplate)
        }else {
            return nil
        }
    }

    // 类方法
    class func localizedString(forKey key: String) -> String? {
        return self.localizedString(forKey: key, value: nil)
    }

    // 参数value为可选值，可以传值为nil。
    class func localizedString(forKey key: String, value: String?) -> String? {
        var language = Locale.preferredLanguages.first
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        if language?.hasPrefix("en") ?? false {
            language = "en"
        } else if language?.hasPrefix("zh") ?? false {
            language = "zh-Hans"
        } else {
            language = "en"
        }

        if let bundle = bundle?.path(forResource: language, ofType: "lproj") {
            let v = Bundle(path: bundle)?.localizedString(forKey: key, value: value, table: nil)
            return Bundle.main.localizedString(forKey: key, value: v, table: nil)
        }else {
            return nil
        }
    }
}
