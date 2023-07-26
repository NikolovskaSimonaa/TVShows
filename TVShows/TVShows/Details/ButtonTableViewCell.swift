import UIKit

class ButtonTableViewCell: UITableViewCell {
    weak var delegate: ButtonTableViewCellDelegate?
    @IBOutlet var writeReviewButton: UIButton!
    
    @IBAction func writeReviewButtonClicked() {
        delegate?.writeReviewButtonClicked()
    }
    
    func configure() {
        writeReviewButton.layer.cornerRadius = 20
        writeReviewButton.clipsToBounds = true
    }
}

protocol ButtonTableViewCellDelegate: AnyObject {
    func writeReviewButtonClicked()
}
