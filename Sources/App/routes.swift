import Foundation
import Routing
import Vapor

public func routes(_ router: Router) throws {
    
    try router.grouped("poll").register(collection: PollsCollection())
    
    router.get("polls", "list") { req -> Future<[Poll]> in
        return Poll.query(on: req).all()
    }
    router.post(Poll.self, at: "polls", "create") { req, poll -> Future<Poll> in
        return poll.save(on: req)
    }
}
