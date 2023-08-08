import UIKit

protocol AlertPresenterProtocol {
    var controller: UIViewController? { get set }
    func showAlert(_ model: AlertModel)
}
