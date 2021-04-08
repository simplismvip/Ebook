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
            chapterCount.text = "已完结｜共\(newValue.count)章"
            sortBtn.setTitle("排序↑", for: .normal)
            tableView.reloadData()
        }
    }
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: bounds, style: .plain)
        tableView.register(JMBookChapterCell.self, forCellReuseIdentifier: "kReuseCellIdentifier")
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = backgroundColor
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        return tableView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        addSubview(titleLabel)
        addSubview(sortBtn)
        addSubview(chapterCount)
        
        titleLabel.font = UIFont.jmMedium(20)
        chapterCount.font = UIFont.jmRegular(14)
        sortBtn.tintColor = UIColor.black
        
        chapterCount.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(8)
            make.height.equalTo(self)
            make.width.equalTo(200)
        }
        
        chapterCount.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(8)
            make.height.equalTo(self)
            make.width.equalTo(200)
        }
        
        sortBtn.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-5)
            make.height.equalTo(self)
            make.width.equalTo(60)
        }
        
        sortBtn.jmAddAction { (_) in
            // 排序
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "kReuseCellIdentifier")
        if cell == nil { cell = JMBookChapterCell(style: .default, reuseIdentifier: "kReuseCellIdentifier") }
        let newCell = cell as! JMBookChapterCell
        newCell.setup(dataSource[indexPath.row])
        return newCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -- Cell
class JMBookChapterCell: JMBaseTableViewCell {
    private let index = UILabel()
    private let line = UIView()
    private let lock = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        index.lineBreakMode = .byWordWrapping
        index.numberOfLines = 0
        index.translatesAutoresizingMaskIntoConstraints = false
        index.font = UIFont(name: "Avenir-Light", size: 17)
        line.backgroundColor = UIColor.jmHexColor("EAEAEA")
        lock.jmConfigLabel(alig: .right, font: .jmAvenir(12), color: .gray)
        
        addSubview(index)
        addSubview(line)
        addSubview(lock)
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.right.equalTo(snp.right).offset(-20)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        
        index.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(10)
            make.right.equalTo(snp.right).offset(-60)
            make.height.equalTo(self)
            make.bottom.equalTo(line.snp.top)
        }
        
        lock.snp.makeConstraints { (make) in
            make.left.equalTo(index.snp.left).offset(10)
            make.right.equalTo(snp.right).offset(-20)
            make.height.equalTo(self)
            make.bottom.equalTo(line.snp.top)
        }
    }

    func setup(_ item: JMBookChapter) {
        index.text = item.title
        lock.text = "免费"
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️") }
}

    
