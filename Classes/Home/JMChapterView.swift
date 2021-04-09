//
//  JMChapterView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/8.
//

import UIKit
import ZJMKit

final class JMChapterView: JMBaseView, UITableViewDelegate, UITableViewDataSource {
    private let titleLabel = UILabel()
    private let chapterCount = UILabel()
    private let sortBtn = UIButton(type: .system)
    var dataSource = [JMBookChapter]() {
        willSet {
            titleLabel.text = "三国演义"
            chapterCount.text = "已完结｜共\(newValue.count)章"
            sortBtn.setTitle("排序↑", for: .normal)
        }
        
        didSet {
            tableView.reloadData()
        }
    }
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: bounds, style: .plain)
        tableView.register(JMBookChapterCell.self, forCellReuseIdentifier: "kReuseCellIdentifier")
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.jmRGB(200, 200, 200)
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.jmRGB(150, 150, 150)
        addSubview(tableView)
        addSubview(titleLabel)
        addSubview(chapterCount)
        addSubview(sortBtn)
        
        titleLabel.font = UIFont.jmMedium(20)
        chapterCount.font = UIFont.jmRegular(14)
        sortBtn.tintColor = UIColor.black
        
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.equalTo(self).offset(15)
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
            make.right.equalTo(snp.right).offset(-20)
            make.height.height.equalTo(34)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.width.bottom.equalTo(self)
            make.top.equalTo(chapterCount.snp.bottom).offset(5)
        }
        
        sortBtn.jmAddAction { [weak self](_) in
            self?.dataSource.reverse()
            self?.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].subTable?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "kReuseCellIdentifier")
        if cell == nil { cell = JMBookChapterCell(style: .default, reuseIdentifier: "kReuseCellIdentifier") }
        let newCell = cell as! JMBookChapterCell
        if let item = dataSource[indexPath.section].subTable?[indexPath.row] {
            newCell.setup(item)
        }
        return newCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = JMReaderHeaderView.reuse()
        header.config(dataSource[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataSource[indexPath.section].subTable?[indexPath.row] {
            jmRouterEvent(eventName: kEventNameDidSelectChapter, info: item as MsgObjc)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -- Cell
class JMBookChapterCell: JMBaseTableViewCell {
    private let index = UILabel()
    private let lock = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.jmRGB(200, 200, 200)
        index.lineBreakMode = .byWordWrapping
        index.numberOfLines = 0
        index.translatesAutoresizingMaskIntoConstraints = false
        index.font = UIFont(name: "Avenir-Light", size: 15)
        lock.jmConfigLabel(alig: .right, font: .jmAvenir(12), color: .gray)
        
        contentView.addSubview(index)
        contentView.addSubview(lock)
        
        index.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(40)
            make.right.equalTo(snp.right).offset(-60)
            make.height.equalTo(self)
            make.bottom.equalTo(snp.bottom)
        }
        
        lock.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-20)
            make.height.equalTo(self)
            make.bottom.equalTo(snp.bottom)
        }
    }

    func setup(_ item: JMBookChapter) {
        index.text = item.title
        lock.text = "免费"
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️") }
}

    
// MARK: -- headerView --
class JMReaderHeaderView: UITableViewHeaderFooterView {
    private let label = UILabel()
    private let actionBtn = UIButton(type: .system)
    public static func reuse() ->JMReaderHeaderView  {
        return JMReaderHeaderView(reuseIdentifier: "SRHomeHeaderView")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.jmRGB(200, 200, 200)
        contentView.addSubview(label)
        contentView.addSubview(actionBtn)
        label.font = UIFont(name: "Avenir-Light", size: 15)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(15)
            make.right.equalTo(snp.right).offset(-60)
            make.height.equalTo(self)
            make.bottom.equalTo(snp.bottom)
        }
        
        actionBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func config(_ model: JMBookChapter) {
        label.text = model.title
        actionBtn.jmAddAction { [weak self](_) in
            self?.jmRouterEvent(eventName: kEventNameDidSelectChapter, info: model as MsgObjc)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
