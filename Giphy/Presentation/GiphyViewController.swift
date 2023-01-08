import UIKit

// Экран на котором показываются гифки
final class GiphyViewController: UIViewController {
    
    // Переменная Int -- Счетчик залайканых или задизлайканных гифок
    // Например showGifCounter -- счетчика показанных гифок
    private var showGifCounter: Int = 0
    
    // Переменная Int -- Количество понравившихся гифок
    // Например likedGifCounter -- счетчик любимых гифок
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    private var likedGifCounter: Int = 0
    
    private var alertPresenter: AlertPresenterProtocol?
    
    // @IBOutlet UILabel для счетчика гифок, например 1/10
    // Например -- @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    // @IBOutlet UIImageView для Гифки
    // Например -- @IBOutlet weak var giphyImageView: UIImageView!
    @IBOutlet weak var giphyImageView: UIImageView!
    
    // @IBOutlet UIActivityIndicatorView загрузки гифки, так как она может загрухаться долго
    @IBOutlet weak var giphyActivityIndicatorView: UIActivityIndicatorView!
    
    // Нажатие на кнопку лайка
    @IBAction func onYesButtonTapped(_ sender: Any) {
        giphyImageView.layer.masksToBounds = true
        giphyImageView.layer.borderWidth = 8
        giphyImageView.layer.borderColor = UIColor.ypGreen.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        // Проверка на то просмотрели или нет 10 гифок
        if showGifCounter < 10 {
            // Иначе, если еще не просмотрели 10 гифок, то увеличиваем счетчик и обновляем UIlabel с счетчиком
            
            // Сохраняем понравившуюся гифку
            // presenter.saveGif(<Созданный UIImageView для @IBOutlet>.image)
            presenter.saveGif(giphyImageView.image)
            
            // Загружаем следующую гифку
            presenter.fetchNextGiphy()
            
            // увеличиваем счетчик понравившихся гифок
            likedGifCounter += 1
        } else {
            // Если все 10 гифок просомтрели необходимо показать UIAlertController о завершении
            // При нажатии на кнопку в UIAlertController необходимо сбросить счетчики и начать сначала
            showEndOfGiphy()
        }
    }
    
    // Нажатие на кнопку дизлайка
    @IBAction func onNoButtonTapped(_ sender: Any) {
        giphyImageView.layer.masksToBounds = true
        giphyImageView.layer.borderWidth = 8
        giphyImageView.layer.borderColor = UIColor.ypRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        // Проверка на то просмотрели или нет 10 гифок
        if showGifCounter < 10 {
            //  если еще не просмотрели 10 гифок, то увеличиваем счетчик и обновляем UIlabel с счетчиком
            
            // Загружаем следующую гифку
            presenter.fetchNextGiphy()
        } else {
            
            // При нажатии на кнопку в UIAlertController необходимо сбросить счетчики и начать
            // Если все 10 гифок просомтрели необходимо показать UIAlertController о завершении
            showEndOfGiphy()
            
        }
    }
    
    private func showEndOfGiphy() {
        let action: (UIAlertAction) -> Void = { _ in
            self.restart()
        }
        let alertModel = AlertModel(title: "Мемы закончились!",
                                    message: "Вам понравилось \(likedGifCounter)/10",
                                    buttonText: "Хочу посмотреть еще \nгифок",
                                    action: action)
        alertPresenter?.showAlert(alertModel)
    }
    
    
    // Слой Presenter - бизнес логика приложения, к которым должен общаться UIViewController
    private lazy var presenter: GiphyPresenterProtocol = {
        let presenter = GiphyPresenter()
        presenter.viewController = self
        return presenter
    }()
    
    // MARK: - Жизенный цикл экрана
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restart()
        alertPresenter = AlertPresenter()
        alertPresenter?.controller = self
    }
}

// MARK: - Приватные методы

private extension GiphyViewController {
    // Учеличиваем счетчик просмотренных гифок на 1
    // Обновляем UILabel который находится в верхнем UIStackView и отвечает за количество просмотренных гифок
    // Обновляем счетчик просмотренных гифок UIlabel
    func updateCounterLabel() {
        showGifCounter += 1
        counterLabel.text = "\(showGifCounter)/10"
    }
    
    // Перезапускаем счетчики просмотренных гифок и понравивишихся гифок
    // Обновляем UILabel который находится в верхнем UIStackView и отвечает за количество просмотренных гифок
    // Загружаем гифку
    func restart() {
        presenter.fetchNextGiphy()
        showGifCounter = 0
        likedGifCounter = 0
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
                                    message: "не возможно загрузить данные",
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
}
