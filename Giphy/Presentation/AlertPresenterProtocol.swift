//
//  AlertPresenterProtocol.swift
//  Giphy
//
//  Created by Viktoria Lobanova on 06.01.2023.
//

import UIKit

protocol AlertPresenterProtocol {
    var controller: UIViewController? { get set }
    func showAlert(_ model: AlertModel)
}
