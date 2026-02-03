import 'package:flutter/widgets.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';
import 'extensions.dart';

extension NetworkExceptionLocalization on NetworkException {
  String getLocalizedMessage(BuildContext context) {
    final l10n = context.appLocalizations;
    if (l10n == null) return message ?? 'Unknown error';

    if (message != null && type == NetworkErrorType.other) {
      return message ?? l10n.errorPleaseTryAgain;
    }

    return switch (type) {
      NetworkErrorType.connectTimeout => l10n.errorConnectTimeout,
      NetworkErrorType.sendTimeout => l10n.errorSendTimeout,
      NetworkErrorType.receiveTimeout => l10n.errorReceiveTimeout,
      NetworkErrorType.cancel => l10n.errorRequestCanceled,
      NetworkErrorType.other => message ?? l10n.errorRequestToServer,
    };
  }
}

extension ServerFailureLocalization on ServerFailure {
  String getLocalizedMessage(BuildContext context) {
    final l10n = context.appLocalizations;
    if (l10n == null) return message;

    return switch (code) {
      400 => message.isNotEmpty ? message : l10n.errorBadRequest,
      401 => l10n.errorUnauthorized,
      403 => l10n.errorForbidden,
      404 => l10n.errorNotFound,
      422 => message.isNotEmpty ? message : l10n.errorValidation,
      429 => l10n.errorTooManyRequests,
      500 => l10n.errorInternalServer,
      502 => l10n.errorBadGateway,
      503 => l10n.errorMaintenance,
      504 => l10n.errorGatewayTimeout,
      _ => l10n.errorUnknown,
    };
  }
}

extension FailureLocalization on Failure {
  String getLocalizedMessage(BuildContext context) {
    _logError();

    final l10n = context.appLocalizations;
    if (l10n == null) return message;

    return switch (this) {
      NetworkFailure(exception: final exception) =>
        exception.getLocalizedMessage(context),
      NullFailure() => l10n.errorNullResponse,
      ServerFailure() => (this as ServerFailure).getLocalizedMessage(context),
      UnknownFailure() => l10n.errorUnknown,
      _ => message,
    };
  }

  void _logError() {
    debugPrint('==================== API ERROR LOG ====================');
    debugPrint('Type        : $runtimeType');
    debugPrint('Message     : $message');

    if (this is ServerFailure) {
      debugPrint('Status Code : ${(this as ServerFailure).code}');
    }

    if (this is NetworkFailure) {
      final netException = (this as NetworkFailure).exception;
      debugPrint('Net Type    : ${netException.type}');
      debugPrint('Original    : ${netException.message}');
    }
    debugPrint('=======================================================');
  }
}
