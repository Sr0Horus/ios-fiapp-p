import UIKit

extension UIView {
    func showBlurLoader() {
        let blurLoader = BlurLoader(frame: frame)
        self.addSubview(blurLoader)
    }
    
    func removeBluerLoader() {
        if let blurLoader = subviews.first(where: { $0 is BlurLoader }) {
            blurLoader.removeFromSuperview()
        }
    }
}


final class BlurLoader: UIView {
    var blurEffectView: UIVisualEffectView?
    
    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.5
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.blurEffectView = blurEffectView
        
        super.init(frame: frame)
        addSubview(blurEffectView)
        addLoader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLoader() {
        guard let blurEffectView = blurEffectView else { return }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.startAnimating()
    }
}
