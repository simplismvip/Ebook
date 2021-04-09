//
//  JMReadMenuContainer+Ext.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/8.
//

import Foundation

extension JMReadMenuContainer {
    func switchWithType() {
        if currType == .ViewType_TOP_BOTTOM {
            
        }else if currType == .ViewType_LIGHT {
            
        }else if currType == .ViewType_SET {
            
        }else if currType == .ViewType_CHAPTER {
            
        }else if currType == .ViewType_PLAY {
            
        }else if currType == .ViewType_NONE {
            
        }
    }
    
    /// 展示
    func showWithType(type: JMMenuViewType) {
        self.currType = type
        if type == .ViewType_TOP_BOTTOM {
            topContainer.snp.updateConstraints { (make) in
                make.top.equalTo(snp.top)
            }
            
            bottomContainer.snp.updateConstraints { (make) in
                make.bottom.equalTo(snp.bottom)
            }
            
        }else if type == .ViewType_LIGHT {
            light.snp.updateConstraints { (make) in
                make.bottom.equalTo(snp.bottom)
            }
        }else if type == .ViewType_SET {
            set.snp.updateConstraints { (make) in
                make.bottom.equalTo(snp.bottom)
            }
        }else if type == .ViewType_CHAPTER {
            chapter.snp.updateConstraints { (make) in
                make.left.equalTo(self)
            }
        }else if type == .ViewType_PLAY {
            play.snp.updateConstraints { (make) in
                make.bottom.equalTo(snp.bottom)
            }
        }else if type == .ViewType_NONE {
            
        }
        
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    /// 隐藏
    func hideWithType() {
        if currType == .ViewType_TOP_BOTTOM {
            topContainer.snp.updateConstraints { (make) in
                make.top.equalTo(snp.top).offset(-104)
            }

            bottomContainer.snp.updateConstraints { (make) in
                make.bottom.equalTo(snp.bottom).offset(104)
            }
        }else if currType == .ViewType_LIGHT {
            light.snp.updateConstraints { (make) in
                make.bottom.equalTo(snp.bottom).offset(160)
            }
        }else if currType == .ViewType_SET {
            set.snp.updateConstraints { (make) in
                make.bottom.equalTo(snp.bottom).offset(320)
            }
        }else if currType == .ViewType_CHAPTER {
            let width = UIScreen.main.bounds.size.width * 0.7
            chapter.snp.updateConstraints { (make) in
                make.left.equalTo(self).offset(-width)
            }
        }else if currType == .ViewType_PLAY {
            play.snp.updateConstraints { (make) in
                make.bottom.equalTo(snp.bottom).offset(230)
            }
        }else if currType == .ViewType_NONE {
            
        }
        
        // 重置
        currType = .ViewType_NONE
        
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
