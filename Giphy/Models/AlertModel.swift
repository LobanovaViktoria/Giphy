//
//  AlertModel.swift
//  Giphy
//
//  Created by Viktoria Lobanova on 07.01.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let action: (UIAlertAction) -> Void
}
