//
//  ImageRetriever.swift
//  AsyncImageStarter
//
//  Created by Tunde Adegoroye on 09/04/2022.
//

import Foundation

@available(iOS 15.0, *)
struct ImageRetriver {
    
    func fetch(_ imgUrl: String) async throws -> Data {
        guard let url = URL(string: imgUrl) else {
            throw RetriverError.invalidUrl
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

@available(iOS 15.0, *)
private extension ImageRetriver {
    enum RetriverError: Error {
        case invalidUrl
    }
}
