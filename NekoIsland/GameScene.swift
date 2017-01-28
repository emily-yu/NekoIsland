
//  GameScene.swift
//  NekoIsland
//
//  Created by VC on 7/15/16.
//  Copyright (c) 2016 Makeschool. All rights reserved.
//

// Goals: in game currency, iap/iads (?)
//Improvements: make it so you can touch and hold to move, extend buttons throughout side using empty node sks file

import SpriteKit
import GameKit

enum GameSceneState {
    case Active, GameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate {
    
    var gameCenterAchievements = [String: GKAchievement]()
    /* Game management */
    var gameState: GameSceneState = .Active
    //var hugeText: MSButtonNode!
    var deathOverlay: SKReferenceNode!
    var GOHome: MSButtonNode!
    var GORestart: MSButtonNode!
    //var GOShop: MSButtonNode!
    var finalScore: SKLabelNode!
    //var achievementText: SKLabelNode!
    
    //Currency
    var coins = 0
    var coinsLabel: SKLabelNode!
    
    //Sprites
    var hero: SKSpriteNode!
    var warningSign: SKSpriteNode!
    
    //Buttons
    var buttonGC: MSButtonNode!
    var buttonRight: MSButtonNode!
    var buttonLeft: MSButtonNode!
    var buttonRestart: MSButtonNode!
    var buttonInfo: MSButtonNode!
    var iconHome: MSButtonNode!
    
    //Spawning Rocks
    var previousNumber: UInt32? //used in rock generation
    var rocks: SKSpriteNode!
    
    //Time Label
    var startCount = true
    var setTime = 0
    var myTime = 0
    var myTimeMinutes = 0
    var timeLabel: SKLabelNode!

    //var scoreLabel: SKLabelNode! //temp score label
    var highScoreLabel: SKLabelNode!
    
    //84-484
    func randomNumber() -> UInt32 {
        var randomNumber = arc4random_uniform(380) + 84
        while previousNumber == randomNumber {
            randomNumber = arc4random_uniform(380) + 84;
        }
        previousNumber = randomNumber
        return randomNumber
    }
    
    func formatTime (myTime: Int) {
        if self.myTime < 10 {
            self.timeLabel.text = ("0:0\(self.myTime)")
        }
        if self.myTime > 10 && self.myTime < 60 {
            self.timeLabel.text = ("0:\(self.myTime)")
        }

        else {
            if myTime > 60 {
                myTimeMinutes += 1
                if myTimeMinutes > 9 {
                    self.timeLabel.text = ("0\(self.myTimeMinutes):\(self.myTime)")
                }
                self.myTime = 0
                self.myTime += 1
                self.timeLabel.text = ("\(self.myTimeMinutes):\(self.myTime)")
            }
        }
    }
    
    func pauseGame(){
        self.view!.paused = true
        self.view!.scene!.paused = true
        gameState = .GameOver
    }
    
    
    func spawnRocks(){
        rocks.runAction(SKAction.moveTo(CGPointMake(CGFloat(randomNumber()), 400), duration: 0))
    }
    
    // Moves sign under where the rock will spawn
    func spawnSign(){
        var rockPosition = rocks.position.x
        warningSign.runAction(SKAction.moveTo(CGPointMake(rockPosition, 300), duration: 0))
    }
   

    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.pauseGame), name: "pauseGameScene", object: nil) // what if cyril is cheating
        
        
        authenticateLocalPlayer()
        
        // Rock Generation
        let timer2 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.spawnSign), userInfo: nil, repeats: true)
        let timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(GameScene.spawnRocks), userInfo: nil, repeats: true)
        

        // Game Over
        finalScore = childNodeWithName("finalScore") as! SKLabelNode
        finalScore.hidden = true
        GOHome = self.childNodeWithName("GOHome") as! MSButtonNode
        GOHome.state = .Hidden
        GOHome.selectedHandler = {
            let skView = self.view as SKView!
            let scene = IntroScene(fileNamed:"IntroScene") as IntroScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            if self.myTime > highScore {
                highScore = self.myTime
            }
        }
        GORestart = self.childNodeWithName("GORestart") as! MSButtonNode
        GORestart.state = .Hidden
        GORestart.selectedHandler = {
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            let savedHighScore = NSUserDefaults.standardUserDefaults().integerForKey("Saved High Score")
            if self.myTime > highScore {
                highScore = self.myTime
                if highScore < 10 {
                    self.highScoreLabel.text = ("Highscore: 0:0\(savedHighScore)")
                }
                else {
                    self.highScoreLabel.text = ("Highscore: 0:\(savedHighScore)")
                }
            }
        }
        
        deathOverlay = self.childNodeWithName("deathOverlay") as! SKReferenceNode
        deathOverlay.hidden = true
        
        /* Setup your scene here */
        coinsLabel = self.childNodeWithName("coinsLabel") as! SKLabelNode
        rocks = self.childNodeWithName("rocks") as! SKSpriteNode
        timeLabel = self.childNodeWithName("timeLabel") as! SKLabelNode
        hero = self.childNodeWithName("hero") as! SKSpriteNode
        warningSign = self.childNodeWithName("warningSign") as! SKSpriteNode
        highScoreLabel = self.childNodeWithName("highScoreLabel") as! SKLabelNode
        if highScore < 10 {
            self.highScoreLabel.text = ("Highscore: 0:0\(highScore)")
        }
        else {
            self.highScoreLabel.text = ("Highscore: 0:\(highScore)")
        }
    
        // Button Control
        // Controls
        buttonRight = self.childNodeWithName("buttonRight") as! MSButtonNode
        buttonRight.selectedHandler = {
            self.hero.runAction(SKAction.moveByX(60, y: 0, duration: 0.2))
        }
        buttonLeft = self.childNodeWithName("buttonLeft") as! MSButtonNode
        buttonLeft.selectedHandler = {
            self.hero.runAction(SKAction.moveByX(-60, y: 0, duration: 0.2))
        }
        // Restart
        buttonRestart = self.childNodeWithName("buttonRestart") as! MSButtonNode
        buttonRestart.selectedHandler = {
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            let savedHighScore = NSUserDefaults.standardUserDefaults().integerForKey("Saved High Score")

            if self.myTime > highScore {
                highScore = self.myTime
                if highScore < 10 {
                    self.highScoreLabel.text = ("Highscore: 0:0\(savedHighScore)")
                }
                else {
                    self.highScoreLabel.text = ("Highscore: 0:\(savedHighScore)")
                }
            }
            if self.myTime < 4 {
                instaKill = true
            }

        }
        
        buttonGC = self.childNodeWithName("buttonGC") as! MSButtonNode
        buttonGC.state = .Hidden
        buttonGC.selectedHandler = {
            self.showGameCenter()
        }
        
        // buttonRestart.state = .Hidden
        // Home
        iconHome = self.childNodeWithName("iconHome") as! MSButtonNode
        iconHome.selectedHandler = {
            let skView = self.view as SKView!
            let scene = IntroScene(fileNamed:"IntroScene") as IntroScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            if self.myTime > highScore {
                highScore = self.myTime
                if self.myTime < 4 {
                    instaKill = true
                }
            }

        }
        
        // button Info
        buttonInfo = self.childNodeWithName("buttonInfo") as! MSButtonNode
        buttonInfo.selectedHandler = {
            let skView = self.view as SKView!
            let scene = InfoScene(fileNamed:"InfoScene") as InfoScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            if self.myTime > highScore {
                highScore = self.myTime
                if self.myTime < 4 {
                    instaKill = true
                }
            }
        }
        
        // Collision Detection
        /* Set physics contact delegate */
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0.0, -6.0)
        
        // End Game 
        /* Hide restart button */
        //hugeText.state = .Hidden

    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        /* Get references to bodies involved in collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        /* Did our hero pass through the 'goal'? */
        if nodeA.name == "boundary" || nodeB.name == "boundary" {
          
//            if(gameState == .GameOver) {return} 
            
            print(highScore)
            deathOverlay.hidden = false
            finalScore.hidden = false
            if self.myTime < 10 {
                self.finalScore.text = ("0:0\(self.myTime)")
            }
                //if self.myTime > 10 && self.myTime < 60 {
            else {
                self.finalScore.text = ("0:\(self.myTime)")
            }
            buttonGC.state = .Active
            GORestart.state = .Active
            //GOShop.state = .Active
            GOHome.state = .Active
            gameState = .GameOver
            if self.myTime > highScore {
                highScore = myTime
            }
            if highScore < 10 {
                self.highScoreLabel.text = ("High Score: 0:0\(highScore)")
                highScoreString = "0:0\(highScore)"
            }
            else {
                self.highScoreLabel.text = ("High Score: 0:\(highScore)")
                highScoreString = "0:\(highScore)"
            }
            //self.highScoreLabel.text = String("High Score: \(highScore)")
            //makes a button visible and able to click
            //buttonRestart.state = .Active
            
            if self.myTime < 4 {
                if instaKill != true {
                    instaKill = true
                    //achievementText.hidden = false
                }
                else {
                   //achievementText.hidden = true
                }
            }
            
            let savedScore = NSUserDefaults.standardUserDefaults().integerForKey("Saved High Score")
            
            if highScore >= savedScore {
              
                NSUserDefaults.standardUserDefaults().setInteger(highScore, forKey: "Saved High Score")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                self.saveHighScore("High_Score", score: highScore)
                
            }
            
        }
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        /* Disable touch if game state is not active */
        //if gameState != .Active { return }
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        /* Skip game update if game no longer active */
        if gameState != .Active { return }
        
        // Outputs Timer
        if self.startCount == true {
            self.setTime = Int(currentTime)
            self.startCount = false
        }
        self.myTime = Int(currentTime) - self.setTime
        if self.myTime < 10 {
            self.timeLabel.text = ("0:0\(self.myTime)")
        }
        //if self.myTime > 10 && self.myTime < 60 {
        else {
            self.timeLabel.text = ("0:\(self.myTime)")
        }
        /*
        else {
            if myTime > 60 {
                myTimeMinutes += 1
                myTime = 0
                self.timeLabel.text = ("\(self.myTimeMinutes):\(self.myTime)")
            }
        }
        */
        
        //if myTiem = blah then add juan to currency
        
    }
    
    func authenticateLocalPlayer() {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { (viewController, error) -> Void in
            
            if viewController != nil {
                
                let vc:UIViewController = self.view!.window!.rootViewController!
                vc.presentViewController(viewController!, animated: true, completion: nil)
                
            } else {
                
                
            }
        }
    }
    
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        self.gameCenterAchievements.removeAll()
        
    }
    
    func saveHighScore(identifier:String, score:Int) {
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: identifier)
            
            scoreReporter.value = Int64(score)
            
            let scoreArray:[GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {
                error -> Void in
                
                if error != nil {
                    print("Error")
                } else {
                    
                    
                }
            })
        }
    }
    
    func reportAchievement (identifier:String, percentComplete:Int) {
        
        let achievement = GKAchievement(identifier: identifier)
        
        achievement.percentComplete = Double(percentComplete)
        achievement.showsCompletionBanner = true
        let achievementArray: [GKAchievement] = [achievement]
        
        GKAchievement.reportAchievements(achievementArray, withCompletionHandler: {
            
            error -> Void in
            
            if ( error != nil) {
                print(error)
            }
                
            else {
                
            }
            
        })
    }
    
    func incrementCurrentPercentageOfAchievement (identifier:String, amount:Double) {
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            var currentPercentFound:Bool = false
            
            if ( gameCenterAchievements.count != 0) {
                
                for (id,achievement) in gameCenterAchievements {
                    
                    if (id == identifier) {
                        
                        currentPercentFound = true
                        
                        var currentPercent:Double = achievement.percentComplete
                        
                        currentPercent = currentPercent + amount
                        
                        
                        break
                    }
                }
            }
            if (currentPercentFound == false) {
                
                
                
            }
        }
    }
    
    
    
    func showGameCenter() {
        
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        
        let vc:UIViewController = self.view!.window!.rootViewController!
        vc.presentViewController(gameCenterViewController, animated: true, completion:nil)
        
    }
    
    
}
