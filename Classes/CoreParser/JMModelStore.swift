//
//  JMModelStore.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/15.
//

import UIKit

public class JMModelStore {
    private var queue = DispatchQueue(label: "com.search.cacheQueue")
    public static let share: JMModelStore = {
        return JMModelStore()
    }()
    
    /// 归档模型
    public func encodeObject<T: Encodable>(_ object: T, cachePath: String) {
        queue.async {
            do {
                let data = try PropertyListEncoder().encode(object)
                NSKeyedArchiver.archiveRootObject(data, toFile: cachePath)
            }catch let error {
                print("data cache \(error.localizedDescription)!!!⚽️⚽️⚽️")
            }
        }
    }
    
    /// 解档模型
    public func decodeObject<T: Codable>(cachePath: String, complate:@escaping (T?)->()) {
        queue.async {
            guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: cachePath) as? Data else {
                DispatchQueue.main.async { complate(nil) }
                return
            }
            
            do {
                let object = try PropertyListDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { complate(object) }
            }catch let error {
                print("data cache \(error.localizedDescription)!!!⚽️⚽️⚽️")
            }
        }
    }
    
    /// 删除归档文件
    public func deleteDecode(_ cachePath: String) {
        let manager = FileManager.default
        if manager.fileExists(atPath: cachePath) && manager.isDeletableFile(atPath: cachePath) {
            try? manager.removeItem(atPath: cachePath)
        }
    }
}
