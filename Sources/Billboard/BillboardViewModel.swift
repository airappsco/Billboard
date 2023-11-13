//
//  BillboardViewModel.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import Foundation
import OSLog

@available(iOS 15.0, *)
public final class BillboardViewModel : ObservableObject {
    
    public static var networkConfiguration : URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.multipathServiceType = .handover
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        return config
    }
}

//MARK: - Air Apps Additions

@available(iOS 15.0, *)
extension BillboardViewModel {
    
    /// Generates BillboardAd model from given JSON as Data type
    /// - Parameter data: Represents BillboardAd JSON as Data type
    /// - Returns: BillboardAd object that states generated ad object
    public static func generateAd(from data: Data) -> BillboardAd? {
        do {
            let decoder = JSONDecoder()
            let advert = try decoder.decode(BillboardAd.self, from: data)
            return advert
        } catch DecodingError.keyNotFound(let key, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
            return nil
        } catch DecodingError.typeMismatch(_, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to type mismatch – \(context.debugDescription)")
            return nil
        } catch DecodingError.valueNotFound(let type, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to missing \(type) value – \(context.debugDescription)")
            return nil
        } catch DecodingError.dataCorrupted(_) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad because it appears to be invalid JSON")
            return nil
        } catch {
            Logger.billboard.error("❌ Failed to decode Billboard Ad: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Downloads and caches downloadable content of Ad
    /// - Parameter data: Represents BillboardAd JSON as Data type
    public static func prepareAd(from data: Data) {
        guard let advert = BillboardViewModel.generateAd(from: data) else {
            return
        }
        
        Task {
            let mediaUrl = advert.media.absoluteString
            await CachedImageManager().load(mediaUrl, cache: .shared)
        }
        
        Task {
            try? await advert.getAppIcon()
        }
    }
}
