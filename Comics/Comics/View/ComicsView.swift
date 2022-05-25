//
//  ComicsView.swift
//  Comics
//
//  Created by Greg on 21/05/2022.
//

import SwiftUI

struct ComicsView: View {
    @EnvironmentObject var comicsVM: ComicViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                SearchTextfield()
                    .padding()
                if comicsVM.comics.isEmpty && comicsVM.searchedComics.isEmpty {
                    ProgressView()
                } else {
                    LazyVGrid(columns: columns) {
                        if !comicsVM.comics.isEmpty {
                            ForEach (comicsVM.comics) { comic in
                                ComicCellView(comic: comic)
                            }
                        } else if !comicsVM.searchedComics.isEmpty {
                            ForEach (comicsVM.searchedComics) { comic in
                                ComicCellView(comic: comic)
                            }
                        }
                    }
                    if !comicsVM.comics.isEmpty && comicsVM.searchQuery == ""{
                        if comicsVM.offset == comicsVM.comics.count {
                            ProgressView()
                                .onAppear(perform: {
                                    comicsVM.fetchComics()
                                })
                        } else {
                            GeometryReader{ geo -> Color in
                                let minY = geo.frame(in: .global).minY
                                let height = UIScreen.main.bounds.height / 1.3
                                if !comicsVM.comics.isEmpty && minY < height{
                                    DispatchQueue.main.async {
                                        comicsVM.offset = comicsVM.comics.count
                                    }
                                }
                                return Color.clear
                            }
                            .frame(width: 20, height: 20)
                        }
                    }
                }
            }.navigationTitle("Marvel Comics")
        }
    }
}

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
