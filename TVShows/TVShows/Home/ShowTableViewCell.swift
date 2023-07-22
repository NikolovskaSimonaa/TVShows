import UIKit

class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    func configure(with show: Show) {
        titleLabel.text = show.title
    }
}
