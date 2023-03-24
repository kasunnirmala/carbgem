enum Flavor {
  DEVELOPMENT,
  STAGING,
  PRODUCTION,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.DEVELOPMENT:
        return 'Development';
      case Flavor.STAGING:
        return 'Staging';
      case Flavor.PRODUCTION:
        return 'BiTTE';
      default:
        return 'title';
    }
  }

}
