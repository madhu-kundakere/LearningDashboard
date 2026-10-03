import XCTest

final class LearningDashboardUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    func testLoginCompleteLessonAndBrowseOffline() {
        launch(offline: false)
        logOutIfNeeded()

        logIn(email: "learner", password: "123")
        XCTAssertTrue(app.staticTexts["Enter a valid email address."].exists)
        attachScreenshot(named: "1-validation")

        logIn(email: "learner@example.com", password: "wrong-pass")
        XCTAssertTrue(app.staticTexts["Incorrect email or password."].waitForExistence(timeout: 5))

        logIn(email: "learner@example.com", password: "password123")
        let pythonCourse = app.staticTexts["Python Programming"]
        XCTAssertTrue(pythonCourse.waitForExistence(timeout: 5))
        attachScreenshot(named: "2-dashboard")

        pythonCourse.tap()
        XCTAssertTrue(app.staticTexts["13 of 20 lessons completed"].waitForExistence(timeout: 5))
        attachScreenshot(named: "3-course-detail")
        let markComplete = app.buttons["Mark complete"].firstMatch
        while !markComplete.isHittable {
            app.swipeUp()
        }
        markComplete.tap()
        attachScreenshot(named: "4-lesson-completed")
        app.swipeDown()
        app.swipeDown()
        XCTAssertTrue(app.staticTexts["14 of 20 lessons completed"].waitForExistence(timeout: 5))

        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(app.buttons.containing(NSPredicate(format: "label CONTAINS '70%'")).firstMatch.waitForExistence(timeout: 5))

        app.terminate()
        launch(offline: true)
        XCTAssertTrue(app.staticTexts["Python Programming"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["You're offline. Showing saved data."].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons.containing(NSPredicate(format: "label CONTAINS '70%'")).firstMatch.exists)
        attachScreenshot(named: "5-offline-dashboard")
    }

    private func launch(offline: Bool) {
        app.launchArguments = ["-mockOffline", offline ? "YES" : "NO", "-AppleLanguages", "(en)"]
        app.launch()
    }

    private func logOutIfNeeded() {
        let logOut = app.buttons["Log Out"]
        if logOut.waitForExistence(timeout: 3) {
            logOut.tap()
        }
    }

    private func logIn(email: String, password: String) {
        let emailField = app.textFields["Email"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        emailField.tap()
        emailField.clearAndType(email)
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.clearAndType(password)
        app.buttons["Log In"].tap()
    }

    private func attachScreenshot(named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

private extension XCUIElement {
    func clearAndType(_ text: String) {
        if let current = value as? String, !current.isEmpty, current != placeholderValue {
            typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count))
        }
        typeText(text)
    }
}
