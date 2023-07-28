import Kingfisher
import UIKit

class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    func configure(with show: Show) {
        titleLabel.text = show.title
        
        guard let url = URL(string: show.imageUrl!) else {return}
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let placeholder = UIImage(named: "ic-show-placeholder-vertical")
            var image:UIImage?
            do {
                let imageData = try Data(contentsOf: url)
                image = UIImage(data: imageData) ?? placeholder!
            } catch {
                image = placeholder
                print("Error loading image: \(error)")
            }
            DispatchQueue.main.async {
                self.iconImageView.image = image
            }
        }
    }
}
