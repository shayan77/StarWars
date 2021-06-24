//
//  FilmsViewController.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import UIKit
import RxSwift
import RxCocoa

class FilmsViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    @IBOutlet var filmsTableView: UITableView!
    @IBOutlet var loading: UIActivityIndicatorView! {
        didSet {
            loading.hidesWhenStopped = true
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private var filmsTableViewDataSource: StarWarsTableViewDataSource<FilmCell>!
    
    weak var coordinator: AppCoordinator?
    
    let filmsViewModel = FilmsViewModel(filmsService: FilmsService.shared)
        
    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
        getData()
    }
    
    // MARK: - Customizing View
    private func setupView() {
        self.title = "Star Wars"
        
        // filmsTableViewDataSource
        filmsTableViewDataSource = StarWarsTableViewDataSource(cellHeight: 140, items: [], tableView: filmsTableView, delegate: self, animationType: .type2(0.5))
        filmsTableView.delegate = filmsTableViewDataSource
        filmsTableView.dataSource = filmsTableViewDataSource
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        
        // Subscribe to Loading
        filmsViewModel.loading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                guard let self = self else { return }
                if loading {
                    self.loading.startAnimating()
                } else {
                    self.loading.stopAnimating()
                }
            }).disposed(by: disposeBag)
        
        // Subscribe to films
        filmsViewModel.successResponse
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] films in
                guard let self = self else { return }
                self.filmsTableViewDataSource.refreshWithNewItems(films)
            }).disposed(by: disposeBag)
        
        // Subscribe to errors
        filmsViewModel.errorResponse
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.filmsTableView.isHidden = true
            }).disposed(by: disposeBag)
    }
    
    private func getData() {
        filmsViewModel.films()
    }
}

// MARK: - StarWarsTableViewDelegate
extension FilmsViewController: StarWarsTableViewDelegate {
    func tableView<T>(didSelectModelAt model: T) {
        if let film = model as? Film {
            self.popFilmDetail(film)
        }
    }
    
    func popFilmDetail(_ film: Film) {
        let storyboard = UIStoryboard(name: "FilmDetail", bundle: nil)
        let filmDetailViewController = storyboard.instantiateViewController(withIdentifier: "FilmDetailViewController") as! FilmDetailViewController
        filmDetailViewController.filmsDetailViewModel.film = film
        
        filmDetailViewController.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.coordinator?.navigateToActors(film)
        }).disposed(by: disposeBag)
        
        let navigationControlr = UINavigationController(rootViewController: filmDetailViewController)
        navigationController?.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
    }
}
