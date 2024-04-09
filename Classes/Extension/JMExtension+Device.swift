//
//  JMExtension+Device.swift
//  Pods-Snp_Layout
//
//  Created by JunMing on 2020/5/21.
//  Copyright © 2022 JunMing. All rights reserved.
//

import Foundation

extension UIDevice {
    public static var isiPhoneXorLater:Bool {
        let screenHieght = UIScreen.main.nativeBounds.size.height
        for value in [2436,1792,2688,1624] {
            if CGFloat(value) == screenHieght {
                return true
            }
        }
        return false
    }
    
    public static var isiPhoneX: Bool {
        if #available(iOS 11, *) {
              guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                  return false
              }
              
              if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
                  print(unwrapedWindow.safeAreaInsets)
                  return true
              }
        }
        return false
    }
    
    // 底部非安全区域高度
    public static var footerSafeAreaHeight:CGFloat {
        if UIDevice.isiPhoneXorLater {
            return 34.0
        }else {
            return 0.0
        }
    }
    
    // 刘海屏额外的高度
    public static var headerSafeAreaHeight:CGFloat {
        if UIDevice.isiPhoneXorLater {
            return 24.0
        }else {
            return 0.0
        }
    }
}

