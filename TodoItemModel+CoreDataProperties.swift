//
//  TodoItemModel+CoreDataProperties.swift
//  
//
//  Created by Medeu Pazylov on 13.07.2023.
//
//

import Foundation
import CoreData


@objc(TodoItemModel)
public class TodoItemModel: NSManagedObject { }

extension TodoItemModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItemModel> {
        return NSFetchRequest<TodoItemModel>(entityName: "TodoItemModel")
    }

    @NSManaged public var text: String?
    @NSManaged public var id: String?
    @NSManaged public var priority: String?
    @NSManaged public var createDate: Date?
    @NSManaged public var changeDate: Date?
    @NSManaged public var isDone: Bool
    @NSManaged public var deadline: Date?

}

extension TodoItemModel: Identifiable {}
