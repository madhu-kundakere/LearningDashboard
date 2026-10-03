import json
import os
import sys

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
SOURCES = os.path.join(ROOT, "Packages", "LearningKit", "Sources")

CATALOGS = {
    os.path.join(SOURCES, "Core", "Resources"): {
        "error.offline": ("You appear to be offline. Check your connection and try again.", "Du scheinst offline zu sein. Prüfe deine Verbindung und versuche es erneut."),
        "error.invalidCredentials": ("Incorrect email or password.", "E-Mail oder Passwort ist falsch."),
        "error.unauthorized": ("Your session has expired. Please log in again.", "Deine Sitzung ist abgelaufen. Bitte melde dich erneut an."),
        "error.notFound": ("We couldn't find what you were looking for.", "Der Inhalt wurde nicht gefunden."),
        "error.server": ("Our servers are having trouble. Please try again later.", "Unsere Server haben Probleme. Bitte versuche es später erneut."),
        "error.decoding": ("We received unexpected data. Please try again later.", "Wir haben unerwartete Daten erhalten. Bitte versuche es später erneut."),
        "error.persistence": ("Saved data couldn't be accessed.", "Auf gespeicherte Daten konnte nicht zugegriffen werden."),
        "error.unknown": ("Something went wrong. Please try again.", "Etwas ist schiefgelaufen. Bitte versuche es erneut."),
    },
    os.path.join(SOURCES, "DesignSystem", "Resources"): {
        "state.retry": ("Retry", "Erneut versuchen"),
        "banner.offline": ("You're offline. Showing saved data.", "Du bist offline. Gespeicherte Daten werden angezeigt."),
        "progress.accessibility %@": ("%@ complete", "%@ abgeschlossen"),
    },
    os.path.join(SOURCES, "AuthFeature", "Resources"): {
        "login.title": ("Welcome back", "Willkommen zurück"),
        "login.subtitle": ("Log in to continue learning", "Melde dich an, um weiterzulernen"),
        "login.email": ("Email", "E-Mail"),
        "login.password": ("Password", "Passwort"),
        "login.submit": ("Log In", "Anmelden"),
        "login.error.emailEmpty": ("Enter your email address.", "Gib deine E-Mail-Adresse ein."),
        "login.error.emailInvalid": ("Enter a valid email address.", "Gib eine gültige E-Mail-Adresse ein."),
        "login.error.passwordEmpty": ("Enter your password.", "Gib dein Passwort ein."),
        "login.error.passwordTooShort %lld": ("Password must be at least %lld characters.", "Das Passwort muss mindestens %lld Zeichen lang sein."),
    },
    os.path.join(SOURCES, "CoursesFeature", "Resources"): {
        "courses.title": ("My Courses", "Meine Kurse"),
        "courses.loading": ("Loading courses…", "Kurse werden geladen…"),
        "courses.empty.title": ("No courses yet", "Noch keine Kurse"),
        "courses.empty.message": ("Courses you enroll in will appear here.", "Kurse, für die du dich einschreibst, erscheinen hier."),
        "courses.error.title": ("Couldn't load courses", "Kurse konnten nicht geladen werden"),
        "courses.refreshFailed": ("Couldn't refresh. Showing saved courses.", "Aktualisierung fehlgeschlagen. Gespeicherte Kurse werden angezeigt."),
        "courses.instructor %@": ("by %@", "von %@"),
        "courses.continue": ("Continue", "Fortsetzen"),
        "courses.summary.title": ("Keep up the momentum!", "Bleib dran!"),
        "detail.loading": ("Loading lessons…", "Lektionen werden geladen…"),
        "detail.error.title": ("Couldn't load lessons", "Lektionen konnten nicht geladen werden"),
        "detail.lessons": ("Lessons", "Lektionen"),
        "detail.completed": ("Completed", "Abgeschlossen"),
        "detail.pending": ("Pending", "Ausstehend"),
        "detail.markComplete": ("Mark complete", "Als erledigt markieren"),
        "detail.actionFailed": ("Couldn't update lesson", "Lektion konnte nicht aktualisiert werden"),
        "detail.ok": ("OK", "OK"),
        "detail.summary %lld %lld": ("%1$lld of %2$lld lessons completed", "%1$lld von %2$lld Lektionen abgeschlossen"),
    },
}

PLURALS = {
    os.path.join(SOURCES, "CoursesFeature", "Resources"): {
        "courses.summary.subtitle %lld": (
            {"one": "%lld course in progress", "other": "%lld courses in progress"},
            {"one": "%lld Kurs in Bearbeitung", "other": "%lld Kurse in Bearbeitung"},
        ),
        "courses.lessonCount %lld": (
            {"one": "%lld lesson", "other": "%lld lessons"},
            {"one": "%lld Lektion", "other": "%lld Lektionen"},
        ),
    },
}


def unit(value):
    return {"stringUnit": {"state": "translated", "value": value}}


def plural(forms):
    return {"variations": {"plural": {key: unit(value) for key, value in forms.items()}}}


def main():
    for directory in set(CATALOGS) | set(PLURALS):
        strings = {}
        for key, (english, german) in CATALOGS.get(directory, {}).items():
            strings[key] = {"localizations": {"en": unit(english), "de": unit(german)}}
        for key, (english, german) in PLURALS.get(directory, {}).items():
            strings[key] = {"localizations": {"en": plural(english), "de": plural(german)}}
        catalog = {"sourceLanguage": "en", "strings": dict(sorted(strings.items())), "version": "1.0"}
        os.makedirs(directory, exist_ok=True)
        with open(os.path.join(directory, "Localizable.xcstrings"), "w", encoding="utf-8") as file:
            json.dump(catalog, file, ensure_ascii=False, indent=2)
            file.write("\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
