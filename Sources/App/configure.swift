import Vapor
import Fluent
import FluentSQLite

public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Configure the rest of your application here
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    // Tells Vapor that we intend to use both Fluent and SQLite in our requests.
    try services.register(FluentSQLiteProvider())
    // Creates an empty DatabasesConfig object, which is used to connect any sort of database to the rest of Fluent.
    var databaseConfig = DatabasesConfig()
    // Opens polls.db in the current working directory, ready to use.
    let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)polls.db"))
    // Connects that SQLite database to Vapor’s built-in .sqlite database identifier.
    databaseConfig.add(database: db, as: .sqlite)
    // Registers the whole thing with the application services, so it can be used elsewhere in the app.
    services.register(databaseConfig)
    
    /*  create a MigrationConfig, tell it that our Poll struct should be migrated
     using the SQLite database identifier, then register that with our app’s services.
     */
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: Poll.self, database: .sqlite)
    services.register(migrationConfig)
}
