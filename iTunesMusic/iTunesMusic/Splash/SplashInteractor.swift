//
//  SplashInteractor.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 7.06.2023.
//


import Foundation

protocol SplashInteractorProtocol {
    func checkInternetConnection()
}

protocol SplashInteractorOutputProtocol {
    func internetConnection(status: Bool)
}

final class SplashInteractor {
    var output: SplashInteractorOutputProtocol?
}

extension SplashInteractor: SplashInteractorProtocol {

    func checkInternetConnection() {
        let internetStatus = Reachability.isConnectedToInternet()
        self.output?.internetConnection(status: internetStatus)
    }

}
