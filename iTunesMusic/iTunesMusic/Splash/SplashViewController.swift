//
//  SplashViewController.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 7.06.2023.
//

import UIKit

protocol SplashViewControllerProtocol: AnyObject {
    func noInternetConnection()
}

final class SplashViewController: BaseViewController {

    var presenter: SplashPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidAppear()
    }

//    var presenter: SplashPresenterProtocol!
//
//     override func viewDidAppear(_ animated: Bool) {
//         super.viewDidAppear(animated)
//         presenter.viewDidAppear()
//     }

}

extension SplashViewController: SplashViewControllerProtocol {

    func noInternetConnection() {
        showAlert("Error", "No internet")
    }

}

