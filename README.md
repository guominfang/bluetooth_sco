# bluetooth_sco

A Flutter plugin for managing Bluetooth SCO (Synchronous Connection Oriented) audio routing on Android.

## Overview

Bluetooth headsets connect in A2DP mode by default, which only supports audio output. To record audio from a Bluetooth headset microphone, the system must switch to SCO/HFP (Hands-Free Profile) mode. This plugin provides a simple API to manage that transition.

**Note:** iOS handles Bluetooth audio routing automatically, so this plugin only affects Android devices.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  bluetooth_sco:
    git: "https://github.com/guominfang/bluetooth_sco"
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:bluetooth_sco/bluetooth_sco.dart';

final bluetoothSco = BluetoothSco();

// Check if Bluetooth SCO is available
bool available = await bluetoothSco.isBluetoothScoAvailable();

if (available) {
  // Start Bluetooth SCO (with 600ms stabilization delay)
  bool started = await bluetoothSco.startBluetoothSco();

  if (started) {
    // Now you can start recording from the Bluetooth headset
    // ... your recording code here ...

    // Stop Bluetooth SCO when done
    await bluetoothSco.stopBluetoothSco();
  }
}
```

### Recording Workflow

```dart
// 1. Check availability
if (await bluetoothSco.isBluetoothScoAvailable()) {
  // 2. Start SCO before starting recorder
  await bluetoothSco.startBluetoothSco();

  // 3. Start your audio recorder
  await audioRecorder.start();

  // 4. Record audio...

  // 5. Stop recorder
  await audioRecorder.stop();

  // 6. Stop SCO
  await bluetoothSco.stopBluetoothSco();
}
```

## API Reference

### `isBluetoothScoAvailable()`

Returns `true` if a Bluetooth SCO/headset device is currently connected and available for recording.

- **Returns:** `Future<bool>`
- **Platform:** Android only (returns `false` on iOS)

### `startBluetoothSco({Duration stabilizationDelay})`

Activates Bluetooth SCO so the Android audio stack routes microphone input from the Bluetooth headset.

- **Parameters:**
  - `stabilizationDelay`: Time to wait after starting SCO for the connection to stabilize (default: 600ms)
- **Returns:** `Future<bool>` - `true` if SCO started successfully, `false` if no headset available
- **Platform:** Android only (returns `false` on iOS)

### `stopBluetoothSco()`

Deactivates Bluetooth SCO and restores normal Android audio mode. Safe to call even when SCO was never started.

- **Returns:** `Future<void>`
- **Platform:** Android only (no-op on iOS)

## Platform Support

- ✅ Android
- ⚠️ iOS (not needed - iOS handles Bluetooth audio routing automatically)

## License

This project is licensed under the MIT License.
