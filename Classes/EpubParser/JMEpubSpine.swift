//
//  JMEpubSpine.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/3.
//

import Foundation

public struct JMEpubSpineItem {
    public var id: String?
    public var idref: String
    public var linear: Bool
}

public struct JMEpubSpine {
    public var id: String?
    public var toc: String?
    public var pageDirection: JMEpubPageDirection?
    public var items: [JMEpubSpineItem]
}

public enum JMEpubPageDirection: String {
    case leftToRight = "ltr"
    case rightToLeft = "rtl"
}

import AEXML

struct JMEpubSpineParser {
    static func parse(_ xmlElement: AEXMLElement) -> JMEpubSpine {
        var items: [JMEpubSpineItem] = []
        for item in xmlElement["itemref"].all! {
            let id = item.attributes["id"]
            let idref = item.attributes["idref"]!
            let linear = (item.attributes["linear"] ?? "yes") == "yes" ? true : false
            items.append(JMEpubSpineItem(id: id, idref: idref, linear: linear))
        }
        let pageDirection = xmlElement["page-progression-direction"].value ?? "ltr"
        return JMEpubSpine(id: xmlElement.attributes["id"],
                         toc: xmlElement.attributes["toc"],
                         pageDirection: JMEpubPageDirection(rawValue: pageDirection),
                         items: items)
    }

}
