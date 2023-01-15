import UIKit

// Протокол для общения между View и Presetner слоями
protocol GiphyPresenterProtocol: AnyObject {
    // Конструктор слоя Presetner
    init(giphyFactory: GiphyFactoryProtocol)

    // Метод получения случайной гифки
    func fetchNextGiphy()
    
    func onYesButtonTapped()
    
    func onNoButtonTapped()
    
    func likedGifCount() -> Int
    
    func showGifCount() -> Int
    
    func restart()
}
