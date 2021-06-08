//
//  JMBookDataBase.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/22.
//

import Foundation
import FMDB
import ZJMKit

struct JMBookDataBase {
    static let share: JMBookDataBase = { return JMBookDataBase() }()
    private let db: FMDatabase
    init() {
        db = FMDatabase(path: JMTools.jmDocuPath()?.appendingPathComponent(".jmeook.sqlite"))
        if db.open() {
            do {
                // 书签
                let bookTag = "CREATE TABLE IF NOT EXISTS bookCharterTag(" +
                "name varchar(100)," +
                "bookid varchar(20)," +
                "timeStr varchar(30)," +
                "charter integer," +
                "location integer," +
                "text varchar(300))"
                try db.executeUpdate(bookTag, values: nil)
                
                // 阅读进度
                let bookRate = "CREATE TABLE IF NOT EXISTS bookRate(" +
                "name varchar(100)," +
                "bookid varchar(20)," +
                "timeStr varchar(30)," +
                "charter integer," +
                "location integer," +
                "text varchar(300))"
                try db.executeUpdate(bookRate, values: nil)
            } catch {
                print(db.lastErrorMessage())
            }
        } else {
            print("🆘🆘🆘打开DB失败！")
        }
    }
    
    /// isTag: 是否是书签🔖
    static func insertData(isTag: Bool, book: JMBookModel) {
        if let targetPage = book.currPage()?.string {
            let text = String(targetPage.prefix(isTag ? 30 : 10))
            if isTag {
                let location = book.currLocation(target: text)
                JMBookDataBase.share.insertData(isTag: isTag, name: book.title, bookid: book.bookId, charter: book.indexPath.chapter, location: location, text: text)
            }else {
                if JMBookDataBase.share.isFieldExistsForRate(book.bookId) {
                    JMBookDataBase.share.update(tableName: "bookRate", bookid: book.bookId, updateFieldName: "charter", updateField: book.indexPath.chapter)
                    JMBookDataBase.share.update(tableName: "bookRate", bookid: book.bookId, updateFieldName: "text", updateField: text)
                    let location = book.currLocation(target: text)
                    JMBookDataBase.share.update(tableName: "bookRate", bookid: book.bookId, updateFieldName: "location", updateField: location)
                    print("⚠️⚠️⚠️更新表 bookRate")
                } else {
                    let location = book.currLocation(target: text)
                    JMBookDataBase.share.insertData(isTag: isTag, name: book.title, bookid: book.bookId, charter: book.indexPath.chapter, location: location, text: text)
                }
            }
        }
    }
    
    /// 插入数据
    func insertData(isTag: Bool, name: String, bookid: String, charter: Int, location: Int, text: String) {
        if isTag {
            if isFieldExistsForTag(text: text) {
                print("⚠️⚠️⚠️表bookCharterTag已经存在")
                return
            }
        }else {
            if isFieldExistsForRate(bookid) {
                print("⚠️⚠️⚠️表bookRate已经存在")
                return
            }
        }
        
        do {
            let time = Date.jmCurrentTime
            let timeStr = String(time).components(separatedBy: ".")[0]
            let insetSql = "INSERT INTO \(isTag ? "bookCharterTag" : "bookRate")(name,bookid,charter,location,text,timeStr)values(?,?,?,?,?,?)"
            let values = [name, bookid, charter, location, text, timeStr] as [Any]
            try db.executeUpdate(insetSql, values: values)
        }catch {
            print(db.lastErrorMessage())
        }
    }
    
    /// 查询数据
    func fetchTag(bookid: String) -> [JMChapterTag] {
        var tempArray = [JMChapterTag]()
        do {
            let set = try db.executeQuery("SELECT * FROM bookCharterTag WHERE bookid = ?", values: [bookid])
            while set.next() {
                if let text = set.string(forColumn: "text"),
                   let timeStr = set.string(forColumn: "timeStr") {
                    let charter = set.int(forColumn: "charter")
                    let location = set.int(forColumn: "location")
                    tempArray.append(JMChapterTag(text: text, timeStr: timeStr, charter: Int(charter), location: Int(location)))
                }
            }
        } catch {
            print(db.lastErrorMessage())
        }
        return tempArray
    }
    
    /// 查询数据
    func fetchRate(bookid: String) -> JMChapterTag? {
        do {
            let set = try db.executeQuery("SELECT * FROM bookRate WHERE bookid = ?", values: [bookid])
            while set.next() {
                if let text = set.string(forColumn: "text"),
                   let timeStr = set.string(forColumn: "timeStr") {
                    let charter = set.int(forColumn: "charter")
                    let location = set.int(forColumn: "location")
                    return JMChapterTag(text: text, timeStr: timeStr, charter: Int(charter), location: Int(location))
                }
            }
        } catch {
            print(db.lastErrorMessage())
        }
        
        return nil
    }
    
    /// 根据插入内容判断数据库中是否有当前数据
    func isFieldExistsForRate(_ bookid: String) -> Bool {
        let sql = String(format: "SELECT bookid FROM bookRate WHERE bookid = '%@'", bookid)
        if let set = try? db.executeQuery(sql, values: nil), set.next() {
            return true
        } else {
            print(db.lastErrorMessage())
            return false
        }
    }
    
    /// 根据插入内容判断数据库中是否有当前数据
    func isFieldExistsForTag(text: String) -> Bool {
        let sql = String(format: "SELECT bookid FROM bookCharterTag WHERE text = '%@'", text)
        if let set = try? db.executeQuery(sql, values: nil), set.next() {
            return true
        } else {
            print(db.lastErrorMessage())
            return false
        }
    }

    /// 根据模型删除数据
    func deleteLocalDB(tableName: String, bookid: String) {
        do{
            let deleteSql = "DELETE FROM \(tableName) WHERE bookid = ?"
            try db.executeUpdate(deleteSql, values: [bookid])
        } catch {
            print(db.lastErrorMessage())
        }
    }
    
    /// 根据bookid更新状态数据
    func update(tableName: String, bookid: String, updateFieldName: String, updateField: Any) {
        do{
            try db.executeUpdate("UPDATE \(tableName) SET \(updateFieldName) = ? where bookid = ?", values: [updateField, bookid])
        } catch {
            print(db.lastErrorMessage())
        }
    }

    /// 删除所有数据
    func deleteAllLocalDB() {
        do{
            try db.executeUpdate("truncate table localEpubInfo", values: nil)
        } catch {
            print(db.lastErrorMessage())
        }
    }
}
