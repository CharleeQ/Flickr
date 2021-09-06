//
//  UploadPhoto.swift
//  Flickr
//
//  Created by Кирилл Какареко on 05.09.2021.
//

import UIKit

extension NetworkService {
    private func sign(parameters: [String: Any], photo: UIImage) -> (URL?, String) {
        var params = parameters
        params[OAuthParameters.oauth_consumer_key.rawValue] = constants.consumerKey
        params[OAuthParameters.oauth_nonce.rawValue] = constants.nonce
        params[OAuthParameters.oauth_signature_method.rawValue] = constants.signatureMethod
        params[OAuthParameters.oauth_timestamp.rawValue] = constants.timestamp
        params[OAuthParameters.oauth_version.rawValue] = constants.version
        params[OAuthParameters.oauth_token.rawValue] = accessToken
        
        
        let base = "https://up.flickr.com/services/upload/".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var paramsString = params
            .sorted { $0.key < $1.key }
            .map { (key, value) in "\(key)%3D\(value)" }
            .joined(separator: "%26")
        
        let string = "POST&\(base)&\(paramsString)"
        let encryptString = string.hmac(key: "\(constants.consumerSecret)&\(tokenSecret)")
        print(encryptString)
        paramsString.append("&\(OAuthParameters.oauth_signature.rawValue)=\(encryptString)")
        let urlString = (base + "?" + paramsString).removingPercentEncoding!
        let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%20"))
        
        return (url, encryptString)
    }
    
    func uploadPhoto(fileName: String,
                     image: UIImage,
                     title: String = "",
                     description: String = "",
                     tags: String = "",
                     completion: @escaping (Result<String, Error>) -> Void) {
        let signature = sign(parameters: ["title": title,
                                          "description": description,
                                          "tags": tags], photo: image)
        guard let url = signature.0 else { return }
        

        let boundary = UUID().uuidString
        
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.POST.rawValue
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"api_key\"\r\n".data(using: .utf8)!)
        if let key = constants.consumerKey.data(using: .utf8) { data.append(key) }
        data.append("Content-Disposition: form-data; name=\"auth_token\"\r\n".data(using: .utf8)!)
        if let token = accessToken.data(using: .utf8) { data.append(token) }
        data.append("Content-Disposition: form-data; name=\"api_sig\"\r\n".data(using: .utf8)!)
        if let sign = signature.1.data(using: .utf8) { data.append(sign) }
        data.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(fileName).jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 1)!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let data = data else { return }
            if let string = String(data: data, encoding: .utf8) {
                completion(.success(string))
            }
        }.resume()
    }
}
// not working
