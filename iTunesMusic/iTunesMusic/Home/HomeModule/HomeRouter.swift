//
//  HomeRouter.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 6.06.2023.
//

import Foundation
import iTunesMusicAPI

// MARK: - Protocol

protocol HomeRouterProtocol {
    func navigate(_ route: HomeRoutes)
}

enum HomeRoutes {
    case detail(source: Results?)
}

final class HomeRouter {
    
    weak var viewController: HomeViewController?
    
    static func createModule() -> HomeViewController {
         let view = HomeViewController()
         let interactor = HomeInteractor()
         let router = HomeRouter()
         let presenter = HomePresenter(view: view, router: router, interactor: interactor)
         view.presenter = presenter
         interactor.output = presenter
         router.viewController = view
         return view
     }
    
}

extension HomeRouter: HomeRouterProtocol {
    
// MARK: - Function
    
    func navigate(_ route: HomeRoutes) {
        switch route {
        case .detail(let source):
            
            let detailVC = DetailRouter.createModule()
            detailVC.presenter.source = source
            viewController?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}





//import Foundation
//import iTunesMusicAPI
//
//protocol HomeRouterProtocol {
//    func navigate(_ route: HomeRoutes)
//}
//
//enum HomeRoutes {
//    case detail(source: Results?)
//}
//
//final class HomeRouter {
//
//    weak var viewController: HomeViewController?
//
//
//    static func createModule() -> HomeViewController {
//        let view = HomeViewController()
//        // Diğer sınıfların örneklerini oluşturun ve presenter'e aktarın
//        let interactor = HomeInteractor()
//        let router = HomeRouter()
//        let presenter = HomePresenter(view: view, router: router, interactor: interactor)
//        view.presenter = presenter
//        interactor.output = presenter
//        router.viewController = view
//        return view
//    }
//}
//
//extension HomeRouter: HomeRouterProtocol {
//
//    func navigate(_ route: HomeRoutes) {
//        switch route {
//        case .detail(let source):
//
//            let detailVC = DetailRouter.createModule()
//            detailVC.presenter.source = source
//            viewController?.navigationController?.pushViewController(detailVC, animated: true)
//        }
//    }
//
//}
