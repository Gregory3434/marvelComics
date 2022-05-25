//
//  ComicCellView.swift
//  Comics
//
//  Created by Greg on 22/05/2022.
//

import SwiftUI

struct ComicCellView: View {
    var comic: Comic
    var body: some View {
        let url = displayImageUrl(thumbnailData: comic.thumbnail!)
        NavigationLink(destination: {
            ComicDetailView(comic: comic)
        }, label: {
            VStack {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
            .frame(width: 120, height: 160)
                Text(comic.title)
                    .lineLimit(2)
            }
        })
    }
}

func displayImageUrl(thumbnailData: [String: String]) -> URL {
    let path = thumbnailData["path"] ?? ""
    let https = "https" + path.dropFirst(4)
    let ext = thumbnailData["extension"] ?? ""
    return URL(string: "\(https).\(ext)")!
}

struct ComicRowView_Previews: PreviewProvider {
    static var previews: some View {
        let comic = Comic(id: 1, title: "Captain Marvel",description: "lol", thumbnail: ["path" :"http://i.annihil.us/u/prod/marvel/i/mg/d/70/4bc69c7e9b9d7", "extension": ".jpg"])
        ComicCellView(comic: comic)
    }
}
