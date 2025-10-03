// App/ContentView.swift (UPDATED)

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingLoading = true
    
    var body: some View {
        Group {
            if showingLoading {
                LoadingScreen()
            } else {
                switch authManager.authState {
                case .loading:
                    LoadingScreen()
                    
                case .unauthenticated:
                    SignInView()
                    
                case .emailVerificationNeeded(let email):
                    EmailVerificationView(email: email)
                    
                case .profileIncomplete(let user):
                    if user.hasActiveSubscription {
                        // Case 1: User purchased online, needs to complete profile
                        ProfileCompletionView(user: user)
                    } else {
                        // Case 2: User signed up in app, needs to complete profile and get subscription
                        ProfileCompletionWithSubscriptionView(user: user)
                    }
                    
                case .authenticated(let user):
                    if user.hasActiveSubscription {
                        // User is fully set up
                        MainTabView()
                    } else {
                        // User needs to purchase subscription
                        SubscriptionRequiredView(user: user)
                    }
                }
            }
        }
        .onAppear {
            // Simulate initial loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showingLoading = false
                }
            }
        }
    }
}
