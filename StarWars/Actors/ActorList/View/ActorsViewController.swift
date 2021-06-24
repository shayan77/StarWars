//
//  ActorsViewController.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import UIKit
import RxSwift
import RxCocoa

class ActorsViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    @IBOutlet var actorsTableView: UITableView!
    @IBOutlet var loading: UIActivityIndicatorView! {
        didSet {
            loading.hidesWhenStopped = true
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private var actorsTableViewDataSource: StarWarsTableViewDataSource<ActorCell>!
    
    weak var coordinator: AppCoordinator?
    
    let actorsViewModel = ActorViewModel(actorService: ActorService.shared)
    
    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
        getData()
    }
    
    // MARK: - Customizing View
    private func setupView() {
        self.title = actorsViewModel.film?.title ?? ""
        
        // actorsTableViewDataSource
        actorsTableViewDataSource = StarWarsTableViewDataSource(cellHeight: 200, items: [], tableView: actorsTableView, delegate: self, animationType: .type2(0.5))
        actorsTableView.delegate = actorsTableViewDataSource
        actorsTableView.dataSource = actorsTableViewDataSource
    }

    // MARK: - Bindings
    private func setupBindings() {
        
        // Subscribe to Loading
        actorsViewModel.loading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                guard let self = self else { return }
                if loading {
                    self.loading.startAnimating()
                } else {
                    self.loading.stopAnimating()
                }
            }).disposed(by: disposeBag)
        
        actorsViewModel.finish
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] finish in
                guard let self = self else { return }
                if finish {
                    self.actorsTableViewDataSource.refreshWithNewItems(self.actorsViewModel.actors)
                }
            }).disposed(by: disposeBag)
        
        // Subscribe to errors
        actorsViewModel.errorResponse
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.actorsTableView.isHidden = true
            }).disposed(by: disposeBag)
    }
    
    private func getData() {
        actorsViewModel.getActors()
    }
}

// MARK: - StarWarsTableViewDelegate
extension ActorsViewController: StarWarsTableViewDelegate {
    func tableView<T>(didSelectModelAt model: T) {
        if let actor = model as? Actor {
            popRate(actor)
        }
    }
    
    func popRate(_ actor: Actor) {
        let storyboard = UIStoryboard(name: "Actors", bundle: nil)
        let rateViewController = storyboard.instantiateViewController(withIdentifier: "RateViewController") as! RateViewController
        rateViewController.rateViewModel.actor = actor
        
        rateViewController.rate.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.actorsTableViewDataSource.refreshWithNewItems(self.actorsViewModel.actors)
        }).disposed(by: disposeBag)
        
        let navigationControlr = UINavigationController(rootViewController: rateViewController)
        navigationController?.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
    }
}
