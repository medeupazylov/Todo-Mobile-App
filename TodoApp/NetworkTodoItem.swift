import Foundation
import UIKit

struct TodoItemList: Codable {
    let list: [NetworkTodoItem]
}

struct SingleTodoItem: Codable {
    let element: NetworkTodoItem
}

struct TodoItemListResponce: Codable {
    let status: String
    let list: [NetworkTodoItem]
    let revision: Int
}

struct SingleTodoItemResponce: Codable {
    let status: String
    let element: NetworkTodoItem
    let revision: Int
}

struct NetworkTodoItem: Codable {
    let id: String
    let text: String
    let importance: String
    let deadline: Int64?
    let done: Bool
    let color: String?
    let createdAt: Int64
    let changedAt: Int64
    let lastUpdatedBy: String

    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case done
        case color
        case createdAt = "created_at"
        case changedAt = "changed_at"
        case lastUpdatedBy = "last_updated_by"
    }

    init(id: String,
         text: String,
         importance: String,
         deadline: Int64?,
         done: Bool,
         color: String?,
         createdAt: Int64,
         changedAt: Int64,
         lastUpdatedBy: String) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.done = done
        self.color = color
        self.createdAt = createdAt
        self.changedAt = changedAt
        self.lastUpdatedBy = lastUpdatedBy
    }

    init(_ item: TodoItem) {
        let creationDate = Int64(item.createDate.timeIntervalSince1970)

        self.init(id: item.id,
                  text: item.text,
                  importance: NetworkTodoItem.importanceToString(item.priority),
                  deadline: Int64(item.deadline?.timeIntervalSince1970 ?? 0),
                  done: item.isDone,
                  color: nil,
                  createdAt: creationDate,
                  changedAt: Int64(item.changeDate?.timeIntervalSince1970 ?? item.createDate.timeIntervalSince1970),
                  lastUpdatedBy: "Samsung A6")
    }

    func toToDoItem() -> TodoItem {
        var deadlineDate: Date?
        if let deadline = deadline {
            deadlineDate = Date(timeIntervalSince1970: Double(deadline))
        }

        return TodoItem(id: id,
                        text: text,
                        priority: NetworkTodoItem.stringToImportance(importance),
                        deadline: deadlineDate,
                        isDone: done,
                        createDate: Date(timeIntervalSince1970: Double(createdAt)),
                        changeDate: Date(timeIntervalSince1970: Double(changedAt))
                        )
    }

    private static func importanceToString(_ importance: Priority) -> String {
        switch importance {
        case .low:
            return "low"
        case .medium:
            return "basic"
        case .high:
            return "important"
        }
    }

    private static func stringToImportance(_ importanceStr: String) -> Priority {
        switch importanceStr {
        case "low":
            return .low
        case "important":
            return .medium
        default:
            return .high
        }
    }

    private static func dateToInt64(_ date: Date?) -> Int64? {
        guard let timeInterval = date?.timeIntervalSince1970
        else { return nil }
        return Int64(timeInterval * 1000)
    }

    private static func int64ToDate(_ timestamp: Int64) -> Date {
        let timeInterval = Double(timestamp) / 1000
        return Date(timeIntervalSince1970: timeInterval)
    }
}
