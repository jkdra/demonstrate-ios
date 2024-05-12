//
//  Authentication Model.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/9/24.
//

import Foundation
import Observation
import AuthenticationServices
import CryptoKit
import SwiftUI
import Supabase
import GoogleSignIn

enum AuthFlow {
    case idle, signIn, signUp, signUpOAuth, complete
}

enum UsernameCheckStatus {
    case taken
    case lessThan3Char
    case invalidCharacters
    case invalidStartEnd
    case error
    case available
    case checking
    case idle
    
    var statusDisplay: String {
        switch self {
        case .taken:
            "Username is Taken"
        case .lessThan3Char:
            "Should have 3 characters minimum"
        case .invalidCharacters:
            "Can only contain letters, numbers, \".\" & \"_\"."
        case .invalidStartEnd:
            "Should start & end with a letter"
        case .error:
            "There was an error..."
        case .available:
            "Username Available!"
        case .checking:
            " "
        case .idle:
            " "
        }
    }
    
    var statusColor: Color? {
        switch self {
        case .available: .accentColor
        case .checking, .idle: nil
        default: .red
        }
    }
}

@Observable
final class AuthenticationViewModel {
    
    var isAuthenticated: Bool = false
    var oAuthSuccess = false
    var loading = false
    var flow: AuthFlow = .idle
    
    private var currentNonce: String?
    
    func signUp(email: String, password: String) async throws {
        loading = true
        defer { loading = false }
        guard !email.isEmpty, !password.isEmpty else { return }
        let response = try await supabase.auth.signUp(email: email, password: password)
        print(response)
    }
    
    func signIn(email: String, password: String) async throws {
        loading = true
        defer { loading = false }
        guard !email.isEmpty, !password.isEmpty else { return }
        let session = try await supabase.auth.signIn(email: email, password: password)
        print(session)
    }
    
    func signOut() async throws {
        loading = true
        defer { loading = false }
        try await supabase.auth.signOut()
        await MainActor.run {
            flow = .idle
            isAuthenticated = false
        }
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
           
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                       )
                   }
                   return random
               }
               
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    @MainActor
    func isUserAuthenticated() async {
        do {
            _ = try await supabase.auth.session.user
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
    
    func checkUsername(usernameInput: String, completion: @escaping (UsernameCheckStatus) -> Void) {
        Task {
            
            let username = usernameInput.lowercased()
            
            do {
                // First check for minimum length
                if username.count < 3 {
                    completion(.lessThan3Char)
                    return
                }
                
                // Check for valid characters including start and end conditions
                let regexValidChars = "^[a-zA-Z][a-zA-Z0-9._]*[a-zA-Z0-9]$"
                let regexTestValidChars = NSPredicate(format:"SELF MATCHES %@", regexValidChars)
                
                if !regexTestValidChars.evaluate(with: username) {
                    if username.first?.isLetter == false || username.last?.isLetter == false {
                        completion(.invalidStartEnd)
                    } else {
                        completion(.invalidCharacters)
                    }
                    return
                }
                
                // Check if the username is already taken in the database
                let response = try await database.from("profiles")
                    .select("username")
                    .eq("username", value: username)
                    .execute()
                    
                // Check if the response contains any rows to determine if the username is taken
                let isUsernameTaken = response.data.isEmpty
                
                // Return the appropriate status based on whether the username is taken
                if isUsernameTaken {
                    completion(.taken)
                } else if usernameInput.isEmpty {
                    completion(.idle)
                } else {
                    completion(.available)
                }
            } catch {
                print("Failed to fetch username: \(error)")
                completion(.error)
            }
        }
    }

    func checkOAuthUser() async {
        do {
            let user = try await auth.session.user
            let newProfile: Profile = try await database.from("profiles")
                                             .select("username")
                                             .eq("id", value: user.id)
                                             .single()
                                             .execute()
                                             .value
            
            if newProfile.username != nil {
                // Username exists, user is not new
                await MainActor.run { flow = .signIn }
            } else {
                // Username is nil, prompt user to set up their profile
                await MainActor.run { flow = .signUpOAuth }
            }
            
        } catch {
            print("Error checking user status: \(error.localizedDescription)")
            await MainActor.run { flow = .signUpOAuth } // Default to sign up on error
            // Set this as default since if there is an error it will probably be database-related anyway.
        }
    }

    
    // MARK: Apple Sign In
    func appleSignIn() {
        loading = true
        defer { loading = false }
        AppleSignInModel().performSignIn()
    }
     
    // MARK: Google Sign In
    func googleSignIn() {
        loading = true
        defer { loading = false }
        
        let newNonce = randomNonceString()
        currentNonce = newNonce
        
        Task {
            let serverClientID = "132876560540-1ua1h2b7r26v91lqnsc3p32ge2sm2ad4.apps.googleusercontent.com"
            
            guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = await windowScene.windows.first,
                  let rootViewController = await window.rootViewController else {
                print("No Root View Controller...")
                return
            }
            
            let config = GIDConfiguration(clientID: Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as! String, serverClientID: serverClientID)
            GIDSignIn.sharedInstance.configuration = config
            
            do {
                let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                let user = userAuth.user
                
                guard let idToken = user.idToken else {
                    throw AuthenticationError.tokenError(message: "ID Token Missing")
                }
                
                guard let nonce = currentNonce else {
                    print("Nonce never recieved...")
                    return
                }
                
                let accessToken = user.accessToken  // Ensure accessToken is being used if necessary
                let credentials = OpenIDConnectCredentials(provider: .google, idToken: idToken.tokenString, accessToken: accessToken.tokenString, nonce: nonce)

                // Pass idToken and accessToken to signInWithIdToken if your backend requires them
                try await auth.signInWithIdToken(credentials: credentials)
                await checkOAuthUser()
                await MainActor.run { oAuthSuccess = true }
            } catch {
                print("ERROR SIGNING IN WITH GOOGLE: \(error.localizedDescription)")
            }
        }
    }
}

enum AuthenticationError: Error, LocalizedError {
    case userExists
    case userNotFound
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
            case .userExists:
                return "An account with this email already exists."
            case .userNotFound:
                return "User not found. Please sign up."
            case .unknownError:
                return "An unknown error occurred."
            case .tokenError(message: let message):
                return message
        }
    }
    
    case tokenError(message: String)
}

@Observable
final class AppleSignInModel: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private var currentNonce: String?
    
    func performSignIn() {
        let request = createAppleIdRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    private func createAppleIdRequest() -> ASAuthorizationRequest  {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        let nonce = AuthenticationViewModel().randomNonceString()
        request.nonce = AuthenticationViewModel().sha256(nonce)
        currentNonce = nonce
        return request
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else  {
                fatalError("DEBUG: Invalid state: A login callback was recieved, but no login request was sent")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("DEBUG: Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("DEBUG: Unable to serialize token string from data \(appleIDToken.debugDescription)")
                return
            }
                 
            Task {
                do {
                    let result = try await supabase.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idTokenString, nonce: nonce))
                    print(result)
                    await AuthenticationViewModel().checkOAuthUser()
                } catch {
                    print("ERROR with apple sign in: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first ?? UIWindow()
    }
}
