sealed class Result<T, E> {
  const Result();

  bool get isOk => this is Ok<T, E>;
  bool get isErr => this is Err<T, E>;

  Result<U, E> map<U>(U Function(T value) f) => switch (this) {
        Ok(:final value) => Ok(f(value)),
        Err(:final error) => Err(error),
      };

  Result<U, E> flatMap<U>(Result<U, E> Function(T value) f) => switch (this) {
        Ok(:final value) => f(value),
        Err(:final error) => Err(error),
      };
}

final class Ok<T, E> extends Result<T, E> {
  const Ok(this.value);
  final T value;

  @override
  String toString() => 'Ok($value)';
}

final class Err<T, E> extends Result<T, E> {
  const Err(this.error);
  final E error;

  @override
  String toString() => 'Err($error)';
}
