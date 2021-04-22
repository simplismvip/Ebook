//
//  JMChapterContainer.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/21.
//

import UIKit
import ZJMKit

final class JMChapterContainer: JMBaseView {
    private let titleLabel = UILabel()
    private let chapterCount = UILabel()
    private let sortBtn = UIButton(type: .system)
    private let switchView = JMReadItemView()
    private let chapter = JMChapterView()
    private let chapterTag = JMChapterTagView()
    private let bkgView = UIView()
    private let s_width = UIScreen.main.bounds.size.width - 60
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.menuBkg
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        regiEvent()
        sortBtn.setTitle("排序↑", for: .normal)
        backgroundColor = UIColor.black.jmComponent(0.5)
        bkgView.backgroundColor = UIColor.menuBkg
        chapter.backgroundColor = UIColor.menuBkg
        titleLabel.font = UIFont.jmMedium(20)
        chapterCount.font = UIFont.jmRegular(14)
        sortBtn.tintColor = UIColor.black
        switchView.margin = 50
        switchView.updateViews(JMJsonParse.parseJson(name: "menu_charper"))
    }
    
    /// 更新目录数据
    public func updateSource(_ items: [JMBookCharpter], title: String, currCharter: Int){
        chapter.updateChartper(items, title, currCharter)
        titleLabel.text = title
        chapterCount.text = "已完结｜共\(items.count)章"
    }
    
    /// 更新目录数据
    public func updateTags(_ bookid: String) {
        chapterTag.updateChartper(JMBookDataBase.share.fetchTag(bookid: bookid))
    }
    
    private func regiEvent() {
        jmRegisterEvent(eventName: kEventNameMenuShowCharter, block: { [weak self](_) in
            self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self?.sortBtn.isHidden = false
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuShowCharterTag, block: { [weak self](_) in
            let width = UIScreen.main.bounds.size.width - 60
            self?.scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: true)
            self?.sortBtn.isHidden = true
        }, next: false)
        
        sortBtn.jmAddAction { [weak self](_) in
            self?.chapter.reverse()
        }
        
        jmAddblock { [weak self] in
            self?.jmRouterEvent(eventName: kEventNameDidSelectChapter, info: nil)
        }
    }
    
    private func setupViews() {
        addSubview(bkgView)
        bkgView.addSubview(scrollView)
        bkgView.addSubview(switchView)
        bkgView.addSubview(titleLabel)
        bkgView.addSubview(chapterCount)
        bkgView.addSubview(sortBtn)
        
        scrollView.addSubview(chapter)
        scrollView.addSubview(chapterTag)
        
        bkgView.snp.makeConstraints { (make) in
            make.left.bottom.top.equalTo(self)
            make.width.equalTo(s_width)
            make.height.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.equalTo(bkgView).offset(15)
            if #available(iOS 11.0, *) {
                make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            } else {
                make.top.equalTo(snp.top).offset(10)
            }
        }
        
        chapterCount.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.height.equalTo(26)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        sortBtn.snp.makeConstraints { (make) in
            make.top.equalTo(chapterCount.snp.top).offset(-5)
            make.right.equalTo(bkgView.snp.right).offset(-20)
            make.height.height.equalTo(34)
        }
        
        switchView.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.width.equalTo(bkgView)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(snp.bottom)
            }
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.left.width.equalTo(bkgView)
            make.top.equalTo(chapterCount.snp.bottom).offset(5)
            make.bottom.equalTo(switchView.snp.top)
        }
        
        chapter.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView)
            make.width.height.equalTo(scrollView)
            make.top.bottom.equalTo(scrollView)
        }
        
        chapterTag.snp.makeConstraints { (make) in
            make.left.equalTo(chapter.snp.right)
            make.width.height.equalTo(scrollView)
            make.top.bottom.equalTo(scrollView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: s_width * 2, height: scrollView.jmHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JMChapterContainer: UIScrollViewDelegate {
    // 任何滚动结束
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sortBtn.isHidden = scrollView.contentOffset.x > (s_width/3)
    }
    
    // 滚动结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating {
            switchStatus(scrollView.contentOffset.x > (s_width/3))
        }
    }
    
    // 滚动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating {
            switchStatus(scrollView.contentOffset.x > (s_width/3))
        }
    }
    
    private func switchStatus(_ status: Bool) {
        for item in switchView.models {
            if item.identify == .CharterTag {
                item.isSelect = status
            }else {
                item.isSelect = !status
            }
        }
        print(status)
    }
}
