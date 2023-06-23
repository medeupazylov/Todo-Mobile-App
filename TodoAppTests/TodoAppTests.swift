//
//  TodoAppTests.swift
//  TodoAppTests
//
//  Created by Medeu Pazylov on 17.06.2023.
//

import XCTest
@testable import TodoApp

final class TodoAppTests: XCTestCase {

    var todoItem: TodoItem!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        todoItem = TodoItem(text: "complete the homework", priority: .high,isDone: false)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        todoItem = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        try test1()
        try test2()
        try test3()
        try test4()
        try test5()
        try test6()
    }

//MARK: - Проверка инициализатора без необъязательных значений, как id, deadline, changeDate
    func test1() throws {
        todoItem = TodoItem(text: "complete the homework", priority: .high,isDone: false)
        XCTAssertEqual(todoItem.text, "complete the homework", "наличие правильного текста")
        XCTAssertEqual(todoItem.priority, Priority.high, "наличие правильной важности")
        XCTAssertEqual(todoItem.isDone, false, "наличие правильного флага ")
        let _ = try XCTUnwrap(todoItem.id, "наличие сгенерированного id")
        XCTAssertNil(todoItem.changeDate, "отсутствие даты изменения")
        XCTAssertNil(todoItem.deadline, "отсутствие дедлайна")
        XCTAssertNotNil(todoItem.createDate, "наличие сгенерированной даты создания")
    }
        
//MARK: - Проверка инициализатора c данными id, deadline, changeDate
    func test2() throws {
        todoItem = TodoItem(id: "123456789",text: "complete the homework",priority: .high, deadline: Date(timeIntervalSinceNow: 100000), isDone: false, changeDate: Date(timeIntervalSinceNow: 15000))
        XCTAssertEqual(todoItem.text, "complete the homework", "наличие правильного текста")
        XCTAssertEqual(todoItem.priority, Priority.high, "наличие правильной важности")
        XCTAssertEqual(todoItem.isDone, false, "наличие правильного флага ")
        XCTAssertNotNil(todoItem.changeDate)
        XCTAssertNotNil(todoItem.deadline)
        XCTAssertNotNil(todoItem.createDate)
    }
        
//MARK: - Проверка функции parse(json: Any)->TodoItem? и свойства var json:Any для объекта инициализированного БЕЗ необъязательных значений, как id, deadline, changeDate
    func test3() throws {
        todoItem = TodoItem(text: "complete the homework", priority: .high,isDone: false)
        let json = todoItem.json
        let todoItem2 = TodoItem.parse(json: json)! //второй элемент получен с помощю переконвертации в json и обратно первого элемент
        XCTAssertEqual(todoItem!, todoItem2, "равенство двух элементов")
    }
        
//MARK: - Проверка функции parse(json: Any)->TodoItem? и свойства var json:Any для объекта инициализированного С данными id, deadline, changeDate
    func test4() throws {
        todoItem = TodoItem(id: "123456789",text: "complete the homework",priority: .high, deadline: Date(timeIntervalSinceNow: 100000), isDone: false, changeDate: Date(timeIntervalSinceNow: 15000))
        let json = todoItem.json
        let todoItem2 = TodoItem.parse(json: json)! //второй элемент получен с помощю переконвертации в json и обратно первого элемент
        XCTAssertEqual(todoItem!, todoItem2, "равенство двух элементов")
    }
        
        
//MARK: - Проверка функции parse(json: Any)->TodoItem? и свойства var json:Any для объекта инициализированного БЕЗ необъязательных значений, как id, deadline, changeDate
    func test5() throws {
        todoItem = TodoItem(text: "complete the homework", priority: .high,isDone: false)
        let csv = todoItem.csv
        let todoItem2 = TodoItem.parse(csvRow: csv)! //второй элемент получен с помощю переконвертации в json и обратно первого элемент
        XCTAssertEqual(todoItem!, todoItem2, "равенство двух элементов")
    }
            
//MARK: - Проверка функции parse(json: Any)->TodoItem? и свойства var json:Any для объекта инициализированного С данными id, deadline, changeDate
    func test6() throws {
        todoItem = TodoItem(id: "123456789",text: "complete the homework",priority: .high, deadline: Date(timeIntervalSinceNow: 100000), isDone: false, changeDate: Date(timeIntervalSinceNow: 15000))
        let csv = todoItem.csv
        let todoItem2 = TodoItem.parse(csvRow: csv)! //второй элемент получен с помощю переконвертации в json и обратно первого элемент
        XCTAssertEqual(todoItem!, todoItem2, "равенство двух элементов")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
