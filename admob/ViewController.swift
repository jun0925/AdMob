//
//  ViewController.swift
//  admob
//
//  Created by pples on 2021/12/10.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADFullScreenContentDelegate {
    
    // The rewarded video ad
    var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func loadRewardVideoAd() {
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: GADRequest())  { (ad, error) in
            
          if let error = error {
            print("오류로 인해 보상광고를 로드하지 못했습니다 : \(error.localizedDescription)")
            return
          }
            
          print("보상광고가 로드되었습니다.")
          self.rewardedAd = ad
          self.rewardedAd?.fullScreenContentDelegate = self
        }
      }
    
    func presentRewardVideo() {
       DispatchQueue.background(background: {
           // do something in background
           self.loadRewardVideoAd()

       }, completion:{
           // when background job finished, do something in main thread
           if let ad = self.rewardedAd {
              // reward the user
              ad.present(fromRootViewController: self) {
                  print("보상 지급 : \(ad)")
            }
             
            } else {
               
             // the Ad failed to present .. show alert message
             let alert = UIAlertController(title: "알림", message: "보상광고 정보를 불러오고 있습니다.\n잠시 후에 다시 시도해 주세요.",preferredStyle: .alert)
             let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] action in
                 self?.loadRewardVideoAd()
             })
             alert.addAction(alertAction)
             self.present(alert, animated: true, completion: nil)
           }
       })
    }
    
    @IBAction func playRewardedAdBtn(_ sender: Any) {
        presentRewardVideo()
    }
}

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
