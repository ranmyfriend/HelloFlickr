import UIKit
class LoadingView: UIView {
    
    public var lblLoadingMessage: UILabel?
    
    private var indicator: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = 70
        
        self.indicator?.frame = CGRect(x:self.bounds.width/2-size/2, y:self.bounds.height/2-size/2, width:size, height:50);
        
        self.lblLoadingMessage?.frame = CGRect(x:10, y:(self.indicator?.frame.maxY)!, width:self.bounds.width-20, height:25)
    }
    
    // MARK: - Private Functions
    private func createViews() {
        self.indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        self.indicator?.color = UIColor.rgb(fromHex: 0x0041FF)
        self.indicator?.backgroundColor = .clear
        self.addSubview(self.indicator!)
        
        self.lblLoadingMessage = UILabel()
        self.lblLoadingMessage?.text = ""
        self.lblLoadingMessage?.textColor = .black
        self.lblLoadingMessage?.textAlignment = .center
        self.lblLoadingMessage?.font = UIFont.systemFont(ofSize: 15)
        self.lblLoadingMessage?.backgroundColor = .clear
        self.lblLoadingMessage?.numberOfLines = 1
        self.addSubview(self.lblLoadingMessage!)
        
    }
    
    // MARK:: Public Functions
    public func startAnimatingLoader() {
        self.indicator?.startAnimating()
    }
    
    public func stopAnimatingLoader() {
        self.indicator?.stopAnimating()
    }

}
