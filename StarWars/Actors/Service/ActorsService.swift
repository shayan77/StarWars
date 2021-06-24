//
//  PeopleService.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import Foundation

/*

 This is Actors Service, responsible for making api calls of getting actors.
 
 */

typealias ActorCompletionHandler = (Result<Actor, RequestError>) -> Void

protocol ActorServiceProtocol {
    func getActor(path: String, completionHandler: @escaping ActorCompletionHandler)
}

/*
 ActorsEndpoint is URLPath of Actor Api calls
 */

private enum ActorsEndpoint {
    
    case actor(String)
    
    var path: String {
        switch self {
        case .actor(let path):
            return path
        }
    }
}

class ActorService: ActorServiceProtocol {
    
    private let requestManager: RequestManagerProtocol
    
    public static let shared: ActorServiceProtocol = ActorService(requestManager: RequestManager.shared)
    
    // We can also inject requestManager for testing purposes.
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getActor(path: String, completionHandler: @escaping ActorCompletionHandler) {
        self.requestManager.performRequestWith(url: ActorsEndpoint.actor(path).path, httpMethod: .get) { (result: Result<Actor, RequestError>) in
            completionHandler(result)
        }
    }
}
