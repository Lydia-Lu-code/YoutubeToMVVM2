//
//  ContainerViewController.swift
//  YoutubeViewController
//
//  Created by Lydia Lu on 2024/4/15.
//
import UIKit

class ContainerVC: UIViewController {

    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    let menuVC = MenuVC()
    let homeVC = HomeViewController(vcType: .home)
    var navVC: UINavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = .red
        addChildVCs()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            view.addGestureRecognizer(panGesture)
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .left
        view.addGestureRecognizer(swipeGesture)
    }
  
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        
        if gesture.direction == .left && menuState == .opened {
            animateMenu(shouldOpen: false)
        }

        
    }
    

    private func addChildVCs() {
        // Menu
//        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        // Home
//        homeVC.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
    
    
}

extension ContainerVC {
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        let menuWidth = view.frame.width * 0.75
        
        if menuState == .opened && location.x > menuWidth {
                animateMenu(shouldOpen: false)
            }
        }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        
        switch recognizer.state {
        case .changed:
            var xPosition = translation.x
            
            if menuState == .closed {
                xPosition = min(view.frame.width * 0.75, xPosition)
            } else {
                xPosition = max(0, xPosition)
            }
            
            menuVC.view.frame.origin.x = xPosition
            homeVC.view.frame.origin.x = xPosition
        case .ended:
            if menuState == .closed {
                if translation.x < view.frame.width / 2 {
                    animateMenu(shouldOpen: true)
                } else {
                    animateMenu(shouldOpen: false)
                }
            } else {
                if translation.x > view.frame.width / 2 {
                    animateMenu(shouldOpen: false)
                } else {
                    animateMenu(shouldOpen: true)
                }
            }
        default:
            break
        }
    }
    
    func animateMenu(shouldOpen: Bool) {
        if shouldOpen {
            menuState = .opened
            animateHomeVCPosition(targetPosition: view.frame.width * 0.75)
        } else {
            menuState = .closed
            animateHomeVCPosition(targetPosition: 0)
        }
    }
    
    func animateHomeVCPosition(targetPosition: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            let xPosition = self.view.frame.width * (targetPosition / self.view.frame.width)
            self.menuVC.view.frame.origin.x = xPosition

        }
    }
}
