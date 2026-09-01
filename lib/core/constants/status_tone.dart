/// Semantic color tone for [StatusBadge], decoupled from any one
/// feature's status enum so the widget can represent conversation
/// status today and channel/message status later without changes.
enum StatusTone { success, warning, danger, neutral, info }
