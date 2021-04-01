//
//  JMReadPageContrller+Collection.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/1.
//

import UIKit

extension JMReadPageContrller: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: collectionView.jmWidth, height: collectionView.jmHeight)
        if #available(iOS 11.0, *) {
            let orientation = UIDevice.current.orientation
            if orientation == .portrait || orientation == .portraitUpsideDown {
                if JMReadConfig.share.scrollDirection == .horizontal {
                    size.height = size.height - view.safeAreaInsets.bottom
                }
            }
        }
        return size
    }
}
