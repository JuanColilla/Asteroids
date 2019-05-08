import Foundation
import CoreGraphics

var nextId = 0

class Asteroid:Actor{
    var id:Int
    
    override init(speed: CGFloat, center: CGPoint, size: CGSize) {
        self.id = nextId + 1;
        super.init(speed: speed, center: center, size: size)
    }
    
    override func step(){
        self.center.y += self.speed
    }
}
