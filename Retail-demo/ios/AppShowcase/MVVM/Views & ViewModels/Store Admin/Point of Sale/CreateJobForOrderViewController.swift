//
//  CreateJobForOrderViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 28/02/22.
//

import UIKit

class CreateJobForOrderViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var headerView: UITableViewHeaderFooterView!
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            self.tableView.tableHeaderView = headerView
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 60
            self.tableView.register(UINib(nibName: CellIdentifier.productTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.productTableViewCell)
        }
    }
    @IBOutlet weak var selectJobTypeBtn: BorderedButton!
    @IBOutlet weak var sourceStoreTF: BorderedTextField!{
        didSet{
            self.sourceStoreTF.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var dropOffAddressTF: BorderedTextField! {
        didSet{
            self.dropOffAddressTF.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var selectAssigneeBtn: BorderedButton!
    @IBOutlet weak var dateTF: BorderedTextField!
    @IBOutlet weak var timeTF: BorderedTextField!
    var datePicker: DatePicker!
    var timePicker: DatePicker!
    var viewModel = CreateJobForOrderViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create Job"
        self.datePicker = DatePicker(presentationController: self, textfield: dateTF, isDate: true)
        self.timePicker = DatePicker(presentationController: self, textfield: timeTF, isDate: false)
        self.datePicker.dateDelegate = self
        self.timePicker.dateDelegate = self

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
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: -
    
    private func loadJobInfo() {
        self.sourceStoreTF.text = self.viewModel.job.sourceStore?.name
        self.dropOffAddressTF.text = self.viewModel.orderToAddAsJob?.type?.address
        viewModel.job.datetime = Date()
        self.dateTF.text = viewModel.job.datetime?.getDateStringFromDate()
        self.timeTF.text = viewModel.job.datetime?.getTimeStringFromDate()
        self.tableView.reloadData()
        
    }
    
    // MARK: - Actions
    
    @IBAction func selectJobTypeBtnAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.selectionViewController.rawValue) as? SelectionViewController
        vc?.delegate = self
        vc?.viewModel.selectionType = .jobType
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func assigneeBtnAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.selectionViewController.rawValue) as? SelectionViewController
        vc?.delegate = self
        vc?.viewModel.selectionType = .users
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func createJobBtn(_ sender: UIButton) {
        viewModel.validateCreateJobForm { completed in
            RealmManager.shared.createJob(job: viewModel.job) { completed in
                DispatchQueue.main.async {
                    if self.viewModel.isFromOrder == true {
                        self.tabBarController?.selectedIndex = 1
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } failure: { errorMsg in
            print(errorMsg)
            self.showErrorAlert(errorMsg)
        }
    }
    
}

extension CreateJobForOrderViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.rowCount ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.productTableViewCell, for: indexPath) as? ProductTableViewCell ?? ProductTableViewCell()
        cell.productQuantityForOrder = viewModel.job.products[indexPath.row]
        return cell
    }
}

extension CreateJobForOrderViewController: SelectionDelegate{
    
    func didSelectJobType(type: String) {
        viewModel.job.type = type
        self.selectJobTypeBtn.setTitle(type, for: .normal)
    }
    
    func didSelectInventory(inventory: StoreInventory) {}
    
    func didSelectStore(store: Stores) {}
   
    func didSelectUser(user: Users) {
        viewModel.job.assignedTo = user
        if let fName = user.firstName, let lName = user.lastName {
            self.selectAssigneeBtn.setTitle(fName.capitalizingFirstLetter() + " " + lName.capitalizingFirstLetter(), for: .normal)
        }
    }
}

extension CreateJobForOrderViewController: DatePickerDelegate {
    func didSelectDate(date: Date) {
        viewModel.job.datetime = date
        dateTF.text = date.getDateStringFromDate()
        timeTF.text = date.getTimeStringFromDate()
    }
}
