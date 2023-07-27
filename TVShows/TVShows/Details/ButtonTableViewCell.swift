import UIKit

protocol ButtonTableViewCellDelegate: AnyObject {
    func writeReviewButtonClicked()
}

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
