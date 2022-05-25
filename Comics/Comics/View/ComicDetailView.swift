//
//  ComicDetailView.swift
//  Comics
//
//  Created by Greg on 22/05/2022.
//

import SwiftUI

struct ComicDetailView: View {
    var comic: Comic
    var body: some View {
        ScrollView {
            let url = displayImageUrl(thumbnailData: comic.thumbnail!)
            AsyncImage(url: url, scale: 4)
                .padding(.top)

            VStack(alignment: .leading) {
                Text(comic.title)
                    .font(.title)
                .font(.subheadline)
                .foregroundColor(.secondary)

                Divider()

                Text("About \(comic.title)")
                    .font(.title2)
                Text(comic.description ?? "")
            }
            .padding()
        }
    }
}

struct ComicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let comic = Comic(id: 1, title: "Captain Marvel",description: "lol", thumbnail: ["path" :"http://i.annihil.us/u/prod/marvel/i/mg/d/70/4bc69c7e9b9d7", "extension": ".jpg"])
        ComicDetailView(comic: comic)
    }
}
