import UIKit
import CocoaLumberjackSwift

protocol MainViewProtocol: AnyObject {
    
}

protocol MainPresenterProtocol {
    var mainView: MainViewProtocol? {get set}
    
    func getCountTodoList() -> Int
    
    func getTodoItem(atIndex index: Int) -> TodoItem?
    
    func addTodoItem(todoItem: TodoItem)
    
    func removeTodoItem(id: String) -> TodoItem?
    
    func getCountUndoneList() -> Int
    
    func getUndoneItem(atIndex index: Int) -> TodoItem?

}

class MainPresenter: MainPresenterProtocol {
    
    private let fileCache: FileCache
    weak var mainView: MainViewProtocol?
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
    }
    
    func getCountTodoList() -> Int {
        return fileCache.todoItems.count
    }
    
    func getTodoItem(atIndex index: Int) -> TodoItem? {
        if index < fileCache.todoItems.count {
            return fileCache.todoItems[index]
        }
        return nil
    }
    
    func addTodoItem(todoItem: TodoItem) {
        fileCache.addNewTodoItem(todoItem: todoItem)
//        print(fileCache.todoItems)
    }
    
    func removeTodoItem(id: String) -> TodoItem? {
        return fileCache.removeTodoItem(id: id)
    }
    
    func getCountUndoneList() -> Int {
        var count = 0
        for item in fileCache.todoItems {
            if(item.isDone == false) {
                count+=1
            }
        }
        return count
    }
    
    func getUndoneItem(atIndex index: Int) -> TodoItem? {
        var i = 0
        for item in fileCache.todoItems {
            if(item.isDone == false) {
                if(i == index) {
                    return item
                }
                i+=1
            }
        }
        return nil
    }
    
}
