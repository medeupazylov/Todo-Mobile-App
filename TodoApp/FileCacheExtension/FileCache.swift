import Foundation
import CocoaLumberjackSwift

enum DataBaseType {
    case coreData
    case sqlite
}

final class FileCache: NSObject {
    private(set) var todoItems: [TodoItem] = []
    
    //MARK: - Change the DataBaseType here
    let dataBaseType = DataBaseType.coreData
    
    func clearList() {
        todoItems = []
    }
    
    func addHelper(todoItem: TodoItem) {
        for i in 0..<todoItems.count {
            if (todoItem.id == todoItems[i].id) {
                todoItems[i] = todoItem
                print(todoItem.isDone)
                return
            }
        }
        todoItems.append(todoItem)
    }
    
    func addNewTodoItem(todoItem: TodoItem) {
        for i in 0..<todoItems.count {
            if (todoItem.id == todoItems[i].id) {
                todoItems[i] = todoItem
                print(todoItem.isDone)
                if(dataBaseType == .sqlite) { updateTodoItemSQL(todoItem: todoItem) }
                if(dataBaseType == .coreData) { updateTodoItemCoreData(todoItem: todoItem) }
                return
            }
        }
        if(dataBaseType == .sqlite) { insertTodoItemSQL(todoItem: todoItem) }
        if(dataBaseType == .coreData) { insertTodoItemCoreData(todoItem: todoItem) }

        todoItems.append(todoItem)
    }
    
    
    func removeTodoItem(id: String) -> TodoItem? {
        for i in 0..<todoItems.count {
            if (id == todoItems[i].id) {
                if(dataBaseType == .sqlite) { deleteTodoItemSQL(id: id) }
                if(dataBaseType == .coreData) { deleteTodoItemCoreData(id: id) }
                
                return todoItems.remove(at: i);
            }
        }
        return nil
    }
    
    func saveTodoItemsToFile(fileName: String) {
        guard let fileURL = getFileURL(fileName: fileName) else {
            DDLogError("Failed to get file URL of json")
            return
        }
        var jsonDatas: [[String : Any]] = []
        for item in todoItems {
            if let json = item.json as? [String : Any] {
                jsonDatas.append(json)
            }
        }
        do {
            let combinedJsonData = try JSONSerialization.data(withJSONObject: jsonDatas, options: .prettyPrinted)
            try combinedJsonData.write(to: fileURL)
            print(fileURL.path)
            DDLogInfo("File(json) created and written successfully.")
        } catch {
            DDLogError("Error(json): \(error)")
        }
    }
    

    func loadTodoItemsFromFile(fileName: String) {
        guard let fileURL = getFileURL(fileName: fileName) else {
            DDLogError("Failed to get file URL of json")
            return
        }
        do {
            let json = try Data(contentsOf: fileURL)
            guard let todoItems = try JSONSerialization.jsonObject(with: json, options: []) as? [[String : Any]] else {return}
            self.todoItems = []
            for item in todoItems {
                guard let todoItem = TodoItem.parse(json: item) else {continue}
                self.todoItems.append(todoItem)
            }
            DDLogInfo("File readed successfully and loaded todolist.")
        } catch {
            DDLogError("Error reading file: \(error)")
        }
    }
    
    
    func saveTodoItemsToCSVFile(fileName: String) {
        guard let fileURL = getFileURL(fileName: fileName) else {
            DDLogError("Failed to get file URL of csv")
            return
        }
        let csvString = todoItems.map({$0.csv}).joined(separator: "\n")
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            DDLogInfo("File(csv) created and written successfully.")
        } catch {
            DDLogError("Error(csv): \(error)")
        }
    }
    
    func loadTodoItemsFromCSVFile(fileName: String) {
        guard let fileURL = getFileURL(fileName: fileName) else {
            DDLogError("Failed to get file URL of csv")
            return
        }
        do {
            let csvString = try String(contentsOf: fileURL)
            let csvRows = csvString.components(separatedBy: "\n")
            self.todoItems = []
            for csvRow in csvRows {
                guard let todoItem = TodoItem.parse(csvRow: csvRow) else {continue}
                self.todoItems.append(todoItem)
            }
            DDLogInfo("File(csv) readed successfully and loaded todolist.")
        } catch {
            DDLogError("Error reading file(csv): \(error)")
        }
    }
    
    
    private func getFileURL(fileName: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to access documents directory.")
            return nil
        }
        return documentsDirectory.appendingPathComponent(fileName)
    }
}
