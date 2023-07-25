import Alamofire
import UIKit

final class ShowDetailsViewController: UIViewController {
    //MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Public Properties
    
    var showModel: Show?
    var authInfo: AuthInfo?
    var reviews: [Review]?
    var filteredReviews: [Review]?
    
    //MARK: - Private Properties
    
    private var showId: String = ""
    
    //MARK: - Utility methods
    
    private func setTitle(title: String) {
        self.title = title
        if let navigationController = navigationController {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 34.0)
            ]
            //navigationItem.backBarButtonItem = UIBarButtonItem(title: "Shows", style: .plain,target: nil, action: nil)
            navigationController.navigationBar.titleTextAttributes = attributes
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func getReviewsFromDatabase() {
        showId = showModel?.id ?? "No ID"
        guard let authInfo else { return }
        AF
            .request(
                "https://tv-shows.infinum.academy/shows/\(showId)/reviews",
                method: .get,
                parameters: ["page": "1", "items": "100"],
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ReviewResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let reviewsResponse):
                    reviews = reviewsResponse.reviews
                    print("ShowID: \(showId)")
                    print("Reviews: \(reviews)")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }

    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: showModel?.title ?? "Show Title")
        setupTableView()
        
    }
}
    //MARK: - Extensions

extension ShowDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.imageDescription, for: indexPath) as! ImageDescriptionTableViewCell
            cell.showDescription.text = showModel?.description
            return cell
        case 1:
            if showModel?.noOfReviews == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.rating, for: indexPath) as! RatingTableViewCell
                cell.noReviewsLabel.isHidden = false
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.rating, for: indexPath) as! RatingTableViewCell
                cell.noReviewsLabel.isHidden = true
                //da se iznese rating-ot
                return cell
            }
        case 2:
            getReviewsFromDatabase()
            if let reviews=reviews {
                filteredReviews = reviews.filter {$0.showId == Int(showModel?.id ?? "0")}
            }
            if let reviews = filteredReviews, !reviews.isEmpty {
                for review in reviews.self {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.reviews, for: indexPath) as! ReviewsTableViewCell
                    cell.usernameLabel.text = review.user.email
                    cell.commentLabel.text = review.comment
                    cell.ratingView.configure(withStyle: .small)
                    cell.ratingView.isUserInteractionEnabled = false
                    cell.ratingView.rating = review.rating
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.reviews, for: indexPath) as! ReviewsTableViewCell
                return cell
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.button, for: indexPath) as! ButtonTableViewCell
            cell.writeReviewButton.layer.cornerRadius = 20
            cell.writeReviewButton.clipsToBounds = true
            return cell
        default:
            return UITableViewCell()
            }
        return UITableViewCell()
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

