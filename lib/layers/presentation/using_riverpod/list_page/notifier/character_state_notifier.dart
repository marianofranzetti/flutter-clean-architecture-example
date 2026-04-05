import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_template/layers/presentation/using_riverpod/list_page/notifier/character_page_state.dart';
import 'package:clean_template/layers/presentation/using_riverpod/providers.dart';

final characterPageStateProvider =
    NotifierProvider<CharacterStateNotifier, CharacterPageState>(
  CharacterStateNotifier.new,
);

class CharacterStateNotifier extends Notifier<CharacterPageState> {
  CharacterStateNotifier();

  @override
  CharacterPageState build() => const CharacterPageState();

  Future<void> fetchNextPage() async {
    if (state.hasReachedEnd) return;
    final getAllCharacters = ref.read(getAllCharactersProvider);

    state = state.copyWith(status: CharacterPageStatus.loading);

    final list = await getAllCharacters(page: state.currentPage);
    state = state.copyWith(
      status: CharacterPageStatus.success,
      currentPage: state.currentPage + 1,
      characters: List.of(state.characters)..addAll(list),
      hasReachedEnd: list.isEmpty,
    );
  }
}
