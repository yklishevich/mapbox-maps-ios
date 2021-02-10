
import Foundation
import UIKit

public class TimeFrameGraph: UIView {
    var scrollLayer: CAScrollLayer!
    var thresholdLayer: CAShapeLayer!
    var barLayers: [CAShapeLayer] = []
    let frameTimeExagerration = 4 * 1000

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        self.isUserInteractionEnabled = false
        self.layer.opacity = 0.9

        scrollLayer = CAScrollLayer()
        scrollLayer.scrollMode = .horizontally
        scrollLayer.masksToBounds = true
        self.layer.addSublayer(scrollLayer)

        thresholdLayer = CAShapeLayer()
        thresholdLayer.fillColor = UIColor.gray.cgColor
        self.layer.addSublayer(thresholdLayer)

    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if self.scrollLayer.frame != self.bounds {
            self.scrollLayer.frame = self.bounds
            let thresholdLineRect = CGRect(x: 0, y: self.frame.size.height - self.renderDurationTargetMilliseconds(),
                                           width: self.frame.size.width, height: 1)

            let path = CGPath(rect: thresholdLineRect, transform: nil)
            self.thresholdLayer.path = path
        }
    }

    func renderDurationTargetMilliseconds() -> CGFloat {
        let maxFrames = CGFloat(UIScreen.main.maximumFramesPerSecond)
        let target : CGFloat = (1 / maxFrames) * CGFloat(frameTimeExagerration)
        return target.rounded()
    }

    func bar(with frameDuration: TimeInterval) {

    }

    public func updatePath(with frameDuration: TimeInterval) {

    }
}

extension UIColor {
    struct BarColors {
        static var safeColor : UIColor { return UIColor(red: 0, green: 190/255 , blue: 123/244, alpha: 1) }
        static var warningColor : UIColor { return UIColor(red: 1, green: 154/255, blue: 82/255, alpha: 1) }
        static var dangerColor : UIColor { return UIColor(red: 1, green: 91/255, blue: 86/255, alpha: 1) }
    }
}
