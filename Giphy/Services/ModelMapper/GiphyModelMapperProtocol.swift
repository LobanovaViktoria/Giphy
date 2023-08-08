// Протокол для маппинга сетевой модели в бизнес модель гифок
// Разделение моделей часто используется, чтобы каждая модель работала со своим слоем
// Напрмиер сетевая модель используется в сетевом слое (URLSession)
// А бизнес модель используется в ViewModel или Presenter для подготовки к показу на экране
protocol GiphyModelMapperProtocol {
    // Преобразуем сетевую модель в бизнес модель
    func map(model: GiphyAPIModel) -> GiphyModel?
}
