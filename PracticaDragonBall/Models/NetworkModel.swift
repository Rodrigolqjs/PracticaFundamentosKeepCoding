import Foundation

enum NetworkError: Error, Equatable {
    case malformedURL
    case dataFormatting
    case other
    case noData
    case errorCode(Int?)
    case tokenFormatError
    case decoding
}

class NetworkModel {
    
    let session: URLSession
    
    var token: String?
    
    init(urlSession: URLSession = .shared, token: String? = nil) {
      self.session = urlSession
      self.token = token
    }
    
    func login(user: String, password: String, completion: @escaping (String?, NetworkError?) -> Void) {
        
        guard let url = URL(string: "https://vapor2022.herokuapp.com/api/auth/login") else {
            completion(nil, .malformedURL)
            return
        }
        
        let loginString = "\(user):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            completion(nil, .dataFormatting)
            return
        }
        let base64LoginData = loginData.base64EncodedString()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(nil, .other)
                return
            }
            
            guard let data = data else {
                completion(nil, .noData)
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse),
                    httpResponse.statusCode == 200 else {
                completion(nil, .errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }

            guard let token = String(data: data, encoding: .utf8) else {
                completion(nil, .tokenFormatError)
                return
            }
            
            self.token = token
            
            completion(token, nil)
        }
        task.resume()
    }
    
    
    func getHeroes(name: String? = "",
                   completion: @escaping ([Hero], NetworkError?) -> Void) {
        guard let url = URL(string: "https://vapor2022.herokuapp.com/api/heros/all") else {
            completion([], .malformedURL)
            return
        }
        
        guard let token = token else {
            completion([], .tokenFormatError)
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        struct Body: Encodable {
            let name: String
            
        }
        
        let body = Body(name: name ?? "")
        
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion([], .other)
                return
            }
            
            guard let data = data else {
                completion([], .noData)
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse),
                    httpResponse.statusCode == 200 else {
                completion([], .errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }

            guard let herosResponse = try? JSONDecoder().decode([Hero].self, from: data) else {
                completion([], .decoding)
                return
            }
            
            completion(herosResponse, nil)
        }
        task.resume()
    }
    
    func getTransformations(id: String? = "",
                   completion: @escaping ([Transformations], NetworkError?) -> Void) {
        guard let url = URL(string: "https://vapor2022.herokuapp.com/api/heros/tranformations") else {
            completion([], .malformedURL)
            return
        }
        
        guard let token = token else {
            completion([], .tokenFormatError)
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        struct Body: Encodable {
            let id: String
            
        }
        
        let body = Body(id: id ?? "")
        
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion([], .other)
                return
            }
            
            guard let data = data else {
                completion([], .noData)
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse),
                    httpResponse.statusCode == 200 else {
                completion([], .errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }

            guard let TransformationsResponse = try? JSONDecoder().decode([Transformations].self, from: data) else {
                completion([], .decoding)
                return
            }
            
            completion(TransformationsResponse, nil)
        }
        task.resume()
    }
    
}

