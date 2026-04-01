import SwiftUI

struct EditInfoView: View {
    let appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var reasonForQuitting: String = ""
    @State private var whoFor: String = ""
    @State private var isSaving = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.charcoal.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Username")
                                .font(.caption)
                                .foregroundStyle(AppTheme.subtleGray)
                            Text(appState.currentUser?.username ?? "")
                                .font(.body)
                                .foregroundStyle(AppTheme.warmWhite)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        if let addictions = appState.currentUser?.selectedAddictions, !addictions.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Working on")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.subtleGray)
                                Text(addictions.map { $0.capitalized }.joined(separator: ", "))
                                    .font(.body)
                                    .foregroundStyle(AppTheme.warmWhite)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why do you want to stop?")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(AppTheme.warmWhite)
                            AppTextEditor(placeholder: "Your reason...", text: $reasonForQuitting, minHeight: 80)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Who are you doing this for?")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(AppTheme.warmWhite)
                            AppTextField(placeholder: "For...", text: $whoFor)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("My Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(AppTheme.subtleGray)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task { await save() }
                    } label: {
                        if isSaving {
                            ProgressView().tint(AppTheme.terracotta)
                        } else {
                            Text("Save")
                                .fontWeight(.semibold)
                                .foregroundStyle(AppTheme.terracotta)
                        }
                    }
                }
            }
            .onAppear {
                reasonForQuitting = appState.currentUser?.reasonForQuitting ?? ""
                whoFor = appState.currentUser?.whoFor ?? ""
            }
        }
    }

    private func save() async {
        guard let userId = appState.currentUser?.id else { return }
        isSaving = true
        var fields: [String: Any] = [:]
        if !reasonForQuitting.isEmpty { fields["reason_for_quitting"] = reasonForQuitting }
        if !whoFor.isEmpty { fields["who_for"] = whoFor }
        if !fields.isEmpty {
            try? await appState.supabase.updateUser(id: userId, fields: fields)
            appState.currentUser?.reasonForQuitting = reasonForQuitting
            appState.currentUser?.whoFor = whoFor
        }
        isSaving = false
        dismiss()
    }
}
