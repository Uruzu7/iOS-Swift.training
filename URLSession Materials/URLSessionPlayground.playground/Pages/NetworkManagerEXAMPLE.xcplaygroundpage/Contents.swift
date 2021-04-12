import Foundation

typealias NetworkingResult = Result<[Beer], BeersApiError>

enum BeersApiError: Error, LocalizedError {
    case invalidURL
    case badResponse
    case noData
    case noResponseBody

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Provided URL is invalid!"
        case .badResponse:
            return "Bad response!"
        case .noData:
            return "No data was retrieved"
        case .noResponseBody:
            return "No response body"
        }
    }
}

protocol NetworkClient {
    func getBeers(completionHandler: @escaping (NetworkingResult) -> Void)
}

public class NetworkManager: NetworkClient {
    func getBeers(completionHandler: @escaping (NetworkingResult) -> Void) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers") else {
            print("Invalid URL")
            completionHandler(.failure(BeersApiError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in

            guard let data = data,
                error == nil else {
                    print("error=\(String(describing: error))")
                    completionHandler(.failure(BeersApiError.noData))
                    return
            }

            do {
                let beers = try JSONDecoder().decode([Beer].self, from: data)
                completionHandler(.success(beers))
            } catch let error as NSError {
                print(error)
                completionHandler(.failure(BeersApiError.noResponseBody))
            }
        }
        dataTask.resume()
    }
}
