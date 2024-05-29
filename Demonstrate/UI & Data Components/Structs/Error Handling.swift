//
//  Error Handling.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/26/24.
//

import Foundation


@Observable
class ErrorHandler {
    var currentError: AppError = .authentication(.userNotFound)
    var errorOccured = false
    
    func showError(error: AppError) {
        currentError = error
        errorOccured = true
        settingManager.errorHaptic()
    }
}

enum AppError: LocalizedError {
    
    case authentication(AuthenticationError)
    case profile(ProfileError)
    case post(PostError)
    
    var errorDescription: String? {
        switch self {
        case .authentication(let error):
            return error.localizedDescription
        case .profile(let error):
            return error.localizedDescription
        case .post(let error):
            return error.localizedDescription
        }
    }
    
    var errorLongDesctription: String {
        switch self {
        case .authentication(let error):
            return error.errorLongDescription
        case .profile(let error):
            return error.errorLongDescription
        case .post(let error):
            return error.errorLongDescription
        }
    }
}

enum AuthenticationError: LocalizedError {
    case invalidCredentials
    case userNotFound
    case incorrectPassword
    case invalidEmail
    case unknown
    
    var errorLongDescription: String {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("Yeah, uh, please put in some proper values... thanks.", comment: "")
        case .userNotFound:
            return NSLocalizedString("Damn, we couldn't find anyone with those creds... try something else?", comment: "")
        case .incorrectPassword:
            return NSLocalizedString("Ayo... we're just making sure you aren't sabotoging someone's account.", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Uh, we need a proper email? Please?", comment: "")
        case .unknown:
            return NSLocalizedString("Something wrong happened and we can't point our finger on it... Try again, maybe?", comment: "")
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("Invalid Credentials", comment: "")
        case .userNotFound:
            return NSLocalizedString("User Not Found", comment: "")
        case .incorrectPassword:
            return NSLocalizedString("Incorrect Password", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Invalid Email", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "")
        }
    }
}

enum ProfileError: LocalizedError {
    case invalidData
    case updateFailed
    case userProfileNotFound
    case unknown
    
    var errorLongDescription: String {
        switch self {
        case .invalidData:
            return NSLocalizedString("I- okay, just put in the correct stuff please?", comment: "")
        case .updateFailed:
            return NSLocalizedString("Failed to update profile. Please try again.", comment: "")
        case .userProfileNotFound:
            return NSLocalizedString("So we couldn't find the profile... and it's digital so no it couldn't have gotten lost. Try again.", comment: "")
        case .unknown:
            return NSLocalizedString("Sorry, something fucked up our efforts and we couldn't update your profile... Try again maybe?", comment: "")
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return NSLocalizedString("Profile Error", comment: "")
        case .updateFailed:
            return NSLocalizedString("Update Failed", comment: "")
        case .userProfileNotFound:
            return NSLocalizedString("User Profile Not Found", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "")
        }
    }
}

enum PostError: LocalizedError {
    case creationFailed
    case updateFailed
    case petitionSignFailed
    case unknown
    
    var errorLongDescription: String {
        switch self {
        case .creationFailed:
            return NSLocalizedString("Fuck, something wrong occured and we don't know what...", comment: "")
        case .updateFailed:
            return NSLocalizedString("Failed to update post. Please try again.", comment: "")
        case .petitionSignFailed:
            return NSLocalizedString("Failed to sign petition. Please try again.", comment: "")
        case .unknown:
            return NSLocalizedString("An unknown error occurred. Please try again later.", comment: "")
        }
    }
    
    var errorDescription: String {
        switch self {
        case .creationFailed:
            return NSLocalizedString("Post Creation Error", comment: "")
        case .updateFailed:
            return NSLocalizedString("Post Update Failed", comment: "")
        case .petitionSignFailed:
            return NSLocalizedString("Petition Sign Failed", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "")
        }
    }
}
