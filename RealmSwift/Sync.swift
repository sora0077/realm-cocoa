////////////////////////////////////////////////////////////////////////////
//
// Copyright 2016 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import Realm
import Realm.Private
import Foundation

public typealias User = RLMUser

public typealias SyncManager = RLMSyncManager

public typealias SyncSession = RLMSyncSession

public typealias AuthenticationActions = RLMAuthenticationActions

public typealias ErrorReportingBlock = RLMErrorReportingBlock

public typealias UserCompletionBlock = RLMUserCompletionBlock

public typealias SyncError = RLMSyncError

public typealias SyncLogLevel = RLMSyncLogLevel

#if swift(>=3.0)

public typealias Provider = RLMIdentityProvider

public struct Credential {
    public typealias Token = String

    var token: Token
    var provider: Provider
    var userInfo: [String: Any]

    init(customToken token: Token, provider: Provider, userInfo: [String: Any] = [:]) {
        self.token = token
        self.provider = provider
        self.userInfo = userInfo
    }

    private init(_ credential: RLMCredential) {
        self.token = credential.token
        self.provider = credential.provider
        self.userInfo = credential.userInfo
    }

    static func facebook(token: Token) -> Credential {
        return Credential(RLMCredential(facebookToken: token))
    }

    static func usernamePassword(username: String, password: String) -> Credential {
        return Credential(RLMCredential(username: username, password: password))
    }
}

extension RLMCredential {
    fileprivate convenience init(_ credential: Credential) {
        self.init(customToken: credential.token, provider: credential.provider, userInfo: credential.userInfo)
    }
}

extension User {
    public static func authenticate(with credential: Credential,
                                    actions: AuthenticationActions,
                                    server authServerURL: URL,
                                    timeout: TimeInterval = 30,
                                    onCompletion completion: UserCompletionBlock) {
        return User.__authenticate(with: RLMCredential(credential),
                                   actions: actions,
                                   authServerURL: authServerURL,
                                   timeout: timeout,
                                   onCompletion: completion)
    }
}

#else

public typealias Provider = String // `RLMIdentityProvider` imports as `NSString`

public struct Credential {
    public typealias Token = String

    var token: Token
    var provider: Provider
    var userInfo: [String: AnyObject]

    init(customToken token: Token, provider: Provider, userInfo: [String: AnyObject] = [:]) {
        self.token = token
        self.provider = provider
        self.userInfo = userInfo
    }

    private init(_ credential: RLMCredential) {
        self.token = credential.token
        self.provider = credential.provider
        self.userInfo = credential.userInfo
    }

    static func facebook(token: Token) -> Credential {
        return Credential(RLMCredential(facebookToken: token))
    }

    static func usernamePassword(username: String, password: String) -> Credential {
        return Credential(RLMCredential(username: username, password: password))
    }
}

extension RLMCredential {
    private convenience init(_ credential: Credential) {
        self.init(customToken: credential.token, provider: credential.provider, userInfo: credential.userInfo)
    }
}


extension User {

    public static func authenticateWithCredential(credential: Credential,
                                                  actions: AuthenticationActions,
                                                  authServerURL: NSURL,
                                                  timeout: NSTimeInterval = 30,
                                                  onCompletion completion: UserCompletionBlock) {
        return User.__authenticateWithCredential(RLMCredential(credential),
                                                 actions: actions,
                                                 authServerURL: authServerURL,
                                                 timeout: timeout,
                                                 onCompletion: completion)
    }
}

#endif