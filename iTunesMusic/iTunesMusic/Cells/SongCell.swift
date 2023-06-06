//
//  SongCell.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 6.06.2023.
//

import UIKit
import iTunesMusicAPI
import SDWebImage


class SongCell: UITableViewCell {

    @IBOutlet weak var artWorkURL: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with song: Results) {
        trackName?.text = song.trackName
        artistName?.text = song.artistName
        collectionName.text = song.collectionName
        if let artworkUrl = song.artworkUrl100, let url = URL(string: artworkUrl) {
                    // SDWebImage kullanarak görseli yükle
                    artWorkURL?.sd_setImage(with: url, completed: nil)
                }
    }
   

}
