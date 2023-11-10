//
//  Constants.swift
//  BillboardExample
//
//  Created by Ufuk on 10/11/2023.
//

import Foundation

enum Constants {
    
    enum Apps {
        static let golaAi = 
"""
      {
        "appStoreID" : "1661833753",
        "name" : "Gola AI",
        "title": "Let AI help you with your goals",
        "description" : "Achieve your goals with Gola and get motivation from an AI-powered advice generator.",
        "media": "https://pub-378e0dd96b5343108a04317ebddebb4e.r2.dev/AIAd.jpg",
        "backgroundColor" : "19001F",
        "textColor" : "ffffff",
        "tintColor" : "ffffff",
        "fullscreen": false,
        "transparent": false
      } 
"""
        
        static let volo =
"""
{
      "appStoreID" : "1588877511",
      "name" : "Volo",
      "title": "Track your Kitesurfing on Apple Watch",
      "description" : "Volo is a kitesurfing workout app for watchOS and iOS that lets you track jumps and save the sessions into Fitness.",
      "media": "https://pub-378e0dd96b5343108a04317ebddebb4e.r2.dev/volo-1588877511.jpg",
      "backgroundColor" : "000000",
      "textColor" : "ffffff",
      "tintColor" : "F9B959",
      "fullscreen": false,
      "transparent": false
    }
"""
        
        static let gola =
"""
{
      "appStoreID" : "1661833753",
      "name" : "Gola",
      "title": "Stay on top of your goals",
      "description" : "Gola is a beautiful app for iOS and watchOS to help you track your bigger yearly goals and not only offers reminders but also fun little widgets.",
      "media": "https://pub-378e0dd96b5343108a04317ebddebb4e.r2.dev/goalTypes.jpg",
      "backgroundColor" : "02071E",
      "textColor" : "ffffff",
      "tintColor" : "ffffff",
      "fullscreen": false,
      "transparent": false
    }
"""
        
        static let petey =
"""
{
      "appStoreID" : "6446047813",
      "name" : "Petey",
      "title": "Have fun with ChatGPT",
      "description" : "Meet Petey, the AI assistant app for the iPhone & Apple Watch! With this app, you can now talk with ChatGPT right on the go.",
      "media": "https://pub-378e0dd96b5343108a04317ebddebb4e.r2.dev/petey-header.png",
      "backgroundColor" : "000000",
      "textColor" : "ffffff",
      "tintColor" : "00D9FF",
      "fullscreen": false,
      "transparent": true
    }
"""
        
        static var all: [Data] {
            let jsonArray = [golaAi, volo, gola, petey]
            let apps: [Data] = jsonArray.compactMap {
                $0.data(using: .utf8)
            }
            return apps
        }
    }
}
