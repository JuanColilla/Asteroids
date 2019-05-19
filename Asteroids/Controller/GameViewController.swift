import UIKit
import AVFoundation

class GameViewController: UIViewController {

    //Viper
    var viperImageView = UIImageView()
    var viper = Viper(speed: 3.5, center: CGPoint(), size: CGSize(width: 75, height: 75))

    
    //Asteroids
    let ASTEROIDS_IMAGES = [UIImage(named: "Asteroid_A"), UIImage(named: "Asteroid_B"), UIImage(named: "Asteroid_C"), UIImage(named: "Asteroid_D"), UIImage(named: "Asteroid_E"), UIImage(named: "Asteroid_F")]
    var asteroids = [Asteroid]()
    var asteroidsViews = [UIImageView]()
    var asteroidsToBeRemoved = [Asteroid]()
    
    
    //Game Logic
    var gameRunning = false //to control game state
    var stepNumber = 0 //Used in asteroids generation: every 5s an asteroid will be created
    var score = 0
    var lvl = 1
    var collisions = 0
    
    // Outlets
    @IBOutlet weak var scoreBoard: UILabel!
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    
    // Alert
    let alert = UIAlertController(title: "GAME OVER", message: "Te has quedado sin vidas...", preferredStyle: .alert)
    
    // Music
    var audioPlayer: AVAudioPlayer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set up Viper
        viper.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-80)
        viper.moveToPoint = viper.center
        viperImageView.frame.size = viper.size
        viperImageView.center = viper.center
        viperImageView.image = UIImage(named: "viper")
        self.view.addSubview(viperImageView)
        
        //allow user tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
        
        // Prepare score board
        scoreBoard.text = String(score)
        heart1.image = UIImage(named: "Heart")
        heart2.image = UIImage(named: "Heart")
        heart3.image = UIImage(named: "Heart")
        self.view.addSubview(heart1)
        self.view.addSubview(heart2)
        self.view.addSubview(heart3)
        self.view.addSubview(scoreBoard)
        
        //set game running
        self.gameRunning = true
        
        // Starting music
        let url = URL(string: Bundle.main.path(forResource: "music", ofType: "m4a")!)
        audioPlayer = try? AVAudioPlayer(contentsOf: url!, fileTypeHint: nil)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        
        //initialize timer
        let dislayLink = CADisplayLink(target: self, selector: #selector(self.updateScene))
        dislayLink.add(to: .current, forMode: .default)
        
        // handle alert
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.alert.dismiss(animated: true, completion: nil)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
    }
    
    
    
    
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        if sender.state == .ended {
            let tapPoint = sender.location(in: self.view)
            //update the model
            self.viper.moveToPoint = tapPoint
        }
    }
    
    @objc func updateScene(){
        
        if gameRunning{
            //create an asterior every 5s
            if (stepNumber%(60*5)==0){
                generateRandomAsteroid()
            }
            stepNumber+=1
            
            //update location viper
            self.viper.step() //update the model
            self.viperImageView.center = self.viper.center //update the view from the model
            
            //update location asteroids
            for index in 0..<asteroids.count{
                asteroids[index].step()
                asteroidsViews[index].center = asteroids[index].center
            }
            
            //check viper screen collision
            /*INSERT CODE HERE*/
            checkAsteroidCollision()
                
            
            
            
            //check asteroids collision between viper and screen
            /*INSERT CODE HERE*/
            if viper.checkScreenCollision(screenViewSize: self.view.frame.size){
                
            }
            
            
            /* for asteroid in asteroids {
                if asteroid.checkScreenCollision(screenViewSize: self.view.frame.size) {
                    asteroidsToBeRemoved.append(asteroid)
                }
            } */
            
            //remove from scene asteroids
            // eraseAvoidedAsteroids()
            

        }
    }
    
    func generateRandomAsteroid() {
        let randomSpeed = Int.random(in: 1..<5)
        let randomPosition = CGPoint(x: Int.random(in: 0..<Int(view.frame.width)), y: 0)
        let randomInt = Int.random(in: 15..<65)
        let asteroid = Asteroid(speed: CGFloat(randomSpeed), center: randomPosition, size: CGSize(width: randomInt, height: randomInt))
        self.asteroids.append(asteroid)
        let randomImage = Int.random(in: 0..<ASTEROIDS_IMAGES.count)
        let asteroidView = UIImageView(image: ASTEROIDS_IMAGES[randomImage])
        asteroidView.center = asteroid.center
        asteroidView.frame.size = asteroid.size
        self.view.addSubview(asteroidView)
        self.asteroidsViews.append(asteroidView)
    }
    
    func manageScore(lvl: Int, mode: Int) {
        if score > 0 {
            if mode == 0 {
                score += 10 * lvl
                scoreBoard.text = String(score)
            } else if mode == 1 {
                score -= 10 * lvl
                scoreBoard.text = String(score)
            }
        }
    }
    
    func loseOneLife() {
        if collisions == 1 {
            self.heart1.isHidden = true
        } else if collisions == 2 {
            self.heart2.isHidden = true
        } else if collisions == 3 {
            self.heart3.isHidden = true
        } else if collisions == 4 {
            self.present(alert, animated: true, completion: nil)
            viper.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-80)
            self.score = 0
            self.collisions = 0
            self.heart1.isHidden = false
            self.heart2.isHidden = false
            self.heart3.isHidden = false
            viper.moveToPoint = viper.center
        }
    }
    
    func checkAsteroidCollision() {
        for index in 0..<asteroids.count {
            if viper.overlapsWith(actor: asteroids[index]) {
                collisions += 1
                manageScore(lvl: lvl, mode: 1)
                loseOneLife()
                eraseAsteroids(index: index)
            }
        }
    }
    
    func eraseAsteroids(index:Int) {
        self.asteroidsViews[index].removeFromSuperview()
        self.asteroids.remove(at: index)
        self.asteroidsViews.remove(at: index)
    }
    
   /* func eraseAvoidedAsteroids() {
        for index in 0..<asteroidsToBeRemoved.count {
            eraseAsteroids(index: index)
            asteroidsToBeRemoved.remove(at: index)
        }
        
    } */


}

