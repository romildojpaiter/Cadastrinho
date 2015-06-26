//
//  QSQLite3.swift
//  SQLiteWrapper
//
//  Created by Danilo Altheman on 24/06/15.
//  Copyright © 2015 Quaddro - Danilo Altheman. All rights reserved.
/* Usage:
        // Open or create a Database
        let database = QSQLite3(path: NSHomeDirectory() + "/Documents/database.sqlite")
        
        let query = "create table people(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, phone TEXT)"
        
        // Execute SQL Instruction
        database.exec(query)

        database.exec("insert into people (name, age, phone) values ('Danilo Altheman', 33, '+55 11 3171-3080')")
        
        // Returns an Array of Dictionary with records
        let records = database.query("select * from people")
*/
import Foundation

class QSQLite3 {
    var database: COpaquePointer = nil
    var path: String = String()
    var error: String = String()
    
    init(path: String) {
        if sqlite3_open(path, &database) != SQLITE_OK {
            self.error = getError()
        }
        self.path = path
    }
    
    convenience init() {
        self.init(path: String())
    }
    
    private func getError() -> String {
        return String.fromCString(sqlite3_errmsg(database))!
    }
    
    func exec(sql: String) {
        if sqlite3_exec(database, sql, nil, nil, nil) != SQLITE_OK {
            self.error = getError()
        }
    }
    
    func query(query: String) -> [[String: AnyObject]] {
        var statement: COpaquePointer = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) != SQLITE_OK {
            self.error = getError()
        }
        var records: [[String: AnyObject]] = [[String: AnyObject]]()
        while sqlite3_step(statement) == SQLITE_ROW {
            var rowDictionary: [String: AnyObject] = [String: AnyObject]()
            for var i = 0; i < Int(sqlite3_column_count(statement)); i++ {
                let columnName = String.fromCString(UnsafePointer<Int8>(sqlite3_column_name(statement, Int32(i))))

                switch sqlite3_column_type(statement, Int32(i)) {
                    case SQLITE_INTEGER, SQLITE_FLOAT:
                        rowDictionary[columnName!] = Int(sqlite3_column_int64(statement, Int32(i)))
                    case SQLITE_TEXT:
                        rowDictionary[columnName!] = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, Int32(i))))
                    case SQLITE_BLOB:
                        let len = sqlite3_column_bytes(statement, Int32(i))
                        let bytes = sqlite3_column_blob(statement, Int32(i))
                        rowDictionary[columnName!] = NSData(bytes: bytes, length: Int(len))
                    default:
                        rowDictionary[columnName!] = nil
                }
            }
            records.append(rowDictionary)
        }
        return records
    }
    
    deinit {
        sqlite3_close(database)
    }
}
