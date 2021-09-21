//
//  NativeAdWrapper.swift
//  admob-wrapper
//
//  Created by Levent Oral on 21.09.2021.
//

import UIKit
import GoogleMobileAds

@objc(NativeAdWrapper) public class NativeAdWrapper: UIView {
    
    private var nativeAdView: GADNativeAdView!
    private var nativeMediaView: GADMediaView!
    
    private var nativeAd: GADNativeAd? = nil
    
    private var adRequest: GADRequest!
    private var adLoader: GADAdLoader!
    
    private var onAdLoaded: (() -> Void)? = nil
    private var onAdLoadFailed: (() -> Void)? = nil
    
    public init(frame: CGRect,
                rootViewController: UIViewController,
                adMobAdUnitId: String,
                onAdLoaded: @escaping () -> Void,
                onAdLoadFailed: @escaping () -> Void) {
        super.init(frame: frame)
        
        self.onAdLoaded = onAdLoaded
        self.onAdLoadFailed = onAdLoadFailed
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setupView()
        
        self.adRequest = GADRequest()
        let adOptions = GADNativeAdViewAdOptions()
        adOptions.preferredAdChoicesPosition = .bottomRightCorner
        self.adLoader = GADAdLoader(adUnitID: adMobAdUnitId,
                                    rootViewController: rootViewController,
                                    adTypes: [.native],
                                    options: [adOptions])
        self.adLoader.delegate = self
        self.adLoader.load(self.adRequest)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        self.nativeAdView = GADNativeAdView(frame: self.frame)
        self.nativeAdView.isUserInteractionEnabled = false
        self.nativeMediaView = GADMediaView(frame: self.frame)
        self.nativeAdView.isUserInteractionEnabled = false
        
        self.nativeAdView.addSubview(self.nativeMediaView)
        self.addSubview(self.nativeAdView)
    }
    
    private func renderNativeAd() {
        self.nativeMediaView.mediaContent = self.nativeAd?.mediaContent
        
        self.nativeAdView.nativeAd = self.nativeAd
    }
}

extension NativeAdWrapper: GADNativeAdLoaderDelegate {
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("AdmobAdView:didReceive")
        self.nativeAd = nativeAd
        self.nativeAd?.delegate = self
        self.renderNativeAd()
        self.onAdLoaded?()
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("AdmobAdView:didFailToReceiveAdWithError")
        self.onAdLoadFailed?()
    }
}

extension NativeAdWrapper: GADNativeAdDelegate {
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("AdmobAdView:nativeAdDidRecordClick")
    }
}
