//
//  JobsFilterViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 22/02/22.
//

import UIKit

protocol JobsFilterDelegate  {
    func didSelectFilters(jobType: JobType?, jobStatus: JobStatus?)
}

class JobsFilterViewController: BaseViewController {
    var viewModel = SlideUpSelectionViewModel()
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var deliveryBtn: UIButton!
    @IBOutlet weak var installationBtn: UIButton!
    @IBOutlet weak var todoBtn: UIButton!
    @IBOutlet weak var inProgressBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!

    var delegate: JobsFilterDelegate?
    var jobTypeFilter: JobType?
    var jobStatusFilter: JobStatus?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.makeRoundCornerWithoutBorder(withRadius: 15)
    }

    
    // MARK: - Actions
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func jobtypeBtnAction(_ sender: UIButton) {
        if sender.tag == 0 {
            jobTypeFilter = JobType.delivery
            selectDelivery()
        } else {
            jobTypeFilter = JobType.installation
            selectInstallation()
        }
        self.delegate?.didSelectFilters(jobType: self.jobTypeFilter, jobStatus: self.jobStatusFilter)
    }

    @IBAction func jobStatusBtnAction(_ sender: UIButton) {
        if sender.tag == 0 {
            jobStatusFilter = JobStatus.todo
            selectTodo()
        } else if sender.tag == 1  {
            jobStatusFilter = JobStatus.inprogress
            selectInProgress()
        } else {
            jobStatusFilter = JobStatus.done
            selectDone()
        }
        self.delegate?.didSelectFilters(jobType: self.jobTypeFilter, jobStatus: self.jobStatusFilter)
    }

    // MARK: - private methods
    
    private func selectDelivery(){
        deliveryBtn.isSelected = true;
        deliveryBtn.setImage(#imageLiteral(resourceName: "circle_selected"), for: .normal)
        installationBtn.isSelected = false;
        installationBtn.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
     }
    private func selectInstallation(){
        deliveryBtn.isSelected = false;
        deliveryBtn.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        installationBtn.isSelected = true;
        installationBtn.setImage(#imageLiteral(resourceName: "circle_selected"), for: .normal)
    }
    
    private func selectTodo() {
        todoBtn.isSelected = true;
        todoBtn.setImage(#imageLiteral(resourceName: "circle_selected"), for: .normal)
        inProgressBtn.isSelected = false;
        inProgressBtn.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        doneBtn.isSelected = false;
        doneBtn.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
    }
    
    private func selectInProgress() {
        todoBtn.isSelected = false;
        todoBtn.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        inProgressBtn.isSelected = true;
        inProgressBtn.setImage(#imageLiteral(resourceName: "circle_selected"), for: .normal)
        doneBtn.isSelected = false;
        doneBtn.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
    }
    
    private func selectDone() {
        todoBtn.isSelected = false;
        todoBtn.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        inProgressBtn.isSelected = false;
        inProgressBtn.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        doneBtn.isSelected = true;
        doneBtn.setImage(#imageLiteral(resourceName: "circle_selected"), for: .normal)
    }
}

