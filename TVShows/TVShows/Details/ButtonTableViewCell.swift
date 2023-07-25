import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet var writeReviewButton: UIButton!
    
    @IBAction func writeReviewButtonClicked() {
    }
    
    func configure() {
        writeReviewButton.layer.cornerRadius = 20
        writeReviewButton.clipsToBounds = true
    }
}
