//
//  JMPageParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/18.
//

import UIKit

struct JMPageParse {
    /// 文本内容分页 Page
    static public func pageContent(content: NSMutableAttributedString, title: String, bounds: CGRect) -> [JMBookPage]{
        var pageArray = [JMBookPage]()
        let cfPath = CGPath(rect: bounds, transform: nil);
        let ctFrameSetter = CTFramesetterCreateWithAttributedString(content as CFAttributedString)
        
        // 当前偏移
        var curOffset = 0
        var ctRange = CFRangeMake(0, 0)
        var page = 0
        repeat {
            let ctFrame = CTFramesetterCreateFrame(ctFrameSetter, CFRangeMake(curOffset, 0), cfPath, nil)
            ctRange = CTFrameGetVisibleStringRange(ctFrame)
            
            let pageStr = content.attributedSubstring(from: NSMakeRange(ctRange.location, ctRange.length))
            let item = JMBookPage(pageStr, title: title, page: page)
            pageArray.append(item)
            curOffset += ctRange.length
            page += 1
        }while( ctRange.location + ctRange.length < content.length )
        
        return pageArray
    }
    
    /// 文本内容分页
    static public func pageWithContent(content: NSMutableAttributedString, bounds: CGRect) -> [Int]{
        var pageArray = [Int]()
        
        let cfPath = CGPath(rect: bounds, transform: nil);
        let ctFrameSetter = CTFramesetterCreateWithAttributedString(content as CFAttributedString)
        
        // 当前偏移
        var curOffset = 0
        pageArray.append(curOffset)
        var ctRange = CFRangeMake(0, 0)
        repeat {
            let ctFrame = CTFramesetterCreateFrame(ctFrameSetter, CFRangeMake(curOffset, 0), cfPath, nil)
            ctRange = CTFrameGetVisibleStringRange(ctFrame)
            curOffset += ctRange.length
            pageArray.append(curOffset)
        }while( ctRange.location + ctRange.length < content.length )
        
        return pageArray
    }
    
    /// 获取当页文本内容
    static public func currentPage(content: NSAttributedString, currPage: Int, pages: [Int]) ->NSAttributedString {
        let loction = pages[currPage]
        var length = 0
        if currPage < pages.count - 1 {
            length = pages[currPage + 1] - loction
        }else {
            length = content.length - loction
        }
        return content.attributedSubstring(from: NSMakeRange(loction, length))
    }
}

// MARK: -- 暂时没有用到的部分 --
extension JMPageParse {
    /**
     *  若点击位置有链接返回链接对象否则返回nil
     *
     *  @param view  点击的视图
     *  @param point 点击位置
     *  @param data  存放富文本的数据
     *
     *  @return 返回链接对象
     */
    public static func touchLike(view: UIView, atPoint: CGPoint, ctFrame: CTFrame) {
        guard let lines: [CTLine] = CTFrameGetLines(ctFrame) as? [CTLine] else {
            return
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
                Logger.debug(idx)
            }
        }
        return
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
