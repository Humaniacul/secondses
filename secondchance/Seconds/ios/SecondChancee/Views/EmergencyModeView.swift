import SwiftUI

struct EmergencyModeView: View {
    let appState: AppState
    @Binding var selectedTab: Int
    @Environment(\.dismiss) private var dismiss
    @State private var breathPhase = 0
    @State private var isAnimating = false

    private let breathingSteps = [
        "Breathe in slowly... 1... 2... 3... 4...",
        "Hold gently... 1... 2... 3... 4... 5... 6... 7...",
        "Breathe out slowly... 1... 2... 3... 4... 5... 6... 7... 8..."
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 40) {
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .foregroundStyle(AppTheme.subtleGray)
                        }
                    }

                    Spacer().frame(height: 20)

                    VStack(spacing: 20) {
                        Circle()
                            .fill(AppTheme.terracotta.opacity(0.15))
                            .frame(width: 120, height: 120)
                            .overlay {
                                Circle()
                                    .fill(AppTheme.terracotta.opacity(0.3))
                                    .frame(width: isAnimating ? 80 : 50, height: isAnimating ? 80 : 50)
                                    .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: isAnimating)
                            }
                            .onAppear { isAnimating = true }

                        Text(breathingSteps[breathPhase % breathingSteps.count])
                            .font(.system(.body, design: .serif))
                            .foregroundStyle(AppTheme.warmWhite.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .contentTransition(.opacity)
                            .animation(.easeInOut(duration: 0.5), value: breathPhase)

                        Button("Next step") {
                            breathPhase += 1
                        }
                        .font(.caption)
                        .foregroundStyle(AppTheme.subtleGray)
                    }

                    if let whoFor = appState.currentUser?.whoFor, !whoFor.isEmpty {
                        VStack(spacing: 8) {
                            Text("You're doing this for")
                                .font(.caption)
                                .foregroundStyle(AppTheme.subtleGray)
                            Text(whoFor)
                                .font(.system(.title3, design: .serif, weight: .semibold))
                                .foregroundStyle(AppTheme.terracotta)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.cardBackground.opacity(0.5))
                        .clipShape(.rect(cornerRadius: 14))
                    }

                    if let reason = appState.currentUser?.reasonForQuitting, !reason.isEmpty {
                        VStack(spacing: 8) {
                            Text("You said")
                                .font(.caption)
                                .foregroundStyle(AppTheme.subtleGray)
                            Text("\"\(reason)\"")
                                .font(.system(.body, design: .serif))
                                .foregroundStyle(AppTheme.warmWhite.opacity(0.85))
                                .multilineTextAlignment(.center)
                                .italic()
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.cardBackground.opacity(0.5))
                        .clipShape(.rect(cornerRadius: 14))
                    }

                    VStack(spacing: 12) {
                        Button {
                            dismiss()
                            selectedTab = 2
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "message.fill")
                                Text("Talk to the AI")
                            }
                        }
                        .buttonStyle(AppButtonStyle())

                        Button {
                            dismiss()
                            selectedTab = 3
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "link")
                                Text("See Resources")
                            }
                        }
                        .buttonStyle(AppButtonStyle(filled: false))
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
        }
    }
}
