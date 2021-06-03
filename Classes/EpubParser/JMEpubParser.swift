//
//  JMEpubParser.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/3.
//

import AEXML
import Zip

class JMEpubParser: NSObject {
    
    public func parse(documentAt path: URL) throws -> JMEpubBook {
        // delegate?.parser(self, didBeginParsingDocumentAt: path)
        do {
            let directory = try unarchive(archive: path)
            // delegate?.parser(self, didUnzipArchiveTo: directory)

            let path = try getContentPath(from: directory)
            let data = try Data(contentsOf: path)
            let content = try AEXMLDocument(xml: data)
            let contentDirectory = path.deletingLastPathComponent()
            // delegate?.parser(self, didLocateContentAt: contentDirectory)

            let spine = JMEpubSpineParser.parse(content.root["spine"])
            // delegate?.parser(self, didFinishParsing: spine)

            let metadata = JMEpubMetadataParser.parse(content.root["metadata"])
//            delegate?.parser(self, didFinishParsing: metadata)

            let manifest = JMEpubManifestParser.parse(content.root["manifest"])
//            delegate?.parser(self, didFinishParsing: manifest)

            guard let toc = spine.toc, let fileName = manifest.items[toc]?.path else {
                throw JMParserError.tableOfContentsMissing
            }
            
            let tocElement = try getTableOfContents(contentDirectory.appendingPathComponent(fileName))
            let tableOfContents = JMEpubTOCParser.parse(tocElement)
            return JMEpubBook(directory: directory,
                              contentDirectory: contentDirectory,
                              metadata: metadata,
                              manifest: manifest,
                              spine: spine,
                              tableOfContents: tableOfContents)
//            delegate?.parser(self, didFinishParsing: tableOfContents)
        } catch let error {
//            delegate?.parser(self, didFailParsingDocumentAt: path, with: error)
            throw error
        }
//        delegate?.parser(self, didFinishParsingDocumentAt: path)
        
    }
    
    private func getContentPath(from url: URL) throws -> URL {
        let path = url.appendingPathComponent("META-INF/container.xml")
        guard let data = try? Data(contentsOf: path) else {
            throw JMParserError.containerMissing
        }
        let container = try AEXMLDocument(xml: data)
        guard let content = container.root["rootfiles"]["rootfile"].attributes["full-path"] else {
            throw JMParserError.contentPathMissing
        }
        return url.appendingPathComponent(content)
    }

    private func getTableOfContents(_ url: URL) throws -> AEXMLElement {
        let data = try Data(contentsOf: url)
        return try AEXMLDocument(xml: data).root
    }
    
    private func unarchive(archive url: URL) throws -> URL {
        Zip.addCustomFileExtension("epub")
        var destination: URL
        do {
            destination = try Zip.quickUnzipFile(url)
        } catch let error {
            throw JMParserError.unzipFailed(reason: error)
        }
        return destination
    }
}


public protocol JMParserProtocol {
    
}
