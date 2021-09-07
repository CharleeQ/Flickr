//
//  UploadPhoto.swift
//  Flickr
//
//  Created by Кирилл Какареко on 05.09.2021.
//

import UIKit

struct FormData {
    var data = Data()
    let boundary = "Boundary-" + UUID().uuidString
    
    mutating func append(name: String, data: Data) {
        self.data.append("--\(boundary)\r\n".data(using: .utf8)!)
        self.data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        self.data.append(data)
        self.data.append("\r\n".data(using: .utf8)!)
        
    }
    
    mutating func append(name: String, filename: String, contentType: String, data: Data) {
        self.data.append("--\(boundary)\r\n".data(using: .utf8)!)
        self.data.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"; size=\(data.count)\r\n".data(using: .utf8)!)
        self.data.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
        self.data.append(data)
        self.data.append("\r\n".data(using: .utf8)!)
        self.data.append("--\(boundary)\r\n".data(using: .utf8)!)
    }
}

extension NetworkService {
    private func sign(parameters: [String: Any]) -> (String, String, String) {
        var params = parameters
        params["nojsoncallback"] = "1"
        params["format"] = "json"
        params[OAuthParameters.oauth_consumer_key.rawValue] = constants.consumerKey
        params[OAuthParameters.oauth_nonce.rawValue] = constants.nonce
        params[OAuthParameters.oauth_signature_method.rawValue] = constants.signatureMethod
        params[OAuthParameters.oauth_timestamp.rawValue] = constants.timestamp
        params[OAuthParameters.oauth_version.rawValue] = constants.version
        params[OAuthParameters.oauth_token.rawValue] = accessToken
        
        let base = "https://up.flickr.com/services/upload".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let paramsString = params
            .sorted { $0.key < $1.key }
            .map { (key, value) in "\(key)%3D\(value)" }
            .joined(separator: "%26")
        let string = "POST&\(base)&\(paramsString)"
        let encryptString = string.hmac(key: "\(constants.consumerSecret)&\(tokenSecret)")
        let nonce = params[OAuthParameters.oauth_nonce.rawValue] as! String
        let timestamp = params[OAuthParameters.oauth_timestamp.rawValue] as! String
        
        return (encryptString, nonce, timestamp)
    }
    
    func uploadPhoto(filename: String, image: UIImage,
                     title: String = "",
                     description: String = "",
                     tags: String = "",
                     completion: @escaping (Result<String, Error>) -> Void) {
        let signature = sign(parameters: ["title": title,
                                          "description": description,
                                          "tags": tags])
        var formdata = FormData()
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: URL(string: "https://up.flickr.com/services/upload")!)
        urlRequest.httpMethod = HTTPMethod.POST.rawValue
        urlRequest.setValue("multipart/form-data; boundary=\(formdata.boundary)", forHTTPHeaderField: "Content-Type")
        
        let image = image
        let imageToData = image.pngData()!
        
        formdata.append(name: NetworkParameters.title.rawValue,
                        data: title.data(using: .utf8)!)
        formdata.append(name: NetworkParameters.description.rawValue,
                        data: description.data(using: .utf8)!)
        formdata.append(name: NetworkParameters.tags.rawValue,
                        data: tags.data(using: .utf8)!)
        formdata.append(name: NetworkParameters.nojsoncallback.rawValue,
                        data: "1".data(using: .utf8)!)
        formdata.append(name: NetworkParameters.format.rawValue,
                        data: "json".data(using: .utf8)!)
        formdata.append(name: OAuthParameters.oauth_consumer_key.rawValue,
                        data: constants.consumerKey.data(using: .utf8)!)
        formdata.append(name: OAuthParameters.oauth_nonce.rawValue,
                        data: signature.1.data(using: .utf8)!)
        formdata.append(name: OAuthParameters.oauth_signature.rawValue,
                        data: signature.0.data(using: .utf8)!)
        formdata.append(name: OAuthParameters.oauth_signature_method.rawValue,
                        data: constants.signatureMethod.data(using: .utf8)!)
        formdata.append(name: OAuthParameters.oauth_timestamp.rawValue,
                        data: signature.2.data(using: .utf8)!)
        formdata.append(name: OAuthParameters.oauth_token.rawValue,
                        data: accessToken.data(using: .utf8)!)
        formdata.append(name: OAuthParameters.oauth_version.rawValue,
                        data: constants.version.data(using: .utf8)!)
        formdata.append(name: NetworkParameters.photo.rawValue, filename: filename,
                        contentType: "image/png", data: imageToData)
        
        
        urlRequest.setValue("\(formdata.data.count)", forHTTPHeaderField: "Content-Length")
        session.uploadTask(with: urlRequest, from: formdata.data) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            guard let string = String.init(data: data, encoding: .utf8) else { return }
            if let photoID = string.components(separatedBy: "<photoid>").last?.components(separatedBy: "</photoid>").first {
                completion(.success(photoID))
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
