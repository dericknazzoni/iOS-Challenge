//
//  GistFeedCell.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 29/10/20.
//

import UIKit

protocol GistFeedCellDelegate: NSObject {
    func didClickFavorite(indexPath: IndexPath?, image: UIImage)
}

class GistFeedCell: UITableViewCell, Identifiable, NibOwnerLoadable {
    
    @IBOutlet private weak var favoriteImageView: UIImageView?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var photoImageView: UIImageView?
    
    var spinner = UIView()
    weak var delegate: GistFeedCellDelegate?
    var indexPath: IndexPath?
    var isFavorite: Bool{
        get {
            if favoriteImageView?.image == UIImage(named: "star") {
                return true
            }
            return false
        }
        set(isFavorite) {
            favoriteImageView?.image = isFavorite
                ? UIImage(named: "star_selected")
                : UIImage(named: "star")
        }
    }
    
    
    func setup(image: UIImage?, name: String?) {
        photoImageView?.image = image
        photoImageView?.layer.cornerRadius = 10
        photoImageView?.clipsToBounds = true
        favoriteImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didFavorite)))
        favoriteImageView?.isUserInteractionEnabled = true
        nameLabel?.text = name
        
    }
    
    @objc
    func didFavorite() {
        isFavorite = !isFavorite
        delegate?.didClickFavorite(indexPath: indexPath, image: favoriteImageView?.image ?? UIImage() )
    }
    
    func updateImage(image: UIImage) {
        photoImageView?.image = image
    }
    
    override func prepareForReuse() {
        photoImageView?.image = nil
        nameLabel?.text = ""
        favoriteImageView?.image = UIImage(named: "star")
        delegate = nil
        indexPath = nil
        spinner.removeFromSuperview()
    }
    
}
