//
//  Biometric.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/12/22.
//

import Foundation
import LocalAuthentication


func biometricType() -> String {
    let authContext = LAContext()
    let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    switch authContext.biometryType {
    case .none:
        return ""
    case .touchID:
        return "touchid"
    case .faceID:
        return "faceid"
    @unknown default:
        return ""
    }
}

enum BioError: Error, LocalizedError, Identifiable {
    case invalidCredentials
    case deniedAccess
    case noFaceIdEnrolled
    case noFingerprintEnrolled
    case biometrictError
    case credentialsNotSaved
    
    var id: String {
        self.localizedDescription
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("Either your email or password are incorrect. Please try again.", comment: "")
        case .deniedAccess:
            return NSLocalizedString("You have denied access. Please go to the settings app and locate this application and turn Face ID on.", comment: "")
        case .noFaceIdEnrolled:
            return NSLocalizedString("You have not registered any Face Ids yet", comment: "")
        case .noFingerprintEnrolled:
            return NSLocalizedString("You have not registered any fingerprints yet.", comment: "")
        case .biometrictError:
            return NSLocalizedString("Your face or fingerprint were not recognized.", comment: "")
        case .credentialsNotSaved:
            return NSLocalizedString("Your credentials have not been saved. Do you want to save them after the next successful login?", comment: "")
        }
    }
}
