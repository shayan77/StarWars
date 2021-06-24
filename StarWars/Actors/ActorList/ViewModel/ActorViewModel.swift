//
//  ActorViewModel.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import Foundation
import RxSwift
import RxCocoa

class ActorViewModel {
        
    enum ActorViewModelError {
        case tryAgainLater
        case serverError
        case unknown
    }
    
    public var film: Film?
    
    private var actorService: ActorServiceProtocol
    
    init(actorService: ActorServiceProtocol) {
        self.actorService = actorService
    }
    
    let loading: PublishSubject<Bool> = PublishSubject()
    let finish: PublishSubject<Bool> = PublishSubject()
    let errorResponse: PublishSubject<ActorViewModelError> = PublishSubject()
    
    var actors = [Actor]()
    
    func getActors() {
        let total = (film?.characters ?? []).count
        for path in film?.characters ?? [] {
            loading.onNext(true)
            actorService.getActor(path: path) { [self] actorCallback in
                loading.onNext(false)
                switch actorCallback {
                case .success(let actor):
                    self.actors.append(actor)
                    if total == self.actors.count {
                        self.sortActors()
                        self.finish.onNext(true)
                    }
                case .failure(let requestError):
                    switch requestError {
                    case .authorizationError:
                        errorResponse.onNext(.tryAgainLater)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private func sortActors() {
        self.actors = self.actors.sorted { ($0.name ?? "").lowercased() < ($1.name ?? "").lowercased() }
    }
}
