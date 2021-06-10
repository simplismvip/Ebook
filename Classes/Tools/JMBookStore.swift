//
//  JMBookStore.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/15.
//

import UIKit

public class JMBookStore {
    private var queue = DispatchQueue(label: "com.search.cacheQueue")
    public static let share: JMBookStore = {
        return JMBookStore()
    }()
    
    /// 归档模型
    public static func encodeObject<T: Encodable>(_ object: T, cachePath: String) {
        JMBookStore.share.queue.async {
            do {
                let data = try PropertyListEncoder().encode(object)
                NSKeyedArchiver.archiveRootObject(data, toFile: cachePath)
            }catch let error {
                Logger.debug("data cache \(error.localizedDescription)!!!⚽️⚽️⚽️")
            }
        }
    }
    
    /// 解档模型
    public static func decodeObject<T: Codable>(cachePath: String, complate:@escaping (T?)->()) {
        JMBookStore.share.queue.async {
            guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: cachePath) as? Data else {
                DispatchQueue.main.async { complate(nil) }
                return
            }
            
            do {
                let object = try PropertyListDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { complate(object) }
            }catch let error {
                Logger.debug("data cache \(error.localizedDescription)!!!⚽️⚽️⚽️")
            }
        }
    }
    
    /// 解档模型
    public static func decodeMain<T: Codable>(cachePath: String, complate:@escaping (T?)->()) {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: cachePath) as? Data else {
            DispatchQueue.main.async { complate(nil) }
            return
        }
        
        do {
            let object = try PropertyListDecoder().decode(T.self, from: data)
            DispatchQueue.main.async { complate(object) }
        }catch let error {
            Logger.debug("data cache \(error.localizedDescription)!!!⚽️⚽️⚽️")
        }
    }
    
    /// 删除归档文件
    public static func deleteDecode(_ cachePath: String) {
        let manager = FileManager.default
        if manager.fileExists(atPath: cachePath) && manager.isDeletableFile(atPath: cachePath) {
            try? manager.removeItem(atPath: cachePath)
        }
    }
}
