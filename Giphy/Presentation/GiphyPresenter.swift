import UIKit
import Photos

// Presetner (бизнес слой для получения следующей гифки)
final class GiphyPresenter: GiphyPresenterProtocol {
    private var giphyFactory: GiphyFactoryProtocol
    
    // Слой View для общения и отображения случайной гифки
    weak var viewController: GiphyViewControllerProtocol?
    
    //Счетчик залайканых или задизлайканных гифок
    private var showGifCounter: Int = 0
    
    //Количество понравившихся гифок
    private var likedGifCounter: Int = 0
    
    // MARK: - GiphyPresenterProtocol
    
    init(giphyFactory: GiphyFactoryProtocol = GiphyFactory()) {
        self.giphyFactory = giphyFactory
        self.giphyFactory.delegate = self
    }
    
    // Сохранение гифки
    private func saveGif(_ image: UIImage?) {
        guard let data = image?.pngData() else {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, data: data, options: nil)
        })
    }
    
    // Загрузка следующей гифки
    func fetchNextGiphy() {
        // Необходимо показать лоадер
        viewController?.showLoader()
        
        // Обратиться к фабрике и начать грузить новую гифку
        giphyFactory.requestNextGiphy()
    }
    
    func onYesButtonTapped() {
        if showGifCounter < 10 {
            // Иначе, если еще не просмотрели 10 гифок, то увеличиваем счетчик и обновляем UIlabel с счетчиком
            
            // Сохраняем понравившуюся гифку
            saveGif(viewController?.currentGif())
            
            // Загружаем следующую гифку
            fetchNextGiphy()
            
            // увеличиваем счетчик понравившихся гифок
            likedGifCounter += 1
        } else {
            // Если все 10 гифок просомтрели необходимо показать UIAlertController о завершении
            // При нажатии на кнопку в UIAlertController необходимо сбросить счетчики и начать сначала
            viewController?.showEndOfGiphy()
        }
    }
    
    func onNoButtonTapped() {
        // Проверка на то просмотрели или нет 10 гифок
        if showGifCounter < 10 {
            //  если еще не просмотрели 10 гифок, то увеличиваем счетчик и обновляем UIlabel с счетчиком
            
            // Загружаем следующую гифку
            fetchNextGiphy()
        } else {
            // При нажатии на кнопку в UIAlertController необходимо сбросить счетчики и начать
            // Если все 10 гифок просомтрели необходимо показать UIAlertController о завершении
            viewController?.showEndOfGiphy()
        }
    }
    
    func likedGifCount() -> Int {
        likedGifCounter
    }
    
    func showGifCount() -> Int {
        showGifCounter
    }
    
    // Перезапускаем счетчики просмотренных гифок и понравивишихся гифок
    // Обновляем UILabel который находится в верхнем UIStackView и отвечает за количество просмотренных гифок
    // Загружаем гифку
    func restart() {
        fetchNextGiphy()
        showGifCounter = 0
        likedGifCounter = 0
    }
}

// MARK: - GiphyFactoryDelegate

extension GiphyPresenter: GiphyFactoryDelegate {
    // Успешная загрузка гифки
    func didRecieveNextGiphy(_ giphy: GiphyModel) {
        // Преобразуем набор картинок в гифку
        let image = UIImage.gif(url: giphy.url)
        showGifCounter += 1
        // !Обратите внимание в каком потоке это вызывается и нужно ли вызывать дополнительно!
        DispatchQueue.main.async { [weak self] in
            // Останавливаем индикатор загрузки --
            self?.viewController?.hideLoader()
            // Показать гифку --
            self?.viewController?.showGiphy(image)
        }
    }
    // При загрузке гифки произошла ошибка
    func didReciveError(_ error: GiphyError) {
        // !Обратите внимание в каком потоке это вызывается и нужно ли вызывать дополнительно!
        DispatchQueue.main.async { [weak self] in
            // Останавливаем индикатор загрузки --
            self?.viewController?.hideLoader()
            
            // Показать ошибку --
            self?.viewController?.showError()
        }
    }
}
