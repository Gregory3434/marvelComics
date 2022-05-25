//
//  Comic.swift
//  Comics
//
//  Created by Greg on 21/05/2022.
//

import SwiftUI

struct Result: Codable {
    var data: ComicsData
}

struct ComicsData: Codable {
    var results: [Comic]
}

struct Comic: Identifiable, Codable {
    var id: Int
    var title: String
    var description: String?
    var thumbnail: [String: String]?
}
