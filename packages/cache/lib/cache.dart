library cache;

class CacheClient {
  final Map<String, Object> _cache;

  CacheClient() : _cache = <String, Object>{};
  // write the provide key, value pair to the in-memory cache.
  void write<T extends Object>({required String key, required T value}) {
    _cache[key] = value;
  }
  // looks up the value for the provided key
  T? read<T extends Object>({required String key}) {
    final value = _cache[key];
    if (value is T) return value;
    return null;
  }
  // remove the value for the provided key
  void remove<T extends Object>({required String key}){
    _cache.remove(key);
  }
}