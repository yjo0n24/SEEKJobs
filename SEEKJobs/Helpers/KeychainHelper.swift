//
//  KeychainHelper.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 29/09/2024.
//

import Foundation

enum KeychainError: LocalizedError {
    case itemNotFound
    case itemDuplicate
    case unexpectedStatus(OSStatus)
}

struct KeychainHelper {
    private let TOKEN_SERVICE = "SEEKJobs.token-service"
    
    func getToken(identifier: String) throws -> String {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: TOKEN_SERVICE,
            kSecAttrAccount: identifier,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        
        let status = SecItemCopyMatching(query, &result)
        if status != errSecSuccess {
            throw status == errSecItemNotFound ? KeychainError.itemNotFound :
            KeychainError.unexpectedStatus(status)
        }
        let token = String(data: result as! Data, encoding: .utf8)!
        return token.replacingOccurrences(of: "\"", with: "")
    }
    
    func insertOrUpdateToken(_ token: Data, identifier: String) throws {
        do {
            try updateToken(token, identifier: identifier)
        }
        catch KeychainError.itemNotFound {
            try insertToken(token, identifier: identifier)
        }
    }
    
    func deleteToken(identifier: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: TOKEN_SERVICE,
            kSecAttrAccount: identifier
        ] as CFDictionary

        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    private func insertToken(_ token: Data, identifier: String) throws {
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: TOKEN_SERVICE,
            kSecAttrAccount: identifier,
            kSecValueData: token
        ] as CFDictionary

        let status = SecItemAdd(attributes, nil)
        if status != errSecSuccess {
            throw status == errSecItemNotFound ? KeychainError.itemNotFound :
            KeychainError.unexpectedStatus(status)
        }
    }
    
    private func updateToken(_ token: Data, identifier: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: TOKEN_SERVICE,
            kSecAttrAccount: identifier
        ] as CFDictionary
        
        let attributes = [kSecValueData: token] as CFDictionary
        
        let status = SecItemUpdate(query, attributes)
        if status != errSecSuccess {
            throw status == errSecItemNotFound ? KeychainError.itemNotFound :
            KeychainError.unexpectedStatus(status)
        }
    }
}
