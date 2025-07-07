//
//  LoginViewController.swift
//  Assignment-Technozis
//
//  Created by abh on 06/07/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var vwTable: UITableView!
    @IBOutlet weak var vwTableHeightConstraint: NSLayoutConstraint!
    
    let viewModel = LoginViewModel()
    private var loaderManager: CustomLoaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initController()
    }
    
    func initController(){
        self.vwTable.layer.cornerRadius = 12
        self.vwTable.layer.masksToBounds = true
        self.vwTable.register(UINib(nibName: "DynamicTextField",
                                    bundle: nil),
                              forCellReuseIdentifier: "DynamicTextField")
        self.vwTable.layoutIfNeeded()
        self.manageDynamicHeightForList()
        self.loaderManager = CustomLoaderView(frame: view.bounds)
        view.addSubview(loaderManager)
    }
    
    func manageDynamicHeightForList(){
        DispatchQueue.main.async {
            self.vwTable.reloadData()
            self.vwTable.layoutIfNeeded()
            self.vwTableHeightConstraint.constant = self.vwTable.contentSize.height
        }
    }
    
    private func isDataAlreadyPersisting()->Bool{
        let articles = PersistenceService.shared.fetchArticles()
        return !articles.isEmpty
    }
    
    private func syncDataAndUpdateUI(){
        self.loaderManager.startLoading()
        self.viewModel.syncArticles {
            self.loaderManager.stopLoading()
            Utility.showToastBanner(on: self.view,
                                    title: "Sync completed!",
                                    subtitle: "Now you can login",
                                    icon: UIImage(named: "sync-icon"),
                                    backgroundColor: UIColor.systemGreen)
        }

    }
}

extension LoginViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:DynamicTextField = self.vwTable.dequeueReusableCell(withIdentifier: "DynamicTextField", for: indexPath) as? DynamicTextField{
            cell.selectionStyle = .none
            cell.delegate = self
            cell.vwParentForController = self.view
            cell.configureCell()
            if self.viewModel.isClickedOnSubmit{
                cell.isShowError()
            }
            return cell
        }
        return UITableViewCell()
    }
}


extension LoginViewController:DynamicTextFieldDelegate{
    func clickedOnSyncData() {
        if self.isDataAlreadyPersisting(){
            Utility.showInteractiveAlertBox(on: self.navigationController?.topViewController ?? UIViewController(),
                                            message: "Data exists already, do you want to resync?",
                                            noTitle: "No",
                                            yesHandler:  {
                self.syncDataAndUpdateUI()
            })
        } else {
            self.syncDataAndUpdateUI()
        }
    }
    
    func clickedOnLogin() {
        self.viewModel.isClickedOnSubmit = true
        self.manageDynamicHeightForList()
        if self.viewModel.username != ""{
            if !self.isDataAlreadyPersisting() {
                Utility.showAlertBox(on: NavigationManager.shared.navigationController ?? UINavigationController(),
                                        message: "Please sync the app.")
                return
            }
            self.viewModel.storeLogin()
            let listController = NewsListController(nibName: "NewsListController", bundle: nil)
            NavigationManager.shared.push(listController)
        }
    }
    
    func userUpdatedInput(value: String) {
        self.viewModel.username = value
    }
}
