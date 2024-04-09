//
//  JMFileTools.swift
//  JMEpubReader
//
//  Created by jh on 2024/4/9.
//

import UIKit

public class JMFileTools: NSObject {
    /// 获取document路径Url
    public static func jmDescpath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    /// 获取document路径
    public static func jmDocuPath() -> String? {
        let documentDir = FileManager.SearchPathDirectory.documentDirectory
        let domainMask = FileManager.SearchPathDomainMask.allDomainsMask
        return NSSearchPathForDirectoriesInDomains(documentDir,domainMask, true).first
    }
    
    /// 获取home路径
    public static func jmHomePath() -> String? {
        return NSHomeDirectory()
    }
    
    /// 获取Cache路径
    public static func jmCachePath() -> String? {
        let documentDir = FileManager.SearchPathDirectory.cachesDirectory
        let domainMask = FileManager.SearchPathDomainMask.allDomainsMask
        return NSSearchPathForDirectoriesInDomains(documentDir,domainMask, true).first
    }
    
    /// 获取temp路径
    public static func jmTempPath() -> String? {
        return NSTemporaryDirectory()
    }
    
    /// 判断document文件是否存在
    public static func jmDocuFileExist(fileName name: String) -> Bool {
        if let docuPath = jmDocuPath() {
            let toPath = docuPath+"/"+name
            return FileManager.default.fileExists(atPath: toPath)
        } else {
            return false
        }
    }
    
    /// 根据后缀获取文件
    public static func jmGetFileFromDir(_ dir:String,_ subffix:String) -> Array<String> {
        var nameArr = [String]()
        let manager = FileManager.default
        if let array = try? manager.contentsOfDirectory(atPath: dir) {
            for name in array {
                if name.hasSuffix(subffix){
                    nameArr.append(name)
                }
            }
        }
        return nameArr
    }
    
    /// 删除文件
    public static func jmDeleteFile(_ fromPath:String) {
        do{
            let manager = FileManager.default
            if manager.fileExists(atPath: fromPath) && manager.isDeletableFile(atPath: fromPath) {
                try manager.removeItem(atPath: fromPath)
            }
        }catch{
            print(error)
        }
    }
    
    /// 移动文件
    public static func jmMoveFile(_ fromPath:String, _ toPath:String) {
        if !FileManager.default.fileExists(atPath: toPath) {
            do {
                try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
            }catch {
                print(error)
            }
        }
    }
    
    /// 创建文件夹
    public static func jmCreateFolder(_ folderPath:String) {
        let manager = FileManager.default
        if !manager.fileExists(atPath: folderPath) {
            do{
                try manager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
                print("Succes to create folder")
            }
            catch{
                print("Error to create folder")
            }
        }
    }
    
    /// 计算缓存文件大小
    public static func jmFileSizeOfCache()-> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        var sumSize:NSInteger = 0
        for file in fileArr! {
            if let path = cachePath?.appendingFormat("/\(file)") {
                sumSize += NSInteger(jmGetSize(path))
            }
        }
        return jmTransBytes(sumSize)
    }
    
    /// 获取文件大小，返回值没有转换，是字节数
    public static func jmGetSize(_ path: String)->UInt64 {
        var fileSize : UInt64 = 0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: path)
            fileSize += attr[FileAttributeKey.size] as! UInt64
        } catch {
            print("Error: \(error)")
        }
        return fileSize
    }
    
    /// 清空缓存文件
    public static func jmClearCache() {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        for file in fileArr! {
            if let path = cachePath?.appendingFormat("/\(file)") {
                if FileManager.default.fileExists(atPath: path) {
                    do {
                        try FileManager.default.removeItem(atPath: path)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    /// 返回值有转换，返回值是字符串
    public static func jmGetFilesBytesByPath(_ path: String) -> String {
        var sumSize: NSInteger = 0
        let isDirectory = unsafeBitCast(false, to: UnsafeMutablePointer<ObjCBool>.self)
        if FileManager.default.fileExists(atPath: path, isDirectory: isDirectory) {
            sumSize = NSInteger(jmGetSize(path))
        }
        return jmTransBytes(sumSize)
    }
    
    /// bit字节数转字符串
    public static func jmTransBytes(_ sumSize:NSInteger = 0) ->String {
        var str:String = ""
        var tempSize = sumSize
        if sumSize < 1024 {
            str = str.appendingFormat("%d B", sumSize)
        }else if sumSize > 1024 && sumSize < 1024*1024 {
            tempSize = tempSize/1024
            str = str.appendingFormat("%d Kb", tempSize)
        }else if sumSize > 1024*1024 && sumSize < 1024*1024*1024 {
            tempSize = tempSize/1024/1024
            str = str.appendingFormat("%d Mb", tempSize)
        }
        return str
    }
}
