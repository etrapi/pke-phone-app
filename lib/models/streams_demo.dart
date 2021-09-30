import 'dart:async';


class StreamsDemo {

  StreamController<String> streamController = StreamController.broadcast();

  StreamsDemo () {
    // https://medium.com/comunidad-flutter/usando-streams-en-flutter-28c9357772a9
    final duration = Duration(seconds: 1);
    Timer.periodic(duration, (Timer t) => streamController.add('You got a stream message! ' + t.tick.toString()));
  }
}