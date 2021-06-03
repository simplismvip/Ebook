//
//  JMEpubModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/23.
//

import Foundation

public struct JMEpubBook {
    public let directory: URL
    public let contentDirectory: URL
    public let metadata: JMEpubMetadata
    public let manifest: JMEpubManifest
    public let spine: JMEpubSpine
    public let tableOfContents: JMEpubTOC
}

extension JMEpubBook {
    
    public var bookId: String {
        return metadata.identifier ?? title.jmTransformChinese()
    }
    
    public var title: String {
        return metadata.title ?? ""
    }
    
    public var author: String {
        return metadata.creator?.name ?? ""
    }
    
    public var publisher: String {
        return metadata.publisher ?? ""
    }
    
    public var cover: URL? {
        guard let coverId = metadata.coverId, let path = manifest.items[coverId]?.path else {
            return nil
        }
        return contentDirectory.appendingPathComponent(path)
    }
    
    public func findTarget(target: String) -> JMEpubTOC? {
        guard let items = tableOfContents.subTable, items.count > 0 else {
            return nil
        }
        
        for item in items {
            if item.item == target {
                return item
            }else {
                // 第一层没找到遍历第二层
                if let subItems = item.subTable, subItems.count > 0 {
                    for subItem in subItems {
                        if subItem.item == target {
                            return subItem
                        }
                    }
                }
            }
        }
        return nil
    }
}


