// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'view_state.freezed.dart';

//参考资料：https://twitter.com/craig_labenz/status/1491583794054270976?t=MYANpSSSz2RzRRc5Hr81QA&s=19
@freezed
class ViewState<T> with _$ViewState<T> {
  const factory ViewState.idle() = Idle;
  const factory ViewState.loading() = Loading;
  const factory ViewState.ready(T data) = Ready<T>;
  const factory ViewState.error({required String error}) = Error;
}
