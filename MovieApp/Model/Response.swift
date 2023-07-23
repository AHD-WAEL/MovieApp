//
//  Response.swift
//  MovieApp
//
//  Created by Mac on 23/07/2023.
//

import Foundation

struct Response: Codable {
    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
