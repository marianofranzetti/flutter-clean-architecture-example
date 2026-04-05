import 'package:clean_template/layers/domain/entity/character.dart';

class DetailsPageState {
  const DetailsPageState({this.character});

  final Character? character;

  DetailsPageState copyWith({Character? character}) {
    return DetailsPageState(character: character ?? this.character);
  }
}
