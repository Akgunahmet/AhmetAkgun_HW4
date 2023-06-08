//
//  DetailViewController.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 8.06.2023.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
   func setArtistImage(_ image: UIImage)
    func setArtistName(_ text: String)
    func setCollection(_ text: String)
    func setTrackName(_ text: String)
    func setKind(_ text: String)
    func setTrackPrice(_ text: Double)
    func setCollectionPrice(_ text: Double)

}



class DetailViewController: UIViewController {

    
    
    @IBOutlet weak var artistImage: UIImageView!
    
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblCollection: UILabel!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblKind: UILabel!
    @IBOutlet weak var lblTrackPrice: UILabel!
    @IBOutlet weak var lblCollectionPrice: UILabel!
    
    
  
  

    var presenter: DetailPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}
extension DetailViewController: DetailViewControllerProtocol {
    func setArtistImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.artistImage.image = image
        }
    }
    
    func setArtistName(_ text: String) {
        self.lblArtistName.text = text
    }
    
    func setCollection(_ text: String) {
        self.lblCollection.text = text
    }
    
    func setTrackName(_ text: String) {
        self.lblTrackName.text = text
    }
    
    func setKind(_ text: String) {
        self.lblKind.text = text
    }
    
    func setTrackPrice(_ text: Double) {
      let formattedPrice = String(format: "%.2f", text)
        self.lblTrackPrice.text = "Track Price: \(formattedPrice)$"
    }

    func setCollectionPrice(_ text: Double) {
        let formattedPrice = String(format: "%.2f", text)
        self.lblCollectionPrice.text = "Collection Price: \(formattedPrice)$"
    }
    
    
    
}
