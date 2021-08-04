//
//  models.swift
//  
//
//  Created by 이성노 on 2021/07/28.
//

import Vapor
import Fluent

//class SomeClass: Validatable

enum State: String, Codable {
    case todo, doing, done
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
}

struct CreateTask: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.enum("state")
            .case("todo")
            .case("doing")
            .case("done")
            .create()
            .flatMap { state in
                return database.schema("tasks")
                    .id()
                    .field("title", .string, .required)
                    .field("body", .string)
                    .field("due_date", .date, .required)
                    .field("state", .string, .required)
                    .create()
            }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("tasks").delete().flatMap {
            return database.enum("state").delete()
        }
    }
}
