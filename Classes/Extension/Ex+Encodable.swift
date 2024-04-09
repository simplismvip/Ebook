//
//  Ex+Encodable.swift
//  Smoothly
//
//  Created by jh on 2023/12/7.
//

import Foundation

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
