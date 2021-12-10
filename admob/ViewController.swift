//
//  ViewController.swift
//  admob
//
//  Created by pples on 2021/12/10.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADRewardedAdDelegate {
    
    var rewardedAd: GADRewardedAd?
    var adRequestInProgress = false
    var testUnitId = "ca-app-pub-3940256099942544/1712485313"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rewardedAd = createAndLoadRewardedAd()
    }
    
    func createAndLoadRewardedAd()  -> GADRewardedAd{
        
        rewardedAd = GADRewardedAd(adUnitID: testUnitId)
        rewardedAd?.load(GADRequest()) { error in
            if let error = error {
                print("広告の読み出し失敗: \(error)")
            } else {
                print("広告の読み出し設定完了")
            }
        }
        return rewardedAd!
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
            print("再生終了。達成おめでとう")
            print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        }
        
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("動画広告表示中")
    }
    
    // 前のリワード広告の表示が終了したらすぐに次のリワード広告の読み込みを開始できるようにする
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("動画広告終了")
        adRequestInProgress = false
        var rewardedAd = createAndLoadRewardedAd()
        print("rewardedAd : \(rewardedAd)")
    }
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("動画広告表示失敗")
        adRequestInProgress = false
    }
    
    
    @IBAction func playRewardedAdBtn(_ sender: Any) {
        if rewardedAd!.isReady == true {
            rewardedAd!.present(fromRootViewController: self, delegate: self)
        }
    }
}

