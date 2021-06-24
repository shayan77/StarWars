//
//  FilmsViewModel.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import Foundation
import RxSwift
import RxCocoa

class FilmsViewModel {
        
    enum FilmsViewModelError {
        case tryAgainLater
        case serverError
        case unknown
    }
    
    private var filmsService: FilmsServiceProtocol
    
    init(filmsService: FilmsServiceProtocol) {
        self.filmsService = filmsService
    }
    
    let loading: PublishSubject<Bool> = PublishSubject()
    let successResponse: PublishSubject<[Film]> = PublishSubject()
    let errorResponse: PublishSubject<FilmsViewModelError> = PublishSubject()
    
    public var isFinished = false
    private var path = "https://swapi.dev/api/films/"
        
    func films() {
        
        loading.onNext(true)
        filmsService.getFilms(path: path) { [self] filmsCallback in
            loading.onNext(false)
            switch filmsCallback {
            case .success(let films):
                guard let films = films.results else {
                    assertionFailure("Data should already checked in validation func")
                    return
                }
                successResponse.onNext(films)
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
