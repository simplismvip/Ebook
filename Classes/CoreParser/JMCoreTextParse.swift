//
//  JMCoreTextParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/6.
//

import UIKit

public struct JMCoreTextParse {
    /**
     *  若点击位置有链接返回链接对象否则返回nil
     *
     *  @param view  点击的视图
     *  @param point 点击位置
     *  @param data  存放富文本的数据
     *
     *  @return 返回链接对象
     */
    public static func touchLike(view: UIView, atPoint: CGPoint, data: JMCoreTextData) -> JMCoreTextLinkData? {
        let ctFrame = data.ctFrame
        guard let lines: [CTLine] = CTFrameGetLines(ctFrame) as? [CTLine] else {
            return nil
        }
        
        let linesOrigins = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
        CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), linesOrigins)
        
        var transform = CGAffineTransform(translationX: 0, y: view.bounds.size.height)
        transform = transform.scaledBy(x: 1, y: -1);
        
        for (index, line) in lines.enumerated() {
            
            let linePoint = linesOrigins[index]
            
            // 获取当前行的rect信息
            let flippedRect = getLineBounds(line: line, point: linePoint)
            // 将CoreText坐标转换为UIKit坐标
            let rect = flippedRect.applying(transform)
            
            // 判断点是否在Rect当中
            if rect.contains(atPoint) {
                // 获取点在line行中的位置
                let relativePoint = CGPoint(x: atPoint.x - rect.minX, y: atPoint.y - rect.maxY)
                
                let idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                return linkAtIndex(i: idx, linkArray: data.linkArray)
            }
            
        }
        return nil
    }
    
    private static func getLineBounds(line: CTLine, point: CGPoint) -> CGRect {
        let ascent = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        ascent.pointee = 0
        
        let descent = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        descent.pointee = 0
        
        let leading = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        leading.pointee = 0
        
        let width = CGFloat(CTLineGetTypographicBounds(line, ascent, descent, leading))
        let height = ascent.pointee + descent.pointee
        return CGRect.Rect(point.x, point.y, width, height)
    }
    
    private static func linkAtIndex(i: CFIndex, linkArray: [JMCoreTextLinkData]) ->JMCoreTextLinkData? {
        return linkArray.filter { NSLocationInRange(i, $0.range) }.first
    }
    
    /// 获取run 的rect
    public static func getRunsBounds(line: CTLine, run: CTRun, point: CGPoint) -> CGRect {
        let ascent = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        ascent.pointee = 0
        
        let desent = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        desent.pointee = 0
        
        let leading = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        leading.pointee = 0
        
        let width = CGFloat(CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), ascent, desent, leading)))
        let height = ascent.pointee + desent.pointee
        
        let offset: CGFloat = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
        
        return CGRect.Rect(point.x + offset, point.y - desent.pointee, width, height)
    }
}
