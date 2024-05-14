//
//  LaunchArgument.swift
//  ArticleWave
//
//  Created by Yago Pereira on 13/5/24.
//

import Foundation

enum LaunchArgument: String {
    /// flag indicates that is running on UI tests
    case uiTest = "--uitesting"

    /// flag for add delay because show loading and blur
    case useMockHttpRequestWithDelay = "--mock-api-requests-with-delay"

    /// flag to use fake errors data on API requests
    case useMockHttpRequestsWithError = "--mock-error-api-requests"

    static func check(_ argument: LaunchArgument) -> Bool {
        CommandLine.arguments.contains(argument.rawValue)
    }
}
