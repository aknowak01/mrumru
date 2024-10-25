import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

/// A class that represents a [UintDynamic] with a reminder.
class UintReminder<T extends UintDynamic> extends Equatable {
  /// The parsed value of type [UintDynamic].
  final T value;

  /// The remaining unprocessed bytes after parsing the value.
  final Uint8List reminder;

  /// Creates an instance of [UintReminder] with the given [value] and [reminder].
  ///
  /// [value] represents the parsed `UintDynamic`, and [reminder] contains
  /// any leftover bytes not yet processed.
  const UintReminder(this.value, this.reminder);

  @override
  List<Object?> get props => <Object?>[value, reminder];
}
