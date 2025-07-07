//
//  NavigationManager.swift
//  Assignment-Technozis
//
//  Created by abh on 06/07/25.
//

import Foundation
import UIKit

final class NavigationManager {
    
    static let shared = NavigationManager()
    
    private init() {}

    var navigationController: UINavigationController?

    func setRoot(viewController: UIViewController, animated: Bool = true) {
        navigationController?.setViewControllers([viewController], animated: animated)
    }

    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }

    func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController?.present(viewController, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }
}
