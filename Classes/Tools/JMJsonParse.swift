//
//  JMJsonParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/30.
//

import Foundation


public struct JMJsonParse {
    /// 解析本地[model,model,model,]结构json
    static public func parseJson<T: Codable>(name: String, ofType: String = "json") -> [T] {
        guard let path = Bundle.resouseBundle?.path(forResource: name, ofType: ofType) else { return [T]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [T]() }
        guard let obj = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) else { return [T]() }
        return parseJson(obj:obj)
    }
    
    /// 解析本地[model,model,model,]结构json
    static public func pathJson<T: Codable>(name: String, ofType: String = "json") -> [T] {
        guard let path = Bundle.main.path(forResource: name, ofType: ofType) else { return [T]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [T]() }
        guard let obj = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) else { return [T]() }
        return parseJson(obj:obj)
    }
    
    /// 解析本地[[model],[model],[model],]结构json
    static public func parseJsonItems<T: Codable>(name: String, ofType: String = "json") -> [[T]] {
        guard let path = Bundle.resouseBundle?.path(forResource: name, ofType: ofType) else { return [[T]]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [[T]]() }
        guard let obj = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) else { return [[T]]() }
        guard let bookInfoDic = obj as? [[Dictionary<String, Any>]] else { return [[T]]() }
        return bookInfoDic.map {
            return parseJson(obj:$0)
        }
    }
    
    /// 解析整体。例如shelf.json可以整体解析
    static public func parseJson<T: Codable>(obj: Any) -> [T] {
        guard let bookInfoDic = obj as? [Dictionary<String, Any>] else { return [T]() }
        return parse(items: bookInfoDic)
    }
    
    /// 解析拆分后的
    static public func parse<T: Codable>(items: [Dictionary<String, Any>]) -> [T] {
        var models = [T]()
//        for dicInfo in items {
//            if let model = T.deserialize(from: dicInfo) {
//                models.append(model)
//            }
//        }
        return models
    }
}

struct DataTool<T: Codable> {
    public static func parsersJson(name: String) -> [T]? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else { return [T]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [T]() }
        return parsers(data)
    }
    
    public static func parserJson(name: String) -> T? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else { return nil }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return nil }
        return parser(data)
    }
    
    public static func parsersLocal(_ path: String) -> [T]? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [T]() }
        return parsers(data)
    }
    
    public static func parsers(_ data: Data) -> [T]? {
        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch let jsonError {
            print("==================")
            print(jsonError)
        }
        return nil
    }
    
    public static func parsers(dic: [String: Any]) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: [])
            return parser(data)
        } catch let jsonError {
            print("==================")
            print(jsonError)
        }
        return nil
    }
    
    public static func stringToModel(_ jsonString: String) -> T? {
        guard let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return nil }
        return parser(data)
    }
    
    public static func parser(_ data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let jsonError {
            print("==================")
            print(jsonError)
        }
        return nil
    }
}
