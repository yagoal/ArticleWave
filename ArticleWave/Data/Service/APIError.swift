//
//  APIError.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case parametersMissing
    case invalidResponse
    case unknownError(message: String)
    case invalidImageData

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL provided was invalid."
        case .parametersMissing: return "Required parameters are missing from the request."
        case .invalidResponse: return "Invalid Response"
        case .unknownError(let message): return message
        case .invalidImageData: return "Invalid Image Data"
        }
    }
}
