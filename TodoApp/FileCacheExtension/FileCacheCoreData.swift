import UIKit
import CoreData

extension FileCache {
    
    func insertTodoItemCoreData(todoItem: TodoItem?) {
        guard let todoItem = todoItem else {return}
        guard let todoItemDescription = NSEntityDescription.entity(forEntityName: "TodoItemModel", in: context) else {return}
        let todoItemModel = TodoItemModel(entity: todoItemDescription, insertInto: context)
        todoItemModel.id = todoItem.id
        todoItemModel.text = todoItem.text
        todoItemModel.priority = todoItem.priority.rawValue
        todoItemModel.isDone = todoItem.isDone
        todoItemModel.deadline = todoItem.deadline
        todoItemModel.createDate = todoItem.createDate
        todoItemModel.changeDate = todoItem.changeDate
        
        appDelegate.saveContext()
        print("successfully added to CoreData")
    }
    
    func updateTodoItemCoreData(todoItem: TodoItem?) {
        guard let todoItem = todoItem else {return}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItemModel")
        do {
            let todoItemsModel = try context.fetch(fetchRequest) as [TodoItemModel] ?? []
            guard let todoItemModel =  todoItemsModel.first(where: {$0.id == todoItem.id}) else {return}
            todoItemModel.id = todoItem.id
            todoItemModel.text = todoItem.text
            todoItemModel.priority = todoItem.priority.rawValue
            todoItemModel.isDone = todoItem.isDone
            todoItemModel.deadline = todoItem.deadline
            todoItemModel.createDate = todoItem.createDate
            todoItemModel.changeDate = todoItem.changeDate
            appDelegate.saveContext()
        } catch {
            print(error)
        }
    }
    
    func deleteTodoItemCoreData(id: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItemModel")
        do {
            let todoItemsModel = try context.fetch(fetchRequest) as [TodoItemModel] ?? []
            guard let todoItemModel =  todoItemsModel.first(where: {$0.id == id}) else {return}
            context.delete(todoItemModel)
            appDelegate.saveContext()
        } catch {
            print(error)
        }
    }
    
    func loadTodoItemsCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItemModel")
        do {
            
            let todoItemsModel = try context.fetch(fetchRequest) as [TodoItemModel] ?? []
            for todoItemModel in todoItemsModel {
                print("loading from COREDATA")
                guard let id = todoItemModel.id,
                      let text = todoItemModel.text,
                      let createDate = todoItemModel.createDate else {continue}
                let deadline = todoItemModel.deadline
                let changeDate = todoItemModel.changeDate
                let isDone = todoItemModel.isDone
                        var priority = Priority.medium
                        switch (todoItemModel.priority) {
                        case "high":
                            priority = .high
                        case "low":
                            priority = .low
                        default:
                            priority = .medium
                        }
                
                let todoItem = TodoItem(id: id, text: text, priority: priority,deadline: deadline, isDone: isDone, createDate: createDate, changeDate: changeDate)
                addHelper(todoItem: todoItem)
            }
        } catch {
            print(error)
        }
    }
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
}
