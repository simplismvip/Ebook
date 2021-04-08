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
        
        jmRegisterEvent(eventName: kEventNameMenuActionListenBook, block: { [weak self](_) in
            self?.menuView.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
            self?.menuView.showOrHide.onNext(JMMenuStatus.ShowPlay(false))
        }, next: false)
        
        
        jmRegisterEvent(eventName: kEventNameMenuActionShareWifi, block: { (_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionMore, block: { [weak self](_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionBookCatalog, block: { [weak self](_) in
            if let tocItems = self?.bookModel.toc {
                self?.menuView.showChapter(items: tocItems)
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionDayOrNight, block: { [weak self](_) in
            
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionBrightness, block: { [weak self](_) in
            self?.menuView.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
            self?.menuView.showOrHide.onNext(JMMenuStatus.ShowLight(false))
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionSettingMore, block: { [weak self](_) in
            self?.menuView.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
            self?.menuView.showOrHide.onNext(JMMenuStatus.ShowSet(false))
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuFontSizeSlider, block: { [weak self](value) in
            print(value as Any)
        }, next: false)
    }
}

// TODO: -- RxSwift Method --
extension JMReadPageContrller {
    func binder() {
//        let input = JMEpubVModel.JMInput(path: Bundle.resouseBundle!.path(forResource: "TianXiaDaoZong", ofType: "epub")!)
//        let output = vmodel.transform(input: input)
//        output.refresh.bind(to: rx.isLoading).disposed(by: disposeBag)
        
        rx.viewWillAppear.asObservable().subscribe { [weak self](_) in
            self?.navigationController?.setNavigationBarHidden(true, animated: false)
        }.disposed(by: disposeBag)
        
        rx.viewWillDisappear.asObservable().subscribe { [weak self](_) in
            self?.navigationController?.setNavigationBarHidden(false, animated: false)
        }.disposed(by: disposeBag)
    }
}
