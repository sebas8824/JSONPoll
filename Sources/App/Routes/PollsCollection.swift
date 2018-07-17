//
//  PollsCollection.swift
//  App
//
//  Created by Sebastian on 7/16/18.
//

import Foundation
import Vapor

final class PollsCollection: RouteCollection {
    func boot(router: Router) throws {
        let byId = router.grouped("id", UUID.parameter)
        
        byId.get("get") { req -> Future<Poll> in
            let id = try req.parameters.next(UUID.self)
            return Poll.find(id, on: req).map() { poll in
                guard let poll = poll else {
                    throw Abort(.notFound)
                }
                return poll
            }
        }
        
        byId.delete("remove") { req -> Future<String> in
            let id = try req.parameters.next(UUID.self)
            return try Poll.find(id, on: req).map() { poll in
                guard let poll = poll else {
                    throw Abort(.notFound)
                }
                poll.delete(on: req)
                return "Deleted"
            }
        }
        
        byId.post("vote", Int.parameter) { req -> Future<Poll> in
            let id = try req.parameters.next(UUID.self)
            let vote = try req.parameters.next(Int.self)
            return try Poll.find(id, on: req).flatMap(to: Poll.self) { poll in
                guard var poll = poll else {
                    throw Abort(.notFound)
                }
                if vote == 1 { poll.votes1 += 1 }
                else { poll.votes2 += 1 }
                return poll.save(on: req)
            }
        }
    }
}
