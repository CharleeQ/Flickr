//
//  Parameters.swift
//  Flickr
//
//  Created by Кирилл Какареко on 02.09.2021.
//

import Foundation


enum NetworkParameters: String {
    case api_key
    case method
    case photo_id
    case user_id
    case count
    case period
    case per_page
    case page
    case extras
    case secret
    case format
    case comment_text
    case comment_id
    case min_comment_date
    case max_comment_date
    case min_fave_date
    case max_fave_date
    case safe_search
    case min_upload_date
    case max_upload_date
    case min_taken_date
    case max_taken_date
    case content_type
    case privacy_filter
}

enum OAuthParameters: String {
    case oauth_nonce
    case oauth_timestamp
    case oauth_consumer_key
    case oauth_signature_method
    case oauth_version
    case oauth_callback
    case oauth_signature
    case oauth_token
    case perms
    case oauth_verifier
}
