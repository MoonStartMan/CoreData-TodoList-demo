//
//  TodoList+CoreDataProperties.swift
//  
//
//  Created by 王潇 on 2023/2/6.
//
//

import Foundation
import CoreData


extension TodoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
        return NSFetchRequest<TodoList>(entityName: "TodoList")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var level: Int32

}
