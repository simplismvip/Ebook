//
//  JMBookDataBase.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/22.
//

import Foundation

public struct JMBookDataBase {
//    private let db: FMDatabase
//    static let share: JMBookDataBase = {
//        return JMBookDataBase()
//    }()
//
//    init() {
//        db = FMDatabase(path: JMFileTools.jmDocuPath()?.appendingPathComponent(".jmeook.sqlite"))
//        if db.open() {
//            do {
//                // 书签
//                let bookTag = "CREATE TABLE IF NOT EXISTS bookCharterTag(" +
//                "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," +
//                "name varchar(100)," +
//                "bookid varchar(20)," +
//                "timeStr varchar(30)," +
//                "charter integer," +
//                "location integer," +
//                "text varchar(300))"
//                try db.executeUpdate(bookTag, values: nil)
//                
//                // 阅读进度
//                let bookRate = "CREATE TABLE IF NOT EXISTS bookRate(" +
//                "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," +
//                "name varchar(100)," +
//                "bookid varchar(20)," +
//                "timeStr varchar(30)," +
//                "charter integer," +
//                "location integer," +
//                "text varchar(300))"
//                try db.executeUpdate(bookRate, values: nil)
//                
//                // 记录阅读时长
//                let readTime = "CREATE TABLE IF NOT EXISTS readTime(" +
//                    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," +
//                    "bookid varchar(20)," +
//                    "dateT varchar(20)," +
//                    "time integer)"
//                try db.executeUpdate(readTime, values: nil)
//            } catch {
//                Logger.error(db.lastErrorMessage())
//            }
//        } else {
//            Logger.error("🆘🆘🆘打开DB失败！")
//        }
//    }
    
    /// 根据模型删除数据
    func deleteLocalDB(tableName: String, bookid: String) {
//        do {
//            let deleteSql = "DELETE FROM \(tableName) WHERE bookid = ?"
//            try db.executeUpdate(deleteSql, values: [bookid])
//        } catch {
//            Logger.debug(db.lastErrorMessage())
//        }
    }
    
    /// 插入数据
    private func insertData(isTag: Bool, name: String, bookid: String, charter: Int, location: Int, text: String) {
//        if isTag {
//            if isFieldExistsForTag(text: text) {
//                Logger.debug("⚠️⚠️⚠️表bookCharterTag已经存在")
//                return
//            }
//        } else {
//            if isFieldExistsForRate(bookid) {
//                Logger.debug("⚠️⚠️⚠️表bookRate已经存在")
//                return
//            }
//        }
//        
//        do {
//            let time = Date.jmCurrentTime
//            let timeStr = String(time).components(separatedBy: ".")[0]
//            let insetSql = "INSERT INTO \(isTag ? "bookCharterTag" : "bookRate")(name,bookid,charter,location,text,timeStr)values(?,?,?,?,?,?)"
//            let values = [name, bookid, charter, location, text, timeStr] as [Any]
//            try db.executeUpdate(insetSql, values: values)
//        } catch {
//            Logger.debug(db.lastErrorMessage())
//        }
    }
    
    /// 根据bookid更新状态数据
    private func update(tableName: String, bookid: String, updateFieldName: String, updateField: Any) {
//        do {
//            try db.executeUpdate("UPDATE \(tableName) SET \(updateFieldName) = ? where bookid = ?", values: [updateField, bookid])
//        } catch {
//            Logger.debug(db.lastErrorMessage())
//        }
    }
}

// MARK: -- bookRate && bookCharterTag 公共方法
extension JMBookDataBase {
    /// isTag: 是否是书签🔖
    public static func insertData(isTag: Bool, book: JMBookModel) {
        
//        guard let targetPage = book.currPage()?.string else {
//            return
//        }
//        
//        let text = String(targetPage.prefix(isTag ? 30 : 10))
//        if isTag {
//            let location = book.currLocation(target: text)
//            JMBookDataBase.share.insertData(isTag: isTag, name: book.title, bookid: book.bookId, charter: book.indexPath.chapter, location: location, text: text)
//        } else {
//            if JMBookDataBase.share.isFieldExistsForRate(book.bookId) {
//                JMBookDataBase.share.update(tableName: "bookRate", bookid: book.bookId, updateFieldName: "charter", updateField: book.indexPath.chapter)
//                JMBookDataBase.share.update(tableName: "bookRate", bookid: book.bookId, updateFieldName: "text", updateField: text)
//                
//                let location = book.currLocation(target: text)
//                JMBookDataBase.share.update(tableName: "bookRate", bookid: book.bookId, updateFieldName: "location", updateField: location)
//                
//                let timeStr = String(Date.jmCurrentTime).components(separatedBy: ".")[0]
//                JMBookDataBase.share.update(tableName: "bookRate", bookid: book.bookId, updateFieldName: "timeStr", updateField: timeStr)
//                Logger.debug("⚠️⚠️⚠️更新表 bookRate")
//            } else {
//                let location = book.currLocation(target: text)
//                JMBookDataBase.share.insertData(isTag: isTag, name: book.title, bookid: book.bookId, charter: book.indexPath.chapter, location: location, text: text)
//            }
//        }
    }
}

// MARK: -- bookRate 阅读进度
extension JMBookDataBase {
    /// 查询数据
    public static func fetchRate(bookid: String) -> JMChapterTag? {
//        do {
//            let set = try JMBookDataBase.share.db.executeQuery("SELECT * FROM bookRate WHERE bookid = ?", values: [bookid])
//            while set.next() {
//                if let text = set.string(forColumn: "text"),
//                   let timeStr = set.string(forColumn: "timeStr") {
//                    let charter = set.int(forColumn: "charter")
//                    let location = set.int(forColumn: "location")
//                    return JMChapterTag(text: text, timeStr: timeStr, charter: Int(charter), location: Int(location))
//                }
//            }
//        } catch {
//            Logger.debug(JMBookDataBase.share.db.lastErrorMessage())
//        }
        
        return nil
    }
    
    /// 根据插入内容判断数据库中是否有当前数据
    private func isFieldExistsForRate(_ bookid: String) -> Bool {
//        let sql = String(format: "SELECT bookid FROM bookRate WHERE bookid = '%@'", bookid)
//        if let set = try? db.executeQuery(sql, values: nil), set.next() {
//            return true
//        } else {
//            Logger.debug(db.lastErrorMessage())
//            return false
//        }
        return true
    }
}

// MARK: -- bookCharterTag 书签
extension JMBookDataBase {
    /// 根据插入内容判断数据库中是否有当前数据
    private func isFieldExistsForTag(text: String) -> Bool {
//        let sql = String(format: "SELECT bookid FROM bookCharterTag WHERE text = '%@'", text)
//        if let set = try? db.executeQuery(sql, values: nil), set.next() {
//            return true
//        } else {
//            Logger.debug(db.lastErrorMessage())
//            return false
//        }
        return true
    }
    
    /// 查询数据
    public static func fetchTag(bookid: String) -> [JMChapterTag] {
        var tempArray = [JMChapterTag]()
//        do {
//            let set = try JMBookDataBase.share.db.executeQuery("SELECT * FROM bookCharterTag WHERE bookid = ?", values: [bookid])
//            while set.next() {
//                if let text = set.string(forColumn: "text"),
//                   let timeStr = set.string(forColumn: "timeStr") {
//                    let charter = set.int(forColumn: "charter")
//                    let location = set.int(forColumn: "location")
//                    tempArray.append(JMChapterTag(text: text, timeStr: timeStr, charter: Int(charter), location: Int(location)))
//                }
//            }
//        } catch {
//            Logger.debug(JMBookDataBase.share.db.lastErrorMessage())
//        }
        return tempArray
    }
}

// MARK: -- readTime 阅读时长
extension JMBookDataBase {
    /// 查询当天是否存在数据
    static func isExistsForId(_ bookid: String) -> Bool {
//        let dataT = Date.jmCreateTspString().jmFormatTspString("yyyy-MM-dd") as Any
//        let sql = "SELECT bookid FROM readTime WHERE bookid = ? AND dateT = ?"
//        if let set = try? JMBookDataBase.share.db.executeQuery(sql, values: [bookid,dataT]), set.next() {
//            return true
//        } else {
//            return false
//        }
        return true
    }
    
    /// 查询数据 & 总阅读时长。bookid不为空代表查询某本书
    public static func fetchReadTime(_ bookid: String?) -> Int {
//        do {
//            var totalTime = 0
//            if let bookid = bookid {
//                let set = try JMBookDataBase.share.db.executeQuery("SELECT SUM(time) AS totalTime FROM readTime WHERE bookid = ?", values: [bookid])
//                while set.next() {
//                    totalTime += Int(set.int(forColumn: "totalTime"))
//                }
//            } else {
//                let set = try JMBookDataBase.share.db.executeQuery("SELECT SUM(time) AS totalTime FROM readTime", values: nil)
//                while set.next() {
//                    totalTime += Int(set.int(forColumn: "totalTime"))
//                }
//            }
//            return totalTime
//        } catch {
//            Logger.debug(JMBookDataBase.share.db.lastErrorMessage())
//        }
        return 0
    }
    
    /// 今日阅读时长
    public static func todayRead() -> Int {
//        do {
//            var totalTime = 0
//            let dataT = Date.jmCreateTspString().jmFormatTspString("yyyy-MM-dd") as Any
//            let set = try JMBookDataBase.share.db.executeQuery("SELECT SUM(time) AS totalTime FROM readTime WHERE dateT = ?", values: [dataT])
//            while set.next() {
//                totalTime += Int(set.int(forColumn: "totalTime"))
//            }
//            return totalTime
//        } catch {
//            Logger.debug(JMBookDataBase.share.db.lastErrorMessage())
//        }
        return 0
    }
    
    /// 插入数据
    public static func insertReadTime(bookid: String, time: Int) {
//        if isExistsForId(bookid) {
//            do {
//                try JMBookDataBase.share.db.executeUpdate("UPDATE readTime SET time=time+? WHERE bookid = ?", values: [time, bookid])
//            } catch {
//                Logger.debug(JMBookDataBase.share.db.lastErrorMessage())
//            }
//        } else {
//            do {
//                let dataT = Date.jmCreateTspString().jmFormatTspString("yyyy-MM-dd") as Any
//                let insetSql = "INSERT INTO readTime(bookid, dateT, time)values(?,?,?)"
//                try JMBookDataBase.share.db.executeUpdate(insetSql, values: [bookid, dataT, time])
//            } catch {
//                Logger.debug(JMBookDataBase.share.db.lastErrorMessage())
//            }
//        }
    }
}
