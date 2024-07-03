// Create a enum with the WMO just below

enum WmoType {
  clearSky, // 0
  mainlyClearPartlyCloudyOvercast, // 1, 2, 3
  fogDepositionRimeFog, // 45, 48
  drizzleLightModerateDense, // 51, 53, 55
  freezingDrizzleLightDenseIntensity, // 56, 57
  rainsSlightModerateHeavyIntensity, // 61, 63, 65
  freezingRainLightHeavyIntensity, // 66, 67
  snowFallSlightModerateHeavyIntensity, // 71, 73, 75
  snowGrains, // 77
  rainShowersSlightModerateViolent, // 80, 81, 82
  snowShowersSlightHeavy, // 85, 86
  thunderstormSlightModerate, // 95
  thunderstormSlightHeavyHail // 96, 99
}

class WmoTypeHelper {
  static final Map<WmoType, List<int>> _wmoRanges = {
    WmoType.clearSky: [0],
    WmoType.mainlyClearPartlyCloudyOvercast: [1, 2, 3],
    WmoType.fogDepositionRimeFog: [45, 48],
    WmoType.drizzleLightModerateDense: [51, 53, 55],
    WmoType.freezingDrizzleLightDenseIntensity: [56, 57],
    WmoType.rainsSlightModerateHeavyIntensity: [61, 63, 65],
    WmoType.freezingRainLightHeavyIntensity: [66, 67],
    WmoType.snowFallSlightModerateHeavyIntensity: [71, 73, 75],
    WmoType.snowGrains: [77],
    WmoType.rainShowersSlightModerateViolent: [80, 81, 82],
    WmoType.snowShowersSlightHeavy: [85, 86],
    WmoType.thunderstormSlightModerate: [95],
    WmoType.thunderstormSlightHeavyHail: [96, 99]
  };

  static final Map<WmoType, List<String>> _description = {
    WmoType.clearSky: ['Clear sky'],
    WmoType.mainlyClearPartlyCloudyOvercast: [
      'Mainly clear',
      'partly cloudy',
      'overcast'
    ],
    WmoType.fogDepositionRimeFog: ['Fog', 'depositing rime fog'],
    WmoType.drizzleLightModerateDense: [
      'Drizzle light',
      'Drizzle moderate',
      'Drizzle dense'
    ],
    WmoType.freezingDrizzleLightDenseIntensity: [
      'Freezing drizzle light',
      'Freezing drizzle dense'
    ],
    WmoType.rainsSlightModerateHeavyIntensity: [
      'Rain slight',
      'Rain moderate',
      'Rain heavy'
    ],
    WmoType.freezingRainLightHeavyIntensity: [
      'Freezing rain light',
      'Freezing rain heavy'
    ],
    WmoType.snowFallSlightModerateHeavyIntensity: [
      'Snow fall slight',
      'Snow fall moderate',
      'Snow fall heavy'
    ],
    WmoType.snowGrains: ['Snow grains'],
    WmoType.rainShowersSlightModerateViolent: [
      'Rain slight',
      'Rain moderate',
      'Rain violent'
    ],
    WmoType.snowShowersSlightHeavy: ['Snow slight', 'Snow heavy'],
    WmoType.thunderstormSlightModerate: [
      'Thunderstorm slight',
      'Thunderstorm moderate'
    ],
  };

  static String getDescription(int code) {
    for (var entry in _wmoRanges.entries) {
      if (entry.value.contains(code)) {
        int index = entry.value.indexOf(code);
        return _description[entry.key]![index];
      }
    }
    return "unknown";
  }
}



/*
  WMO Weather interpretation codes (WW)
  Code	Description
    * 0	Clear sky
    * 1, 2, 3	Mainly clear, partly cloudy, and overcast
    * 45, 48	Fog and depositing rime fog
    * 51, 53, 55	Drizzle: Light, moderate, and dense intensity
    * 56, 57	Freezing Drizzle: Light and dense intensity
    * 61, 63, 65	Rain: Slight, moderate and heavy intensity
    * 66, 67	Freezing Rain: Light and heavy intensity
    * 71, 73, 75	Snow fall: Slight, moderate, and heavy intensity
    * 77	Snow grains
    * 80, 81, 82	Rain showers: Slight, moderate, and violent
    * 85, 86	Snow showers slight and heavy
    * 95 *	Thunderstorm: Slight or moderate
    * 96, 99 *	Thunderstorm with slight and heavy hail
*/
