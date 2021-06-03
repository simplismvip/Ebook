//
//  JMEpubManifest.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/3.
//

import Foundation

public struct JMEpubManifest {
    public var id: String?
    public var items: [String: JMEpubManifestItem]
}

public struct JMEpubManifestItem {
    public var id: String
    public var path: String
    public var mediaType: JMEpubMediaType
    public var property: String?
}

import AEXML

struct JMEpubManifestParser {

    static func parse(_ xmlElement: AEXMLElement) -> JMEpubManifest {
        var items: [String: JMEpubManifestItem] = [:]
        for item in xmlElement["item"].all! {
            let id = item.attributes["id"]!
            let path = item.attributes["href"]!
            let mediaType = item.attributes["media-type"]
            let properties = item.attributes["properties"]
            items[id] = JMEpubManifestItem(id: id,
                                         path: path,
                                         mediaType: JMEpubMediaType(rawValue: mediaType!) ?? .unknown,
                                         property: properties)
        }
        return JMEpubManifest(id: xmlElement["id"].value, items: items)
    }
}
