//
//  migrations.swift
//  
//
//  Created by 김민성 on 2021/08/04.
//
import Fluent

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
