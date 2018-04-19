'use strict';

import { NativeModules } from 'react-native';
module.exports = NativeModules.IOTWifi;

/**
 * isAvaliable(Callback callback)
 * connect(String ssid, int lifeTimeInDays, Boolean joinOnce, Callback callback)
 * connectSecure(String ssid, String passphrase, Boolean isWEP, int lifeTimeInDays, Boolean joinOnce, Callback callback)
 * removeSSID(String ssid, Callback callback)
 * getSSID(Callback callback)
 * Android only: forceWifiUsage()
 */