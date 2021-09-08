//
//  Encryption.swift
//  Flickr
//
//  Created by Кирилл Какареко on 22.08.2021.
//

import Foundation
import CommonCrypto

extension String {
    func hmac(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), key, key.count, self, self.count, &digest)
        return Data(digest).base64EncodedString()
    }

}
