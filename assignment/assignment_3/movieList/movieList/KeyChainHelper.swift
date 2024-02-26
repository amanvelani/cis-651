//
//  KeyChainHelper.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//

import Foundation
import Security

// Referance 1: https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_keychain
// Referance 2: https://www.andyibanez.com/posts/using-ios-keychain-swift/
class KeychainHelper {
    static func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }

    static func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == noErr {
            return item as? Data
        }
        return nil
    }
    
    func retrieveToken() -> String {
        if let receivedData = KeychainHelper.load(key: "bearerToken"),
           let tokenString = String(data: receivedData, encoding: .utf8) {
            return tokenString
        } else {
            return "Failed to retrieve or decode token"
        }
    }
}
