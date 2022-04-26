//
//  CreateJobViewController.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import UIKit

class CreateJobViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var headerView: UITableViewHeaderFooterView!
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            self.tableView.tableHeaderView = headerView
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 60
            self.tableView.register(UINib(nibName: CellIdentifier.addedProductTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.addedProductTableViewCell)
        }
    }
    @IBOutlet weak var sourceStoreTF: BorderedTextField!{
        didSet{
            self.sourceStoreTF.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var selectDropStoreBtn: BorderedButton!
    @IBOutlet weak var selectAssigneeBtn: BorderedButton!
    @IBOutlet weak var selectProductBtn: BorderedButton!
    @IBOutlet weak var addProductsBtn: BorderedButton! {
        didSet {
//            self.addProductsBtn.setColors(titleColor: .appGreenColor(), bordeColor: .appGreenColor())
        }
    }
    @IBOutlet weak var dateTF: BorderedTextField!
    @IBOutlet weak var timeTF: BorderedTextField!
    @IBOutlet weak var quantityTF: BorderedTextField!
    var datePicker: DatePicker!
    var timePicker: DatePicker!
    var viewModel = CreateJobViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create Job"
        self.datePicker = DatePicker(presentationController: self, textfield: dateTF, isDate: true)
        self.timePicker = DatePicker(presentationController: self, textfield: timeTF, isDate: false)
        self.datePicker.dateDelegate = self
        self.timePicker.dateDelegate = self
        self.addProductsBtn.setGreenBorderAndText()

        //  Set some default values to create job.
        // partion - master, jobstatus = todo,
        // createdby - my user document, source store - my store document
        viewModel.job._partition = "master"
        viewModel.job.status = JobStatus.todo.rawValue
        if let user = RealmManager.shared.getMyUserInfo() {
            viewModel.job.createdBy = user
        }
        if let store = RealmManager.shared.getMyStore() {
            self.sourceStoreTF.text = store.name.capitalizingFirstLetter()
            viewModel.job.sourceStore = store
        }
        if viewModel.isFromOrder {
            loadJobInfo()
        } else {
            // default to current date time
            viewModel.job.datetime = Date()
            dateTF.text = viewModel.job.datetime?.getDateStringFromDate()
            timeTF.text = viewModel.job.datetime?.getTimeStringFromDate()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: -
    
    private func loadJobInfo() {
        self.sourceStoreTF.text = self.viewModel.job.sourceStore?.name
        self.selectDropStoreBtn.setTitle(self.viewModel.job.destinationStore?.name.capitalizingFirstLetter(), for: .normal)
        self.dateTF.text = self.viewModel.job.datetime?.getDateStringFromDate()
        self.timeTF.text = self.viewModel.job.datetime?.getTimeStringFromDate()
        self.tableView.reloadData()
        
    }
    
    // MARK: - Actions
    
    @IBAction func dropStoreBtnAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.selectionViewController.rawValue) as? SelectionViewController
        vc?.delegate = self
        vc?.viewModel.selectionType = .stores
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func assigneeBtnAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.selectionViewController.rawValue) as? SelectionViewController
        vc?.delegate = self
        vc?.viewModel.selectionType = .users
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func selectProductAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.selectionViewController.rawValue) as? SelectionViewController
        vc?.delegate = self
        vc?.viewModel.selectionType = .inventories
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func addProductAction(_ sender: UIButton) {
        let name = self.selectProductBtn.titleLabel?.text
        let quantity: Int = Int(self.quantityTF.text ?? "0") ?? 0
        if name?.isEmpty == true || name == "Product Name" {
            self.showMessage(message: "Select a Product")
        } else if quantity == 0 {
            self.showMessage(message: "Enter the quantity of product")
        } else {
            self.viewModel.addProductToJob(withQuantity: quantity) { completed in
                self.tableView.reloadData()
                self.selectProductBtn.setTitle("Product Name", for: .normal)
                self.quantityTF.text = ""
                self.viewModel.selectedInventory = nil
            }
        }
    }
    @IBAction func removeProductAction(_ sender: UIButton) {
        self.viewModel.deleteProduct(atIndex: sender.tag)
        tableView.reloadData()
    }
    @IBAction func createJobBtn(_ sender: UIButton) {
        viewModel.job.type = JobType.delivery.rawValue
        viewModel.validateCreateJobForm { completed in
            RealmManager.shared.createJob(job: viewModel.job) { completed in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } failure: { errorMsg in
            print(errorMsg)
            self.showErrorAlert(errorMsg)
        }
    }
}

extension CreateJobViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.rowCount ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.addedProductTableViewCell, for: indexPath) as? AddedProductTableViewCell ?? AddedProductTableViewCell()
        cell.removeBtn.tag = indexPath.row
        viewModel.configureCell(cell: cell, atIndex: indexPath.row)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Added Products"
//    }
}

extension CreateJobViewController: SelectionDelegate{
    func didSelectJobType(type: String) {
        
    }
    
    func didSelectInventory(inventory: StoreInventory) {
        viewModel.selectedInventory = inventory
        self.selectProductBtn.setTitle(inventory.productName.capitalizingFirstLetter(), for: .normal)
    }
    
    func didSelectStore(store: Stores) {
        viewModel.job.destinationStore = store
        self.selectDropStoreBtn.setTitle(store.name.capitalizingFirstLetter(), for: .normal)
    }
    
    func didSelectUser(user: Users) {
        viewModel.job.assignedTo = user
        if let fName = user.firstName, let lName = user.lastName {
            self.selectAssigneeBtn.setTitle(fName.capitalizingFirstLetter() + " " + lName.capitalizingFirstLetter(), for: .normal)
        }
    }
}

extension CreateJobViewController: DatePickerDelegate {
    func didSelectDate(date: Date) {
        viewModel.job.datetime = date
        dateTF.text = date.getDateStringFromDate()
        timeTF.text = date.getTimeStringFromDate()
    }
}
