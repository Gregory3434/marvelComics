//
//  Home.swift
//  Comics
//
//  Created by Greg on 21/05/2022.
//
// test
import SwiftUI

struct Home: View {
    @StateObject var comicsData = ComicViewModel()
    var body: some View {
        TabView {
            ComicsView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Comics")
                }
                .environmentObject(comicsData)
            Text("Favorites")
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
