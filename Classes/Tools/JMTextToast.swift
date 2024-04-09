//
//  JMTextToast.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/6/29.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

// Toast
public struct JMToast {
    static func toast(_ text: String, second: Int = 1) {
        JMTextToast.share.jmShowString(text: text, seconds: TimeInterval(second))
    }
}

open class JMTextToast: NSObject {
    public static let share:JMTextToast = { return JMTextToast() }()
    private var strViews = [UIView]()
    private func jmShowString(text:String,seconds:TimeInterval,onView:UIView?,offset:CGPoint) {
        func addContainerViews(containerView:UIView, backView:UIView) {
            containerView.addSubview(backView)
            containerView.bringSubview(toFront: backView)
            createLable(backView: backView)
            
            if let containerView = UIApplication.shared.keyWindow {
                containerView.layoutIfNeeded()
                self.perform(#selector(alertHidden(_:)), with: backView, afterDelay: seconds, inModes: [RunLoopMode.commonModes])
                let deadLine = DispatchTime.now()+seconds
                DispatchQueue.main.asyncAfter(deadline: deadLine) {
                    self.alertHidden(backView)
                }
                strViews.append(backView)
            }
        }
        
        func layoutLable(label:UILabel){
            label.text = text
            let info = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13.0)]
            let size = text.boundingRect(with: CGSize(width: 320, height: 1000), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes:info ,context: nil).size
            
            var width:CGFloat = 0
            if size.width + 30 > 320 {
                width = 320
            }else {
                width = size.width + 30
            }
            guard let suview = label.superview else { return }
            guard let container = suview.superview else { return }
            
            // label layout
            label.translatesAutoresizingMaskIntoConstraints = false
            suview.translatesAutoresizingMaskIntoConstraints = false
            
            let bottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: suview, attribute: .bottom, multiplier: 1, constant: -10)
            let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: suview, attribute: .top, multiplier: 1, constant: 10)
            let leading = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: suview, attribute: .leading, multiplier: 1, constant: 11)
            let trailing = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: suview, attribute: .trailing, multiplier: 1, constant: -11)
            let constHeight = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: size.height+5)
            let constWidth = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width-27)
            suview.addConstraints([constHeight,constWidth,bottom,top,leading,trailing])
            
            // suview layout
            let consCentX = NSLayoutConstraint(item: suview, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1, constant: offset.x)
            let consCentY = NSLayoutConstraint(item: suview, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: offset.y)
            container.addConstraints([consCentX,consCentY])
        }
        
        func createLable(backView:UIView) {
            if let view = backView.viewWithTag(100000012),let label = view as? UILabel {
                layoutLable(label: label)
            }else{
                let label = UILabel()
                label.tag = 100000012
                label.font = UIFont.systemFont(ofSize: 13)
                label.textColor = UIColor.white
                label.numberOfLines = 0
                label.textAlignment = .center
                backView.addSubview(label)
                layoutLable(label: label)
            }
        }
        
        if let containerView = onView, let backView = containerView.viewWithTag(100000011) {
            backView.removeFromSuperview()
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(alertHidden(_:)), object: backView)
            addContainerViews(containerView: containerView, backView: backView)
        }else {
            if let containerView = UIApplication.shared.keyWindow {
                let backView = UIView()
                backView.tag = 100000011
                backView.backgroundColor = UIColor.black.jmComponent(0.65)
                backView.layer.cornerRadius = 5
                addContainerViews(containerView: containerView, backView: backView)
            }
        }
    }
    
    @objc func alertHidden(_ backView:UIView?){
        guard let backview = backView else { return }
        backview.removeFromSuperview()
        strViews.removeAll()
    }
    
    /// 展示Toast，设置时间
    open func jmShowString(text:String, seconds:TimeInterval) {
        DispatchQueue.main.async {
            self.jmShowString(text: text, seconds: seconds, onView: nil, offset: CGPoint(x: 0, y: 0))
        }
    }
    
    /// 展示Toast，默认时间1秒钟
    open func jmShowString(text:String, onview:UIView) {
        DispatchQueue.main.async {
            self.jmShowString(text: text, seconds: 1, onView: onview, offset: CGPoint(x: 0, y: 0))
        }
    }
    
    /// 展示Toast
    open func jmShowString(text:String, seconds:TimeInterval, offset:CGPoint) {
        DispatchQueue.main.async {
            self.jmShowString(text: text, seconds: seconds, onView: nil, offset: offset)
        }
    }
    
    func dismissAllString(){
        strViews.forEach({ view in
            alertHidden(view)
        })
    }
}

