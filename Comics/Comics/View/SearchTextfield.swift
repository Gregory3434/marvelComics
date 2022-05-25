//
//  SearchTextfield.swift
//  Comics
//
//  Created by Greg on 24/05/2022.
//

import SwiftUI

struct SearchTextfield: View {
    @EnvironmentObject var comicsVM: ComicViewModel
    var body: some View {
        VStack(spacing: 15){
            HStack(spacing: 10){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search Character", text: $comicsVM.searchQuery)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(.vertical,10)
            .padding(.horizontal)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
        }
    }
}

struct SearchTextfield_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextfield()
    }
}
