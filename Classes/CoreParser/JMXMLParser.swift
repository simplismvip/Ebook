//
//  JMXMLParser.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/18.
//

import AEXML
import YYText
import ZJMKit

public struct JMXmlNode {
    var tag: String
    var content: String
    var media: Bool {
        return ["h1","h2","h3","h4","h5"].contains(tag)
    }
    
    init(_ tag: String, _ content: String) {
        self.tag = tag
        self.content = content
    }
}

public class JMXMLParser {
    public var xmlNodes = [JMXmlNode]()
    private var options = AEXMLOptions()
    private var baseHref: URL?
    init() {
        options.parserSettings.shouldProcessNamespaces = false
        options.parserSettings.shouldReportNamespacePrefixes = false
        options.parserSettings.shouldResolveExternalEntities = false
    }
    
    public func titlePage(_ href: URL) {
        do {
            self.baseHref = href
            let data = try Data(contentsOf: href)
            let xmlDoc = try AEXMLDocument(xml: data, options: options)
            for child in xmlDoc.root["body"]["div"].children {
                parserXml(child: child)
            }
        } catch {
            print("🆘🆘🆘 解析XML出错\(error)")
        }
    }
    
    public func coverPage(_ href: URL) {
        do {
            self.baseHref = href
            let data = try Data(contentsOf: href)
            let xmlDoc = try AEXMLDocument(xml: data, options: options)
            for child in xmlDoc.root["body"]["div"].children {
                parserXml(child: child)
            }
        } catch {
            print("🆘🆘🆘 解析XML出错\(error)")
        }
    }
    
    public func content(_ href: URL) {
        do {
            self.baseHref = href
            let data = try Data(contentsOf: href)
            let xmlDoc = try AEXMLDocument(xml: data, options: options)
            for child in xmlDoc.root["body"]["div"].children {
                parserXml(child: child)
            }
        } catch {
            print("🆘🆘🆘 解析XML出错\(error)")
        }
    }

    /// 解析XML标签
    func parserXml(child: AEXMLElement) {
        if child.children.count > 0 {
            for subChild in child.children {
                parserXml(child: subChild)
            }
        }else {
            if let value = child.value, value.count > 0 {
//                print(child.name, value)
                xmlNodes.append(JMXmlNode(child.name,value))
            }else {
                if child.name == "img", let src = child.attributes["src"] {
                    xmlNodes.append(JMXmlNode("img",src))
//                    print(child.name,src)
                }
            }
        }
    }
    
    /// XML文件解析为属性字符串
    func attributeStr(_ config: JMBookConfig) -> NSMutableAttributedString {
        guard let href = baseHref else {
            return NSMutableAttributedString(string: "🆘🆘🆘 解析内容发生错误")
        }
        
        let text = NSMutableAttributedString()
        for xmlNode in xmlNodes {
            if xmlNode.tag == "img" {
                let path = href.deletingLastPathComponent().appendingPathComponent(xmlNode.content)
                if let data = try? Data(contentsOf: path), let image = UIImage(data: data) {
                    if image.size.width > config.width, let cgimage = image.cgImage {
                        let rate = image.size.width / config.width
                        let tempIma = UIImage(cgImage: cgimage, scale: rate, orientation: .up)
                        let attachText = attachMent(image: tempIma, font: config.font())
                        text.append(attachText)
                        text.append(NSAttributedString(string: "\n"))
                    }else {
                        let attachText = attachMent(image: image, font: config.font())
                        text.append(attachText)
                        text.append(NSAttributedString(string: "\n"))
                    }
                }
            }else {
                let conText = NSMutableAttributedString(string: xmlNode.content)
                conText.yy_lineSpacing = config.lineSpace
                conText.yy_font = xmlNode.media ? UIFont.jmMedium(20) : config.font()
                conText.yy_firstLineHeadIndent = 20
                text.append(conText)
                text.append(NSAttributedString(string: "\n"))
            }
        }
        return text
    }
    
    func attachMent(image: UIImage, font: UIFont) -> NSMutableAttributedString {
        return NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: image.size, alignTo: font, alignment: .center)
    }
}

extension AEXMLElement {
    func parserXml(child: AEXMLElement) {
        if child.children.count > 0 {
            for subChild in child.children {
                parserXml(child: subChild)
            }
        }else {
            if let value = child.value {
                print(child.name, value)
            }else {
                print(child.name,child.attributes)
            }
        }
    }
}
