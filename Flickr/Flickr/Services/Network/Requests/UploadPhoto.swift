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
    private func sign(url: String, parameters: [String: Any]) -> String {
        let base = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let paramsString = parameters
            .sorted { $0.key < $1.key }
            .map { (key, value) in "\(key)=\(value)".replacingOccurrences(of: " ", with: "%20") }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlCharset)!
        let string = "POST&\(base)&\(paramsString)"
        let encryptString = string.hmac(key: "\(constants.consumerSecret)&\(tokenSecret)")
        
        return encryptString
    }
    
    func uploadPhoto(filename: String, image: UIImage,
                     title: String?,
                     description: String?,
                     tags: String?,
                     completion: @escaping (Result<String, Error>) -> Void) {
        let url = "https://up.flickr.com/services/upload"
        var parameters = [NetworkParameters.nojsoncallback.rawValue: "1",
                          NetworkParameters.format.rawValue: "json",
                          OAuthParameters.oauth_consumer_key.rawValue: constants.consumerKey,
                          OAuthParameters.oauth_nonce.rawValue: constants.nonce,
                          OAuthParameters.oauth_signature_method.rawValue: constants.signatureMethod,
                          OAuthParameters.oauth_timestamp.rawValue: constants.timestamp,
                          OAuthParameters.oauth_version.rawValue: constants.version,
                          OAuthParameters.oauth_token.rawValue: accessToken]
        if let title = title { parameters["title"] = title }
        if let description = description { parameters["description"] = description }
        if let tags = tags { parameters["tags"] = tags }
        
        let signature = sign(url: url, parameters: parameters)
        var formdata = FormData()
        let session = URLSession.shared
        let imageToData = image.pngData()!
        
        parameters.forEach { key, value in
            guard let data = value.data(using: .utf8) else { return }
            formdata.append(name: key, data: data)
        }
        formdata.append(name: OAuthParameters.oauth_signature.rawValue,
                        data: signature.data(using: .utf8)!)
        formdata.append(name: NetworkParameters.photo.rawValue, filename: filename,
                        contentType: "image/png", data: imageToData)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.POST.rawValue
        urlRequest.setValue("multipart/form-data; boundary=\(formdata.boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("\(formdata.data.count)", forHTTPHeaderField: "Content-Length")
        
        session.uploadTask(with: urlRequest, from: formdata.data) { data, _, error in
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
