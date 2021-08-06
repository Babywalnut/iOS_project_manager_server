import Vapor
import Fluent

func routes(_ app: Application) throws {
    app.get { req in
        return "Index page"
    }

    app.get("hello") { req -> String in
        return "Hello, world! babian"
    }
    
    app.get("tasks") { req -> EventLoopFuture<[Task]> in
        
        return Task.query(on: req.db).all()
    }
    
    app.post("task") { req -> EventLoopFuture<Task> in
        /// content-type validation
        let incomingData = try req.content.decode(PostTask.self)
        
        let task = Task(incomingData)
        
        return task.create(on: req.db).map {
            task
        }
    }
    
    app.patch("task", ":id") { req -> EventLoopFuture<Task> in
        let incomingData = try req.content.decode(PatchTask.self)
        
        return Task.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { task in
                if let title = incomingData.title {
                    task.title = title
                }
                
                if let body = incomingData.body {
                    task.body = body
                }
                
                if let due_date = incomingData.due_date {
                    task.due_date = due_date
                }
                
                if let state = incomingData.state {
                    task.state = state
                }
                
                return task.save(on: req.db)
                    .transform(to: task)
            }
    }
    
    app.delete("task") { req -> EventLoopFuture<HTTPStatus> in
        let incomingData = try req.content.decode(DeleteTask.self)
        
        return Task.find(incomingData.id, on: req.db)
            .unwrap(or: Abort(.noContent))
            .flatMap { task in
                task.delete(on: req.db)
            }
            .transform(to: .ok)
    }
}
