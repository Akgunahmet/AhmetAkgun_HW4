//
//  BaseViewController.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 7.06.2023.
//


import UIKit

class BaseViewController: UIViewController, LoadingShowable {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func showAlert(_ title: String, _ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}
