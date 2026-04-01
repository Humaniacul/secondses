import SwiftUI

struct SettingsView: View {
    let appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirm = false
    @State private var isDeleting = false
    @State private var companionName: String = ""

    var body: some View {
        ZStack {
            AppTheme.charcoal.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundStyle(AppTheme.subtleGray)
                    }
                    Spacer()
                    Text("Settings")
                        .font(.system(.headline, design: .serif))
                        .foregroundStyle(AppTheme.warmWhite)
                    Spacer()
                    Color.clear.frame(width: 24, height: 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)

                ScrollView {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("AI COMPANION")
                                .font(.system(size: 10, weight: .semibold))
                                .tracking(1.5)
                                .foregroundStyle(AppTheme.subtleGray)
                                .padding(.horizontal, 4)

                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(AppTheme.terracotta.opacity(0.18))
                                            .frame(width: 36, height: 36)
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 14))
                                            .foregroundStyle(AppTheme.terracotta)
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Companion Name")
                                            .font(.subheadline.weight(.medium))
                                            .foregroundStyle(AppTheme.warmWhite)
                                        Text("Your AI companion's name (default: Joy)")
                                            .font(.caption)
                                            .foregroundStyle(AppTheme.subtleGray)
                                    }
                                }

                                TextField("", text: $companionName, prompt: Text("Joy").foregroundStyle(AppTheme.subtleGray))
                                    .font(.body)
                                    .foregroundStyle(AppTheme.warmWhite)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .background(AppTheme.charcoal)
                                    .clipShape(.rect(cornerRadius: 10))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(AppTheme.subtleGray.opacity(0.25), lineWidth: 1)
                                    }
                                    .onChange(of: companionName) { _, newValue in
                                        let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                                        appState.aiCompanionName = trimmed.isEmpty ? "Joy" : trimmed
                                    }
                            }
                            .padding(16)
                            .background(AppTheme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("ACCOUNT")
                                .font(.system(size: 10, weight: .semibold))
                                .tracking(1.5)
                                .foregroundStyle(AppTheme.subtleGray)
                                .padding(.horizontal, 4)

                            VStack(spacing: 2) {
                                Button {
                                    appState.signOut()
                                    dismiss()
                                } label: {
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .foregroundStyle(AppTheme.subtleGray)
                                            .frame(width: 24)
                                        Text("Sign Out")
                                            .foregroundStyle(AppTheme.warmWhite)
                                        Spacer()
                                    }
                                    .padding(16)
                                }
                            }
                            .background(AppTheme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("ABOUT")
                                .font(.system(size: 10, weight: .semibold))
                                .tracking(1.5)
                                .foregroundStyle(AppTheme.subtleGray)
                                .padding(.horizontal, 4)

                            VStack(alignment: .leading, spacing: 10) {
                                Text("About Second Chance")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(AppTheme.warmWhite)

                                Text("Second Chance is a structured accountability and self-awareness tool. It does not diagnose or cure addiction. It is not a substitute for professional help.")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.subtleGray)
                                    .lineSpacing(3)
                            }
                            .padding(16)
                            .background(AppTheme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                        }

                        Button {
                            showDeleteConfirm = true
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete All My Data")
                            }
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.red.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color.red.opacity(0.08))
                            .clipShape(.rect(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .onAppear {
            companionName = appState.aiCompanionName == "Joy" ? "" : appState.aiCompanionName
        }
        .alert("Delete All Data?", isPresented: $showDeleteConfirm) {
            Button("Delete Everything", role: .destructive) {
                Task {
                    isDeleting = true
                    try? await appState.deleteAllData()
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently remove all your data from our servers and this device. This cannot be undone.")
        }
    }
}
