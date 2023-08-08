import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var controller: UIViewController?
    
    func showAlert(_ model: AlertModel) {
        let finalAlert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.action)
        finalAlert.addAction(action)
        self.controller?.present(finalAlert, animated: true, completion: nil)
    }
}

