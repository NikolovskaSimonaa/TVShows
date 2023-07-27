import UIKit

class RatingTableViewCell: UITableViewCell {
    @IBOutlet private var showRatingLabel: UILabel!
    @IBOutlet private var averageRatingView: RatingView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            averageRatingView.configure(withStyle: .small)
            averageRatingView.isEnabled = false
        }

        func configure(with show: Show) {
            averageRatingView.setRoundedRating(show.averageRating!)
            if let noOfReviews = show.noOfReviews, let averageRating = show.averageRating {
                showRatingLabel.text = "\(noOfReviews) REVIEWS, \(averageRating) AVERAGE"
            }
        }
}
