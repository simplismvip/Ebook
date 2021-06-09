//
//  JMXMLParser.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/18.
//

import AEXML
import YYText
import ZJMKit

public class JMXmlNode {
    var tag: String
    var content: String
    var media: Bool {
        return ["h1","h2","h3","h4","h5","h6"].contains(tag)
    }
    
    init(_ tag: String, _ content: String) {
        self.tag = tag
        self.content = content
    }
}

public class JMXmlParser {
    public var xmlNodes = [JMXmlNode]()
    private var options = AEXMLOptions()
    private var baseHref: URL?
    init() {
        options.parserSettings.shouldProcessNamespaces = false
        options.parserSettings.shouldReportNamespacePrefixes = false
        options.parserSettings.shouldResolveExternalEntities = false
    }

    public func content(_ href: URL) {
        do {
            self.baseHref = href
            let data = try Data(contentsOf: href)
            let xmlDoc = try AEXMLDocument(xml: data, options: options)
            for child in xmlDoc.root["body"].children {
                parserXml(child: child)
            }
        } catch {
            Logger.error("解析XML出错\(error)")
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
                // Logger.debug(child.name, value)
                // 如果上一段落是文本没必要新建模型，直接拼接到上一个模型上去
                // 因为某些文本文件有大量短段落，每段都生成属性字符串时会导致内存问题
                if let prevNode = xmlNodes.last, prevNode.tag != "img", !prevNode.media {
                    prevNode.content += ("\n"+value)
                }else {
                    xmlNodes.append(JMXmlNode(child.name,value))
                }
            }else {
                if child.name == "img", let src = child.attributes["src"] {
                    xmlNodes.append(JMXmlNode("img",src))
                    // Logger.debug(child.name,src)
                }else if child.name == "image", let src = child.attributes["xlink:href"] {
                    xmlNodes.append(JMXmlNode("img", src))
                    // Logger.debug(child.attributes)
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
                    if image.size.width > config.width(), let cgimage = image.cgImage {
                        let rate = image.size.width / config.width()
                        let tempIma = UIImage(cgImage: cgimage, scale: rate, orientation: .up)
                        let attachText = attachMent(image: tempIma, font: config.font())
                        text.append(attachText)
                        text.append(NSAttributedString(string: "\n"))
                    } else {
                        let attachText = attachMent(image: image, font: config.font())
                        text.append(attachText)
                        text.append(NSAttributedString(string: "\n"))
                    }
                }
            } else {
                let conText = NSMutableAttributedString(string: xmlNode.content)
                conText.yy_lineSpacing = config.lineSpace()
                conText.yy_paragraphSpacing = config.lineSpace() * 1.2
                conText.yy_font = xmlNode.media ? UIFont.jmMedium(20) : config.font()
                conText.yy_firstLineHeadIndent = 20
                conText.yy_color = config.textColor()
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
