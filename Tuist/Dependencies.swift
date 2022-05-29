//
//  Dependencies.swift
//  Config
//
//  Created by Insu Byeon on 2022/05/28.
//

import ProjectDescription

let dependencies = Dependencies(carthage: nil,
                                swiftPackageManager: [
                                  .remote(url: "https://github.com/uber/RIBs", requirement: .upToNextMajor(from: "0.12.1"))
                                ],
                                platforms: [.iOS])
