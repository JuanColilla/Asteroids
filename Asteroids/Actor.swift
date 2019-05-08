import Foundation
import CoreGraphics

class Actor{
    var speed:CGFloat
    var center:CGPoint
    var size:CGSize
    
    init(speed:CGFloat, center:CGPoint, size:CGSize){
        self.speed = speed
        self.center = center
        self.size = size
    }
    
    func overlapsWith(actor:Actor)->Bool{
        let frame = CGRect(origin: CGPoint(x: self.center.x-self.size.width/2,y:self.center.y-self.size.height/2), size: size)
        let actorFrame = CGRect(origin: CGPoint(x: actor.center.x-actor.size.width/2,y:actor.center.y-actor.size.height/2), size: size)
        return frame.intersects(actorFrame)
    }
    

    func checkScreenCollision(screenViewSize:CGSize)->Bool{
        let xMax = self.center.x+self.size.width/2
        let xMin = self.center.x-self.size.width/2
        let yMax = self.center.y+self.size.height/2
        let yMin = self.center.y-self.size.height/2
        return (xMax>screenViewSize.width || xMin<0 || yMax>screenViewSize.height || yMin<0)
    }
    
    func step (){
        
    }
}
