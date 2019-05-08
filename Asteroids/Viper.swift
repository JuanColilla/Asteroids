import Foundation
import CoreGraphics

class Viper: Actor{
    
    var moveToPoint:CGPoint?
    
    override init(speed:CGFloat, center:CGPoint, size:CGSize){
        super.init(speed: speed, center:center, size: size)
        self.moveToPoint = self.center
    }
    
    override func step(){
        if let newPoint = moveToPoint{
            if !(newPoint==self.center){
                if abs(newPoint.x-self.center.x)<self.speed && abs(newPoint.y-self.center.y)<self.speed{
                    self.center = newPoint
                }else{
                
                    let dx = newPoint.x-self.center.x
                    let dy = newPoint.y-self.center.y
                    let theta = atan(dy/dx)
                
                    var dxf = self.speed*cos(theta)
                    var dyf = self.speed*sin(theta)
                
                    if (dx<0){
                        dxf = dxf*(-1)
                        dyf = dyf*(-1)
                    }
                
                    self.center.x = self.center.x + dxf
                    self.center.y = self.center.y + dyf
                }
            }
        }
    }
}
