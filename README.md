# SimpleVaavudIntegration

<h3 align="center">
  <a href="https://www.vaavud.com">
    <img src="http://vaavud.com/brand/Vaavud_logo_vertical_RGB.png" width="400" />
    <br />
  </a>
</h3>

[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://developer.apple.com/swift/)
[![Twitter: @Vaavud](https://img.shields.io/badge/contact-%40Vaavud-blue.svg)](https://twitter.com/Vaavud)
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/vaavud/integration/blob/master/LICENSE)

Demonstrates how to easily integrate your app with Vaavud using URL schemes

To use Vaavud in your own app, follow the steps below. Read more about custom URL schemes [here](http://iosdevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html "iOS Developer Tips") or in the [documentation](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html "Inter-app communication").

### Opening the Vavud app
To simply open the Vaavud app and take a measurement, you need to ask your application to open a url that looks like this:```vaavud://x-callback-url/measure```
 - ```vaavud```: The scheme, this tells the device to look for an app that supports the vaavud scheme.
 - ```x-callback-url```: The host, it is chosen by Vaavud and invariable.
 - ```/measure```: The path, corresponding to the action you want to perform. Currently this is the only choice.

To do this, add the following code where you want to go to the Vaavud and take a measurement
```swift
let url = NSURL(scheme: "vaavud", host: "x-callback-url", path: "/measure")!
let success = UIApplication.sharedApplication().openURL(url)
```
At this point ```success``` will be ```true```if your device succeeded in opening the Vaavud app. If you want you can also check if the Vaavud app is installed, before asking calling ```openURL```, with:

```swift
let installed = UIApplication.sharedApplication().canOpenURL(url)
```

### Getting data back from the Vaavud app

In most cases you will also want the Vaavud app to get back to you with the measured value. To mae this possible you need to

1. Register a custom URL scheme for your app
2. Send information about this URL scheme to the Vaavud app when opening it
3. Make your app handle the callback from the Vaavud app


