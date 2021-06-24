//
//  AppCoordinator.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import UIKit
import RxSwift

final class AppCoordinator: NSObject, Coordinator {

    let window: UIWindow?
    
    private let disposeBag = DisposeBag()

    // Since AppCoordinator is top of all coordinators of our app, it has no parent and is nil.
    weak var parentCoordinator: Coordinator?

    // ChildCoordinators of AppCoordinator
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
        super.init()
        navigationController.delegate = self
    }

    // Start of the app
    func start(animated: Bool) {
        guard let window = window else { return }

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let filmsViewController = FilmsViewController.instantiate(coordinator: self)
        navigationController.pushViewController(filmsViewController, animated: true)
    }
    
    func navigateToActors(_ film: Film) {
        let actorsViewController = ActorsViewController.instantiate(coordinator: self)
        actorsViewController.actorsViewModel.film = film
        navigationController.pushViewController(actorsViewController, animated: true)
    }
}

extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
    }
}
