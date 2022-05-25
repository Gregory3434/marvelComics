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
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(string: "\(ts)\(privateKey)\(publicKey)")
        let url = "https://gateway.marvel.com/v1/public/comics?limit=20&offset=\(offset)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        launchQuery(url, byTitle: false)
    }
    
    func fetchComicsByTitle(_ title: String) {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(string: "\(ts)\(privateKey)\(publicKey)")
        let originalQuery = title.replacingOccurrences(of: " ", with: "%20")
        let url = "https://gateway.marvel.com/v1/public/comics?titleStartsWith=\(originalQuery)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        launchQuery(url, byTitle: false)
    }
    
    private func launchQuery(_ url: String, byTitle: Bool) {
        let session = URLSession(configuration: .default)
        let url = URL(string: url)!
        
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
}
