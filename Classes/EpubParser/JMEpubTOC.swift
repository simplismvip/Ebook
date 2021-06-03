//
//  JMEpubTableOfContents.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/3.
//

import Foundation

public struct JMEpubTOC {
    public var label: String
    public var id: String
    public var item: String?
    public var subTable: [JMEpubTOC]?
}

import AEXML

struct JMEpubTOCParser {
    static func parse(_ xmlElement: AEXMLElement) -> JMEpubTOC {
        let item = xmlElement["head"]["meta"].all(
            withAttributes: ["name": "dtb=uid"])?.first?.attributes["content"]
        var tableOfContents = JMEpubTOC(label: xmlElement["docTitle"]["text"].value!,
                                                  id: "0",
                                                  item: item, subTable: [])
        tableOfContents.subTable = evaluateChildren(from: xmlElement["navMap"])
        return tableOfContents
    }
    
    private static func evaluateChildren(from xmlElement: AEXMLElement) -> [JMEpubTOC] {
        guard let points = xmlElement["navPoint"].all else { return [] }
        let subs: [JMEpubTOC] = points.map { point in
            return JMEpubTOC(label: point["navLabel"]["text"].value!,
                                       id: point.attributes["id"]!,
                                       item: point["content"].attributes["src"]!,
                                       subTable: evaluateChildren(from: point))
        }
        return subs
    }
}
