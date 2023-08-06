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
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: showModel?.title ?? "Show Title")
        setupTableView()
        getReviewsFromDatabase()
    }
}
    //MARK: - Extensions

extension ShowDetailsViewController: ButtonTableViewCellDelegate {
    func writeReviewButtonClicked() {
        let storyboard = UIStoryboard(name: Constants.Storyboards.writeReview, bundle: nil)
        let writeReviewViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.writeReview) as! WriteReviewViewController
        writeReviewViewController.showId = Int(showModel?.id ?? "0")
        writeReviewViewController.authInfo = authInfo
        writeReviewViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: writeReviewViewController)
        present(navigationController, animated: true)
    }
}

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
            return showDetailsCell(for: indexPath)
        case 1:
            return reviewsCell(for: indexPath)
        case 2:
            return buttonCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ShowDetailsViewController: WriteReviewViewControllerDelegate {    
    func didAddNewReview() {
        getReviewsFromDatabase()
        tableView.reloadData()
    }
}

private extension ShowDetailsViewController {
    func setTitle(title: String) {
        self.title = title
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
    }
    
    func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func getReviewsFromDatabase() {
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
                case .failure(let error):
                    alertMessage(title: "Error", message: error.localizedDescription)
                }
            }
    }
    
    func showDetailsCell(for indexPath: IndexPath) -> ImageDescriptionTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.imageDescription, for: indexPath) as! ImageDescriptionTableViewCell
        cell.configure(with: showModel!)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        return cell
    }
    
    func reviewsCell(for indexPath: IndexPath) -> UITableViewCell {
        if showModel?.noOfReviews == nil ||
            showModel?.averageRating == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.noReviews, for: indexPath) as! NoReviewsTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.rating, for: indexPath) as! RatingTableViewCell
                cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
                cell.configure(with: showModel!)
                return cell
            } else {
                if let review = reviews?[indexPath.row - 1] {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.review, for: indexPath) as! ReviewTableViewCell
                    cell.configure(with: review)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func buttonCell(for indexPath: IndexPath) -> ButtonTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.button, for: indexPath) as! ButtonTableViewCell
        cell.delegate = self
        cell.configure()
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
        return cell
    }
}
