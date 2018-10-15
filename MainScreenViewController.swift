//
//  MainScreenViewController.swift
//  DuckShot
//
//  Created by Drew Foster on 4/3/17.
//  Copyright © 2017 Drfalcoew. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import GameKit
import GameplayKit
import StoreKit
import Firebase



class MainScreenViewController: UIViewController, GADBannerViewDelegate, GKGameCenterControllerDelegate, GADInterstitialDelegate {
    
    
    
    
    
    var adFree : Bool? = UserDefaults.standard.bool(forKey: "adFree")
    var costume : String? = UserDefaults.standard.string(forKey: "costume")
    var snails : Int? = UserDefaults.standard.integer(forKey: "snail")
    var nightMode : Bool? = UserDefaults.standard.bool(forKey: "nightMode")
    var sound : Bool? = UserDefaults.standard.bool(forKey: "sound")
    var dismiss : Bool? = UserDefaults.standard.bool(forKey: "dismiss")

    var btnFrame : CGFloat?
    var btnPos : CGFloat?
    
    var img : UIImage?
    var img2 : UIImage?
    var imgA : UIImage?
    var imgB : UIImage?
    
    var bottomViewHeightAnchor : NSLayoutConstraint?
    
    var dropletSoundPlayer : AVAudioPlayer = AVAudioPlayer()
    
    var rated: Bool? = UserDefaults.standard.bool(forKey: "rate")
    
    var nMTemp : Bool?
    var sTemp : Bool?
    
    let nightModeButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(nightModeToggle), for: .touchUpInside)
        return btn
    }()
    
    let soundButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(toggleSound), for: .touchUpInside)
        return btn
    }()
    
    let playButton : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(playGame), for: .touchUpInside)
        return btn
    }()
    
  
    var blackView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 1.0
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    
    
    let chartsButton: UIButton = {
        let btn = UIButton()
     
        btn.setImage(#imageLiteral(resourceName: "chartsButton"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(showLeaderBoard), for: .touchUpInside)

        return btn
    }()
    
    let costumeButton: UIButton = {
        let btn = UIButton()
        
        btn.setImage(#imageLiteral(resourceName: "costumeButton"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(showCostumes), for: .touchUpInside)
        
        return btn
    }()
    
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let rateButton : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "ratepng"), for: .normal)
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(gameRatings), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let adFreeButton : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "adFree"), for: .normal)
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(adFreeHandler), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let restorePurchases : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "restorePurchases"), for: .normal)
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(restorePurchasesHandler), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let titleImage : UIImageView = {
        let ti = UIImageView()
        ti.image = UIImage(named: "title")
        ti.layer.masksToBounds = true
        ti.translatesAutoresizingMaskIntoConstraints = false
        return ti
    }()
    
    
    let snail : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "snail")
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let background : UIImageView = {
        let img = UIImageView()
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let nightSky : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "nightSky")
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = true
        return img
    }()
    
    let moon : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "moon")
        //img.layer.masksToBounds = true
        //img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let snailPoints : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gill Sans", size: 35)
        lbl.textColor = .white
        lbl.layer.masksToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        return lbl
    }()
    

    
    override func viewDidAppear(_ animated: Bool) {
        //MainScreenViewController().viewDidAppear(true)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
        }) { (true) in
            self.blackView.isHidden = true
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateLocalPlayer()
        
        btnPos = view.frame.height / 4
        btnFrame = view.frame.width / 4
        
        img = UIImage(named: "nightMode")
        img2 = UIImage(named: "dayMode")
        imgA = UIImage(named: "buildingsAndSky")
        imgB = UIImage(named: "buildingsAndSkyNight")
        
        if dismiss == true {
            UserDefaults.standard.set(false, forKey: "dismiss")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissScene"), object: nil)
            print("DISMISSING SCENE")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainScreenViewController.adFreeModeTemp), name: NSNotification.Name(rawValue: "adFree"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainScreenViewController.displayAlertFailed), name: NSNotification.Name(rawValue: "Main"), object: nil)

        UserDefaults.standard.set(1, forKey: "vc")

        if nightMode == true {
            //NightMode Enabled
            nightModeButton.setImage(img, for: .normal)
            background.image = imgB
            moon.isHidden = false
          
        } else {
            //DayMode Enabled
            nightModeButton.setImage(img2, for: .normal)
            background.image = imgA
            moon.isHidden = true
        }
        
        nMTemp = nightMode
        
        if sound == false {
            
            soundButton.setImage(UIImage(named: "soundOff"), for: .normal)
        } else {
            sound = true
            soundButton.setImage(UIImage(named: "soundOn"), for: .normal)
        }
        
        sTemp = sound
        
        if let x = snails {
            snailPoints.text = "\(x)"
        } else {
            snailPoints.text = "0"
        }

        let request = GADRequest()
        request.testDevices = ["f563d68dca9609fdee497d621bb0e6b7"]

        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        
        bannerView.adUnitID = "ca-app-pub-8752347849222491/1113550569"
        bannerView.delegate = self
        
        
        bannerView.rootViewController = self
        bannerView.load(request)
        
        Assets.sharedInstance.preloadAssets()
        
        
        adFreeButton.isHidden = false
        
        view.addSubview(nightSky)
        view.addSubview(moon)
        view.addSubview(background)
        view.addSubview(titleImage)
        view.addSubview(snail)
        view.addSubview(snailPoints)
        view.addSubview(playButton)
        view.addSubview(nightModeButton)
        view.addSubview(soundButton)
        view.addSubview(rateButton)
        view.addSubview(adFreeButton)
        view.addSubview(chartsButton)
        view.addSubview(costumeButton)
        view.addSubview(bottomView)
        view.addSubview(restorePurchases)
        self.bottomView.addSubview(bannerView)

        view.addSubview(blackView)
        setupConstraints()
        adFreeMode()

        if nMTemp == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                UIView.animate(withDuration: 3.5, delay: 1, options: .curveEaseOut, animations: {
                    if self.view.frame.height > 720 {
                        self.moon.frame = CGRect(x: self.moon.frame.width / -5, y: self.nightModeButton.center.y - 50, width: self.btnFrame! * 1.25, height: self.btnFrame! * 1.25)
                    } else {
                        self.moon.frame = CGRect(x: self.moon.frame.width / -5, y: self.nightModeButton.center.y + 10, width: self.btnFrame! * 1.25, height: self.btnFrame! * 1.25)
                    }
                }, completion: nil)
            })
        }
    }

    var snailRightAnchor : NSLayoutConstraint!
    
    func setupConstraints(){

        blackView.frame = view.frame
        
        background.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        background.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        background.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        background.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
        
        nightSky.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        if (view.frame.height <= 400){
            bottomViewHeightAnchor = bottomView.heightAnchor.constraint(equalToConstant: 32)
        } else if (view.frame.height > 400 && view.frame.height <= 720) {
            bottomViewHeightAnchor = bottomView.heightAnchor.constraint(equalToConstant: 50)
        } else if (view.frame.height > 720){
            bottomViewHeightAnchor = bottomView.heightAnchor.constraint(equalToConstant: 90)
        }
        
        bottomViewHeightAnchor?.isActive = true
        
        restorePurchases.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        restorePurchases.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        restorePurchases.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5).isActive = true
        restorePurchases.bottomAnchor.constraint(greaterThanOrEqualTo: titleImage.topAnchor, constant: -10).isActive = true
        restorePurchases.heightAnchor.constraint(equalToConstant: restorePurchases.frame.width * 0.47).isActive = true
        
        snail.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        snail.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        snail.widthAnchor.constraint(equalToConstant: btnFrame! / 2).isActive = true
        snail.heightAnchor.constraint(equalToConstant: btnFrame! / 2).isActive = true
        
        
        if let x = snails {
            if x < 10 {
                snailRightAnchor = snailPoints.rightAnchor.constraint(equalTo: snail.rightAnchor, constant: -50)
            } else if x >= 10 && x < 100 {
                snailRightAnchor = snailPoints.rightAnchor.constraint(equalTo: snail.rightAnchor, constant: -40)
            } else if x >= 100 && x < 1000 {
                snailRightAnchor = snailPoints.rightAnchor.constraint(equalTo: snail.rightAnchor, constant: -45)
            } else if x >= 1000 {
                snailRightAnchor = snailPoints.rightAnchor.constraint(equalTo: snail.rightAnchor, constant: -50)
            }
        }
        snailRightAnchor.isActive = true
        snailPoints.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        snailPoints.widthAnchor.constraint(equalToConstant: btnFrame!).isActive = true
        snailPoints.heightAnchor.constraint(equalToConstant: btnFrame! / 2).isActive = true
        
        
        titleImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9.5/10).isActive = true
        titleImage.heightAnchor.constraint(equalTo: titleImage.widthAnchor, multiplier: 0.265).isActive = true
        titleImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        titleImage.topAnchor.constraint(equalTo: snail.bottomAnchor, constant: 15).isActive = true
      
        adFreeButton.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 10).isActive = true
        adFreeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        adFreeButton.widthAnchor.constraint(equalToConstant: btnFrame! / 1.5).isActive = true
        adFreeButton.heightAnchor.constraint(equalTo: nightModeButton.widthAnchor, multiplier: 1).isActive = true
        
        nightModeButton.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 10).isActive = true
        nightModeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        nightModeButton.widthAnchor.constraint(equalToConstant: btnFrame! / 1.5).isActive = true
        nightModeButton.heightAnchor.constraint(equalTo: nightModeButton.widthAnchor, multiplier: 1).isActive = true
        
        soundButton.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 10).isActive = true
        soundButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        soundButton.widthAnchor.constraint(equalToConstant: btnFrame! / 1.5).isActive = true
        soundButton.heightAnchor.constraint(equalTo: nightModeButton.widthAnchor, multiplier: 1).isActive = true
        
        costumeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        costumeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: btnPos! + (btnFrame! / 2 + 20)).isActive = true
        costumeButton.widthAnchor.constraint(equalToConstant: btnFrame!).isActive = true
        costumeButton.heightAnchor.constraint(equalToConstant: btnFrame!).isActive = true
        
        
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: btnPos! - (btnFrame! / 2 + 20)).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: btnFrame!).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: btnFrame!).isActive = true

        
        rateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width / -4).isActive = true
        rateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: btnPos!).isActive = true
        rateButton.widthAnchor.constraint(equalToConstant: btnFrame!).isActive = true
        rateButton.heightAnchor.constraint(equalToConstant: btnFrame!).isActive = true
      
        
        chartsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width / 4).isActive = true
        chartsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: btnPos!).isActive = true
        chartsButton.widthAnchor.constraint(equalToConstant: btnFrame!).isActive = true
        chartsButton.heightAnchor.constraint(equalToConstant: btnFrame!).isActive = true
    
        
        moon.frame = CGRect(x: moon.frame.width / -5, y: view.frame.maxY, width: self.btnFrame! * 1.25, height: self.btnFrame! * 1.25)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func playDropletSound(){
        let dropletSoundURL: URL = Bundle.main.url(forResource: "WaterDroplet", withExtension: "mp3")! as URL
        
        do {
            dropletSoundPlayer = try AVAudioPlayer(contentsOf: dropletSoundURL as URL)
        } catch {
            print("Could not play music")
        }
        dropletSoundPlayer.volume = 0.7
        dropletSoundPlayer.prepareToPlay()
        dropletSoundPlayer.play()
    }
    
    
    
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.present(viewController!, animated: true, completion: nil)
            }
            else {
                print(error?.localizedDescription as Any)
                print(GKLocalPlayer.localPlayer().isAuthenticated)
            }
        }
    }
    
    func gameRatings(){
        if sTemp != false {
            playDropletSound()
        }
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id1266446119"),
                UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
            }
        UserDefaults.standard.set(true, forKey: "rate")
        }
    }
    
    func showCostumes() {
        self.blackView.isHidden = false
        if sTemp != false {
            playDropletSound()
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
        }) { (true) in
            self.performSegue(withIdentifier: "toCostumes", sender: self)
        }
    }
    
    func toggleSound(){
        if sTemp == true {
            soundButton.setImage(UIImage(named: "soundOff"), for: .normal)
            UserDefaults.standard.set(false, forKey: "sound")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fadeBGMusic"), object: nil)
            sTemp = false
        } else {
            playDropletSound()
            soundButton.setImage(UIImage(named: "soundOn"), for: .normal)
            sTemp = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playBGMusic"), object: nil)
            UserDefaults.standard.set(true, forKey: "sound")
        }
    }
    
    // PURCHASE HANDLER

    func restorePurchasesHandler(){
        if sTemp != false {
            playDropletSound()
        }
        IAPService.shared.restorePurchases()
    }
    
    func adFreeMode(){
        
        print("AdFree: \(String(describing: adFree))")

        if adFree == true {
            bottomView.isHidden = true
            adFreeButton.isHidden = true
        } else {
            bottomView.isHidden = false
            adFreeButton.isHidden = false
        }
    }
    
    func adFreeModeTemp(){
        print("AdFree: \(String(describing: adFree))")
        
        bottomView.isHidden = true
        adFreeButton.isHidden = true
       
    }
    
    func adFreeHandler(){
        IAPService.shared.purchase(product: .adFree)
    }
    
    func nightModeToggle(){
        if sTemp != false {
            playDropletSound()
        }
       
        if nMTemp == true {
            nMTemp = false
            nightModeButton.setImage(img2, for: .normal)
            background.image = imgA
            moon.isHidden = true
            UserDefaults.standard.set(false, forKey: "nightMode")
            
            
        } else {
            nMTemp = true
            background.image = imgB
            nightModeButton.setImage(img, for: .normal)
            UserDefaults.standard.set(true, forKey: "nightMode")
            
            print(bottomView.frame.maxY)
            moon.isHidden = false
            moon.frame = CGRect(x: moon.frame.width / -5, y: view.frame.maxY, width: self.btnFrame! * 1.25, height: self.btnFrame! * 1.25)
            UIView.animate(withDuration: 3.5, delay: 1, options: .curveEaseOut, animations: {
                if self.view.frame.height > 720 {
                    self.moon.frame = CGRect(x: self.moon.frame.width / -5, y: self.nightModeButton.center.y - 50, width: self.btnFrame! * 1.25, height: self.btnFrame! * 1.25)
                } else {
                    self.moon.frame = CGRect(x: self.moon.frame.width / -5, y: self.nightModeButton.center.y + 10, width: self.btnFrame! * 1.25, height: self.btnFrame! * 1.25)
                }
            }, completion: { (true) in
                print("Moon.y: \(self.moon.center.y), Moon.x: \(self.moon.center.x)")
            })
        }
        
    }
    
    func showLeaderBoard(){
        if sTemp != false {
            playDropletSound()
        }
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.viewState = .default
        gc.leaderboardIdentifier = "Dumpy.Duck"
        self.present(gc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController){
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    
    func playGame(){
        self.blackView.isHidden = false
        if sTemp != false {
            playDropletSound()
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
        }) { (true) in
            self.performSegue(withIdentifier: "toGame", sender: self)
        }
    }
    
    func displayAlertFailed(){
        let myAlert = UIAlertController(title: "Purchase Failed!", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}


class Assets {
    static let sharedInstance = Assets()
    let sprites = SKTextureAtlas(named: "Sprites")
    
    func preloadAssets() {
        sprites.preload { 
            print("Sprites preloaded")
        }
    }
}



