# 🌐 Localization

Pink Auto supports three languages with **zero network cost** — all translations live in a static in-memory dictionary inside `LanguageCubit`.

---

## Supported Languages

| Code | Language | Script |
|---|---|---|
| `en` | English | Latin |
| `hi` | Hindi | Devanagari |
| `mr` | Marathi | Devanagari |

---

## Architecture

```
lib/core/localization/
├── language_cubit.dart    # LanguageCubit — holds current language + translation map
├── language_state.dart    # LanguageState — immutable state with language code
└── translated_text.dart   # TranslatedText widget — thin wrapper over Text
```

---

## `LanguageCubit`

**File**: [`lib/core/localization/language_cubit.dart`](../lib/core/localization/language_cubit.dart)

- Extends `Cubit<LanguageState>`.
- Provided globally via `BlocProvider<LanguageCubit>` in `main.dart`.
- Contains an inline `Map<String, Map<String, String>>` static dictionary for all UI strings.
- Exposes `translate(String key)` → returns the current-language string for the given key, or falls back to English if the key is missing.

### Switching Language

```dart
context.read<LanguageCubit>().setLanguage('hi'); // Switch to Hindi
context.read<LanguageCubit>().setLanguage('mr'); // Switch to Marathi
context.read<LanguageCubit>().setLanguage('en'); // Switch to English
```

---

## `TranslatedText` Widget

**File**: [`lib/core/localization/translated_text.dart`](../lib/core/localization/translated_text.dart)

A convenience widget that reads `LanguageCubit` from context and displays the translated value for a key.

```dart
TranslatedText(
  'welcome_title',
  style: Theme.of(context).textTheme.headlineLarge,
)
```

This is equivalent to:

```dart
BlocBuilder<LanguageCubit, LanguageState>(
  builder: (context, state) {
    return Text(
      context.read<LanguageCubit>().translate('welcome_title'),
      style: Theme.of(context).textTheme.headlineLarge,
    );
  },
)
```

---

## Adding a New String

1. Open [`language_cubit.dart`](../lib/core/localization/language_cubit.dart).
2. Add your key to all three language maps (`en`, `hi`, `mr`).
3. Use `TranslatedText('your_key')` or `context.read<LanguageCubit>().translate('your_key')` in your widget.

### Example

```dart
// In language_cubit.dart
static const _translations = {
  'en': {
    'book_now': 'Book Now',
    // ... your new key:
    'my_new_key': 'Hello',
  },
  'hi': {
    'book_now': 'अभी बुक करें',
    'my_new_key': 'नमस्ते',
  },
  'mr': {
    'book_now': 'आत्ता बुक करा',
    'my_new_key': 'नमस्कार',
  },
};
```

---

## Language Selection UI

The language selector is exposed as a **bottom drawer** launched from the Onboarding screen. It lists the three supported languages with their native script names and a checkmark on the active selection.

- Drawer closes on selection and immediately re-renders the onboarding content in the chosen language.
- The selected language persists for the lifetime of the app session (in-memory, via `LanguageCubit` state).

> [!NOTE]
> Language preference is not persisted to disk. On app restart, the language resets to English. To add persistence, save the language code to `SessionStorage` and reload it in `LanguageCubit`'s constructor.
