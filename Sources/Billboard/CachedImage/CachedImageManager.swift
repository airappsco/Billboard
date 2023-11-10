//
//  CachedImageManager.swift
//  AsyncImageStarter
//
//  Created by Tunde Adegoroye on 09/04/2022.
//

import Foundation

@available(iOS 15.0, *)
final class CachedImageManager: ObservableObject {
    
    @Published private(set) var currentState: CurrentState?
    
    private let imageRetriver = ImageRetriver()
    
    @MainActor
    func load(_ imgUrl: String,
              cache: ImageCache = .shared) async {
        
        self.currentState = .loading
        
        if let imageData = cache.object(forkey: imgUrl as NSString) {
            self.currentState = .success(data: imageData)
            return
        }
        
        do {
            let data = try await imageRetriver.fetch(imgUrl)
            self.currentState = .success(data: data)
            cache.set(object: data as NSData,
                      forKey: imgUrl as NSString)            
        } catch {
            self.currentState = .failed(error: error)
        }
    }
}

@available(iOS 15.0, *)
extension CachedImageManager {
    enum CurrentState {
        case loading
        case failed(error: Error)
        case success(data: Data)
    }
}

@available(iOS 15.0, *)
extension CachedImageManager.CurrentState: Equatable {
    static func == (lhs: CachedImageManager.CurrentState,
                    rhs: CachedImageManager.CurrentState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (let .failed(lhsError), let .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (let .success(lhsData), let .success(rhsData)):
            return lhsData == rhsData
        default:
            return false
        }
    }
}
