//
//  Reachability.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 7.06.2023.
//

import Alamofire

final class Reachability {
    class func isConnectedToInternet() -> Bool {
        NetworkReachabilityManager()?.isReachable ?? false
    }
}
