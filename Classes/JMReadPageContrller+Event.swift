//
//  JMReadPageContrller+Event.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/30.
//

import UIKit

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
        
        jmRegisterEvent(eventName: kEventNameMenuActionListenBook, block: { (_) in
            
        }, next: false)
        
        
        jmRegisterEvent(eventName: kEventNameMenuActionShareWifi, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionMore, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionBookCatalog, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionDayOrNight, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionBrightness, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionSettingMore, block: { (_) in
            
        }, next: false)
    }
}
