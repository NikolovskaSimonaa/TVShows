import UIKit

class ImageDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet var showImage: UIImageView!
    @IBOutlet var showDescription: UILabel!
    
    func configure(with show: Show) {
        showDescription.text = show.description
    }
}
