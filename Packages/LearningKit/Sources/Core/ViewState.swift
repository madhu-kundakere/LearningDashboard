public enum ViewState<Value: Sendable>: Sendable {
    case idle
    case loading
    case loaded(Value)
    case empty
    case failed(AppError)

    public var value: Value? {
        guard case .loaded(let value) = self else { return nil }
        return value
    }
}

extension ViewState: Equatable where Value: Equatable {}
