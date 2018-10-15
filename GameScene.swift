
//
//  GameScene.swift
//  DuckShot
//
//  Created by Drew Foster on 4/3/17.
//  Copyright © 2017 Drfalcoew. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation




struct CollisionTypes {
    static let duck : UInt32 = 0x1 << 0
    static let poop : UInt32 = 0x1 << 1
    static let person : UInt32 = 0x1 << 2
    static let endPoint : UInt32 = 0x1 << 3
    static let sideWalk : UInt32 = 0x1 << 4
    static let enemy : UInt32 = 0x1 << 5
    static let deadEnemy : UInt32 = 0x1 << 6
    static let bread : UInt32 = 0x1 << 7
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    var poopSpawn : SKNode!
    var upPosition : SKNode!
    var downPosition : SKNode!
    var endPoint : SKNode!
    
    
    var poopArray = [SKTexture]()
    var duckAtlas = SKTextureAtlas()
    var duckArray = [SKTexture]()
    var splatArray = [SKTexture]()
    var enemyArray = [SKTexture]()
    var wPoopArray = [SKTexture]()
    var bPoopArray = [SKTexture]()
    var aPoopArray = [SKTexture]()
    var lPoopArray = [SKTexture]()
    
    var nightMode : Bool? = UserDefaults.standard.bool(forKey: "nightMode")
    var costume : String? = UserDefaults.standard.string(forKey: "costume")
    var snails : Int? = UserDefaults.standard.integer(forKey: "snail")
    var sound : Bool? = UserDefaults.standard.bool(forKey: "sound")
    
    var duck : SKSpriteNode!
    var enemy : SKSpriteNode?
    var deadEnemy : SKSpriteNode?
    var deadEnemySpawn : SKSpriteNode?
    var sideWalk : SKSpriteNode!
    var asianGuy : SKSpriteNode!
    var wizard : SKSpriteNode!
    var hillary : SKSpriteNode!
    var donald : SKSpriteNode!
    var blackGuy : SKSpriteNode!
    var initialBlackView : SKSpriteNode!
    var littleGirl : SKSpriteNode!
    var point : SKSpriteNode!
    var bread : SKSpriteNode!
    
    var firsTap : Bool = true
    var tapGesture : Bool = true
    var firstGame : Bool? = true
    var poopHit = [Bool]()
    var tenOrHun : Bool!
    var adBool : Bool = true
    
    var randomSpawn : Int!
    var lives : Int = 3
    var ammo : Int?
    var ammoLim : Int?
    var spawnNum : Int? = 0
    var score : Int = 0
    var enemyCount : Double = 0.0
    var hitCountA : Int = 0
    var hitCountB : Int = 0
    
    var spawnAB : Bool?
    var spawnTimer : Timer?
    var spawnBreadTimer : Timer?
    var breadTimer : Double = 0.0
    var timeInterval : Double = 0.15
    var gameTime : Double = 0.0
    var level : Double!
    
    var node : SKSpriteNode!
    var poop : SKSpriteNode!
    var spawnPoop : SKSpriteNode?
    var ammoLabel : SKLabelNode?
    var minusHeart : SKSpriteNode!
    var heartOne : SKSpriteNode!
    var heartTwo : SKSpriteNode!
    var heartThree : SKSpriteNode!
    var safeBackground : SKSpriteNode!
    var background : SKSpriteNode!
    var nightSky : SKSpriteNode?

    var tap : UITapGestureRecognizer!
    var swipeDown : UISwipeGestureRecognizer!
    var swipeUp : UISwipeGestureRecognizer!
    
    var moveAndRemoveEnemy = SKAction()
    var moveAndRemovePlane = SKAction()
    var moveAndRemove = SKAction()
    var moveAndRemoveHeart = SKAction()
    var moveAndRemovePoint = SKAction()
    var fadeIn : SKAction!
    var fadeOut : SKAction!
    var repeatAction = SKAction()
    var moveAndRemoveBread = SKAction()
    var moveBUDForever = SKAction()
    var moveBDUForever = SKAction()

    var scoreLabel : SKLabelNode!
    
    var poopSound = SKAction.playSoundFileNamed("poop.m4a", waitForCompletion: false)
    var violinSound : AVAudioPlayer = AVAudioPlayer()
    var quackSound = SKAction.playSoundFileNamed("Duck.mp3", waitForCompletion: false)
    var dropletSoundPlayer : AVAudioPlayer = AVAudioPlayer()
    var bgCry = SKAction.playSoundFileNamed("bGCry.m4a", waitForCompletion: false)
    var hilCry = SKAction.playSoundFileNamed("hillaryCry.m4a", waitForCompletion: false)
    var lGCry = SKAction.playSoundFileNamed("lGCry.m4a", waitForCompletion: false)
    var aGCry = SKAction.playSoundFileNamed("wGCry.m4a", waitForCompletion: false)
    var wizCry = SKAction.playSoundFileNamed("wizCry.m4a", waitForCompletion: false)
    var dtCry = SKAction.playSoundFileNamed("trumpCry.m4a", waitForCompletion: false)
    
    
    
    
    let retryFrame: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()
    
    
    let retryButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "play"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        return btn
    }()
    
    let homeButton : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "HomeButton"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        return btn
    }()
    
    let chartsButton: UIButton = {
        let btn = UIButton()
        let img = UIImage(named: "chartsButton")
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(showLeaderBoard), for: .touchUpInside)
        return btn
    }()

    
    var endScore : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gill Sans", size: 20)
        lbl.text = "Score: "
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var endHighScore : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gill Sans", size: 20)
        lbl.text = "HighScore: "
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var startFrame : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    var tapPlay : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "tapToPlay")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    var blackView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func didMove(to view: SKView) {
        fadeIn = SKAction.fadeIn(withDuration: 0.3)
        fadeOut = SKAction.fadeOut(withDuration: 1.0)
        
        blackView.isHidden = true
        scene?.isPaused = false
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.contactDelegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(enteredBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enteredGame), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        //sprites
        duck = childNode(withName: "duck") as! SKSpriteNode!
        deadEnemy = childNode(withName: "deadEnemy") as! SKSpriteNode!
        asianGuy = childNode(withName: "asianGuy") as! SKSpriteNode!
        blackGuy = childNode(withName: "blackGuy") as! SKSpriteNode!
        wizard = childNode(withName: "wizard") as! SKSpriteNode!
        hillary = childNode(withName: "hillary") as! SKSpriteNode!
        donald = childNode(withName: "donald") as! SKSpriteNode!
        littleGirl = childNode(withName: "littleGirl") as! SKSpriteNode!
        poopSpawn = childNode(withName: "poopSpawn")! as SKNode
        poop = childNode(withName: "poop") as! SKSpriteNode!
        ammoLabel = childNode(withName: "Ammo") as? SKLabelNode
        minusHeart = childNode(withName: "minusHeart") as! SKSpriteNode!
        heartOne = childNode(withName: "heartOne") as! SKSpriteNode!
        heartTwo = childNode(withName: "heartTwo") as! SKSpriteNode!
        heartThree = childNode(withName: "heartThree") as! SKSpriteNode!
        scoreLabel = childNode(withName: "score") as! SKLabelNode!
        initialBlackView = childNode(withName: "initialBlackView") as! SKSpriteNode!
        point = childNode(withName: "point") as! SKSpriteNode!
        bread = childNode(withName: "bread") as! SKSpriteNode!
        
        upPosition = childNode(withName: "firstRow")! as SKNode
        downPosition = childNode(withName: "lastRow")! as SKNode
        endPoint = childNode(withName: "endPoint")! as SKNode
        
        duckAtlas = SKTextureAtlas(named: "duck")
        
        // Loading in preloaded Textures
    
        for i in 1...2 {
            let name = "splat_\(i).png"
            splatArray.append(Assets.sharedInstance.sprites.textureNamed(name))
        }
        
        for i in 1...3 {
            let name = "poop_\(i).png"
            poopArray.append(Assets.sharedInstance.sprites.textureNamed(name))
        }
        
        for i in 1...2 {
            let name = "bird_\(i).png"
            self.enemyArray.append(Assets.sharedInstance.sprites.textureNamed(name))
        }
        
        // CHECK IF USER ENABLED ANY COSTUME
        print("COSTUME: \(costume)")

        switch costume {
        case "1"?:
            for i in 1...4 {
                let name = "DuckHelmet_\(i).png"
                duckArray.append(SKTexture(imageNamed: name))
            }
            duck?.run(SKAction.repeatForever(SKAction.animate(with: duckArray, timePerFrame: 0.2)))
            break
        case "2"?:
            for i in 1...4 {
                let name = "airplane_\(i).png"
                duckArray.append(SKTexture(imageNamed: name))
            }
            duck?.run(SKAction.repeatForever(SKAction.animate(with: duckArray, timePerFrame: 0.2)))
            break
        case "3"?:
            for i in 1...4 {
                let name = "duckKnight_\(i).png"
                duckArray.append(SKTexture(imageNamed: name))
            }
            duck?.run(SKAction.repeatForever(SKAction.animate(with: duckArray, timePerFrame: 0.2)))
            break
        default:
            for i in 1...duckAtlas.textureNames.count {
                let name = "Duck_\(i).png"
                duckArray.append(SKTexture(imageNamed: name))
            }
            duck?.run(SKAction.repeatForever(SKAction.animate(with: duckArray, timePerFrame: 0.2)))
            break
        }
        
        self.retryButton.addTarget(self, action: #selector(retryGame), for: .touchUpInside)
        self.homeButton.addTarget(self, action: #selector(home), for: .touchUpInside)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        
        if nightMode == true {
            enemy = SKSpriteNode(imageNamed: "owl")
            enemy?.size = CGSize(width: (self.duck.size.width) / 3.3, height: self.duck.size.width / 3.3 * 0.8714)
            startFrame.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
            retryFrame.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
            background = SKSpriteNode(imageNamed: "buildingsAndSkyNight")
            safeBackground = SKSpriteNode(imageNamed: "safeBackgroundNight")
            nightSky = SKSpriteNode(imageNamed: "nightSky")
            
        } else {
            retryFrame.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            startFrame.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            enemy = childNode(withName: "enemy") as! SKSpriteNode!
            enemy?.run(SKAction.repeatForever(SKAction.animate(with: enemyArray, timePerFrame: 0.2)))
            background = SKSpriteNode(imageNamed: "buildingsAndSky")
            safeBackground = SKSpriteNode(imageNamed: "safeBackground")
        }
                
        view.addSubview(blackView)
        view.addSubview(startFrame)
        startFrame.addSubview(tapPlay)
        view.addSubview(retryFrame)
        retryFrame.addSubview(homeButton)
        retryFrame.addSubview(chartsButton)
        retryFrame.addSubview(retryButton)
        retryFrame.addSubview(endScore)
        retryFrame.addSubview(endHighScore)
        
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
        view.addGestureRecognizer(tap)
        
        
        initialBlackView.run(fadeOut) {
            self.initialBlackView.isHidden = true
        }
        
     
        
        
        
        
        createSideWalk()
        createForeground()
        createBackground()
        setupConstraints()
        setupBitMasks()
    }
    
    
  
                
       
    
    func setupBitMasks() {
        
        poop?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: poop.frame.size.width - (poop.frame.size.width / 1.5), height: poop.frame.size.height - (poop.frame.size.height / 2)))
        poop?.physicsBody?.isDynamic = true
        poop?.physicsBody?.restitution = 0
        poop?.physicsBody?.friction = 0
        poop?.physicsBody?.allowsRotation = false
        poop?.physicsBody?.angularDamping = 0
        poop?.physicsBody?.affectedByGravity = false
        poop?.anchorPoint = CGPoint(x: 0.5, y: 0.2)
        
        
        poopSpawn.physicsBody?.collisionBitMask = 0
        
        
        duck.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: duck.size.width - 18, height: duck.size.height - 25))
        duck.physicsBody?.isDynamic = false
        duck.physicsBody?.categoryBitMask = CollisionTypes.duck
        duck.physicsBody?.pinned = false
        duck.physicsBody?.allowsRotation = false
        duck.physicsBody?.collisionBitMask = 0
        
        enemy?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (enemy?.frame.width)! - 3, height: (enemy?.frame.height)! - (enemy?.frame.height)! / 4))
        enemy?.physicsBody?.isDynamic = true
        enemy?.physicsBody?.allowsRotation = false
        enemy?.physicsBody?.affectedByGravity = false
        enemy?.physicsBody?.contactTestBitMask = CollisionTypes.duck
        enemy?.physicsBody?.collisionBitMask = 0
        enemy?.physicsBody?.categoryBitMask = CollisionTypes.enemy
        enemy?.physicsBody?.pinned = false
        
        bread?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bread.frame.width, height: bread.frame.height))
        bread?.physicsBody?.isDynamic = true
        bread?.physicsBody?.allowsRotation = false
        bread?.physicsBody?.affectedByGravity = false
        bread?.physicsBody?.contactTestBitMask = CollisionTypes.duck
        bread?.physicsBody?.collisionBitMask = 0
        bread?.physicsBody?.categoryBitMask = CollisionTypes.bread
        bread?.physicsBody?.pinned = false
        
        deadEnemy?.physicsBody = SKPhysicsBody(rectangleOf: (deadEnemy?.size)!)
        deadEnemy?.physicsBody?.isDynamic = true
        deadEnemy?.physicsBody?.allowsRotation = false
        deadEnemy?.physicsBody?.affectedByGravity = true
        deadEnemy?.physicsBody?.collisionBitMask = 0
        deadEnemy?.physicsBody?.contactTestBitMask = CollisionTypes.sideWalk
        deadEnemy?.physicsBody?.categoryBitMask = CollisionTypes.deadEnemy
        deadEnemy?.physicsBody?.pinned = false
        
        endPoint?.physicsBody = SKPhysicsBody(rectangleOf: endPoint.frame.size)
        endPoint?.physicsBody?.contactTestBitMask = CollisionTypes.person
        endPoint?.physicsBody?.collisionBitMask = CollisionTypes.person
        endPoint?.physicsBody?.isDynamic = true
        endPoint?.physicsBody?.pinned = true
        endPoint?.physicsBody?.affectedByGravity = false
        endPoint?.physicsBody?.categoryBitMask = CollisionTypes.endPoint
        
        poop?.physicsBody?.linearDamping = 0
        poop?.physicsBody?.collisionBitMask = CollisionTypes.person | CollisionTypes.sideWalk
        poop?.physicsBody?.contactTestBitMask = CollisionTypes.person | CollisionTypes.sideWalk
        poop?.physicsBody?.categoryBitMask = CollisionTypes.poop
        poop?.physicsBody?.collisionBitMask = 0
        
        asianGuy?.physicsBody?.contactTestBitMask = CollisionTypes.poop | CollisionTypes.endPoint
        asianGuy.physicsBody?.categoryBitMask = CollisionTypes.person
        asianGuy?.physicsBody?.collisionBitMask = 0
        
        blackGuy?.physicsBody?.contactTestBitMask = CollisionTypes.poop | CollisionTypes.endPoint
        blackGuy?.physicsBody?.categoryBitMask = CollisionTypes.person
        blackGuy?.physicsBody?.collisionBitMask = 0
        
        littleGirl?.physicsBody?.contactTestBitMask = CollisionTypes.poop | CollisionTypes.endPoint
        littleGirl?.physicsBody?.categoryBitMask = CollisionTypes.person
        littleGirl?.physicsBody?.collisionBitMask = 0
        
        wizard?.physicsBody?.contactTestBitMask = CollisionTypes.poop | CollisionTypes.endPoint
        wizard?.physicsBody?.categoryBitMask = CollisionTypes.person
        wizard?.physicsBody?.collisionBitMask = 0
        
        hillary?.physicsBody?.contactTestBitMask = CollisionTypes.poop | CollisionTypes.endPoint
        hillary?.physicsBody?.categoryBitMask = CollisionTypes.person
        hillary?.physicsBody?.collisionBitMask = 0
        
        donald?.physicsBody?.contactTestBitMask = CollisionTypes.poop | CollisionTypes.endPoint
        donald?.physicsBody?.categoryBitMask = CollisionTypes.person
        donald?.physicsBody?.collisionBitMask = 0
        
        enumerateChildNodes(withName: "sideWalk") { (node, _) in
            node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.sideWalk.frame.size.width, height: self.sideWalk.frame.size.height))
            node.physicsBody?.contactTestBitMask = CollisionTypes.poop | CollisionTypes.deadEnemy
            node.physicsBody?.categoryBitMask = CollisionTypes.sideWalk
            node.physicsBody?.collisionBitMask = CollisionTypes.deadEnemy
            node.physicsBody?.isDynamic = false
            node.physicsBody?.pinned = true
            node.physicsBody?.restitution = 0
            node.zPosition = 10
            node.physicsBody?.friction = 0
            node.physicsBody?.allowsRotation = false
            node.physicsBody?.angularDamping = 0
            node.physicsBody?.affectedByGravity = false
        }
    }
    
    
    func setupConstraints() {
        poop?.alpha = 0
        poop?.position = poopSpawn.position
        
        let retryWidth = (view?.frame.width)! / 1.8
        let retryHeight = (view?.frame.height)! / 3.5
        
        let startWidth = (view?.frame.width)! / 1.2
        let startHeight = (view?.frame.width)! / 3
        
        blackView.frame = (view?.frame)!
        
        startFrame.widthAnchor.constraint(equalToConstant: startWidth).isActive = true
        startFrame.heightAnchor.constraint(equalToConstant: startHeight).isActive = true
        startFrame.centerXAnchor.constraint(equalTo: (view?.centerXAnchor)!).isActive = true
        startFrame.centerYAnchor.constraint(equalTo: (view?.centerYAnchor)!, constant: 0).isActive = true
    
        tapPlay.centerXAnchor.constraint(equalTo: startFrame.centerXAnchor).isActive = true
        tapPlay.centerYAnchor.constraint(equalTo: startFrame.centerYAnchor).isActive = true
        tapPlay.widthAnchor.constraint(equalToConstant: startWidth * 0.9).isActive = true
        tapPlay.heightAnchor.constraint(equalToConstant: startHeight * 0.9).isActive = true
        
        //tapPlay.frame = CGRect(x: 0, y: startFrame.center.y, width: (view?.frame.width)! / 1.2 - 20, height: ((view?.frame.width)! / 1.2 - 20) / 2)
        
        retryFrame.widthAnchor.constraint(equalToConstant: retryWidth).isActive = true
        retryFrame.heightAnchor.constraint(equalToConstant: retryHeight).isActive = true
        retryFrame.centerXAnchor.constraint(equalTo: (view?.centerXAnchor)!).isActive = true
        retryFrame.centerYAnchor.constraint(equalTo: (view?.centerYAnchor)!, constant: 0).isActive = true
        
        chartsButton.centerXAnchor.constraint(equalTo: retryFrame.centerXAnchor, constant: retryWidth / -3.5).isActive = true
        chartsButton.widthAnchor.constraint(equalToConstant: retryWidth / 2.5).isActive = true
        chartsButton.heightAnchor.constraint(equalToConstant: retryWidth / 2.5).isActive = true
        chartsButton.bottomAnchor.constraint(equalTo: retryButton.bottomAnchor as NSLayoutAnchor<NSLayoutYAxisAnchor>).isActive = true
        
        retryButton.centerXAnchor.constraint(equalTo: retryFrame.centerXAnchor, constant: retryWidth / 3.5).isActive = true
        retryButton.centerYAnchor.constraint(equalTo: retryFrame.centerYAnchor).isActive = true
        retryButton.widthAnchor.constraint(equalToConstant: retryWidth / 2.5).isActive = true
        retryButton.heightAnchor.constraint(equalToConstant: retryWidth / 2.5).isActive = true
        
        homeButton.centerXAnchor.constraint(equalTo: retryFrame.centerXAnchor, constant: 0).isActive = true
        homeButton.centerYAnchor.constraint(equalTo: retryFrame.centerYAnchor, constant: retryHeight / -4).isActive = true
        homeButton.widthAnchor.constraint(equalToConstant: retryWidth / 2.5).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: retryHeight / 2.5).isActive = true
        
        endScore.centerXAnchor.constraint(equalTo: retryFrame.centerXAnchor, constant: 0).isActive = true
        endScore.topAnchor.constraint(equalTo: chartsButton.bottomAnchor, constant: -5).isActive = true
        endScore.widthAnchor.constraint(equalToConstant: retryWidth - retryWidth/5).isActive = true
        
        endHighScore.centerXAnchor.constraint(equalTo: retryFrame.centerXAnchor, constant: 0).isActive = true
        endHighScore.bottomAnchor.constraint(equalTo: retryFrame.bottomAnchor, constant: -5).isActive = true
        endHighScore.widthAnchor.constraint(equalToConstant: retryWidth - retryWidth/5).isActive = true
   
        
    }
    
   
    
    func setupStart(){
        
        self.isPaused = false
        
        
        if firstGame != true {
            if sound != false {
                if violinSound.volume < 0 {
                    violinSound.fadeOut()
                }
            }
        }
        
        
        let distance = CGFloat(self.frame.width + self.asianGuy.frame.width * 3)

        spawnAB = true
        tenOrHun = true
        level = 3.0
        gameTime = 0
        ammo = 1
        ammoLim = 1
        hitCountA = 0
        hitCountB = 0
        
        self.enumerateChildNodes(withName: "wizard") { (node, _) in
            node.removeFromParent()
        }
        self.enumerateChildNodes(withName: "littleGirl") { (node, _) in
            node.removeFromParent()
        }
        self.enumerateChildNodes(withName: "asianGuy") { (node, _) in
            node.removeFromParent()
        }
        self.enumerateChildNodes(withName: "blackGuy") { (node, _) in
            node.removeFromParent()
        }
        self.enumerateChildNodes(withName: "enemy") { (node, _) in
            node.removeFromParent()
        }
        self.enumerateChildNodes(withName: "hillary") { (node, _) in
            node.removeFromParent()
        }
        self.enumerateChildNodes(withName: "donald") { (node, _) in
            node.removeFromParent()
        }
        
        
        let moveBUp = SKAction.moveTo(y: self.upPosition.frame.midY, duration: 2.0)
        let moveBDown = SKAction.moveTo(y: self.downPosition.frame.midY, duration: 2.0)
        let breadUDsequence = SKAction.sequence([moveBUp, moveBDown])
        self.moveBUDForever = SKAction.repeatForever(breadUDsequence)
        
        
        let moveBread = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.0051 * distance))
        let removeBread = SKAction.removeFromParent()
        self.moveAndRemoveBread = SKAction.sequence([moveBread, removeBread])
        
        if let x = bread {
            node = x.copy() as! SKSpriteNode
            node.run(moveAndRemoveBread)
            node.run(moveBUDForever)
            node?.name = "bread"
            self.addChild(node)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.75) {
            
            self.spawnTimer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
            self.spawnBreadTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startBreadTimer), userInfo: nil, repeats: true)
           
            
            // personAction
            
            let spawn = SKAction.run {
                self.spawnPeople()
            }
            
            let delay = SKAction.wait(forDuration: 3.0)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever, withKey: "spawnDelay") //Action 2
            
            let movePeople = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.0051 * distance))
            let removePeople = SKAction.removeFromParent()
            self.moveAndRemove = SKAction.sequence([movePeople, removePeople])
            
            
            // heartAction
            
            let moveHeart = SKAction.moveBy(x: 0, y: 50, duration: 1.5)
            let fadeHeart = SKAction.fadeOut(withDuration: 1.5)
            let removeHeart = SKAction.removeFromParent()
            
            let group = SKAction.group([moveHeart, fadeHeart])
            
            
            self.moveAndRemoveHeart = SKAction.sequence([group, removeHeart])
            
            // pointAction
            
            let movePoint = SKAction.moveBy(x: 0, y: 50, duration: 1.5)
            let fadePoint = SKAction.fadeOut(withDuration: 1.5)
            let removePoint = SKAction.removeFromParent()
            
            let groupPoint = SKAction.group([movePoint, fadePoint])
            
            self.moveAndRemovePoint = SKAction.sequence([groupPoint, removePoint])
            
            
            //breadAction
            let moveBUp = SKAction.moveTo(y: self.upPosition.frame.midY, duration: 2.0)
            let moveBDown = SKAction.moveTo(y: self.downPosition.frame.midY, duration: 2.0)
            let moveBUD = SKAction.sequence([moveBUp, moveBDown])
            let moveBDU = SKAction.sequence([moveBDown, moveBUp])
            self.moveBDUForever = SKAction.repeatForever(moveBDU)
            self.moveBUDForever = SKAction.repeatForever(moveBUD)
            
            let moveBread = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.0051 * distance))
            let removeBread = SKAction.removeFromParent()
            self.moveAndRemoveBread = SKAction.sequence([moveBread, removeBread])
        }
    }
    
    func startTimer(){
        timeInterval = round(1000.0 * timeInterval) / 1000.0
        gameTime += timeInterval
        enemySpawnLoop()
    }
    
    func startBreadTimer(){
        breadTimer += 1
        spawnBread()
    }
    
    func enemySpawnLoop() {
        // Rounding the variables at the 10th place
        if tenOrHun == true {
            gameTime = round(1000.0 * gameTime) / 1000.0 // rounds gameTime to the nearest 100th place
            level = round(100.0 * level) / 100.0
            tenOrHun = false
        } else {
            gameTime = round(100.0 * gameTime) / 100.0 // rounds gameTime to the nearest 10th place
            level = round(1000.0 * level) / 1000.0
            tenOrHun = true
        }
        
        // enemyAction
        let distance = CGFloat(self.frame.width + self.asianGuy.frame.width * 3)
        
        
        let moveEnemyBlock = SKAction.run {
            var moveEnemy : SKAction
            moveEnemy = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.0030 * distance))
            print(self.level)
            switch self.level {
            
            case 2.4:
                print("case 1")
                moveEnemy = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.00295 * distance))
            case 2.25:
                print("case 2")

                moveEnemy = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.0029 * distance))
            case 2.1:
                print("case 3")

                moveEnemy = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.00285 * distance))
            case 1.95:
                print("case 4")

                moveEnemy = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.0028 * distance))
            case 1.8:
                print("case 5")

                moveEnemy = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.00275 * distance))
            case 1.65:
                print("case 6")

                moveEnemy = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.0027 * distance))
            case 1.5:
                print("case 7")

                moveEnemy = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.00265 * distance))
            case 1.35:
                print("case 8")

                moveEnemy = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.00255 * distance))
            case 1.2:
                print("case 9")

                moveEnemy = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.00248 * distance))
            case 1.05:
                print("case 10")
                moveEnemy = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.00236 * distance))

            default:
                print("case default")
                break
            }
            
            let removeEnemy = SKAction.removeFromParent()
            self.moveAndRemoveEnemy = SKAction.sequence([moveEnemy, removeEnemy])
        }
        if gameTime == level {
            
            gameTime = 0
          
            if level != 1.05 {
                level? -= 0.15
            }
        
            
            self.run(moveEnemyBlock) {
                self.spawnEnemy()
            }
        }
     
        
        return
    }

    
    func spawnBread() {
        if breadTimer.truncatingRemainder(dividingBy: 10) == 0 {
            breadTimer = 0
            if randomSpawn == nil || randomSpawn != nil {
                randomSpawn = randomNum(range: 0 ... 1)
                
                switch randomSpawn {
                case 1:
                    if let x = bread {
                        node = x.copy() as! SKSpriteNode
                        node.position.y = downPosition.position.y
                        node.run(moveAndRemoveBread)
                        node.run(moveBUDForever)
                        node?.name = "bread"
                        self.addChild(node)
                    }
                    break
                default:
                    if let x = bread {
                        node = x.copy() as! SKSpriteNode
                        node.position.y = upPosition.position.y
                        node.run(moveAndRemoveBread)
                        node.run(moveBDUForever)
                        node?.name = "bread"
                        self.addChild(node)
                        break
                    }
                }
            }
        }
    }
    
    
    func tapAction(){
        
        if firsTap == true {
            firsTap = false
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.startFrame.alpha = 0
            }, completion: { (true) in
                self.startFrame.isHidden = true
            })
            setupStart()
        }
        
        ammo? -= 1
        ammoLabel?.text = "\(ammo!)"
        if let x = poop {
            x.position = poopSpawn.position
            spawnPoop = (x.copy() as! SKSpriteNode)
            spawnPoop?.physicsBody?.affectedByGravity = false
            spawnPoop?.name = "poop"
            self.addChild(spawnPoop!)
            spawnPoop?.run(SKAction.fadeIn(withDuration: 0.1))
            poopAction()
        }
        checkAmmo()
    }
    
    func checkAmmo(){
        if ammo! == 0 {
            view?.removeGestureRecognizer(tap)
            tapGesture = false
        }
        if ammo! < ammoLim! {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                if self.tapGesture == false {
                    self.view?.addGestureRecognizer(self.tap)
                    self.tapGesture = true
                }
                self.ammo? += 1
                self.ammoLabel?.text = "\(self.ammo!)"
            })
        }
    }
    
    func poopAction(){
        
        //let fall = SKAction.moveTo(y: bottomPos, duration: 3)
        if let x = spawnPoop {
            //spawnPoop?.run(SKAction.animate(with: poopArray, timePerFrame: 0.2))
            x.physicsBody?.applyImpulse(CGVector(dx: -5, dy: -35))
            x.zRotation = CGFloat((-Double.pi / 4) / 4)
            x.run(SKAction.animate(with: poopArray, timePerFrame: 0.2))
        }
        if sound != false {
        playPoopSound(sound: poopSound)
        }
    }
    
    
    
    func spawnEnemy(){
        if randomSpawn == nil || randomSpawn != nil {
            randomSpawn = randomNum(range: 1 ... 3)
            
            switch randomSpawn {
            case 1:
                if let x = enemy {
                    node = x.copy() as! SKSpriteNode
                    node.run(moveAndRemoveEnemy)
                    node?.position = upPosition.position
                    node?.name = "enemy"
                    self.addChild(node)
                }
                break
            default:
                if let x = enemy {
                    node = x.copy() as! SKSpriteNode
                    node.run(moveAndRemoveEnemy)
                    node?.position = downPosition.position
                    node?.name = "enemy"
                    self.addChild(node)
                }
                break
            }
        }
    }
    
    func resetHitCount() {
        if spawnAB == true {
            hitCountA = 0
            spawnAB = false
        } else {
            hitCountB = 0
            spawnAB = true
        }
    }
    
    func spawnPeople(){
        if randomSpawn == nil || randomSpawn != nil {
            randomSpawn = randomNum(range: 1 ... 6)
            poopHit.insert(false, at: spawnNum!)
            spawnNum? += 1
            
            switch randomSpawn {
            case 1:
                if let x = littleGirl {
                    node = (x.copy() as! SKSpriteNode)
                    node.run(moveAndRemove, withKey: "movePeople")
                    self.addChild(node!)
                    node.name = "littleGirl"
                }
                break
            case 2:
                if let x = asianGuy {
                    node = (x.copy() as! SKSpriteNode)
                    node.run(moveAndRemove, withKey: "movePeople")
                    node.name = "asianGuy"
                    self.addChild(node!)
                }
                break
            case 3:
                if let x = blackGuy {
                    node = (x.copy() as! SKSpriteNode)
                    node.run(moveAndRemove, withKey: "movePeople")
                    node.name = "blackGuy"
                    self.addChild(node!)
                }
                break
            case 4:
                if let x = wizard {
                    node = (x.copy() as! SKSpriteNode)
                    node.run(moveAndRemove, withKey: "movePeople")
                    node.name = "wizard"
                    self.addChild(node!)
                }
                break
            case 5:
                if let x = donald {
                    node = (x.copy() as! SKSpriteNode)
                    node.run(moveAndRemove, withKey: "movePeople")
                    node.name = "donald"
                    self.addChild(node!)
                }
                break
            default:
                if let x = hillary {
                    node = (x.copy() as! SKSpriteNode)
                    node.run(moveAndRemove, withKey: "movePeople")
                    node.name = "hillary"
                    self.addChild(node!)
                }
                break
            }
        }
    }
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact){
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        var a: SKSpriteNode? = nil
        var b: SKSpriteNode? = nil
        var x : Int
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if firstBody.categoryBitMask == CollisionTypes.poop && secondBody.categoryBitMask == CollisionTypes.person {
            a = firstBody.node as! SKSpriteNode?
            b = secondBody.node as! SKSpriteNode?
            var position : CGPoint
            a?.physicsBody?.categoryBitMask = 0
            
            if spawnAB == true {
                if hitCountA != 7 && hitCountA <= 6 {
                    hitCountA += 1
                }
                x = hitCountA
            } else {
                if hitCountB != 7 && hitCountB <= 6 {
                    hitCountB += 1
                }
                x = hitCountB
            }
            
            if b?.name == "asianGuy" {
                b?.texture = SKTexture(imageNamed: "aPoop_\(x)")
                position = (b?.position)!
                plusPoint(n: "asianGuy", p: position)
                if sound != false {
                    playAGSound(sound: aGCry)
                }
            } else if b?.name == "blackGuy" {
                b?.texture = SKTexture(imageNamed: "bPoop_\(x)")
                position = (b?.position)!
                plusPoint(n: "blackGuy", p: position)
                if sound != false {
                    playBGSound(sound: bgCry)
                }
            } else if b?.name == "littleGirl" {
                b?.texture = SKTexture(imageNamed: "lPoop_\(x)")
                position = (b?.position)!
                plusPoint(n: "littleGirl", p: position)
                if sound != false {
                    playLGSound(sound: lGCry)
                }
            } else if b?.name == "wizard" {
                b?.texture = SKTexture(imageNamed: "wizardHit_\(x)")
                position = (b?.position)!
                plusPoint(n: "wizard", p: position)
                if sound != false {
                    playWizSound(sound: wizCry)
                }
            } else if b?.name == "hillary" {
                b?.texture = SKTexture(imageNamed: "politicianHit_\(x)")
                position = (b?.position)!
                plusPoint(n: "hillary", p: position)
                if sound != false {
                    playHilSound(sound: hilCry)
                }
            } else if b?.name == "donald" {
                b?.texture = SKTexture(imageNamed: "politicianOne_\(x)")
                position = (b?.position)!
                plusPoint(n: "donald", p: position)
                if sound != false {
                    playdtSound(sound: dtCry)
                }
            }
            
            poopHit[spawnNum! - 1] = true
            
            //a?.physicsBody?.velocity = CGVector(dx: -215, dy: 0)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
                a?.run(SKAction.fadeOut(withDuration: 0.1), completion: {
                    a?.removeFromParent()
                })
            })
            
            
        } else if firstBody.categoryBitMask == CollisionTypes.person && secondBody.categoryBitMask == CollisionTypes.endPoint {
            resetHitCount()
            
            
        } else if firstBody.categoryBitMask == CollisionTypes.poop && secondBody.categoryBitMask == CollisionTypes.sideWalk {
            a = firstBody.node as! SKSpriteNode?
            
            a?.physicsBody?.velocity = CGVector(dx: -215, dy: 0)
            a?.run(SKAction.animate(with: splatArray, timePerFrame: 0.2), completion: { })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                let fadePoo = SKAction.fadeOut(withDuration: 0.2)
                a?.run(fadePoo, completion: {
                    a?.removeFromParent()
                })
            })
        } else if firstBody.categoryBitMask == CollisionTypes.duck && secondBody.categoryBitMask == CollisionTypes.enemy {
            b = secondBody.node as! SKSpriteNode?
            if sound != false {
                playDuckSound(sound: quackSound)
            }
            lives -= 1
            checkLives()
            var position: CGPoint
            
            if let x = deadEnemy {
                position = (b?.position)!

                if nightMode != true {
                x.zPosition = 5
                deadEnemySpawn = x.copy() as? SKSpriteNode
                deadEnemySpawn?.position = (b?.position)!
                deadEnemySpawn?.name = "deadEnemy"
                deadEnemySpawn?.zPosition = 5
                self.addChild(deadEnemySpawn!)
                birdDeath()
                b?.removeFromParent()
                }
            minusHeartAnim(l: "Bird", p: position)
            }
        } else if firstBody.categoryBitMask == CollisionTypes.sideWalk && secondBody.categoryBitMask == CollisionTypes.deadEnemy {
            b = secondBody.node as! SKSpriteNode?
            b?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            b?.run(fadeOut, completion: {
                b?.removeFromParent()
            })
            
            //thud sound of bird
        } else if firstBody.categoryBitMask == CollisionTypes.duck && secondBody.categoryBitMask == CollisionTypes.bread {
            b = secondBody.node as! SKSpriteNode?
            b?.run(SKAction.fadeOut(withDuration: 0.2), completion: {
                b?.removeFromParent()
            })
            ammoLim? += 1
            ammo? += 1
            ammoLabel?.text = "\(ammo!)"
            ammoLabel?.fontColor = .green
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.ammoLabel?.fontColor = .white
            })
        }
    }
    
    func minusHeartAnim(l: String, p: CGPoint?){
        var newP : CGPoint
        switch l {
        default: //bird
            if let x = minusHeart {
                node = x.copy() as! SKSpriteNode
                if let p = p {
                    newP = p
                    newP.x += 75
                    node.position = newP
                }
                node.run(moveAndRemoveHeart, withKey: "minusHeart")
                self.addChild(node!)
                node.name = "minusHeart"
            }
            break
        }
    }
    
    func home() {
        if sound != false {
            playDropletSound()
            violinSound.fadeOut()
        }
        UserDefaults.standard.set(true, forKey: "dismiss")
        blackView.layer.zPosition = 100
        UIView.animate(withDuration: 0.7, delay: 0.1, options: .curveEaseIn, animations: {
            self.blackView.alpha = 1.0
        }) { (true) in
            if self.sound != false {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playBGMusic"), object: nil)
            }
            //self.removeAllChildren()
            //self.removeFromParent()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "restartGame"), object: nil)
        }
    }
    
    
    func plusPoint(n: String, p: CGPoint?){
        var newP : CGPoint
        if let x = point {
            node = x.copy() as! SKSpriteNode
            if let p = p {
                newP = p
                newP.x += 75
                node.position = newP
            }
            node.run(moveAndRemovePoint, withKey: "plusPoint")
            self.addChild(node!)
            node.name = "PlusPoint"
        }
        score += 1
        UserDefaults.standard.set(snails! + score, forKey: "snail")
        UserDefaults.standard.synchronize()
    }
    
    func birdDeath(){
        if let x = deadEnemySpawn {
            x.alpha = 1.0
            x.zPosition = 5
            x.physicsBody?.applyImpulse(CGVector(dx: -30, dy: -3))
            // x.zRotation = CGFloat((-M_PI_4) / 4)
            x.zRotation = CGFloat(Double.pi / 4)
        }
    }
    
    
    
    func checkLives(){
        switch lives {
        case 2:
            heartThree.isHidden = true
            break
        case 1:
            heartTwo.isHidden = true
            break
        case 0:
            heartOne.isHidden = true
            gameOver()
            break
        default:
            break
        }
        
    }
    
    func createSideWalk(){
        for i in 0...2 {
            sideWalk = SKSpriteNode(imageNamed: "sideWalk_1")
            sideWalk.name = "sideWalk"
            sideWalk.zPosition = 10
            sideWalk.size = CGSize(width: (self.scene?.size.width)!, height: self.frame.size.height / 12)
            sideWalk.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sideWalk.position = CGPoint(x: CGFloat(i) * sideWalk.size.width, y: -(self.frame.size.height / 2))
            
            self.addChild(sideWalk)
        }
    }
    
    func createForeground(){
        for i in 0...2 {
            let foreGround : SKSpriteNode
            if nightMode == true {
                foreGround = SKSpriteNode(imageNamed: "hillsAndTreesNight")
            } else {
                foreGround = SKSpriteNode(imageNamed: "hillsAndTrees")
            }
            if i == 0 || i == 2 {
                foreGround.zPosition = -8
                foreGround.name = "foreGround"
                foreGround.size = CGSize(width: (self.scene?.size.width)!, height: (self.frame.size.height / 2) - (self.frame.size.height * 0.06287))
                foreGround.anchorPoint = CGPoint(x: 0.5, y: 0.55)
                foreGround.position = CGPoint(x:  CGFloat(i) * foreGround.size.width, y: (self.frame.size.height * -0.25))
            } else if i == 1 {
                foreGround.zPosition = -8
                foreGround.name = "foreGround"
                foreGround.size = CGSize(width: (self.scene?.size.width)!, height: (self.frame.size.height / 2) - (self.frame.size.height * 0.06287))
                foreGround.anchorPoint = CGPoint(x: 0.5, y: 0.55)
                foreGround.position = CGPoint(x:  CGFloat(i) * foreGround.size.width, y: (self.frame.size.height * -0.25))
                foreGround.xScale = -1.0
            }
            
            
            self.addChild(foreGround)
        }
    }
    func createBackground(){
        if nightMode == true {
            nightSky?.zPosition = -11
            nightSky?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            nightSky?.position = CGPoint(x: 0, y: 0)
            nightSky?.size = CGSize(width: initialBlackView.frame.size.width, height: initialBlackView.frame.size.height)
            self.addChild(nightSky!)
        }
    
        background.zPosition = -10
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: initialBlackView.frame.size.width, height: initialBlackView.frame.size.height)
        
        safeBackground.zPosition = -9
        safeBackground.size = CGSize(width: (self.scene?.size.width)!, height: (self.frame.size.height * 0.22))
        safeBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        safeBackground.position = CGPoint(x: 0, y: (self.frame.size.height * -0.31))

        self.addChild(background)
        self.addChild(safeBackground)

    }
    
    
    func moveSideWalk(){
        enumerateChildNodes(withName: "sideWalk") { (node, _) in
            node.position.x -= 3.3
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 2
            }
        }
    }
    
    func moveForeGround(){
        enumerateChildNodes(withName: "foreGround") { (node, _) in
            node.position.x -= 0.3
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 2
            }
        }
    }
    
    func playPoopSound(sound : SKAction){
        self.run(poopSound)
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
    
    func playDuckSound(sound : SKAction){
        if lives > 0 {
            self.run(quackSound)
        }
    }
    
    func playdtSound(sound : SKAction){
        if hitCountA == 1 || hitCountB == 1 {
            self.run(dtCry)
        }
    }
    
    func playAGSound(sound : SKAction){
        if hitCountA == 1 || hitCountB == 1 {
            self.run(bgCry)
        }
    }
    
    func playBGSound(sound : SKAction){
        if hitCountA == 1 || hitCountB == 1 {
            self.run(aGCry)
        }
    }
    
    func playWizSound(sound : SKAction){
        if hitCountA == 1 || hitCountB == 1 {
            self.run(wizCry)
        }
    }
    
    func playHilSound(sound : SKAction){
        if hitCountA == 1 || hitCountB == 1 {
            self.run(hilCry)
        }
    }
    
    func playLGSound(sound : SKAction){
        if hitCountA == 1 || hitCountB == 1 {
            self.run(lGCry)
        }
    }
    
    
    func playSadViolin(){
        let bgMusicURL: URL = Bundle.main.url(forResource: "SadViolin", withExtension: "mp3")! as URL
        
        do {
            violinSound = try AVAudioPlayer(contentsOf: bgMusicURL as URL)
        } catch {
            print("Could not play music")
        }
        
        violinSound.volume = 0
        violinSound.prepareToPlay()
        violinSound.play()
        violinSound.fadeIn()
    }
    
    
    
    func retryGame(){
        view?.addGestureRecognizer(tap)
        view?.addGestureRecognizer(swipeUp)
        view?.addGestureRecognizer(swipeDown)
        
        if sound != false {
            playDropletSound()
            violinSound.fadeOut()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playBGMusic"), object: nil)
        }
    
        
        
        spawnTimer?.invalidate()
        
        lives = 3
        score = 0
        enemyCount = 0.0
        endScore.text = "Score: "
        
        heartOne.isHidden = false
        heartTwo.isHidden = false
        heartThree.isHidden = false
        
        removeAction(forKey: "movePeople")
        removeAction(forKey: "enemySpawnDelay")
        removeAction(forKey: "spawnDelay")
        
        enumerateChildNodes(withName: "enemy") { (node, _) in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "asianGuy") { (node, _) in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "blackGuy") { (node, _) in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "littleGirl") { (node, _) in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "deadEnemy") { (node, _) in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "wizard") { (node, _) in
            node.removeFromParent()
        }
        
        UIView.animate(withDuration: 0.7, delay: 0.1, options: .curveEaseIn, animations: {
            //self.retryFrame.center.y += (self.retryFrame.frame.height / 2 + (self.view?.frame.height)! / 2)
            self.blackView.alpha = 0
            self.retryFrame.alpha = 0
        }) { (true) in
            self.blackView.isHidden = true
            self.retryFrame.isHidden = true
        }
        setupStart()
    }
    
    func gameOver(){
        
        if self.adBool == true {
            self.displayAd()
            self.adBool = false
        } else { self.adBool = true }
        
        
        spawnBreadTimer?.invalidate()
        
        view?.removeGestureRecognizer(swipeUp)
        view?.removeGestureRecognizer(swipeDown)
        view?.removeGestureRecognizer(tap)
        blackView.removeGestureRecognizer(tap)
        
        removeAction(forKey: "scoreAction")
        
        if score > UserDefaults.standard.integer(forKey: "HighScore") {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
        firstGame = false
        
        endHighScore.text = "HighScore: \(UserDefaults.standard.integer(forKey: "HighScore"))"
        endScore.text = "Score: \(score)"
        
        Score().saveHighScore(score: score)
        
        retryFrame.alpha = 0
        blackView.alpha = 0
        
        if sound != false {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fadeBGMusic"), object: nil)
            playSadViolin()
        }
        
        if retryFrame.isHidden {
            retryFrame.isHidden = false
            blackView.isHidden = false
            
            UIView.animate(withDuration: 0.7, delay: 0.1, options: .curveEaseIn, animations: {
                self.blackView.alpha = 0.5
                self.retryFrame.alpha = 1
                self.retryFrame.center.y = (self.view?.frame.minY)! - self.retryFrame.frame.height / 2 - 50
                
            }, completion: { (true) in
                
            })
        }
    }
    
    
    func displayAd() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.sound != false {
                self.violinSound.fadeOut()
                
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadAndShow"), object: nil)
        }
    }
    
    func showLeaderBoard(){
        playDropletSound()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showLeaderBoard"), object: nil)
    }
    
    
    

    
    func swipe(sender: UISwipeGestureRecognizer){
        if sender.direction == .down {
            if duck.position.y != downPosition.position.y {
                poopSpawn.run(SKAction.moveTo(y: downPosition.position.y, duration: 0.5))
                duck.run(SKAction.moveTo(y: downPosition.position.y, duration: 0.5), completion: { })
            }
        } else if sender.direction == .up {
            if duck.position.y != upPosition.position.y {
                poopSpawn.run(SKAction.moveTo(y: upPosition.position.y, duration: 0.5))
                duck.run(SKAction.moveTo(y: upPosition.position.y, duration: 0.5), completion: {
                })
            }
        }
    }
    
    func randomNum(range: ClosedRange<Int> = 1...3) -> Int {
        let min = range.lowerBound
        let max = range.upperBound
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
    
    
    func enteredBackground(notification : NSNotification) {
        print("didEnterBackground")
        spawnBreadTimer?.invalidate()
        spawnTimer?.invalidate()
    
    }
    func enteredGame(notification : NSNotification) {
       print("didEnterGame")
        self.spawnTimer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
        if lives > 0 {
            self.spawnBreadTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startBreadTimer), userInfo: nil, repeats: true)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        scoreLabel.text = "\(score)"
        
        moveSideWalk()
        moveForeGround()
    }
}




