class Observable<T> {
    var value: T {
        didSet {
            for observer in observers {
                observer(value)
            }
        }
    }
    
    private var observers: [(T) -> Void] = []
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ observer: @escaping (T) -> Void) {
        observers.append(observer)
        observer(value)
    }
}
