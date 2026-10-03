import DesignSystem
import SwiftUI

public struct LoginView: View {
    @Bindable private var viewModel: LoginViewModel
    @FocusState private var focusedField: Field?

    private enum Field {
        case email
        case password
    }

    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xLarge) {
                header
                VStack(alignment: .leading, spacing: Spacing.large) {
                    emailField
                    passwordField
                    if let errorMessage = viewModel.errorMessage {
                        InlineBanner(message: errorMessage, systemImage: SystemSymbol.warningFilled, tint: .red)
                    }
                    PrimaryButton(Strings.Login.submit, isLoading: viewModel.isLoading, action: submit)
                }
                .card(padding: Spacing.large)
            }
            .padding(Spacing.large)
        }
        .scrollDismissesKeyboard(.interactively)
        .screenBackground()
        .disabled(viewModel.isLoading)
    }

    private var header: some View {
        VStack(spacing: Spacing.medium) {
            IconTile(systemImage: Symbols.appLogo, style: Palette.brand, size: 88)
            VStack(spacing: Spacing.small) {
                Text(Strings.Login.title)
                    .font(.largeTitle.bold())
                Text(Strings.Login.subtitle)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
        }
        .padding(.top, Spacing.xLarge)
    }

    private var emailField: some View {
        LabeledField(title: Strings.Login.email, error: viewModel.emailError) {
            TextField(Strings.Login.email, text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textContentType(.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.next)
                .focused($focusedField, equals: .email)
                .onSubmit { focusedField = .password }
        }
    }

    private var passwordField: some View {
        LabeledField(title: Strings.Login.password, error: viewModel.passwordError) {
            SecureField(Strings.Login.password, text: $viewModel.password)
                .textContentType(.password)
                .submitLabel(.go)
                .focused($focusedField, equals: .password)
                .onSubmit(submit)
        }
    }

    private func submit() {
        focusedField = nil
        Task { await viewModel.submit() }
    }
}

private struct LabeledField<Content: View>: View {
    let title: String
    let error: String?
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .accessibilityHidden(true)
            content
                .padding(Spacing.medium - Spacing.xSmall)
                .background(Color(uiColor: .tertiarySystemFill), in: RoundedRectangle(cornerRadius: Radius.field, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: Radius.field, style: .continuous)
                        .stroke(error == nil ? Palette.brand.primary.opacity(0.15) : Color.red, lineWidth: 1)
                }
                .accessibilityHint(error ?? "")
            if let error {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
    }
}
