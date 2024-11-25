# Flutter Network Capture

### Flutter developer、test network debugging tools，Easily view HTTPS requests

> [!NOTE]
> If you want to copy the content, you can try double tap or long pressing.

<img src="https://github.com/azhon/network_capture/raw/main/imgs/img_0.jpg" width="300"> <img src="https://github.com/azhon/network_capture/raw/main/imgs/img_1.jpg" width="300">
<img src="https://github.com/azhon/network_capture/raw/main/imgs/img_2.jpg" width="300"> <img src="https://github.com/azhon/network_capture/raw/main/imgs/img_3.jpg" width="300">
<img src="https://github.com/azhon/network_capture/raw/main/imgs/img_4.jpg" width="300">

### Usage
- Add dependencies [latest_version](https://pub.dev/packages/network_capture)

```yml
dependencies:
    network_capture: ^latest_version
```
- Change your App to `NetworkCaptureApp`

```dart
void main() {
  runApp(NetworkCaptureApp(
    enable: true,
    navigatorKey: navigatorKey,
    child: const MyApp(),
  ));
}
```
- Add `CaptureDioInterceptor` to Dio interceptors

```dart
dio.interceptors.add(CaptureDioInterceptor());
```
### Important! It is prohibited to use it in a release environment. We will not be responsible for any problems that arise.