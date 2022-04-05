//
//  WindowController.swift
//  IconShop
//
//  Created by Billow on 2022/4/5.
//

import Cocoa

class WindowController: NSWindowController, NSSearchFieldDelegate {


    @IBOutlet weak var countryButton: NSPopUpButton!
    
    @IBOutlet weak var platformButton: NSPopUpButton!

    @IBOutlet weak var searchField: NSSearchField!
    

    var viewController: ViewController?

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        searchField.refusesFirstResponder = true
        viewController = window?.contentViewController as? ViewController
        
    }

    func getAppIcon( platform: Platform, country: Country, text: String) {
        let semaphore = DispatchSemaphore (value: 0)

        var component = URLComponents(string: "https://itunes.apple.com/search")
        component?.queryItems = [
            URLQueryItem(name: "term", value: text),
            URLQueryItem(name: "country", value: "\(country)"),
            URLQueryItem(name: "media", value: "software"),
            URLQueryItem(name: "entity", value: "\(platform.software)"),
            URLQueryItem(name: "limit", value: "20")
        ]

        var request = URLRequest(url: (component?.url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])

                if let dictionary = json as? [String: Any],
                   let results = dictionary["results"] as? Array<Any> {

                    var applications = [Application]()

                    for result in results {
                        let application = result as! [String: Any]

                        let trackCensoredName = application["trackCensoredName"] as! String
                        let artworkUrl60 = application["artworkUrl60"] as! String
                        let artworkUrl100 = application["artworkUrl100"] as! String
                        let artworkUrl512 = application["artworkUrl512"] as! String
                        
                        dump(trackCensoredName, name: "应用名")
                        dump(artworkUrl512, name: "图片")

                        applications.append(Application(platform: platform, country: country, trackCensoredName: trackCensoredName, artworkUrl60: artworkUrl60, artworkUrl100: artworkUrl100, artworkUrl512: artworkUrl512))
                    }
                    DispatchQueue.main.async { [self] in
                        if !applications.isEmpty {
                            viewController?.applications = applications
                        }
                    }
                }
                semaphore.signal()
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
        semaphore.wait()
    }

    func controlTextDidEndEditing(_ obj: Notification) {
        searchField.refusesFirstResponder = true
    }

    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        viewController?.applications = []
        viewController?.collectionView.reloadData()
    }

    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            let text = searchField.cell?.title
            let country = Country(rawValue: countryButton.indexOfSelectedItem)!
            let platform = Platform(rawValue: platformButton.indexOfSelectedItem)!

            getAppIcon(platform: platform, country: country, text: text!)
        }

        if commandSelector == #selector(cancelOperation(_:)) {
            searchField.refusesFirstResponder = true
            viewController?.applications = []
            viewController?.collectionView.reloadData()
        }
        return false
    }
}
