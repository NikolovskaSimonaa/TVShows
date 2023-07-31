import UIKit

class ImageDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet private var showImage: UIImageView!
    @IBOutlet private var showDescription: UILabel!
    
    func configure(with show: Show) {
        showDescription.text = show.description
    }
}
