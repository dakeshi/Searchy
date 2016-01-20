import Foundation
import RxSwift

public protocol DisposableCollection {
    typealias AddDisposableReturnType
    
    func addDisposable(disposable: Disposable) -> AddDisposableReturnType
}

extension CompositeDisposable: DisposableCollection {
    public typealias AddDisposableReturnType = DisposeKey?
}

extension DisposeBag: DisposableCollection {
    public typealias AddDisposableReturnType = Void
}

infix operator ++ {
associativity left

// Binds same as addition
precedence 140
}

public func ++<T: DisposableCollection>(composite: T, disposable: Disposable) -> T {
	composite.addDisposable(disposable)
	return composite
}

public func ++<T: DisposableCollection>(disposable: Disposable, composite: T) -> T {
	return composite ++ disposable
}

infix operator <~ {
associativity right

// Binds tighter than addition
precedence 141
}

@warn_unused_result(message="http://git.io/rxs.ud")
public func <~<O: ObservableType>(variable: Variable<O.E>, observable: O) -> Disposable {
    return observable.bindTo(variable)
}

@warn_unused_result(message="http://git.io/rxs.ud")
public func <~<T>(variable1: Variable<T>, variable2: Variable<T>) -> Disposable {
    return variable2.asObservable().bindTo(variable1)
}

@warn_unused_result(message="http://git.io/rxs.ud")
public func <~<Source: ObservableType, Destination: ObserverType where Source.E == Destination.E>(observer: Destination, observable: Source) -> Disposable {
	return observable.subscribe(observer)
}

@warn_unused_result(message="http://git.io/rxs.ud")
public func <~<Source: ObservableType>(observer: (Source.E)->Void, observable: Source) -> Disposable {
	return observable.subscribeNext(observer)
}