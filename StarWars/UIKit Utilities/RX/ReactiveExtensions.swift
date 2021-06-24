//
//  ReactiveExtensions.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol loadingViewable: AnyObject {
    func startAnimating()
    func stopAnimating()
}

extension loadingViewable where Self: UIViewController {
            
    func startAnimating() {
        // adding AnimationView
        let animation = UIActivityIndicatorView()
        animation.contentMode = .scaleAspectFit
        animation.frame = CGRect(x: 20, y: 20, width: 60, height: 60)
        let height = view.frame.size.height / 2
        let width = view.frame.size.width / 2
        
        animation.center = CGPoint(x: width, y: height)
        
        // giving Identifier
        animation.restorationIdentifier = "loadingView"
        
        animation.startAnimating()
    }
    
    func stopAnimating() {
        view.subviews.first(where: {$0.restorationIdentifier == "loadingView"})?.removeFromSuperview()
    }
}

// MARK: - UIViewController
extension UIViewController: loadingViewable {}

extension Reactive where Base: UIViewController {
    
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(base, scheduler: MainScheduler.instance, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
}

