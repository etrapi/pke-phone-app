class FuturesDemo {

  //https://dart.dev/guides/libraries/futures-error-handling

  Future<String> getFutureMessage() =>
      // Devuelve un texto al cabo de 2 segundos
  Future.delayed(
    Duration(seconds: 2),
        () => 'Future message',
  );


}
