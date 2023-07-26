import UIKit

protocol WriteReviewTableViewCellDelegate: AnyObject {
    func submitReview(withRating rating: Int, comment: String, showId: String)
}

class WriteReviewTableViewCell: UITableViewCell {
    weak var delegate: WriteReviewTableViewCellDelegate?
    var showId: String?
    @IBOutlet var setRating: RatingView!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var commentTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        //setUILogic()
    }
    
    @IBAction func submitButtonClicked() {
        guard let comment = commentTextField.text, !comment.isEmpty else { return }
        let rating = setRating.rating
        delegate?.submitReview(withRating: rating, comment: comment, showId: showId ?? "")
    }
    
    /*@objc func editingChanged() {
    if let comment = commentTextField.text, !comment.isEmpty {
    submitButton.isEnabled = true
    submitButton.backgroundColor = UIColor(red: 82, green: 54, blue: 140, alpha: 1)
    } else {
    submitButton.isEnabled = false
    //submitButton.backgroundColor = .lightText
    //submitButton.backgroundColor = UIColor(red: 82, green: 54, blue: 140, alpha: 0.2)
    submitButton.alpha = 0.2
    submitButton.setTitleColor(.white, for: .disabled)
    // submitButton.tintColor = .white
    }
    }
    
    private func setUILogic() {
    submitButton.layer.cornerRadius = 20
    submitButton.clipsToBounds = true
    submitButton.isEnabled = false
    submitButton.backgroundColor = UIColor(red: 82, green: 54, blue: 140, alpha: 0.2)
    //submitButton.alpha = 0.2
    //submitButton.setTitleColor(.white, for: .disabled)
    // submitButton.tintColor = .white

    setRating.configure(withStyle: .large)
    }*/
    
}
    //MARK: - Extensions
extension WriteReviewTableViewCell: RatingViewDelegate {
    func didChangeRating(_ rating: Int) {
        submitButton.isEnabled = rating > 0 && !(commentTextField.text?.isEmpty ?? true)
    }
}

extension WriteReviewTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        submitButton.isEnabled = setRating.rating > 0 && !(textField.text?.isEmpty ?? true)
    }
}
