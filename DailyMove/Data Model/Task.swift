//
//  Task.swift
//  DailyMove
//
//  Created by Seydoux on 2021/09/28.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var detail: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dueDate: Date = Date()
    @objc dynamic var createdDate: Date = Date()
    @objc dynamic var color: String = ""
}
