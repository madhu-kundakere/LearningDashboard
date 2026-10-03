import Domain
import Testing

struct CredentialsValidatorTests {
    private let validator = CredentialsValidator(minimumPasswordLength: 6)

    @Test(arguments: ["learner@example.com", "  first.last+tag@sub.domain.io  "])
    func acceptsValidEmails(email: String) {
        #expect(validator.validateEmail(email) == nil)
    }

    @Test func rejectsEmptyEmail() {
        #expect(validator.validateEmail("   ") == .empty)
    }

    @Test(arguments: ["learner", "learner@", "learner@example", "@example.com"])
    func rejectsMalformedEmails(email: String) {
        #expect(validator.validateEmail(email) == .invalidFormat)
    }

    @Test func rejectsShortPassword() {
        #expect(validator.validatePassword("12345") == .tooShort(minimumLength: 6))
        #expect(validator.validatePassword("") == .empty)
        #expect(validator.validatePassword("123456") == nil)
    }
}
