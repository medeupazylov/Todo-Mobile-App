
import UIKit
import SQLite



extension FileCache {
    
    static let id = Expression<String>("id")
    static let text = Expression<String>("text")
    static let priority = Expression<String>("priority")
    static let deadline = Expression<Date?>("deadline")
    static let isDone = Expression<Bool>("isDone")
    static let createDate = Expression<Date>("createDate")
    static let changeDate = Expression<Date?>("changeDate")
    
    private func clearDataBaseSQL() {
        do{
            guard let dbComponents = getSQLDataBase() else {return}
            let db = dbComponents.0
            let todoItemTable = dbComponents.1
            try db.run(todoItemTable.delete())
        } catch {
            print(error)
        }
    }
    
    func saveToSQL() {
        clearDataBaseSQL()
        for todoItem in todoItems {
            insertTodoItemSQL(todoItem: todoItem)
        }
    }
    
    func insertTodoItemSQL(todoItem: TodoItem?) {
        do {
            guard let dbComponents = getSQLDataBase() else {return}
            let db = dbComponents.0
            let todoItemTable = dbComponents.1
            guard let todoItem = todoItem else {return}
            let rowID = try db.run(todoItemTable.insert(
                FileCache.id <- todoItem.id,
                FileCache.text <- todoItem.text,
                FileCache.priority <- todoItem.priority.rawValue,
                FileCache.isDone <- todoItem.isDone,
                FileCache.deadline <- todoItem.deadline,
                FileCache.createDate <- todoItem.createDate,
                FileCache.changeDate <- todoItem.changeDate
            ))
        } catch {
            print(error)
        }
    }
    
    func updateTodoItemSQL(todoItem: TodoItem?) {
        do {
            guard let todoItem = todoItem else {return}
            guard let dbComponents = getSQLDataBase() else {return}
            let db = dbComponents.0
            let todoItemTable = dbComponents.1
            try db.run(todoItemTable.filter(FileCache.id == todoItem.id).update(
                FileCache.id <- todoItem.id,
                FileCache.text <- todoItem.text,
                FileCache.priority <- todoItem.priority.rawValue,
                FileCache.isDone <- todoItem.isDone,
                FileCache.deadline <- todoItem.deadline,
                FileCache.createDate <- todoItem.createDate,
                FileCache.changeDate <- todoItem.changeDate
            ))
            print("updated")
        } catch {
            print(error)
        }

    }
    
    func deleteTodoItemSQL(id: String) {
        do {
            guard let dbComponents = getSQLDataBase() else {return}
            let db = dbComponents.0
            let todoItemTable = dbComponents.1
            try db.run(todoItemTable.filter(FileCache.id == id).delete())
            print("deleted")
        } catch {
            print(error)
        }
    }
    
    func loadFromSQL() {
        do {
            guard let dbComponents = getSQLDataBase() else {return}
            let db = dbComponents.0
            let todoItemTable = dbComponents.1
            let query = todoItemTable.select(*)
            let rows = try db.prepare(query)
    
            self.clearList()
            
            for row in rows {
                guard let todoItem = TodoItem.parse(sqlRow: row) else {continue}
                self.addHelper(todoItem: todoItem)
            }
        } catch {
            print(error)
        }
    }
    
    private func getSQLDataBase() -> (Connection, Table)? {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            let db = try Connection("\(path)/diacompanion.db")
            let todoItemTable = Table("todoItems")
            try db.run(todoItemTable.create (ifNotExists: true) { table in
                table.column(FileCache.id, primaryKey: true)
                table.column(FileCache.text)
                table.column(FileCache.priority)
                table.column(FileCache.deadline)
                table.column(FileCache.isDone)
                table.column(FileCache.createDate)
                table.column(FileCache.changeDate)
            })
            return (db,todoItemTable)
        } catch {
            print(error)
            return nil
        }
    }
    
}
