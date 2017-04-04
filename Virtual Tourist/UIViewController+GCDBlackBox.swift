//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by Fernando Geraldo Mantoan on 03/04/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
