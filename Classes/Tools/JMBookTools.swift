//
//  JMBookTools.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/22.
//

import Foundation

class JMBookTools {
    private let hightLabel = UILabel()
    private var contSize = [String: CGSize]()
    private let width = UIScreen.main.bounds.size.width
    public static let share: JMBookTools = {
        let util = JMBookTools()
        util.hightLabel.numberOfLines = 0
        return util
    }()
    
    public func contentSize(text: String, textID: String, maxW: CGFloat, font: UIFont) -> CGSize {
        if let size = contSize[textID] {
            return size
        }else {
            hightLabel.font = font
            hightLabel.text = text
            let maxSize = CGSize(width: maxW, height: CGFloat.greatestFiniteMagnitude)
            let size = hightLabel.sizeThatFits(maxSize)
            contSize[textID] = size
            return size
        }
    }
    
    public static func contentHight(text: String, textID: String, maxW: CGFloat, font: UIFont) -> CGFloat {
        JMBookTools.share.contentSize(text: text, textID: textID, maxW: maxW, font: font).height
    }
}
    
public class JMBookCache {
    private var caches = [String: AnyObject]()
    public static let share: JMBookCache = {
        return JMBookCache()
    }()
    
    static public func setObjc(key: String, obj: AnyObject) {
        if JMBookCache.share.caches[key] == nil {
            JMBookCache.share.caches[key] = obj
        }
    }
    
    static public func updateObjc(key: String, obj: AnyObject) {
        JMBookCache.share.caches[key] = obj
    }
    
    static public func getObjc(key: String) -> AnyObject? {
        return JMBookCache.share.caches[key]
    }
    
    static public func config() -> JMBookConfig {
        return JMBookCache.share.caches["jmBookConfig"] as! JMBookConfig
    }
}
  
public struct JMBookWapper<T: NSObject> {
    weak var obj: T?
    var ident: String
    init(obj: T, ident: String) {
        self.obj = obj
        self.ident = ident
    }
}

typealias Logger = JMBookLogger
public struct JMBookLogger {
    enum Level: String {
        case debug = "🐝🐝🐝 "
        case info = "ℹ️ℹ️ℹ️ "
        case warning = "⚠️⚠️⚠️ "
        case error = "🆘🆘🆘 "
    }
    
    static func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        JMBookLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .debug)
    }
    
    static func info(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        JMBookLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .info)
    }
    
    static func warning(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        JMBookLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .warning)
    }
    
    static func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        JMBookLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .error)
    }
    
    private static func eBookPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", level: Level){
        #if DEBUG
        print("\(level.rawValue)：\(items)", separator: separator, terminator: terminator)
        #endif
    }
}
