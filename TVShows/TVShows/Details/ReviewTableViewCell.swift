import Kingfisher
import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var ratingView: RatingView!
    @IBOutlet private var commentLabel: UILabel!
    @IBOutlet private var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
    
    func configure(with review: Review) {
        usernameLabel.text = review.user.email
        commentLabel.text = review.comment
        ratingView.setRoundedRating(Double(review.rating))
        userImage.kf.setImage(
              with: review.user.imageUrl,
              placeholder: UIImage(named: "ic-profile-placeholder")
            )
    }
}
