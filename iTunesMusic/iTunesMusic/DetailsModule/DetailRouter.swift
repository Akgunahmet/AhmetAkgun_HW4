//
//  DetailsRouter.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 6.06.2023.
//



import Foundation

protocol DetailRouterProtocol {

}

final class DetailRouter: DetailRouterProtocol {

    weak var viewController: DetailViewController?

    static func createModule() -> DetailViewController {
         let view = DetailViewController()
         let router = DetailRouter()
         let interactor = DetailInteractor()
        let presenter = DetailPresenter(view: view, router: router, interactor: interactor)
         view.presenter = presenter
         router.viewController = view
         return view
     }

}




//import Foundation
//
//protocol DetailRouterProtocol {
//
//}
//
//final class DetailRouter: DetailRouterProtocol {
//
//    weak var viewController: DetailViewController?
//
//    static func createModule() -> DetailViewController {
//         let view = DetailViewController()
//         let router = DetailRouter()
//        let presenter = DetailPresenter(view: view, router: router)
//         view.presenter = presenter
//         router.viewController = view
//         return view
//     }
//
//}
