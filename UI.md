# UI.md - UI Reference

## Reusable Widgets (`lib/presentation/widgets/`)

| Widget                     | Purpose                                      | Key Props                                                                 |
| -------------------------- | -------------------------------------------- | ------------------------------------------------------------------------- |
| `AppButton`                | Primary action button                        | text, onTap, buttonColor, textColor, borderColor, enabled, child          |
| `AppIconButton`            | Circular icon button                         | icon, onTap, iconSize, enabled, padding                                   |
| `AppTextField`             | Text input with variants                     | controller, hintText, labelText, type (general/search/currency), onChanged |
| `AppDropDown`              | Single or multi-select dropdown              | selectedValue, dropdownItems, onChanged, labelText                        |
| `AppDialog`                | Modal dialog (static: show, showError, showProgress) | title, text, child, leftButtonText, rightButtonText, dismissible  |
| `AppSnackBar`              | Snackbar (static: show, showError)           | message, context                                                          |
| `AppProgressIndicator`     | Centered loading spinner                     | message, showMessage                                                      |
| `AppLoadingMoreIndicator`  | Animated loading indicator for infinite scroll | isLoading, padding                                                       |
| `AppEmptyState`            | Empty state placeholder                      | title, subtitle, buttonText, onTapButton                                  |
| `AppErrorWidget`           | Error display (full or text-only)            | error, message, textOnly                                                  |
| `LearningCategoryCard`     | Tappable card for vocab/Kanji/exam category  | title, subtitle, trailingInfo, disabled, onTap                            |

## Screen Structure

Screens follow a consistent pattern:

- `ConsumerWidget` or `ConsumerStatefulWidget` for Riverpod access
- `ConsumerStatefulWidget` triggers its notifier `load()` from `initState` via
  `WidgetsBinding.instance.addPostFrameCallback`
- `Scaffold` with `AppBar`
- Bottom navigation lives in `MainScreen` (a `NavigationBar` inside a GoRouter `ShellRoute`);
  feature list screens are `pageBuilder` children, detail/quiz screens `push` on the root navigator
- List screens use `ListView.separated`; the exam grid uses `GridView` with
  `SliverGridDelegateWithMaxCrossAxisExtent`
- Empty/loading/error states handled inline
- Quiz screens switch on a `QuizPhase` enum (`setup` / `playing` / `finished`) rendering a
  sub-view widget per phase from `components/`

### Grid Layout

```dart
SliverGrid(
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200,
    childAspectRatio: 1 / 1.5,
    crossAxisSpacing: AppSizes.padding / 2,
    mainAxisSpacing: AppSizes.padding / 2,
  ),
)
```

## Screen Components

Each screen can have a `components/` subfolder for private sub-widgets specific to that screen.

```
screens/
└── home/
    ├── home_screen.dart
    └── components/
        ├── cart_panel_header.dart
        ├── cart_panel_body.dart
        └── cart_panel_footer.dart
```

## Sizing & Spacing (`AppSizes`)

| Constant       | Value | Usage                          |
| -------------- | ----- | ------------------------------ |
| `padding`      | 18    | Standard padding/margin        |
| `margin`       | 18    | Standard margin                |
| `radius`       | 8     | Border radius                  |
| `padding / 2`  | 9     | Tight spacing                  |
| `padding / 4`  | 4.5   | Minimal spacing                |
| `padding * 2`  | 36    | Large spacing                  |

Responsive helpers: `screenWidth(context)`, `screenHeight(context)`, `viewPadding(context)`, `appBarHeight()`

## Color Usage

Always reference colors via `Theme.of(context).colorScheme`:

```dart
colorScheme.primary
colorScheme.surface
colorScheme.surfaceContainer
colorScheme.surfaceContainerLowest
colorScheme.onSurface
colorScheme.onSurfaceVariant
colorScheme.outline
colorScheme.error
colorScheme.tertiary
colorScheme.secondary
```

Text styles via `Theme.of(context).textTheme`: `bodySmall`, `bodyMedium`, `bodyLarge`, `labelSmall`, `labelLarge`, `titleMedium`, `titleLarge`.

## UI Patterns

- **Disabled state**: 0.5 opacity on buttons/cards, `onTap: null`
- **"Sắp có" categories**: `LearningCategoryCard(disabled: true)` shows a badge instead of a chevron
- **Quiz answer feedback**: correct choice card → `Colors.green.shade600`, wrong pick → `Colors.red.shade600`
- **TTS**: `ref.read(ttsServiceProvider).speak(hiragana)` behind a `volume_up` icon button
- **Dialogs/Snackbars**: Use `AppRoutes.rootNavigatorKey` for global context access
