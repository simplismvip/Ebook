//
//  JMEpubModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/23.
//

import UIKit

public struct JMEpubCreator {
    public var name: String?
    public var role: String?
    public var fileAs: String?
}

public struct JMEpubSpineModel {
    public var id: String?
    public var idref: String
    public var linear: Bool
}

public struct JMEpubMetadata {
    public var contributor: JMEpubCreator?
    public var coverage: String?
    public var creator: JMEpubCreator?
    public var date: String?
    public var description: String?
    public var format: String?
    public var identifier: String?
    public var language: String?
    public var publisher: String?
    public var relation: String?
    public var rights: String?
    public var source: String?
    public var subject: String?
    public var title: String?
    public var type: String?
    public var coverId: String?
}

public struct JMEpubSpine {
    public var id: String?
    public var toc: String?
    public var pageDirection: JMEpubPageDirection?
    public var items: [JMEpubSpineModel]
}

public enum JMEpubPageDirection: String {
    case leftToRight = "ltr"
    case rightToLeft = "rtl"
}

public struct JMEpubManifestItem {
    public var id: String
    public var path: String
    public var mediaType: JMEpubMediaType
    public var property: String?
}

public struct JMEpubTOC {
    public var label: String
    public var id: String
    public var item: String?
    public var subTable: [JMEpubTOC]?
}
