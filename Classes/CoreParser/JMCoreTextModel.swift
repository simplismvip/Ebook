//
//  JMCoreTextModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/6.
//

import UIKit

// TODO: -- 为Core阅读View JMReadPageView 提供数据
public struct JMReadPageModel {
    let frame: CTFrame
    let content: String
    let images: [String]
}

// TODO: -- 文本的数据类
public class JMCoreTextData {
    /// 文本绘制的区域大小
    var ctFrame: CTFrame
    
    /// 文本绘制区域高度
    var height: CGFloat
    
    /// 文本中存储图片信息数组
    var imageArray = [JMCoreTextImageData]()
    
    /// 文本中存储链接信息数组
    var linkArray = [JMCoreTextLinkData]() {
        willSet {
            if newValue.count > 0 {
                fillImagePosition()
            }
        }
    }
    
    /// 文本绘制区域高度
    var content: String?
    
    /// 文本绘制区域高度
    var attributeString: NSAttributedString?
    
    init(ctFrame: CTFrame, height: CGFloat) {
        self.ctFrame = ctFrame
        self.height = height
    }
    
    // 计算图片的位置
    // 在CTFrame内部是由多个CTline组成，每行CTline又是由多个CTRun组成
    // 每个CTRun代表一组风格一致的文本(CTline和CTRun的创建不需要我们管理)
    // 在CTRun中我们可以设置代理来指定绘制此组文本的宽高和排列方式等信息
    // 此处利用CTRun代理设置一个空白的字符给定宽高，最后在利用CGContextDrawImage将其绘制
    func fillImagePosition() {
        // 获取CTFrame中所有的CTline
        guard let lines: [CTLine] = CTFrameGetLines(ctFrame) as? [CTLine] else {
            return
        }
        
        // 利用CGPoint数组获取所有CTline的起始坐标
        let linesOrigins = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
        // FIXME: CTFrameGetLineOrigins获取CTLine的起始坐标，是一个个数为行数的一维数组，每个数组元素是一个CGPoint结构体，后面计算图片位置需要使用到
        CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), linesOrigins)
        
        var imgIndex = 0
        var imageData = imageArray[imgIndex]
        for (index, line) in lines.enumerated() {
            // 获取该行CTRun信息
            if let runs = CTLineGetGlyphRuns(line) as? [CTRun] {
                for run in runs {
                    // 若CTRun有代理，则获取代理信息，代理信息若不为字典直接进行下次循环
                    if let runAttr = (CTRunGetAttributes(run) as? [NSAttributedString.Key: Any]),
                    let _ = runAttr[kCTRunDelegateAttributeName as NSAttributedString.Key] {
                        // 找到代理则开始计算图片位置信息
                        let linePoint = linesOrigins[index]
                        let runBounds = JMCoreTextParse.getRunsBounds(line: line, run: run, point: linePoint)
                        // 获取CTFrame的路径
                        let pathRef = CTFrameGetPath(ctFrame)
                        // 利用路径获取绘制视图的Rect
                        let colRect = pathRef.boundingBox;
                        // 根据runBounds配置图片在绘制视图中的实际位置
                        let r1 = runBounds.offsetBy(dx: colRect.origin.x + (colRect.size.width - runBounds.size.width) * 0.5, dy: colRect.origin.y)
                        let r2 = runBounds.offsetBy(dx: colRect.origin.x, dy: colRect.origin.y)
                        imageData.position = (imgIndex == 0) ? r1 : r2
                        
                        imgIndex += 1
                        imageData = imageArray[imgIndex]
                        
                    }
                }
            }
        }
    }
}

// TODO: -- url链接的数据类
public class JMCoreTextLinkData {
    /// String类型url链接地址
    let urlStr: String
    
    /// 文字在属性文字中的范围
    let range: NSRange
    
    init(urlStr: String, range: NSRange) {
        self.urlStr = urlStr
        self.range = range
    }
}

// TODO: -- 图片的数据类
public class JMCoreTextImageData {
    /// 文本绘制的区域大小
    var name: String
    
    /// 文本绘制区域高度
    var position: CGRect
    
    init(name: String, position: CGRect) {
        self.name = name
        self.position = position
    }
}

// TODO: -- CTFrame配置信息类
public struct JMCTFrameParserConfig {
    /// 文本宽度
    var width: CGFloat = 200.0
    /// 字体大小
    var fontSize: CGFloat = 16.0
    /// 字体行间距
    var lineSpace: CGFloat = 8.0
    /// 字体颜色
    var textColor: UIColor = UIColor.black
}
