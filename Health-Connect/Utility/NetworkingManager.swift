
import Foundation

final class NetworkingManager {
    
    static let shared = NetworkingManager() // Singleton instance
    
    private init() {}
    
    // Generic function to perform GET request and decode response
    func fetchData<T: Codable>(from urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkingError.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

// Custom networking errors
enum NetworkingError: Error {
    case invalidURL
    case noData
}
