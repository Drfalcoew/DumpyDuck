//
//  GameViewController.swift
//  DuckShot
//
//  Created by Drew Foster on 4/3/17.
//  Copyright © 2017 Drfalcoew. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import GameKit
import AVFoundation

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GADInterstitialDelegate {

    var adView : GADInterstitial!
    
    var dropletSoundPlayer : AVAudioPlayer = AVAudioPlayer()
    var adFree : Bool? = UserDefaults.standard.bool(forKey: "adFree")

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.restartGame), name: NSNotification.Name(rawValue: "restartGame"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.loadAndShow), name: NSNotification.Name(rawValue: "loadAndShow"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.dismissScene), name: NSNotification.Name(rawValue: "dismissScene"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showLeaderBoard), name: NSNotification.Name(rawValue: "showLeaderBoard"), object: nil)

            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    
    override var shouldAutorotate: Bool {
        return true
    }

    func dismissScene() {
        print("DISMISSING SCENE")
        if let view = self.view as! SKView? {
            view.presentScene(nil)
        }
    }
    
    func loadAndShow(){
        if adFree != true {
            adView = GADInterstitial(adUnitID: "ca-app-pub-8752347849222491/6955889197")
            let request = GADRequest()
            request.testDevices = ["f563d68dca9609fdee497d621bb0e6b7"]
            adView.delegate = self
            adView.load(request)
        }
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if adFree != true {
            if (self.adView.isReady){
                adView.present(fromRootViewController: self)
            }
        }
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
    
    
    func showLeaderBoard(){
        playDropletSound()
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.viewState = .default
        gc.leaderboardIdentifier = "leaderboard.dumpyduck"
        self.present(gc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController){
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }
    func restartGame(){
        self.performSegue(withIdentifier: "backToMain", sender: self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}



class Score: GameScene {
    
    func saveHighScore(score: Int){
       
        print(score)
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "Dumpy.Duck")
            
            scoreReporter.value = Int64(score)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: { (error) in
                if error != nil {
                    print("Error")
                }
            })
            
        } else {
            print("LocalPlayer is not Authenticated")
        }
    }
}


