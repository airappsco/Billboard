//
//  BillboardAd.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public struct BillboardAd: Identifiable, Equatable {
    
    public static func == (lhs: BillboardAd, rhs: BillboardAd) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id : String {
        return "\(name)+\(appStoreID)"
    }
    
    /// Should be the Apple ID of App that's connected to the Ad (e.g. 1596487035)
    public let appStoreID : String
    
    /// Name of ad (e.g. NowPlaying)
    public let name : String
    
    /// Title that's displayed on the Ad (Recommended to be no more than 25 characters)
    public let title : String
    
    /// Description that's displayed on the Ad (Recommended to be no more than 140 characters)
    public let description : String
    
    /// Title that's displayed on show paywall button
    public let paywallButtonTitle: String
    
    /// URL of image that's used in the Ad
    public let media : URL
    
    /// App Store Link based on `appStoreID`
    public var appStoreLink : URL? {
        return URL(string: "https://apps.apple.com/app/id\(appStoreID)")
    }

    /// Main Background color in HEX format
    public let backgroundColor : String
    
    /// Text color in HEX format
    public let textColor : String
    
    /// Main tint color in HEX format
    public let tintColor : String
    
    
    /// For fullscreen media styling (should be true when the main image is a photo)
    public let fullscreen: Bool
    
    /// Allows blurred background when the main image is a PNG
    public let transparent : Bool
    
    /// The duration of the advertisement
    public let advertDuration: TimeInterval
    
    /// Enable or disable haptics
    public let allowHaptics: Bool
    
    public var background : Color {
        return Color(hex: self.backgroundColor)
    }
    
    public var text : Color {
        return Color(hex: self.textColor)
    }
    
    public var tint : Color {
        return Color(hex: self.tintColor)
    }
    
    
    public var appIconURL : URL? {
        return URL(string: "http://itunes.apple.com/lookup?id=\(appStoreID)")
    }
    
    public func getAppIcon() async throws -> Data? {
        guard let appIconURL else { return nil }
        let session = URLSession(configuration: BillboardViewModel.networkConfiguration)
        session.sessionDescription = "Fetching App Icon"
        
        do {
            let (data, _) = try await session.data(from: appIconURL)
            let decoder = JSONDecoder()
            let response = try decoder.decode(AppIconResponse.self, from: data)
            guard let artworkUrlStr = response.results.first?.artworkUrl100, let artworkURL = URL(string: artworkUrlStr) else { return nil }
            
            return try? Data(contentsOf: artworkURL)
            
        } catch {
            return nil
        }

    }
}

public struct AppIconResponse : Codable {
    let results: [AppIconResult]
}


public struct AppIconResult : Codable {
    let artworkUrl100: String

}

@available(iOS 15.0, *)
extension BillboardAd: Codable {
    
    enum CodingKeys: String, CodingKey {
        case appStoreID
        case name
        case title
        case description
        case paywallButtonTitle
        case media
        case backgroundColor
        case textColor
        case tintColor
        case fullScreen
        case transparent
        case advertDuration
        case allowHaptics
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        appStoreID = try container.decode(String.self, forKey: .appStoreID)
        name = try container.decode(String.self, forKey: .name)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        paywallButtonTitle = try container.decodeIfPresent(String.self, forKey: .paywallButtonTitle) ?? "Remove Ads"
        media = try container.decode(URL.self, forKey: .media)
        backgroundColor = try container.decode(String.self, forKey: .backgroundColor)
        textColor = try container.decode(String.self, forKey: .textColor)
        tintColor = try container.decode(String.self, forKey: .tintColor)
        fullscreen = try container.decodeIfPresent(Bool.self, forKey: .fullScreen) ?? false
        transparent = try container.decode(Bool.self, forKey: .transparent)
        advertDuration = try container.decodeIfPresent(TimeInterval.self, forKey: .advertDuration) ?? 5
        allowHaptics = try container.decodeIfPresent(Bool.self, forKey: .allowHaptics) ?? false
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appStoreID, forKey: .appStoreID)
        try container.encode(name, forKey: .name)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(paywallButtonTitle, forKey: .paywallButtonTitle)
        try container.encode(media, forKey: .media)
        try container.encode(backgroundColor, forKey: .backgroundColor)
        try container.encode(textColor, forKey: .textColor)
        try container.encode(tintColor, forKey: .tintColor)
        try container.encode(fullscreen, forKey: .fullScreen)
        try container.encode(transparent, forKey: .transparent)
        try container.encode(advertDuration, forKey: .advertDuration)
        try container.encode(allowHaptics, forKey: .allowHaptics)
    }
}
