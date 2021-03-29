//
//  JMReadPageContrller.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/3.
//

import UIKit
import ZJMKit
import SnapKit
import RxCocoa
import RxSwift

public class JMReadPageContrller: JMBaseController {
    lazy var colleView: JMBaseCollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets.zero
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.scrollDirection = JMReadConfig.share.scrollDirection.scrollDirection()
        let collectionView = JMBaseCollectionView(frame: self.view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(JMReadPageView.self, forCellWithReuseIdentifier: kReuseCellIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate(10)
        collectionView.backgroundColor = UIColor.red
        return collectionView
    }()
    
    public let bookTitle = UILabel()
    public let page = UILabel()
    public let activity = UIActivityIndicatorView()
    let vmodel = JMEpubVModel()
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configUI()
        binder()
    }
    
    func binder() {
        let input = JMEpubVModel.JMInput(path: "/Users/jl/Desktop/EPUB/TianXiaDaoZong.epub")
        let output = vmodel.transform(input: input)
        output.refresh.bind(to: rx.isLoading).disposed(by: disposeBag)
        output.items.asObservable()
            .bind(to: colleView.rx.items(cellIdentifier: kReuseCellIdentifier, cellType: JMReadPageView.self)) { [weak self](row, model, cell) in
                self?.bookTitle.text = row.description
            }
            .disposed(by: disposeBag)
        colleView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

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

extension JMReadPageContrller {
    func setupUI() {
        view.addSubview(bookTitle)
        view.addSubview(colleView)
        view.addSubview(page)
        view.addSubview(activity)
        activity.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.centerX.centerY.equalTo(view)
        }
        
        bookTitle.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(view.snp.top)
            }
            make.height.equalTo(34)
        }
        
        page.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(28)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }else {
                make.bottom.equalTo(view.snp.bottom)
            }
        }
        
        colleView.snp.makeConstraints { make in
            make.width.equalTo(view)
            make.top.equalTo(bookTitle.snp.bottom)
            make.bottom.equalTo(page.snp.top)
        }
        
        configUI()
    }
    
    func configUI() {
        view.backgroundColor = UIColor.white
        bookTitle.text = "朝鲜战争：李奇微回忆录"
        page.text = "114"
        bookTitle.jmConfigLabel(alig: .center, font: UIFont.jmBold(20), color: UIColor.jmHexColor("#333333"))
        page.jmConfigLabel(alig: .center, font: UIFont.jmBold(20), color: UIColor.jmHexColor("#333333"))
        
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.color = UIColor.gray
    }
}
