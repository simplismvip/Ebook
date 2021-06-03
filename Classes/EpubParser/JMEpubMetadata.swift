//
//  JMEpubMetadata.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/3.
//

import Foundation

public struct JMEpubCreator {
    public var name: String?
    public var role: String?
    public var fileAs: String?
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

import AEXML

struct JMEpubMetadataParser {

    static func parse(_ xmlElement: AEXMLElement) -> JMEpubMetadata {
        var metadata = JMEpubMetadata()
        metadata.contributor = JMEpubCreator(name: xmlElement["dc:contributor"].value,
                                       role: xmlElement["dc:contributor"].attributes["opf:role"],
                                       fileAs: xmlElement["dc:contributor"].attributes["opf:file-as"])
        metadata.coverage = xmlElement["dc:coverage"].value
        metadata.creator = JMEpubCreator(name: xmlElement["dc:creator"].value,
                                   role: xmlElement["dc:creator"].attributes["opf:role"],
                                   fileAs: xmlElement["dc:creator"].attributes["opf:file-as"])
        metadata.date = xmlElement["dc:date"].value
        metadata.description = xmlElement["dc:description"].value
        metadata.format = xmlElement["dc:format"].value
        metadata.identifier = xmlElement["dc:identifier"].value
        metadata.language = xmlElement["dc:language"].value
        metadata.publisher = xmlElement["dc:publisher"].value
        metadata.relation = xmlElement["dc:relation"].value
        metadata.rights = xmlElement["dc:rights"].value
        metadata.source = xmlElement["dc:source"].value
        metadata.subject = xmlElement["dc:subject"].value
        metadata.title = xmlElement["dc:title"].value
        metadata.type = xmlElement["dc:type"].value
        for metaItem in xmlElement["meta"].all ?? [] where metaItem.attributes["name"] == "cover" {
            metadata.coverId = metaItem.attributes["content"]
        }
        return metadata
    }
}
