//
//  RateViewController.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import UIKit
import Cosmos
import RxSwift

class RateViewController: UIViewController, Storyboarded {
    
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet var submitRateBtn: UIButton!
    @IBOutlet var navItem: UINavigationItem!
    
    weak var coordinator: AppCoordinator?
    
    let rateViewModel = RateViewModel()
    
    let rate: PublishSubject<Int> = PublishSubject()
    let disposeBag = DisposeBag()
    
    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
    }
    
    // MARK: - Customizing View
    private func setupView() {
        self.navItem.title = rateViewModel.actor?.name ?? ""

        submitRateBtn.layer.cornerRadius = 8.0
        toggleButton()
        
        print(rateViewModel.actor?.rate ?? 0)
        cosmosView.rating = Double(rateViewModel.actor?.rate ?? 0)
        cosmosView.didFinishTouchingCosmos = { rating in
            self.rateViewModel.actor?.rate = Int(rating)
            self.toggleButton()
        }
    }
    
    private func toggleButton() {
        if (rateViewModel.actor?.rate ?? 0) == 0 {
            submitRateBtn.alpha = 0.5
            submitRateBtn.isUserInteractionEnabled = false
        } else {
            submitRateBtn.alpha = 1.0
            submitRateBtn.isUserInteractionEnabled = true
        }
    }
    
    private func setupBindings() {
        submitRateBtn.rx.tap
            .debounce(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: {
                    self.rate.onNext(Int(self.rateViewModel.actor?.rate ?? 0))
                    self.rateViewModel.setRate()
                })
            }).disposed(by: disposeBag)
    }
}
