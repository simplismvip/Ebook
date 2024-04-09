//
//  JSONable.swift
//  JMEpubReader
//
//  Created by jh on 2024/4/9.
//

import Foundation

typealias JSONable = BaseCodable & Codable
protocol BaseCodable { }

extension BaseCodable where Self: Codable {
    static func deserialize(dic: [String: Any]) -> Self? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: [])
            return parser(data)
        } catch let jsonError {
            print("==================")
            print(jsonError)
        }
        return nil
    }
    
    static func stringToModel(_ jsonString: String) -> Self? {
        guard let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return nil }
        return parser(data)
    }
    
    static func parser(_ data: Data) -> Self? {
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch let jsonError {
            print("==================")
            print(jsonError)
        }
        return nil
    }
    
    func toJSON() -> [String: Any]? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any]
        } catch {
            return nil
        }
    }
    
    func toJSONString() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch  {
            return nil
        }
    }
}

// MARK: - 本地存储本地
extension BaseCodable where Self: Codable {
    func saved(key: String) {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func load(key: String) -> Self? {
        if let data = UserDefaults.standard.data(forKey: key) {
            if let decoded = try? JSONDecoder().decode(Self.self, from: data) {
                return decoded
            }
        }
        return nil
    }
}

extension Encodable {
    func toJSONString() -> String? {
        if let data = toData() {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func toJSON() -> [String: Any]? {
        if let data = toData(), let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            return json
        } else {
            return nil
        }
    }
    
    func toData() -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            return try encoder.encode(self)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
