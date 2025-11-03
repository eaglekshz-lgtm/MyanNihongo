import '../../features/vocabulary/data/models/vocabulary_item_model.dart';

/// Mock vocabulary data for testing and development
class MockVocabularyData {
  static List<VocabularyItemModel> getSampleVocabulary() {
    return [
      VocabularyItemModel(
        id: 1,
        word: 'こんにちは',
        reading: 'konnichiwa',
        partOfSpeech: 'greeting',
        translations: const TranslationModel(
          burmese: 'မင်္ဂလာပါ',
          english: 'Hello, Good day',
        ),
        exampleSentences: [],
      ),
      VocabularyItemModel(
        id: 2,
        word: 'ありがとう',
        reading: 'arigatou',
        partOfSpeech: 'expression',
        translations: const TranslationModel(
          burmese: 'ကျေးဇူးတင်ပါတယ်',
          english: 'Thank you',
        ),
        exampleSentences: [],
      ),
      VocabularyItemModel(
        id: 3,
        word: '兄妹',
        reading: 'kyoudai',
        partOfSpeech: 'noun',
        translations: const TranslationModel(
          burmese: 'မောင်နှမ',
          english: 'Siblings',
        ),
        exampleSentences: [],
      ),
      VocabularyItemModel(
        id: 4,
        word: '本',
        reading: 'hon',
        partOfSpeech: 'noun',
        translations: const TranslationModel(
          burmese: 'စာအုပ်',
          english: 'Book',
        ),
        exampleSentences: [],
      ),
      VocabularyItemModel(
        id: 5,
        word: '学校',
        reading: 'gakkou',
        partOfSpeech: 'noun',
        translations: const TranslationModel(
          burmese: 'ကျောင်း',
          english: 'School',
        ),
        exampleSentences: [],
      ),
      VocabularyItemModel(
        id: 6,
        word: '水',
        reading: 'mizu',
        partOfSpeech: 'noun',
        translations: const TranslationModel(
          burmese: 'ရေ',
          english: 'Water',
        ),
        exampleSentences: [],
      ),
      VocabularyItemModel(
        id: 7,
        word: '仕事',
        reading: 'shigoto',
        partOfSpeech: 'noun',
        translations: const TranslationModel(
          burmese: 'အလုပ်',
          english: 'Work, Job',
        ),
        exampleSentences: [],
      ),
      VocabularyItemModel(
        id: 8,
        word: '時間',
        reading: 'jikan',
        partOfSpeech: 'noun',
        translations: const TranslationModel(
          burmese: 'အချိန်',
          english: 'Time',
        ),
        exampleSentences: [],
      ),
    ];
  }
}
