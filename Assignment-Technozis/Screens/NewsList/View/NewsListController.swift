//
//  NewsListController.swift
//  Assignment-Technozis
//
//  Created by abh on 06/07/25.
//

import UIKit

class NewsListController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var vwTable: UITableView!
    @IBOutlet weak var constHeightVwMarkAsReviewed: NSLayoutConstraint!
    
    let viewModel = NewsListViewModel()
    private var loaderManager: CustomLoaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initController()
    }
    
    func initController(){
        self.vwTable.register(UINib(nibName: "ReviewerContentCell", bundle: nil), forCellReuseIdentifier: "ReviewerContentCell")
        self.loaderManager = CustomLoaderView(frame: view.bounds)
        self.view.addSubview(loaderManager)
        self.loadArticles()
        self.btnReview.layer.cornerRadius = 12
        self.btnReview.layer.masksToBounds = true
        if self.viewModel.userType == .author{
            self.lblTitle.text = "News (Author)"
        } else if self.viewModel.userType == .reviewer{
            self.lblTitle.text = "News (Reviewer)"
        }
        self.handleMarkAsReviewUI()
    }
    
    func handleMarkAsReviewUI(){
        if self.viewModel.userType == .author{
            self.constHeightVwMarkAsReviewed.constant = 0
        }
    }
    
    func loadArticles() {
        self.loaderManager.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.viewModel.userType == .reviewer {
                self.viewModel.loadArticles(forReviewer: true) {
                    self.loaderManager.stopLoading()
                    self.vwTable.reloadData()
                }
            } else {
                self.viewModel.loadArticles(forReviewer: false) {
                    self.loaderManager.stopLoading()
                    self.vwTable.reloadData()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = "Welcome \(self.viewModel.userName)"
    }
    @IBAction func clickedOnMarkedAsReviewed(_ sender: Any) {
        if self.viewModel.checkMarkState.isEmpty{
            Utility.showAlertBox(on: self.navigationController?.topViewController ?? UINavigationController(), message: "Select atleast one article to mark it as reviewed.")
            return
        }
        let userName = self.viewModel.userName
        loaderManager.startLoading() // (if you have a loader UI)
        viewModel.markApprove(
            selectedIndexPaths: self.viewModel.checkMarkState,
            userType: self.viewModel.userType ?? .reviewer,
            userName: userName
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.loaderManager.stopLoading()
                self?.viewModel.checkMarkState.removeAll()
                self?.vwTable.reloadData()
                
                switch result {
                case .success:
                    Utility.showToastBanner(
                        on: self?.view,
                        title: "Updated Data!",
                        subtitle: "Updated data successfully!!",
                        icon: UIImage(named: "sync-icon"),
                        backgroundColor: UIColor.systemGreen
                    )
                case .failure(let error):
                    let message: String
                    switch error {
                    case .nothingToApprove:
                        message = "Already approved previously."
                    case .saveFailed(let msg):
                        message = "Save failed: \(msg)"
                    }
                    Utility.showToastBanner(
                        on: self?.view,
                        title: "Update Failed",
                        subtitle: message,
                        icon: UIImage(named: "error-icon"),
                        backgroundColor: UIColor.systemRed
                    )
                }
            }
        }

    }
    
    
}

extension NewsListController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.userType == .reviewer ? viewModel.numberOfSections() : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.userType == .reviewer {
            return viewModel.numberOfRows(in: section)
        } else {
            return viewModel.numberOfAuthorRows()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.userType == .reviewer ? viewModel.sectionTitles[section] : nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewerContentCell", for: indexPath) as? ReviewerContentCell else {
            return UITableViewCell()
        }
        let article: ArticleData?
        if self.viewModel.userType == .reviewer {
            article = viewModel.article(for: indexPath)
            cell.index = indexPath
            cell.delegate = self
        } else {
            article = viewModel.authorArticle(at: indexPath.row)
            cell.hideUIForAuthor()
        }
        if let art = article {
            cell.isCheckboxSelected = false
            if self.viewModel.checkMarkState.contains(indexPath){
                cell.isCheckboxSelected = true
            }
            cell.configureCell(with: art)
        }
        return cell
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard self.viewModel.userType == .reviewer else { return nil }

        let container = UIView()
        container.backgroundColor = .lightGray
        container.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 36)

        // Left: Author Name
        let leftLabel = UILabel()
        leftLabel.text = "  \(self.viewModel.sectionTitles[section])"
        leftLabel.font = .boldSystemFont(ofSize: 16)
        leftLabel.textAlignment = .left
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        // Right: Approve Count/
        
        
        let approveCount = self.viewModel.totalApproveCount(forSection: section)
        let rightLabel = UILabel()
        rightLabel.text = "Approves: \(approveCount)"
        rightLabel.font = .systemFont(ofSize: 14)
        rightLabel.textColor = .darkGray
        rightLabel.textAlignment = .right
        rightLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(leftLabel)
        container.addSubview(rightLabel)

        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            leftLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            leftLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightLabel.leadingAnchor, constant: -8),

            rightLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            rightLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        return container
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.viewModel.userType == .author{
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}


//MARK: - Delegate
extension NewsListController: ReviewerContentCellDelegate{
    func checkBoxStateChange(selected: Bool, index: IndexPath) {
        if selected{
            self.viewModel.checkMarkState.append(index)
        } else {
            self.viewModel.checkMarkState.removeAll { indexPath in
                return indexPath == index
            }
        }
    }
}
