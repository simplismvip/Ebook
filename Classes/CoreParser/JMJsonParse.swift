//
//  JMJsonParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/30.
//

import Foundation
import HandyJSON

public struct JMJsonParse {
    /// 解析本地[model,model,model,]结构json
    static public func parseJson<T: HandyJSON>(name: String, ofType: String = "json") -> [T] {
        guard let path = Bundle.resouseBundle?.path(forResource: name, ofType: ofType) else { return [T]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [T]() }
        guard let obj = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) else { return [T]() }
        return parseJson(obj:obj)
    }
    
    /// 解析本地[model,model,model,]结构json
    static public func pathJson<T: HandyJSON>(name: String, ofType: String = "json") -> [T] {
        guard let path = Bundle.main.path(forResource: name, ofType: ofType) else { return [T]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [T]() }
        guard let obj = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) else { return [T]() }
        return parseJson(obj:obj)
    }
    
    /// 解析本地[[model],[model],[model],]结构json
    static public func parseJsonItems<T: HandyJSON>(name: String, ofType: String = "json") -> [[T]] {
        guard let path = Bundle.resouseBundle?.path(forResource: name, ofType: ofType) else { return [[T]]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [[T]]() }
        guard let obj = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) else { return [[T]]() }
        guard let bookInfoDic = obj as? [[Dictionary<String, Any>]] else { return [[T]]() }
        return bookInfoDic.map {
            return parseJson(obj:$0)
        }
    }
    
    /// 解析整体。例如shelf.json可以整体解析
    static public func parseJson<T: HandyJSON>(obj:Any) -> [T] {
        guard let bookInfoDic = obj as? [Dictionary<String, Any>] else { return [T]() }
        return parse(items: bookInfoDic)
    }
    
    /// 解析拆分后的
    static public func parse<T: HandyJSON>(items:[Dictionary<String, Any>]) -> [T] {
        var models = [T]()
        for dicInfo in items {
            if let model = T.deserialize(from: dicInfo) {
                models.append(model)
            }
        }
        return models
    }
}

