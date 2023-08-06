import Kingfisher
import UIKit

class ImageDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet private var showImage: UIImageView!
    @IBOutlet private var showDescription: UILabel!
    
    func configure(with show: Show) {
        showDescription.text = show.description
        if let image = show.imageUrl {
            showImage.kf.setImage(
                with: URL(string: image),
                placeholder: UIImage(named: "ic-show-placeholder-rectangle")
            )
        } else {
            showImage.image = UIImage(named: "ic-show-placeholder-rectangle")
        }
    }
}
