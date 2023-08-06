import Kingfisher
import UIKit

class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    func configure(with show: Show) {
        titleLabel.text = show.title
        if let image = show.imageUrl {
            iconImageView.kf.setImage(
                with: URL(string: image),
                placeholder: UIImage(named: "ic-show-placeholder-vertical")
            )
        } else {
            iconImageView.image = UIImage(named: "ic-show-placeholder-vertical")
        }
    }
}
