import UIKit

class LoadingCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    class public func reuseIdentifier() -> String {
        return "LoadingCell"
    }

    public func showLoader(_ message:String="Loading...") {
       let loadingView = LoadingView.init(frame: CGRect(x:0, y:0, width:self.bounds.width, height:self.bounds.height))
        loadingView.backgroundColor = UIColor.rgba(fromHex: 0xFFFFFF, alpha: 0.5)
        self.addSubview(loadingView)
        loadingView.lblLoadingMessage?.text = message
        loadingView.startAnimatingLoader()
    }
}
