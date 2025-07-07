//
//  Utility.swift
//  Assignment-Technozis
//
//  Created by abh on 07/07/25.
//

import UIKit
import ObjectiveC

class Utility: NSObject {
    
    class func showAlertBox(on viewController: UIViewController,
                            title: String = "Alert",
                            message: String,
                            okTitle: String = "OK",
                            completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { _ in
            completion?()
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showToastBanner(on parentView: UIView? = nil,
                                   title: String,
                                   subtitle: String,
                                   icon: UIImage?,
                                   backgroundColor: UIColor,
                                   duration: TimeInterval = 3.5) {
           DispatchQueue.main.async {

               // 0. Resolve container view
               guard let container = parentView ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                   print("❌ Utility: No parent view / key window")
                   return
               }

               // 1. Banner view setup
               let banner = UIView()
               banner.translatesAutoresizingMaskIntoConstraints = false
               banner.backgroundColor = backgroundColor
               banner.alpha = 0
               banner.layer.cornerRadius = 8
               banner.clipsToBounds = true

               container.addSubview(banner)
               let safe = container.safeAreaLayoutGuide

               NSLayoutConstraint.activate([
                   banner.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
                   banner.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
                   banner.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -20)
               ])

               // 2. ImageView (optional)
               var iconImageView: UIImageView?
               if let icon = icon {
                   let imgView = UIImageView(image: icon)
                   imgView.translatesAutoresizingMaskIntoConstraints = false
                   imgView.contentMode = .scaleAspectFit
                   imgView.tintColor = .white
                   banner.addSubview(imgView)
                   iconImageView = imgView
               }

               // 3. Title and subtitle
               let titleLabel = UILabel()
               titleLabel.translatesAutoresizingMaskIntoConstraints = false
               titleLabel.text = title
               titleLabel.font = .boldSystemFont(ofSize: 16)
               titleLabel.textColor = .white
               titleLabel.numberOfLines = 0

               let subtitleLabel = UILabel()
               subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
               subtitleLabel.text = subtitle
               subtitleLabel.font = .systemFont(ofSize: 14)
               subtitleLabel.textColor = .white
               subtitleLabel.numberOfLines = 0

               banner.addSubview(titleLabel)
               banner.addSubview(subtitleLabel)

               // 4. Constraints for icon and labels
               var constraints: [NSLayoutConstraint] = []

               if let img = iconImageView {
                   constraints += [
                       img.leadingAnchor.constraint(equalTo: banner.leadingAnchor, constant: 12),
                       img.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                       img.widthAnchor.constraint(equalToConstant: 24),
                       img.heightAnchor.constraint(equalToConstant: 24),

                       titleLabel.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 8)
                   ]
               } else {
                   constraints += [
                       titleLabel.leadingAnchor.constraint(equalTo: banner.leadingAnchor, constant: 16)
                   ]
               }

               constraints += [
                   titleLabel.topAnchor.constraint(equalTo: banner.topAnchor, constant: 12),
                   titleLabel.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -16),

                   subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                   subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                   subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                   subtitleLabel.bottomAnchor.constraint(equalTo: banner.bottomAnchor, constant: -12)
               ]

               NSLayoutConstraint.activate(constraints)

               container.layoutIfNeeded()

               // 5. Animate in
               let originalTransform = banner.transform
               banner.transform = originalTransform.translatedBy(x: 0, y: banner.bounds.height)
               UIView.animate(withDuration: 0.3) {
                   banner.alpha = 1
                   banner.transform = originalTransform
               }

               // 6. Auto-dismiss after duration
               DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                   UIView.animate(withDuration: 0.3, animations: {
                       banner.alpha = 0
                   }) { _ in
                       banner.removeFromSuperview()
                   }
               }
           }
       }
    
    class func showInteractiveAlertBox(on viewController: UIViewController,
                                title: String = "Confirm",
                                message: String,
                                yesTitle: String = "Yes",
                                noTitle: String = "No",
                                yesHandler: (() -> Void)? = nil,
                                noHandler: (() -> Void)? = nil) {
            
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: yesTitle, style: .default) { _ in
                yesHandler?()
            }
            
            let noAction = UIAlertAction(title: noTitle, style: .cancel) { _ in
                noHandler?()
            }
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            viewController.present(alert, animated: true)
        }
}

