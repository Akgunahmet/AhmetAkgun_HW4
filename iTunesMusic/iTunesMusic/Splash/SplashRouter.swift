//
//  SplashRouter.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 7.06.2023.
//

import Foundation
import UIKit

enum SplashRoutes {
    case homeScreen
}

protocol SplashRouterProtocol: AnyObject {
    func navigate(_ route: SplashRoutes)
}


final class SplashRouter {
    
    weak var viewController: SplashViewController?
    
    static func createModule() -> SplashViewController {
         let view = SplashViewController()
         let interactor = SplashInteractor()
         let router = SplashRouter()
         let presenter = SplashPresenter(view: view, router: router, interactor: interactor)
         view.presenter = presenter
         interactor.output = presenter
         router.viewController = view
         return view
     }
}

extension SplashRouter: SplashRouterProtocol {
    
    func navigate(_ route: SplashRoutes) {
        
//        switch route {
//        case .homeScreen:
//            guard let window = viewController?.view.window else { return }
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
////            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//            let homeVC = HomeRouter.createModule()
//            let navigationController = UINavigationController(rootViewController: homeVC)
//            window.makeKeyAndVisible()
//            window.rootViewController = navigationController
//        }
        switch route {
        case .homeScreen:
            guard let window = viewController?.view.window else { return }
            let homeVC = HomeRouter.createModule()
            let navigationController = UINavigationController(rootViewController: homeVC)
            window.rootViewController = navigationController
        }
    }
    
    
}
