//
//  AuthenticationModel.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/15/25.
//

import Supabase
import CryptoKit
import Foundation
import Observation
import SwiftUI
import AuthenticationServices


let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://vtuwsvxtqmgxpyjqawnz.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0dXdzdnh0cW1neHB5anFhd256Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY5MDU4OTUsImV4cCI6MjA1MjQ4MTg5NX0.JNDEPSE7uLIdnvSK55JGsdV73m7vjEU3KbjrY6tcGnY"
)

enum EmailValidityState {
    case valid
    case invalid
    case taken
    case empty
}

enum AuthenticationFlow {
    case idle, signIn, signUp, signUpOAuth, complete
}

@Observable
class AuthenticationModel {
    
    private let auth = supabase.auth
    var showOnboarding: Bool = true
    private var isAuthenticated: Bool = false
    var errorMessage: String? = nil
    var userSession: User? = nil
    var authFlow: AuthenticationFlow = .idle
    
    
    // MARK: - Sign Up Function
    func signUp(email: String, password: String) async -> Bool {
        do {
            // Attempt to sign up the user
            let response = try await auth.signUp(email: email, password: password)
            
            userSession = response.user
            isAuthenticated = true
            return true
        } catch {
            // Handle specific errors
            if let authError = error as? AuthError {
                switch authError.errorCode {
                case .emailExists:
                    errorMessage = "This email address is already registered."
                case .weakPassword:
                    errorMessage = "Your password must be stronger."
                default:
                    errorMessage = authError.message
                }
            } else {
                // Handle generic errors
                errorMessage = error.localizedDescription
            }
            return false
        }
    }
    
    // MARK: - Log In Function
    func logIn(email: String, password: String) async -> Bool {
        do {
            // Attempt to log in the user
            let response = try await auth.signIn(email: email, password: password)
            
            userSession = response.user
            return true
            
        } catch {
            // Handle errors
            if let authError = error as? AuthError {
                switch authError.errorCode {
                case .invalidCredentials: break
                default:
                    errorMessage = authError.message
                }
            } else {
                errorMessage = error.localizedDescription
            }
            return false
        }
    }
    
    // MARK: - Log Out Function
    func logOut() async {
        do {
            try await auth.signOut()
            isAuthenticated = false
            userSession = nil
        } catch {
            errorMessage = "Failed to log out: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Check Session
    @MainActor
    func checkAuthentication() async {
        defer { showOnboarding = !isAuthenticated }
        do {
            _ = try await supabase.auth.session.user
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
    
    @MainActor
    func checkOAuthUser() async {
        do {
            let user = try await auth.session.user
            let username: String? = try await supabase.from("profiles")
                .select("username")
                .eq("id", value: user.id)
                .single()
                .execute()
                .value
            
            if username != nil {
                // Username exists, user is not new
                authFlow = .signIn
                showOnboarding = false
            } else {
                // Username is nil, prompt user to set up their profile
                authFlow = .signUpOAuth
            }
        } catch {
            print("Error checking user status: \(error.localizedDescription)")
            authFlow = .signUpOAuth // Default to sign up on error
            // Set this as default since if there is an error it will probably be database-related anyway.

        }
    }
    
    static func checkEmailFormat(emailInput: String) -> EmailValidityState {
        // Trim white spaces
        let trimmedEmail = emailInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if the input is empty
        if trimmedEmail.isEmpty { return .empty }
        
        // Define a regex for a valid email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        // Check the email format
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: trimmedEmail) ? .valid : .invalid
    }
    
    static func formatPhoneNumber(_ phoneNumberInput: Binding<String>) {
        // Remove any non-numeric characters
        let digitsOnly = phoneNumberInput.wrappedValue.filter { $0.isNumber }
        
        // Format the phone number
        var formattedNumber = ""
        let digitCount = digitsOnly.count
        
        if digitCount > 0 {
            formattedNumber += "("
            formattedNumber += String(digitsOnly.prefix(3)) // Area code
            if digitCount > 3 {
                formattedNumber += ") "
                formattedNumber += String(digitsOnly.dropFirst(3).prefix(3)) // First 3 digits
            }
            if digitCount > 6 {
                formattedNumber += "-"
                formattedNumber += String(digitsOnly.dropFirst(6)) // Remaining digits
            }
        }
        
        // Limit the number of digits to 10
        if formattedNumber.count > 14 {
            formattedNumber = String(formattedNumber.prefix(14))
        }
        
        // Update the binding
        phoneNumberInput.wrappedValue = formattedNumber
    }
    
    static func checkPasswordStrength(_ passwordInput: String, score: Binding<Double>) {
        // Reset the score
        score.wrappedValue = 0.0
        
        // Check password length
        if passwordInput.count >= 12 { score.wrappedValue += 1 }
        
        // Check for at least one uppercase letter
        if passwordInput.rangeOfCharacter(from: .uppercaseLetters) != nil { score.wrappedValue += 1 }
        
        // Check for at least one lowercase letter
        if passwordInput.rangeOfCharacter(from: .lowercaseLetters) != nil { score.wrappedValue += 1 }
        
        // Check for at least one number
        if passwordInput.rangeOfCharacter(from: .decimalDigits) != nil { score.wrappedValue += 1 }
        
        // Check for at least one symbol
        let symbolCharacterSet = CharacterSet.punctuationCharacters.union(.symbols)
        if passwordInput.rangeOfCharacter(from: symbolCharacterSet) != nil { score.wrappedValue += 1 }
        
        // Cap the score between 0 and 5
        score.wrappedValue = max(0, min(score.wrappedValue, 5))
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
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
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
}

// MARK: - Apple Sign In Model
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
        let nonce = AuthenticationModel().randomNonceString()
        request.nonce = AuthenticationModel().sha256(nonce)
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
                    //                    await AuthenticationModel().checkOAuthUser()
                } catch {
                    print("ERROR with apple sign in: \(error.localizedDescription)")
                    ErrorHandler().showError(error: .authentication(.unknown))
                }
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first ?? UIWindow()
    }
}
