import UIKit

// Экран на котором показываются гифки
final class GiphyViewController: UIViewController {
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var alertPresenter: AlertPresenterProtocol?
    
    // @IBOutlet UILabel для счетчика гифок, например 1/10
    // Например -- @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    // @IBOutlet UIImageView для Гифки
    // Например -- @IBOutlet weak var giphyImageView: UIImageView!
    @IBOutlet private weak var giphyImageView: UIImageView!
    
    // @IBOutlet UIActivityIndicatorView загрузки гифки, так как она может загружаться долго
    @IBOutlet private weak var giphyActivityIndicatorView: UIActivityIndicatorView!
    
    // Слой Presenter - бизнес логика приложения, к которым должен общаться UIViewController
    private lazy var presenter: GiphyPresenterProtocol = {
        let presenter = GiphyPresenter()
        presenter.viewController = self
        return presenter
    }()
    
    // MARK: - Жизненный цикл экрана
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.restart()
        alertPresenter = AlertPresenter()
        alertPresenter?.controller = self
    }
}

// MARK: - Приватные методы

private extension GiphyViewController {
    
    // Нажатие на кнопку лайка
    @IBAction func onYesButtonTapped(_ sender: Any) {
        disableButtons()
        highLightBorder(with: UIColor.ypGreen)
        presenter.onYesButtonTapped()
    }
    
    // Нажатие на кнопку дизлайка
    @IBAction func onNoButtonTapped(_ sender: Any) {
        disableButtons()
        highLightBorder(with: UIColor.ypRed)
        presenter.onNoButtonTapped()
    }
    
    // Учеличиваем счетчик просмотренных гифок на 1
    // Обновляем UILabel который находится в верхнем UIStackView и отвечает за количество просмотренных гифок
    // Обновляем счетчик просмотренных гифок UIlabel
    func updateCounterLabel() {
        counterLabel.text = "\(presenter.showGifCount())/10"
    }
    
    // Подсвечивание рамки в нужный цвет
    func highLightBorder(with color: UIColor) {
        giphyImageView.layer.masksToBounds = true
        giphyImageView.layer.borderWidth = 8
        giphyImageView.layer.borderColor = color.cgColor
    }
    
    // Деактивация кнопок
    func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
}

// MARK: - GiphyViewControllerProtocol

extension GiphyViewController: GiphyViewControllerProtocol {
    // Показ ошибки UIAlertController, что не удалось загрузить гифку
    func showError() {
        // Необходимо показать UIAlertController
        // Заголовок -- Что-то пошло не так(
        // Сообщение -- не возможно загрузить данные
        // Кнопка -- Попробовать еще раз
        // При нажатии на кнопку необходимо перезагрузить гифку
        let action: (UIAlertAction) -> Void = { _ in
            self.presenter.fetchNextGiphy()
        }
        let alertModel = AlertModel(title: "Что-то пошло не так(",
                                    message: "невозможно загрузить данные",
                                    buttonText: "Попробовать еще раз",
                                    action: action)
        alertPresenter?.showAlert(alertModel)
    }
    
    // Показать гифку UIImage
    func showGiphy(_ image: UIImage?) {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        giphyImageView.image = image
        giphyImageView.contentMode = .scaleAspectFill
        giphyImageView.layer.borderWidth = 0
        updateCounterLabel()
    }
    
    // Показать лоадер
    func showLoader() {
        giphyActivityIndicatorView.startAnimating()
    }
    
    // Остановить giphyActivityIndicatorView показа индикатора загрузки
    func hideLoader() {
        giphyActivityIndicatorView.stopAnimating()
    }
    
    // возвращает текущую гифку
    func currentGif() -> UIImage? {
        giphyImageView.image
    }
    
    func showEndOfGiphy() {
        let action: (UIAlertAction) -> Void = { _ in
            self.presenter.restart()
        }
        let alertModel = AlertModel(title: "Мемы закончились!",
                                    message: "Вам понравилось \(presenter.likedGifCount())/10",
                                    buttonText: "Хочу посмотреть еще гифок",
                                    action: action)
        alertPresenter?.showAlert(alertModel)
    }
}
