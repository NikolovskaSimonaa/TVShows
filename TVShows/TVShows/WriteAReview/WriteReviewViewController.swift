import Alamofire
import UIKit

protocol WriteReviewViewControllerDelegate: AnyObject {
    func didAddNewReview()
}
final class WriteReviewViewController: UIViewController {
    //MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Public Properties
    
    weak var delegate: WriteReviewViewControllerDelegate?
    var showId: String?
    var authInfo: AuthInfo?
    var user: User?
    private var reviewResponse: ReviewResponse?
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCloseButton()
        setTitle()
        setupTableView()
    }
    
    //MARK: - Utility methods
    
    private func showCloseButton() {
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    private func setTitle() {
        title = "Write a Review"
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
    //MARK: - Extensions

extension WriteReviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.writeReview, for: indexPath) as! WriteReviewTableViewCell
        cell.delegate = self
        cell.showId = showId
        return cell
    }
}

extension WriteReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension WriteReviewViewController: WriteReviewTableViewCellDelegate {    
    func submitReview(withRating rating: Int, comment: String, showId: String) {
        guard let authInfo = authInfo else { return }
        let parameters: [String: Any] = [
            "rating": rating,
            "comment": comment,
            "show_id": showId
        ]
        AF.request("https://tv-shows.infinum.academy/reviews",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: HTTPHeaders(authInfo.headers)
                   )
            .validate()
            .responseDecodable(of: ReviewResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success( _):
                    DispatchQueue.main.async {
                        self.delegate!.didAddNewReview()
                        self.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    alertMessage(title: "Error", message: error.localizedDescription)
                }
            }
    }
}


