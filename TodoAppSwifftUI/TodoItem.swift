import Foundation

enum Priority: String {
    case low = "low"
    case medium = "medium"
    case high = "high"
}

struct TodoItem {

    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let isDone: Bool
    let createDate: Date
    let changeDate: Date?
    
    init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date? = nil, isDone: Bool, createDate: Date = Date.now, changeDate: Date? = nil) {
        self.id = id
        self.text = text
        self.priority = priority
        self.isDone = isDone
        self.createDate = createDate
        self.deadline = deadline
        self.changeDate = changeDate
    }
    
}

//MARK: - Extension for JSON parsing

extension TodoItem {
    
    var json: Any {
        get {
            var todoDict: [String:Any] = [
                "id" : self.id,
                "text" : self.text,
                "isDone" : self.isDone,
                "createDate" : self.createDate.timeIntervalSince1970,
                "changeDate" : self.changeDate?.timeIntervalSince1970 ?? 0
            ]
            if let deadline = self.deadline { todoDict["deadline"] = deadline.timeIntervalSince1970 }
            if self.priority != .medium { todoDict["priority"] = self.priority.rawValue}
            return todoDict
        }
    }
    
    
    static func parse(json: Any) -> TodoItem? {
        guard let jsonObject = json as? [String : Any] else {
            print("cant convert heerre")
            return nil
        }

        var id: String = ""
        var text: String = ""
        var priority: Priority = .medium
        var isDone: Bool = false
        var deadline: Date? = nil
        var createDate: Date = Date.now
        var changeDate: Date? = nil
    
        if let newId = jsonObject["id"] as? String { id = newId }
        if let newText = jsonObject["text"] as? String { text = newText }
        if let newPriority = jsonObject["priority"] as? String {
            switch newPriority {
            case "low":
                priority = .low
            case "medium":
                priority = .medium
            case "high":
                priority = .high
            default:
                priority = .medium
            }
        }
        if let newIsDone = jsonObject["isDone"] as? Bool { isDone = newIsDone}
        if let newDeadline = jsonObject["deadline"] as? TimeInterval { deadline = Date(timeIntervalSince1970: newDeadline)}
        if let newCreateDate = jsonObject["createDate"] as? TimeInterval { createDate = Date(timeIntervalSince1970: newCreateDate)}
        if let newChangeDate = jsonObject["changeDate"] as? TimeInterval, newChangeDate != 0 { changeDate = Date(timeIntervalSince1970: newChangeDate)}
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, isDone: isDone, createDate: createDate, changeDate: changeDate)
    }
    
}


//MARK: - Extension for CSV parsing
extension TodoItem {

    // Order: ["id", "text", "priority", "deadline", "isDone", "createDate", "changeDate"]
    var csv: String {
        get {
            var str = "\(self.id);\(self.text)"
            str = str + ((self.priority == .medium) ? ";" : ";\(self.priority.rawValue)")
            str = str + ((self.deadline == nil) ? ";" : ";\(self.deadline!.timeIntervalSince1970)")
            str = str + ";\(self.isDone)"
            str = str + ";\(self.createDate.timeIntervalSince1970)"
            str = str + ((self.changeDate == nil) ? ";" : ";\(self.changeDate!.timeIntervalSince1970)")
            return str
        }
    }
    
    // Order: ["id", "text", "priority", "deadline", "isDone", "createDate", "changeDate"]
    static func parse(csvRow: String) -> TodoItem? {
        let row = csvRow.components(separatedBy: ";")
        let id: String = row[0]
        let text: String = row[1]
        var priority: Priority = .medium
        switch row[2] {
        case "low":
            priority = .low
        case "medium":
            priority = .medium
        case "high":
            priority = .high
        default:
            priority = .medium
        }
        let isDone: Bool = (row[4]=="true") ? true : false
        var deadline: Date? = nil
        var createDate: Date = Date.now
        var changeDate: Date? = nil
        
        if let deadlineDouble = Double(row[3]) {
            deadline = Date(timeIntervalSince1970: deadlineDouble)
        }
        if let createDouble = Double(row[5]) {
            createDate = Date(timeIntervalSince1970: createDouble)
        } else { return nil }
        if let changeDouble = Double(row[6]) {
            changeDate = Date(timeIntervalSince1970: changeDouble)
        }
        
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, isDone: isDone, createDate: createDate, changeDate: changeDate)
    }
    
}

//extension TodoItem {
//    var sqlReplaceStatement: String {
//        return ""
//    }
//
//    static func parse(sqlRow row: Row) -> TodoItem? {
//        do {
//            let id = try row.get(FileCache.id)
//            let text = try row.get(FileCache.text)
//            let priorityRaw = try row.get(FileCache.priority)
//            let deadline = try row.get(FileCache.deadline)
//            let isDone = try row.get(FileCache.isDone)
//            let createDate = try row.get(FileCache.createDate)
//            let changeDate = try row.get(FileCache.changeDate)
//
//            var priority = Priority.medium
//            switch priorityRaw {
//            case "low":
//                priority = .low
//            case "high":
//                priority = .high
//            default:
//                priority = .medium
//            }
//
//            let todoItem = TodoItem(id: id, text: text, priority: priority, deadline: deadline, isDone: isDone, createDate: createDate, changeDate: changeDate)
//            return todoItem
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//
//}

extension TodoItem: Equatable {
    static func ==(lhs: TodoItem, rhs: TodoItem)->Bool {
        return (lhs.id == rhs.id &&
                lhs.text == rhs.text &&
                lhs.priority == rhs.priority &&
                lhs.isDone == rhs.isDone &&
                lhs.deadline?.timeIntervalSince1970 == rhs.deadline?.timeIntervalSince1970 &&
                lhs.changeDate?.timeIntervalSince1970 == rhs.changeDate?.timeIntervalSince1970 &&
                lhs.createDate.timeIntervalSince1970 == rhs.createDate.timeIntervalSince1970)
    }
}
