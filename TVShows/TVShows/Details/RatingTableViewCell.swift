import UIKit

class RatingTableViewCell: UITableViewCell {
    @IBOutlet var showRatingLabel: UILabel!
    @IBOutlet var averageRatingView: RatingView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            averageRatingView.configure(withStyle: .small)
            averageRatingView.isEnabled = false
        }

        func configure(with show: Show) {
            averageRatingView.setRoundedRating(show.averageRating!)
        }
}
