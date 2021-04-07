//
//  JMCTFrameParser.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/6.
//

import UIKit

public struct JMCTFrameParser {
    
    static public func parseAttributed(linkDic: Dictionary<String, String>, config: JMCTFrameParserConfig) ->NSAttributedString? {
        if let attri = parseAttributed(dic: linkDic, config: config) {
            let mutabAttr = NSMutableAttributedString(attributedString: attri)
            
            mutabAttr.addAttribute(kCTUnderlineStyleAttributeName as NSAttributedStringKey, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, attri.length))
            if let colorType = linkDic["color"] {
                let color = colorFrom(name: colorType).cgColor
                mutabAttr.addAttribute(kCTUnderlineColorAttributeName as NSAttributedStringKey, value: color, range: NSMakeRange(0, attri.length))
            }
            return mutabAttr
        }
        
        return nil
    }
    
    /**
     *  根据解析数据和配置信息对象配置属性文字
     *
     *  @param dict   解析数据字典
     *  @param config 配置对象信息
     *
     *  @return 返回的属性文字
     */
    static public func parseAttributed(dic: Dictionary<String, String>, config: JMCTFrameParserConfig) -> NSAttributedString? {
        var attributes = self.attributes(config)
        
        if let colorType = dic["color"] {
            let color = colorFrom(name: colorType)
            attributes[kCTForegroundColorAttributeName as NSAttributedString.Key] = color.cgColor
        }
        
        if let fontText = dic["size"] {
            let fontSize = CGFloat(Double(fontText) ?? 17.0)
            attributes[kCTFontAttributeName as NSAttributedString.Key] = CTFontCreateWithName("ArialMT" as CFString, fontSize, nil)
        }
        
        if let content = dic["content"] {
            return NSAttributedString(string: content, attributes: attributes)
        }
        
        return nil
    }
    
    /**
     *  根据属性文字对象和配置信息对象生成CoreTextData对象
     *
     *  @param content 属性文字对象
     *  @param config  配置信息对象
     *
     *  @return CoreTextData对象
     */
    static public func parseAttributed(content: NSAttributedString, config: JMCTFrameParserConfig) ->JMCoreTextData {
        // 创建CTFrameSetterRef实例
        let ctFrameSetterRef = CTFramesetterCreateWithAttributedString(content as CFAttributedString)
        // 获取要绘制的区域信息
        let restrictSize = CGSize(width: config.width, height: CGFloat.greatestFiniteMagnitude)
        let coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(ctFrameSetterRef, CFRange(location: 0, length: 0), nil, restrictSize, nil)
        let textHeight = coreTextSize.height
        // 配置ctframeRef信息
        let ctFrame = createFrame(frameSetter: ctFrameSetterRef, config: config, height: textHeight)
        // 配置coreTextData数据
        return JMCoreTextData(ctFrame: ctFrame, height: textHeight)
    }
    
    
    /**
     *  根据CTFramesetterRef、配置信息对象和高度生成对应的CTFrameRef
     *
     *  @param frameSetter CTFramesetterRef
     *  @param config      配置信息对象
     *  @param height      CTFrame高度
     *
     *  @return CTFrameRef
     */
    static public func createFrame(frameSetter: CTFramesetter, config: JMCTFrameParserConfig, height: CGFloat) ->CTFrame {
        let path = CGMutablePath()
        path.addRect(CGRect.Rect(0, 0, config.width, height))
        return CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
    }
    
    /**
     *  根据传入配置信息配置文字属性字典
     *
     *  @param config 配置信息对象
     *
     *  @return 配置文字属性字典
     */
    static public func attributes(_ config: JMCTFrameParserConfig) -> [NSAttributedString.Key: Any] {
        let fontSize = config.fontSize
        let ctfont = CTFontCreateWithName("ArialMT" as CFString, fontSize, nil)

        // 设置行间距
        let lineSpace = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        lineSpace.pointee = 5.0
        let sizeOf = MemoryLayout<CGFloat>.size
        let settings = [CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: sizeOf, value: lineSpace),
                        CTParagraphStyleSetting(spec: .maximumLineSpacing, valueSize: sizeOf, value: lineSpace),
                        CTParagraphStyleSetting(spec: .minimumLineSpacing, valueSize: sizeOf, value: lineSpace)]
        // 设置字体颜色
         return [
            kCTForegroundColorAttributeName: config.textColor,
            kCTFontAttributeName: ctfont,
            kCTParagraphStyleAttributeName: CTParagraphStyleCreate(settings, 3)
         ] as [NSAttributedString.Key : Any]
    }
    
    /// 文字颜色
    static public func colorFrom(name: String) -> UIColor {
        if name == "red" {
            return UIColor.red
        }else if name == "blue" {
            return UIColor.blue
        } else {
            return UIColor.black
        }
    }
}