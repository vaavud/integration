<h3 align="center">
  <a href="https://www.vaavud.com">
    <img src="http://vaavud.com/brand/Vaavud_logo_vertical_RGB.png" width="400" />
    <br />
  </a>
</h3>

[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://developer.apple.com/swift/)
[![Twitter: @Vaavud](https://img.shields.io/badge/contact-%40Vaavud-blue.svg)](https://twitter.com/Vaavud)
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/vaavud/integration/blob/master/LICENSE)

# SimpleVaavudIntegration

Demonstrates how to easily integrate your app with Vaavud using URL schemes

To use Vaavud in your own app, follow the steps below. Read more about custom URL schemes [here](http://iosdevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html "iOS Developer Tips") or in the [documentation](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html "Inter-app communication"). We follow the conventions in [x-callback-url](http://x-callback-url.com/ "x-callback-url website").

## Short version

- [Register](http://iosdevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html "iOS Developer Tips") a custom URL scheme for your app, for example ```mysimpleapp://```, in ```info.plist```.

- Open the Vaavud app and ask it to measure and get back to you with:
```swift
let url = NSURL(string: "vaavud://x-callback-url/measure?x-success=mysimpleapp://x-callback-url/measurement")!
let success = UIApplication.sharedApplication().openURL(url)
```

- Implement this method in your ```ÀppDelegate``` to handle the URL that Vaavud calls you back with:
```swift
func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
```
When the Vaavud app is done taking a measurement the above method will get called with a URL like the following:
```
mysimpleapp://x-callback-url/measurement?x-source=Vaavud&windSpeedAvg=5.23&windSpeedMax=7.93
```

## Long version

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

#### 1. Register a custom URL scheme

1. Open your info.plist file
2. Press the **+** on the heading (**Information Property List**) to add a new property
3. Choose to create **URL Types**
4. Open **Item 0** and type in an identifier of your choice as the string for **URL identifier**, e.g. *com.mycompany.myapp*
5. Press to **+** next to **Item 0** and create a new **URL Schemes** array.
6. Open **URL Schemes**, select its **Item 0** and type in the *scheme* you want to use in your app (see above), e.g. *mysimpleapp*.

![Your plist.info after these steps ](https://raw.githubusercontent.com/vaavud/integration/master/assets/PropertyListScreenshot.png)

Now your device will know that your app should handle, or at least get the option to handle, all urls with the scheme *mysimpleapp://*.

#### 2. Tell the Vaavud app about your scheme
Now you need to decide what your own custom URL scheme should look like. You have already selected the scheme *mysimpleapp*, but the rest is up to you. Let's say you also want to use ```x-callback-url```as host and ```measurement```as path. Then the complete callback url will look like this:

```
mysimpleapp://x-callback-url/measurement
```

This has to go in the *query* of the url that **you** use to call **Vaavud**. The query is a sort of dictionary with keys and values and it is the part of a url that follows the interrogation mark:
```
somescheme://somehost/somepath?key1=value1&key2=value2
```
In this case we need you to supply your callback url as the value for the key *x-success*, so instead of opening the Vaavud app as before, you will use this url:
```
vaavud://x-callback-url/measure?x-success=mysimpleapp://x-callback-url/measurement
```
So, replace your old code with this:

```swift
let url = NSURL(string: "vaavud://x-callback-url/measure?x-success=mysimpleapp://x-callback-url/measurement")!
let success = UIApplication.sharedApplication().openURL(url)
```

To be on the safe side, especially if you will be using special characters in your callback, you can also create the URL with ```NSURLComponents```, as we do in the example app.

#### 3. Handle the callback from Vaavud in your app
Now you need to implement the method on your ```ÀppDelegate``` that handles URL scheme calls, namely
```swift
func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
```

This method will gett called with a URL that begins with your scheme, your selected host and path and in the query the Vaavud app will put wind information, for example like this:
```
mysimpleapp://x-callback-url/measurement?x-source=Vaavud&windSpeedAvg=5.23&windSpeedMax=7.93
```
It remains for you to parse this URL query and use the information in your app. In the example app there is a basic parser that returns the value for a supplied key if present, otherwise ```nil```. With the help of this we extract the average windspeed and tell our ViewController to display it.

```swift
func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    if let vc = window?.rootViewController as? ViewController,
        windspeedString = parseUrlQuery(url, key: "windSpeedAvg") {
            vc.displayMessage("The wind is " + windspeedString + " m/s")
    }
    
    return true
}
```

The Vaavud app also returns a key-value pair ```x-source = Vaavud```, following the conventions of *x-callback-url*. Also following these conventions, it will return with ```x-cancel = cancel``` if the user cancels the measurement. Finally, you may want to check the host and path of the URL and return ```false```if they are not as expected.



