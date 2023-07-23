//
//  Network.swift
//  MovieApp
//
//  Created by Mac on 22/07/2023.
//

import Foundation
import Alamofire

class Network: NetworkProtocol{
    func getMovieListData(handler: @escaping (Response?) -> Void) {
        AF.request("https://api.themoviedb.org/3/movie/top_rated?api_key=7f46651666f1ca68e4cf0cb150551f07").responseDecodable(of: Response.self) { response in
            switch response.result{
            case .success(let data):
                handler(data)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
