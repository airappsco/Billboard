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
    
    let configuration: BillboardConfiguration
    
    @Published public var advertisement : BillboardAd? = nil
    
    public init(configuration: BillboardConfiguration = BillboardConfiguration()) {
        self.configuration = configuration
    }
    
    public static var networkConfiguration : URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.multipathServiceType = .handover
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        return config
    }
    
    public func showAdvertisement() async {
        guard let url = configuration.adsJSONURL else { return }

        if let newAd = try? await BillboardViewModel.fetchRandomAd(from: url, excludedIDs: configuration.excludedIDs) {
            await MainActor.run {
                advertisement = newAd
            }
        }
    }
    
    public static func fetchRandomAd(excludedIDs: [String] = []) async throws -> BillboardAd? {
        guard  let url = BillboardConfiguration().adsJSONURL else {
            return nil
        }
        
        let session = URLSession(configuration: BillboardViewModel.networkConfiguration)
        session.sessionDescription = "Fetching Billboard Ad"
        
        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(BillboardAdResponse.self, from: data)
            let filteredAds = response.ads.filter({ !excludedIDs.contains($0.appStoreID) })
            let adToShow = filteredAds.randomElement()
            
            if let adToShow {
                Logger.billboard.debug("✨ Billboard Ad presented: \(adToShow.name)")
            }
            
            return adToShow
            
        } catch DecodingError.keyNotFound(let key, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad because it appears to be invalid JSON")
        } catch {
            Logger.billboard.error("❌ Failed to decode Billboard Ad: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    public static func fetchRandomAd(from url: URL, excludedIDs: [String] = []) async throws -> BillboardAd? {
        let session = URLSession(configuration: BillboardViewModel.networkConfiguration)
        session.sessionDescription = "Fetching Billboard Ad"
        
        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(BillboardAdResponse.self, from: data)
            let filteredAds = response.ads.filter({ !excludedIDs.contains($0.appStoreID) })
            let adToShow = filteredAds.randomElement()
            
            if let adToShow {
                Logger.billboard.debug("✨ Billboard Ad presented: \(adToShow.name)")
            }
            
            return adToShow
            
        } catch DecodingError.keyNotFound(let key, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad because it appears to be invalid JSON")
        } catch {
            Logger.billboard.error("❌ Failed to decode Billboard Ad: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    public static func fetchAllAds(from url: URL) async throws -> [BillboardAd] {
        let session = URLSession(configuration: BillboardViewModel.networkConfiguration)
        session.sessionDescription = "Fetching All Billboard Ads"
                
        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(BillboardAdResponse.self, from: data)
            return response.ads
            
        } catch DecodingError.keyNotFound(let key, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            Logger.billboard.error("❌ Failed to decode Billboard Ad because it appears to be invalid JSON")
        } catch {
            Logger.billboard.error("❌ Failed to decode Billboard Ad: \(error.localizedDescription)")
        }
        
        return []
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
    }
}
