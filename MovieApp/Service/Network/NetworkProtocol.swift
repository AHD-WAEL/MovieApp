//
//  NetworkProtocol.swift
//  MovieApp
//
//  Created by Mac on 22/07/2023.
//

import Foundation

protocol NetworkProtocol{
    func getMovieListData(handler: @escaping (Response?) -> Void)
}
