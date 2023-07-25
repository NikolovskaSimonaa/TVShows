import Alamofire
import UIKit

final class ShowDetailsViewController: UIViewController {
    //MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Public Properties
    
    var showModel: Show?
    var authInfo: AuthInfo?
    var reviews: [Review]?
    
    //MARK: - Private Properties
    
    private var showId: String = ""
    
    //MARK: - Utility methods
    
    private func setTitle(title: String) {
        self.title = title
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
                    tableView.reloadData()
                    //print("ShowID: \(showId)")
                    //print("Reviews: \(reviews)")
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
        getReviewsFromDatabase()
        
    }
}
//MARK: - Extensions

extension ShowDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if let reviews = reviews, reviews.count > 0 {
                return reviews.count + 1
            }
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.imageDescription, for: indexPath) as! ImageDescriptionTableViewCell
            cell.showDescription.text = showModel?.description
            return cell
        case 1:
            if showModel?.noOfReviews == nil, showModel?.averageRating == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.noReviews, for: indexPath) as! NoReviewsTableViewCell
                return cell
            } else {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.rating, for: indexPath) as! RatingTableViewCell
                    if let noOfReviews = showModel?.noOfReviews, let averageRating = showModel?.averageRating {
                        cell.showRatingLabel.text = "\(noOfReviews) REVIEWS, \(averageRating) AVERAGE"
                    }
                    cell.configure(with: showModel!)
                    return cell
                } else {
                    if let review = reviews?[indexPath.row - 1] {
                        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.reviews, for: indexPath) as! ReviewsTableViewCell
                        cell.configure(with: review)
                        return cell
                    }
                }
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.button, for: indexPath) as! ButtonTableViewCell
            cell.configure()
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

