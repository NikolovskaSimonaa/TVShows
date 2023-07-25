import UIKit

class ReviewsTableViewCell: UITableViewCell {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var ratingView: RatingView!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var userImage: UIImageView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            ratingView.configure(withStyle: .small)
            ratingView.isEnabled = false
        }
    
    func configure(with review: Review) {
        usernameLabel.text = review.user.email
        commentLabel.text = review.comment
        ratingView.setRoundedRating(Double(review.rating))
    }
}
