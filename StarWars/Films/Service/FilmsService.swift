//
//  FilmsService.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import Foundation

/*

 This is Film Service, responsible for making api calls of getting films.
 
 */

typealias FilmsCompletionHandler = (Result<Films, RequestError>) -> Void

protocol FilmsServiceProtocol {
    func getFilms(path: String, completionHandler: @escaping FilmsCompletionHandler)
}

/*
 FilmsEndpoint is URLPath of Product Api calls
 */

private enum FilmsEndpoint {
    
    case films(String)
    
    var path: String {
        switch self {
        case .films(let path):
            return path
        }
    }
}

class FilmsService: FilmsServiceProtocol {
    
    private let requestManager: RequestManagerProtocol
    
    public static let shared: FilmsServiceProtocol = FilmsService(requestManager: RequestManager.shared)
    
    // We can also inject requestManager for testing purposes.
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getFilms(path: String, completionHandler: @escaping FilmsCompletionHandler) {
        self.requestManager.performRequestWith(url: FilmsEndpoint.films(path).path, httpMethod: .get) { (result: Result<Films, RequestError>) in
            completionHandler(result)
        }
    }
}
