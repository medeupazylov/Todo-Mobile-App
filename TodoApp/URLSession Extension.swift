import UIKit

extension URLSession {
    
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var task: URLSessionDataTask?
        let cancel = { task?.cancel() }
        
        return try await withTaskCancellationHandler {
            return try await withCheckedThrowingContinuation { continuation in
                task = dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        let error = NSError(domain: "DataTaskError", code: -1, userInfo: nil)
                        continuation.resume(throwing: error)
                    }
                }
                task?.resume()
            }
        } onCancel: {
            print("cancellation of DataTask")
            cancel()
        }
    }
    
}
