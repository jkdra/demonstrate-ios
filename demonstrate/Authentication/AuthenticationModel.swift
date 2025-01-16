//
//  AuthenticationModel.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/15/25.
//

import Supabase
import Foundation
import Observation
import SwiftUICore

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

@Observable
class AuthenticationModel {
    
    private let auth = supabase.auth
    
    private var isAuthenticated: Bool = false
    
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
}
