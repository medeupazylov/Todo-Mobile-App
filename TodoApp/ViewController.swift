//
//  ViewController.swift
//  TodoApp
//
//  Created by Medeu Pazylov on 17.06.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        main()
    }

    enum FileName: String {
            case json = "todoItems.json"
            case csv = "todoItems.csv"
        }


    func main() {
           let cache = FileCache()
           for data in jsonData {
               guard let item = TodoItem.parse(json: data) else { return }
               cache.addNewTodoItem(todoItem: item)
           }

           cache.saveTodoItemsToFile(fileName: FileName.json.rawValue)
           cache.saveTodoItemsToCSVFile(fileName: FileName.csv.rawValue)
           
           cache.loadTodoItemsFromCSVFile(fileName: FileName.csv.rawValue)
           for item in cache.todoItems {
               print(item)
           }
           let csvString = cache.todoItems[0].csv
           let item = TodoItem.parse(csvRow: cache.todoItems[2].csv)
           print(item)
//           print(item)
//           print(csvString)
//           cache.loadTodoItemsFromFile()
           print(cache.todoItems)
           
//           guard let json = item.json as? Data else {return}
//           if let jsonString = String(data: json, encoding: .utf8) {
//                   print(jsonString)
//           }
//
//           guard let newItem = TodoItem.parse(json: json) else { return }
//           print(newItem)
       }


   let jsonData: [[String : Any]] =
       [
           [
               "id" : "123456789",
               "text": "Read the book",
               "priority": "high",
               "deadline" : 1686772483.4351048,
               "isDone": true,
               "createDate" : 1686572483.4351048,
               "changeDate" : 1686574483.4351048,
           ],
           [
               "id" : "00012010",
               "text": "Read the book",
               "priority": "medium",
               "isDone": true,
               "createDate" : 1686572483.4351048,
           ],
           [
               "id" : "0987656712",
               "text": "Read the book",
               "priority": "medium",
               "isDone": true,
               "createDate" : 1686572483.4351048,
           ],
       ]

}

