//
//  ComicViewModel.swift
//  Comics
//
//  Created by Greg on 21/05/2022.
//

import SwiftUI
import Combine
import CryptoKit

class ComicViewModel: ObservableObject {
    private let publicKey = "19d60c29ca60667d94ac8a639a107959"
    private let privateKey = "2bac11b12f33596e54ba4fd96f360973a69eab71"
    private let marvelHost = "gateway.marvel.com"
    private let comicsPath = "/v1/public/comics"
    
    @Published var searchQuery = ""
    var searchCancellable: AnyCancellable? = nil
    @Published var comics: [Comic] = []
    @Published var searchedComics: [Comic] = []
    @Published var offset: Int = 0
    
    init() {
        searchCancellable = $searchQuery
            .removeDuplicates()
            .debounce(for: 1.0, scheduler: RunLoop.main)
            .sink(receiveValue: { textInput in
                self.comics = []
                self.searchedComics = []
                if textInput == ""{
                    self.fetchComics()
                } else {
                    self.fetchComicsByTitle(textInput)
                }
            })
    }
    
    func fetchComics() {
        let components = buildComicsURL()
        launchQuery(components.url!, byTitle: false)
    }
    
    func fetchComicsByTitle(_ title: String) {
        let components = buildComicsURL(byTitle: title)
        launchQuery(components.url!, byTitle: true)
    }
    
    private func launchQuery(_ url: URL, byTitle: Bool) {
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print ("Error fetching comics data")
                return
            }
            do {
                let comics = try JSONDecoder().decode(Result.self, from: data)
                DispatchQueue.main.async {
                    if byTitle {
                        self.searchedComics = comics.data.results
                        self.comics = []
                    } else {
                        self.comics.append(contentsOf: comics.data.results)
                    }
                }
            }
            catch {
                print (error)
            }
        }
        task.resume()
    }
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    func buildComicsURL(byTitle: String? = nil) -> URLComponents {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(string: "\(ts)\(privateKey)\(publicKey)")
        var components = URLComponents()
        components.scheme = "https"
        components.host = marvelHost
        components.path = comicsPath
        if byTitle == nil {
            components.queryItems = [
                URLQueryItem(name: "limit", value: "20"),
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "ts", value: "\(ts)"),
                URLQueryItem(name: "apikey", value: "\(publicKey)"),
                URLQueryItem(name: "hash", value: "\(hash)")
            ]
        } else {
            components.queryItems = [
                URLQueryItem(name: "titleStartsWith", value: byTitle),
                URLQueryItem(name: "ts", value: "\(ts)"),
                URLQueryItem(name: "apikey", value: "\(publicKey)"),
                URLQueryItem(name: "hash", value: "\(hash)")
            ]
        }
        
        return components
    }
}
