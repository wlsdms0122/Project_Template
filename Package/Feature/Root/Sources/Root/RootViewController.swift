//
//  RootViewController.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import UIKit
import RVB
import Route
import Launch
import Main

public protocol RootControllable: UIViewControllable {
    
}

final class RootViewController: UINavigationController, RootControllable {
    // MARK: - View

    // MARK: - Property
    var router: (any RootRoutable)?
    
    // MARK: - Initializer

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        
    }
    
    private func setUpState() {
        // Hide top navigtaion bar
        isNavigationBarHidden = true
        
        // Route to launch.
        presentLaunch(animated: false)
    }
    
    private func setUpAction() {
        
    }
    
    /// Present `Launch` module.
    func presentLaunch(
        animated: Bool,
        force: Bool = true,
        completion: ((LaunchControllable) -> Void)? = nil
    ) {
        if let launch = search(where: { $0 is LaunchControllable })
            .last as? LaunchControllable {
            guard force else {
                completion?(launch)
                return
            }
            
            route(launch, animated: animated) { _ in
                completion?(launch)
            }
            return
        }
        
        guard let launch = router?.routeToLaunch(
            with: .init()
        )
        else { return }
        
        launch.delegate = self
        
        delegate = launch
        
        viewControllers = [launch]
        completion?(launch)
    }
    
    /// Present `Main` module.
    func presentMain(
        animated: Bool,
        force: Bool = true,
        completion: ((MainControllable) -> Void)? = nil
    ) {
        if let main = search(where: { $0 is MainControllable })
            .last as? MainControllable {
            guard force else {
                completion?(main)
                return
            }
            
            route(main, animated: animated) { _ in
                completion?(main)
            }
            return
        }
        
        guard let main = router?.routeToMain(
            with: .init()
        )
        else { return }
        
        setViewControllers([main], animated: true)
        completion?(main)
    }
}

extension RootViewController: LaunchDelegate {
    func launch(_ launchController: LaunchControllable, didComplete state: LaunchState) {
        presentMain(animated: true)
    }
}
