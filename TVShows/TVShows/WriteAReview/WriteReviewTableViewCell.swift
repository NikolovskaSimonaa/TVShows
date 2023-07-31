import UIKit

protocol WriteReviewTableViewCellDelegate: AnyObject {
    func submitReview(withRating rating: Int, comment: String, showId: Int)
}

class WriteReviewTableViewCell: UITableViewCell {
    weak var delegate: WriteReviewTableViewCellDelegate?
    var showId: Int?
    @IBOutlet private var setRating: RatingView!
    @IBOutlet private var submitButton: UIButton!
    @IBOutlet private var commentView: UIView!
    @IBOutlet private var commentTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUILogic()
    }
    
    @IBAction func submitButtonClicked() {
        guard let comment = commentTextView.text, !comment.isEmpty else { return }
        let rating = setRating.rating
        delegate?.submitReview(withRating: rating, comment: comment, showId: showId ?? 0)
    }
    
    @objc func editingChanged() {
        if let comment = commentTextView.text, !comment.isEmpty && comment != Constants.Strings.placeholder && setRating.rating > 0 {
            submitButton.isEnabled = true
            submitButton.backgroundColor = UIColor(red: 82.0/255.0, green: 54.0/255.0, blue: 140.0/255.0, alpha: 1)
        } else {
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor(red: 82.0/255.0, green: 54.0/255.0, blue: 140.0/255.0, alpha: 0.2)
        }
    }
    
    private func setUILogic() {
        submitButton.layer.cornerRadius = 20
        submitButton.clipsToBounds = true
        submitButton.isEnabled = false
        submitButton.backgroundColor = UIColor(red: 82.0/255.0, green: 54.0/255.0, blue: 140.0/255.0, alpha: 0.2)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.setTitleColor(.white, for: .disabled)
        commentView.layer.cornerRadius = 10
        commentTextView.delegate = self
        commentTextView.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        setRating.configure(withStyle: .large)
    }
    
}
//MARK: - Extensions
extension WriteReviewTableViewCell: RatingViewDelegate {
    func didChangeRating(_ rating: Int) {
        submitButton.isEnabled = rating > 0 && !(commentTextView.text?.isEmpty ?? true)
    }
}

extension WriteReviewTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.Strings.placeholder {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView){
        if textView.text != Constants.Strings.placeholder {
            editingChanged()
        }
    }
}
