//
//  SideMenuMainViewController+Extension.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import Foundation
import UIKit
import RealmSwift

extension HomePageViewController {
    
    //Function to set the side menu properties
    func setSideMenuProperties() {
        // Shadow Background View
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .black
        self.sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        if self.revealSideMenuOnTop {
            // view.insertSubview(self.sideMenuShadowView, at: 1)
            self.view.insertSubview(self.sideMenuShadowView, aboveSubview: self.view)
        }
        
        // Side Menu
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.sideMenuViewController = storyboard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.sideMenuControllerID) as? SidemenuViewController
        self.sideMenuViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
        self.sideMenuViewController.delegate = self
        self.view.insertSubview(self.sideMenuViewController!.view, aboveSubview: self.view)
        //        view.insertSubview(self.sideMenuViewController!.view, at: self.revealSideMenuOnTop ? 2 : 0)
        addChild(self.sideMenuViewController!)
        self.sideMenuViewController!.didMove(toParent: self)
        
        // Side Menu AutoLayout
        
        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
            self.sideMenuTrailingConstraint?.isActive = true
        }
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        //        // Side Menu Gestures
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        // Default Main View Controller
        //    self.showViewController(viewController: UINavigationController.self, storyboardId: Storyboard.storyBoardControllerID.homeControllerID, StoryBoardName: Storyboard.storyBoardName.homeBoard)
    }
    
    // Keep the state of the side menu (expanded or collapse) in rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint?.constant = self.isExpanded ? 0 : (-self.sideMenuRevealWidth - self.paddingForRotation)
            }
        }
    }
    
    func animateShadow(targetPosition: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            // When targetPosition is 0, which means side menu is expanded, the shadow opacity is 0.6
            self.sideMenuShadowView.alpha = (targetPosition == 0) ? 0.6 : 0.0
        }
    }
    
    func sideMenuState(expanded: Bool, typeOfView : String) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
            
            //If it is home view controller
            self.navigationItem.searchController?.searchBar.isHidden = false
            self.title = UIConstants.HomePage.homePageTitle
        }
    }
    
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint?.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//MARK:- Protocol extension

extension HomePageViewController : SideMenuViewControllerDelegate {
    
    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            // Home
            self.sideMenuState(expanded: self.isExpanded ? false : true, typeOfView: "HOME")
            
        case 1:
            // doctor info
            self.showViewController(viewController: UINavigationController.self, storyboardId: Storyboard.storyBoardControllerID.doctorInfoVCID, StoryBoardName: Storyboard.storyBoardName.homeBoard)
        case 2:
            //log out
            getAlertFOrLogOut(controllerToInduce: self)
            break
        default:
            break
        }
        
        // Collapse side menu with animation
        DispatchQueue.main.async { self.sideMenuState(expanded: false, typeOfView: "HOME") }
    }
    
    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String, StoryBoardName : String) -> () {
        pushNavControllerStyle(storyBoardName: StoryBoardName, vcId: storyboardId, viewControllerName: self)
    }
}

extension UIViewController {
    
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> HomePageViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is HomePageViewController {
            return viewController! as? HomePageViewController
        }
        while (!(viewController is HomePageViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is HomePageViewController {
            return viewController as? HomePageViewController
        }
        return nil
    }
    
    func setUserRoleAndNameOnNavBar() {
        // Add patient's name to nav bar for easy identification
        let user = RealmManager.shared.app.currentUser?.customData as? Dictionary<String, AnyObject>
        let userRole = user?["userType"] as? RealmSwift.AnyBSON
        let firstName = user?["firstName"] as? RealmSwift.AnyBSON
        let lastName = user?["lastName"] as? RealmSwift.AnyBSON
        self.navigationItem.prompt = "\(userRole?.stringValue?.capitalizingFirstLetter() ?? "Practitioner") - \(firstName?.stringValue ?? "") \(lastName?.stringValue ?? "")"
    }

}


extension HomePageViewController: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false, typeOfView: "HOME")
            }
        }
    }
    
    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            return false
        }
        return true
    }
    
    // Dragging Side Menu
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        guard gestureEnabled == true else { return }
        
        let position: CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x
        
        switch sender.state {
        case .began:
            
            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
            if velocity > 0, self.isExpanded {
                sender.state = .cancelled
            }
            
            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
            if velocity > 0, !self.isExpanded {
                self.draggingIsEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging
            else if velocity < 0, self.isExpanded {
                self.draggingIsEnabled = true
            }
            
            if self.draggingIsEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpanded ? false : true, typeOfView: "HOME")
                    self.draggingIsEnabled = false
                    return
                }
                
                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpanded {
                        self.panBaseLocation = self.sideMenuRevealWidth
                    }
                }
            }
            
        case .changed:
            
            // Expand/Collapse side menu while dragging
            if self.draggingIsEnabled {
                if self.revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
                    
                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    self.sideMenuShadowView.alpha = alpha
                    
                    // Move side menu while dragging
                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTrailingConstraint?.constant = xLocation - self.sideMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                        // Show/Hide shadow background view while dragging
                        let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
                        
                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        self.sideMenuShadowView.alpha = alpha
                        
                        // Move side menu while dragging
                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            self.draggingIsEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animation
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint?.constant ?? 0 > -(self.sideMenuRevealWidth * 0.5)
                self.sideMenuState(expanded: movedMoreThanHalf, typeOfView: "HOME")
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf, typeOfView: "HOME")
                }
            }
        default:
            break
        }
    }
}
