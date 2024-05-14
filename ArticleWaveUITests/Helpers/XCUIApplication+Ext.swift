//
//  XCUIApplication+Ext.swift
//  ArticleWaveUITests
//
//  Created by Yago Pereira on 13/5/24.
//

import XCTest

extension XCUIApplication {
    func setLaunchArgument(_ args: [LaunchArgument]) {
        self.launchArguments = args.map { $0.rawValue }
    }
}
