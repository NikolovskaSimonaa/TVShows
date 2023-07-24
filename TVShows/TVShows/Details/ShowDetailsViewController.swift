import UIKit

final class ShowDetailsViewController: UIViewController {
    //MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Public Properties
    
    var showModel: Show?
    var authInfo: AuthInfo?
    
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
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.imageDescription, for: indexPath) as! ImageDescriptionTableViewCell
            //cell.writeReviewButton.layer.cornerRadius = 20
            //cell.writeReviewButton.clipsToBounds = true
            cell.showDescription.text = showModel?.description
            return cell
        case 1:
            //for now nothing
            return UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewCells.button, for: indexPath) as! ButtonTableViewCell
            cell.writeReviewButton.layer.cornerRadius = 20
            cell.writeReviewButton.clipsToBounds = true
            return cell
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

