//
//  models.swift
//  
//
//  Created by 이성노 on 2021/07/28.
//

import Vapor
import Fluent

enum State: String, Codable {
    case todo, doing, done
}

struct PostTask: Content {
    let id : UUID?
    let title: String
    let body: String
    let due_date: Date
    let state: State
}

struct PatchTask: Content {
    let id : UUID
    let title: String?
    let body: String?
    let due_date: Date?
    let state: State?
}

struct DeleteTask: Content {
    let id : UUID?
}

final class Task: Model, Content {

    static var schema: String = "tasks"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "body")
    var body: String
    
    @Field(key: "due_date")
    var due_date: Date
    
    @Enum(key: "state")
    var state: State

    init() { }
    
    init(id: UUID? = nil, title: String, body: String, due_date: Date, state: State) {
        self.id = id
        self.title = title
        self.body = body
        self.due_date = due_date
        self.state = state
    }
    
    init(_ task: PostTask) {
        self.id = task.id
        self.title = task.title
        self.body = task.body
        self.due_date = task.due_date
        self.state = task.state
    }
}
