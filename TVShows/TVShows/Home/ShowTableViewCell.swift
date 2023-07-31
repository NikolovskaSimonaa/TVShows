import UIKit

class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    func configure(with show: Show) {
        titleLabel.text = show.title
    }
}
