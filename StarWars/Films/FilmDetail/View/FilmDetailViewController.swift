//
//  FilmDetailViewController.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import UIKit
import RxSwift

class FilmDetailViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var poster: UIImageView!
    @IBOutlet var cellView: UIView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var directorLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var actorView: UIView!
    @IBOutlet var descTextView: UITextView!
    
    weak var coordinator: AppCoordinator?
    
    let filmsDetailViewModel = FilmDetailViewModel()
    
    let tap: PublishSubject<Bool> = PublishSubject()

    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fillData()
    }
    
    // MARK: - Customizing View
    private func setupView() {
        self.navItem.title = filmsDetailViewModel.film?.title ?? ""

        cellView.layer.borderWidth = 1.0
        cellView.layer.cornerRadius  = 15.0
        cellView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        
        poster.layer.cornerRadius = 15
        poster.clipsToBounds = true
        
        actorView.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.tap.onNext(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func fillData() {
        guard let film = filmsDetailViewModel.film else {return}
        nameLbl.text = film.title ?? ""
        directorLbl.text = film.director ?? ""
        dateLbl.text = "Release Date: \(film.release_date ?? "")"
        descTextView.text = film.opening_crawl ?? ""
    }
}
