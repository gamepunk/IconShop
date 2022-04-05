//
//  CollectionViewCell.swift
//  IconShop
//
//  Created by Billow on 2022/4/5.
//

import Cocoa

class CollectionViewCell: NSCollectionViewItem {

    @IBOutlet weak var coverView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.cornerRadius = 15

        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: view.topAnchor),
            coverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}
