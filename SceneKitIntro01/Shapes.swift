import Foundation

enum ShapeType:Int {
    case cone
    case capsule
    case tube
    case sphere
    case torus
    case pyramid
    case cylinder
    case box
    
    static func random() -> ShapeType {
        let maxValue = tube.rawValue
        let randomValue = arc4random_uniform(UInt32(maxValue + 1))
//        guard let ShapeType = ShapeType else { return }
        return ShapeType(rawValue: Int(randomValue))!
    }
}
