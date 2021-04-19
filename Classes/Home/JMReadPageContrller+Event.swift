//
//  JMReadPageContrller+Event.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/30.
//

import UIKit

// TODO: -- Register Event --
extension JMReadPageContrller {
    func registerMenuEvent() {
        jmRegisterEvent(eventName: kEventNameMenuActionTapAction, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionTapLeft, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionTapRight, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionSwipeLeft, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionSwipeRight, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionBack, block: { [weak self](_) in
            self?.navigationController?.popViewController(animated: true)
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionShare, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionShareWifi, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionMore, block: { [weak self](_) in
            if let page = self?.bookModel.currPage(), page.attribute.length > 10 {
                self?.speech.readImmediately(page.attribute, clear: false)
            }
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionBookCatalog, block: { [weak self](_) in
            if let tocItems = self?.bookModel.catalogs {
                self?.showChapter(items: tocItems)
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionDayOrNight, block: { [weak self](_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionListenBook, block: { [weak self](_) in
//            self?.menuView.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//            self?.menuView.showOrHide.onNext(JMMenuStatus.ShowPlay(false))
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionBrightness, block: { [weak self](_) in
//            self?.menuView.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//            self?.menuView.showOrHide.onNext(JMMenuStatus.ShowLight(false))
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionSettingMore, block: { [weak self](_) in
//            self?.menuView.showWithType(type: .ViewType_SET)
//            self?.menuView.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//            self?.menuView.showOrHide.onNext(JMMenuStatus.ShowSet(false))
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuFontSizeSlider, block: { [weak self](value) in
            print(value as Any)
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameDidSelectChapter, block: { [weak self](value) in
            print(value as Any)
        }, next: false)
    }
}
