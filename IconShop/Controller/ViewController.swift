//
//  ViewController.swift
//  IconShop
//
//  Created by Billow on 2022/4/5.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!

    var applications: [Application] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = NSNib(nibNamed: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forItemWithIdentifier: .init("CollectionViewCell"))
        configure()
    }


    func configure() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 60.0, height: 60)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        collectionView.collectionViewLayout = flowLayout
    }

}

extension ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return applications.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .init("CollectionViewCell"), for: indexPath) as! CollectionViewCell
        if !applications.isEmpty {
            let application = applications[indexPath.item]
            let imageUrl = URL(string: application.artworkUrl100)
            DispatchQueue.global().async {
                let image = NSImage(contentsOf: imageUrl!)
                DispatchQueue.main.async {
                    item.coverView?.image = image
                }
            }
        } else {
            item.coverView.image = nil
        }
        return item
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print("****")
        if !applications.isEmpty {
            let application = applications[indexPaths.first!.item]
            chooseDirectory(application: application)
        }
        collectionView.deselectItems(at: indexPaths)
    }
}


extension ViewController {
    func chooseDirectory(application: Application) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.prompt = "Export"
        
        panel.begin { [self] result in
            if result == NSApplication.ModalResponse.OK {
                if let directory = createDirectory(directory: panel.url!) {
                    createFile(directory: directory, image: URL(string: application.artworkUrl60)!,file: "\(application.trackCensoredName)_60x60.png")
                    createFile(directory: directory, image: URL(string: application.artworkUrl100)!,file: "\(application.trackCensoredName)_100x100.png")
                    createFile(directory: directory, image: URL(string: application.artworkUrl512)!,file: "\(application.trackCensoredName)_512x512.png")
                }
            }
        }
    }

    func createDirectory(directory url: URL) -> URL? {
        let directory = url.appendingPathComponent(applications.first!.platform.description, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            return directory
        } catch {
            return nil
        }
    }
    
    func createFile(directory url: URL, image: URL, file: String) {
        let directory = url.appendingPathComponent(file)
        let data = NSImage(contentsOf: image)?.tiffRepresentation
        FileManager.default.createFile(atPath: directory.path, contents: data, attributes: nil)
    }

}

