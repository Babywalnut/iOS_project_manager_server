import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    app.migrations.add(CreateTask())
    
    ///database code for heroku server
    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        var clientTLSConfiguration = TLSConfiguration.makeClientConfiguration()
        clientTLSConfiguration.certificateVerification = .none
        postgresConfig.tlsConfiguration = clientTLSConfiguration
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        throw Abort(.internalServerError)
    }
    
    ///database code for local server
//    app.databases.use(.postgres(hostname: "localhost", username: "babywalnut", password: "", database: "project_manager_database"), as: .psql)
//    app.migrations.add(CreateTask())

    // register routes
    try routes(app)
}
