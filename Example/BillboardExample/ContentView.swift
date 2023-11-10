//
//  ContentView.swift
//  BillboardExample
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI
import Billboard

struct ContentView: View {
    
    @StateObject var premium = PremiumStore()
    
    @State private var showRandomAdvert = false
    @State private var adtoshow :BillboardAd? = nil
    @State private var allAds : [BillboardAd] = []
        
    var body: some View {
        NavigationStack {
            List {
                if let advert = allAds.randomElement() {
                    Section {
                        BillboardBannerView(advert: advert, hideDismissButtonAndTimer: true)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                
                Section {
                    ForEach(allAds) { ad in
                        Button {
                            adtoshow = ad
                        } label: {
                            Text(ad.name)
                                .padding(6)
                        }
                        
                    }
                } header: {
                    Text("Total Ads: \(allAds.count)")
                }
            }
            .font(.compatibleSystem(.body, design: .rounded, weight: .medium))
        }
        .safeAreaInset(edge: .bottom, content: {
            if let advert = allAds.randomElement() {
                BillboardBannerView(advert: advert)
                    .padding()
                
            }
        })
        .fullScreenCover(item: $adtoshow) { advert in
            BillboardView(
                advert: advert) {
                    print("Show Paywall Did Tap!")
                }
        }
        .task {
            self.allAds = Constants.Apps.all.compactMap {
                BillboardViewModel.prepareAd(from: $0)
                return BillboardViewModel.generateAd(from: $0)
            }
        }
    }
        
}

@MainActor
final class PremiumStore : ObservableObject {
    @Published var didBuyPremium = false
    
    func buyPremium() {
        didBuyPremium = true
    }
}
