import UIKit

class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    func configure(with show: Show) {
        titleLabel.text = show.title
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
/*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/

}
