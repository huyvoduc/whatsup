class PageInfoDTO {
  int _limit = 10, _index = 0, _total;
  String _nextPageToken = '', _hasNextPage = '';

  PageInfoDTO();

  PageInfoDTO.fromMap(Map<dynamic, dynamic> map) {
    nextPageToken = map['next_page_token'].toString();
    hasNextPage = map['has_next_page'].toString();
  }

  get index => _index;

  set index(value) {
    _index = value;
  }

  String get nextPageToken => _nextPageToken;

  set nextPageToken(String value) {
    _nextPageToken = value;
  }

  int get limit => _limit;

  set limit(int value) {
    _limit = value;
  }

  get total => _total;

  set total(value) {
    _total = value;
  }

  get hasNextPage => _hasNextPage;

  set hasNextPage(value) {
    _hasNextPage = value;
  }
}
