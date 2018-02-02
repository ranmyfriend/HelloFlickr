import UIKit

class LoadingCell: UICollectionViewCell {
    
    fileprivate let activityInicator:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        self.stopAnimatingCell()
        super.removeFromSuperview()   
    }
    
    // MARK: - Public Functions
    class public func reuseIdentifier() -> String {
        return "LoadingCell"
    }
    
    class func getHeight()->CGFloat {
        return 50.0
    }
    
    public func startAnimatingCell() {
        self.activityInicator.startAnimating()
    }
    
    public func stopAnimatingCell() {
        self.activityInicator.stopAnimating()
    }
    
    // MARK: - Private Functions
    private func createViews() {
        self.backgroundColor = UIColor.rgba(fromHex: 0xBE90D4, alpha: 0.1)
        
        self.addSubview(self.activityInicator)
        self.activityInicator.color = UIColor.red
        self.activityInicator.backgroundColor = .clear
        self.activityInicator.hidesWhenStopped = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.activityInicator.frame = CGRect(x:self.bounds.width/2 - 25, y:0, width:50, height:50)
    }
    
    

}
