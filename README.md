# Flutter Network Capture

### Flutter developer、test network debugging tools，Easily view HTTPS requests

<img src="https://github.com/azhon/network_capture/raw/main/imgs/img_0.jpg" width="300"> <img src="https://github.com/azhon/network_capture/raw/main/imgs/img_1.jpg" width="300">
<img src="https://github.com/azhon/network_capture/raw/main/imgs/img_2.jpg" width="300"> <img src="https://github.com/azhon/network_capture/raw/main/imgs/img_3.jpg" width="300">
<img src="https://github.com/azhon/network_capture/raw/main/imgs/img_4.jpg" width="300">

### Usage
- Add dependencies [latest_version](https://pub.dev/packages/network_capture)

```
dependencies:
    network_capture: ^latest_version
```
- Change your App to `NetworkCaptureApp`

```
void main() {
  runApp(NetworkCaptureApp(
    enable: true,
    navigatorKey: navigatorKey,
    child: const MyApp(),
  ));
}
```
- Add `CaptureDioInterceptor` to Dio interceptors

```
dio.interceptors.add(CaptureDioInterceptor());
```
### Important! It is prohibited to use it in a release environment. We will not be responsible for any problems that arise.