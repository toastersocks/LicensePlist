import Foundation
import LoggerAPI

public class ResultOperation<T, E: Error>: Operation, @unchecked Sendable {
    typealias ResultType = Result<T, E>
    var result: ResultType?
    let closure: ((ResultOperation) -> ResultType)
    init(_ closure: @escaping ((ResultOperation) -> ResultType)) {
        self.closure = closure
    }
    public override func main() {
        if isCancelled {
            Log.debug("cancelled")
            return
        }
        result = closure(self)
    }
    func resultSync() -> ResultType {
        if !isFinished {
            OperationQueue().addOperations([self], waitUntilFinished: true)
        }
        return result!
    }
}
