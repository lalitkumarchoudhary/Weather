//
//  Extensions.swift
//  WeatherApp
//
//  Created by Lalit Kumar on 30/10/18.
//  Copyright © 2018 Lalit Kumar. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertController(withTitle title: String?,
                             message: String?,
                             actionTitle: String = "Okay",
                             actionAlertStyle: UIAlertActionStyle = .default,
                             isShowCancel: Bool = false,
                             cancelActionTitle: String = "Cancel",
                             cancelActionAlertStyle: UIAlertActionStyle = .default,
                             actionHandler: ((UIAlertAction?) -> Void)? = nil,
                             cancelHandler: ((UIAlertAction?) -> Void)? = nil,
                             completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if isShowCancel {
            alertController.addAction(UIAlertAction(title: cancelActionTitle, style: cancelActionAlertStyle, handler: cancelHandler))
        }
        alertController.addAction(UIAlertAction(title: actionTitle, style: actionAlertStyle, handler: actionHandler))
        self.present(alertController, animated: true, completion: completion)
    }
}
