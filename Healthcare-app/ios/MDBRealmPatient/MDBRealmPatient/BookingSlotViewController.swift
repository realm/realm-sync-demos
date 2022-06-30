//
//  BookingSlotViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/25/22.
//

import UIKit

class BookingSlotViewController: BaseViewController {
    @IBOutlet weak var bookingButton : UIButton! {
        didSet {
            self.bookingButton.setTitle(ConstantsID.BookingControllerID.bookingButtonName, for: .normal)
        }
    }
    @IBOutlet weak var doctorImage        : UIImageView! {
        didSet {
            self.doctorImage.contentMode = .scaleAspectFill
            self.doctorImage.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var conditionTextField: UITextField! {
        didSet {
            self.conditionTextField.placeholder = ConstantsID.SignUpControllerID.condition
            self.conditionTextField.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var calendarView             : FSCalendar!
    @IBOutlet weak var collectionView           : UICollectionView!
    @IBOutlet weak var doctorName               : UILabel!
    @IBOutlet weak var doctorDescription        : UILabel!
    @IBOutlet weak var noAppointmentsAvailable              : UILabel!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MM d, yyyy"
        return formatter
    }()
    fileprivate lazy var dateFilterFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    @IBOutlet var viewModel: BookingSlotViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNav()
        self.title = "Available slots"
        self.setUserRoleAndNameOnNavBar()

        if let urlStr =  self.viewModel.practitionerRole?.practitioner?.photo.first?.data {
            self.doctorImage.image = urlStr.convertBase64ToImage()
        } else {
            self.doctorImage.image = UIImage(named: "placeholder")
        }
        
        self.collectionView.register(UINib(nibName: "TimeSlotCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeSlotCollectionViewCell")
        
        self.doctorName.text = self.viewModel.practitionerRole?.practitioner?.name?.text
        self.doctorDescription.text = self.viewModel.practitionerRole?.practitioner?.name?.given
        
        self.CalenderViewUpdate()
        self.viewModel.selectedDateString = Date().getMonthYearString()
        self.viewModel.selectedFilterDateString = Date().getOnlyDate()
        self.viewModel.setSlotObjects()
        self.viewModel.filterBySpecifigationTime(timeSpecifigation: "Morning")
        self.collectionView.reloadData()
    }
    func CalenderViewUpdate() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.select(Date())
        self.calendarView.scope = .week
        self.calendarView.headerHeight = 50
        self.calendarView.weekdayHeight = 10
        self.calendarView.calendarHeaderView.scrollEnabled = false
        self.calendarView.appearance.borderRadius = 0.3
        self.calendarView.appearance.headerTitleOffset = .zero
        self.calendarView.appearance.headerTitleAlignment = .center
        self.calendarView.appearance.headerTitleFont = .poppinsSemiBoldFont(withSize: 12)
        self.calendarView.appearance.titleFont = .poppinsMediumFont(withSize: 14)
        self.calendarView.appearance.subtitleFont = .poppinsMediumFont(withSize: 14)
        self.calendarView.appearance.selectionColor = .appPrimaryColor()
//        self.calendarView.appearance.todayColor = .appPrimaryColor()
        self.calendarView.appearance.titleTodayColor = .black
        self.calendarView.appearance.subtitleTodayColor = .black
    }
    // MARK: - IBAction
    @IBAction func actionDidCreateBooking(_ sender: UIButton) {
        self.viewModel.createCondition(onSuccess: {response in
            self.showAlertViewWithBlock(message: "Consultation successfully created.", btnTitleOne: "Ok", btnTitleTwo: "", completionOk: {()in
                if let viewControllers = self.navigationController?.viewControllers {
                       for vc in viewControllers {
                            if vc.isKind(of: DashboardViewController.classForCoder()) {
                                self.navigationController?.popToViewController(vc, animated: true)
                                return
                            }
                       }
                 }
            }, cancel: {()in})
        }, onFailure: {errorMessage in
            self.hideLoader()
            self.showMessage(message: errorMessage)
        })
    }
    @IBAction func actionDidOpenCondition(_ sender: UIButton) {
        if let conditionVC = Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "ConditionBookingViewController") as? ConditionBookingViewController {
            conditionVC.modalPresentationStyle = .overCurrentContext
            conditionVC.delegate = self
            self.navigationController?.pushViewController(conditionVC, animated: true)
        }
    }
    @IBAction func actionDidChangeTimeScecifigation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.viewModel.filterBySpecifigationTime(timeSpecifigation: "Morning")
        } else if sender.selectedSegmentIndex == 1 {
            self.viewModel.filterBySpecifigationTime(timeSpecifigation: "Afternoon")
        } else if sender.selectedSegmentIndex == 2 {
            self.viewModel.filterBySpecifigationTime(timeSpecifigation: "Evening")
        }
        self.collectionView.reloadData()
    }
}
// MARK: - Calendar datasourcee

extension BookingSlotViewController: FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        let maxDate = Calendar.current.date(byAdding: .day, value: 15, to: Date())!
        return maxDate
    }
}
// MARK: - Calendar delegate

extension BookingSlotViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        if date.dayOfWeek()?.uppercased() == "Saturday".uppercased() || date.dayOfWeek()?.uppercased() == "Sunday".uppercased() {
            self.noAppointmentsAvailable.isHidden = false
            self.noAppointmentsAvailable.backgroundColor = .white
        } else {
            self.noAppointmentsAvailable.isHidden = true
            self.noAppointmentsAvailable.backgroundColor = .clear
            self.viewModel.selectedDateString = selectedDates.first ?? ""
            //self.viewModel.setSlotObjects()
        }
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
}

// MARK: - Timeslots Collection View
extension BookingSlotViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.timeSlotFilterObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionViewCell", for: indexPath) as! TimeSlotCollectionViewCell
        let object = self.viewModel.timeSlotFilterObjects[indexPath.row]
        //cell.timeLbl.text = "\(object.startTime)-\(object.endTime)"
        cell.timeLbl.text = object.startTime
        if self.viewModel.selectedTimeSlot.timeslotId == object.timeslotId {
            cell.selectCell()
        } else {
            cell.unselectCell()
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = self.viewModel.timeSlotFilterObjects[indexPath.row]
        self.viewModel.selectedTimeSlot = object
        self.collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 70, height: 40)
    }
}
extension BookingSlotViewController: ConditionDataSource {
    func didSelectForRowAt(object: Any) {
        if let getobject = object as? Condition {
            self.conditionTextField.text = getobject.code?.text
            viewModel.conditionOption = getobject
        }
    }
}
