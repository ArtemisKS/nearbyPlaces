# NearbyPlaces

## ```NearbyPlaces``` is a food places searching app
It gives you the list of food places from [this site](https://developers.arcgis.com/)  
You can move around 20 first of them as pins on the map or look through their entirety in a separate list
It also stores the last 20 pins displayed on the map offline (in a Core Data)

---

## Cloning the repo & installation

To get this app up and running
* clone the repository and open NearbyPlaces.xcodeproj
* install carthage, if necessary (`brew install carthage`)
* run `carthage update` 
* if GoogleMaps framework throws compilation error, add frameworks from path `Carthage/Build/iOS/` in target's `General` tab or in `Build Phases - Link Binary With Libraries` (In case of unsuccessful attempt, visit [this link](https://developers.google.com/maps/documentation/places/ios-sdk/start))
* You're good to go!


---

## Screencasts

<img src="/images/NearbyPlaces1.gif" height="853" width="394"> <img src="/images/NearbyPlaces2.gif" height="853" width="394">

<img src="/images/NearbyPlaces3.gif" height="853" width="394"> <img src="/images/NearbyPlaces4.gif" height="853" width="394">

---

The project is written in MVC (classic MVC pattern, basically MVP, not Apple MVC), with principles of SOLID in mind. Samples of Unit Tests are also provided.

## Will surely strive to do better!
