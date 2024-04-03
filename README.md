### Moneybox iOS Technical Challenge Submission

## Overview
Below is my submission for the Moneybox iOS technical challenge.

<img src="https://github.com/jesusrafaelchris/iOS-Tech-Task/assets/22798773/d334dca9-d0cc-42f2-b96c-0859a2ffb34f" height="500" /><img src="https://github.com/jesusrafaelchris/iOS-Tech-Task/assets/22798773/3da5c3a9-6734-4a08-9f24-b0dd030cf77a" height="500" /><img src="https://github.com/jesusrafaelchris/iOS-Tech-Task/assets/22798773/8df5f00d-ec88-48bb-b834-c9cac15e6451" height="500" /><img src="https://github.com/jesusrafaelchris/iOS-Tech-Task/assets/22798773/d8569759-d651-41a9-9d6b-d0fb711a24f7" height="500" />

## Technologies
The app is built using UIKit and programmatic UI with AutoLayout for creating its screens.
- The AccountsPage `collectionView` uses both `DiffableDataSource` and `CompositionalLayout` to layout the UI using the best new API's

## Design
- The app is designed off of the MoneyBox app, with a few modifications to the home page.

## Architecture
The app adopts an MVVM architecture, complemented by Coordinators for specialized tasks. 
- Communication between the view model and view controller primarily occurs through closures.
- Protocols are employed for dependency injection, facilitating easier testing and mocking.
- Delegates are also used for some communication.
- Modifications were made to the existing `Networking` package to add `viewData` models for injecting into views.

## Testing
Extensive unit testing is conducted on the ViewModels to ensure their functionality.
- The DataProvider was mocked to inject simulated network responses into views.
- Expectations are employed for asynchronous calls via closures.
- The test coverage is about 50%
- The tests are broken into each part of the app it tests


<img width="224" alt="Screenshot 2024-04-03 at 15 17 43" src="https://github.com/jesusrafaelchris/iOS-Tech-Task/assets/22798773/32fd8407-0e04-457b-a50c-dfd210d05e5c">

<img width="223" alt="Screenshot 2024-04-03 at 15 17 50" src="https://github.com/jesusrafaelchris/iOS-Tech-Task/assets/22798773/6856c56f-ff5e-43fb-abd4-cf5dbfed1564">

<img width="223" alt="Screenshot 2024-04-03 at 15 17 56" src="https://github.com/jesusrafaelchris/iOS-Tech-Task/assets/22798773/92abbe2d-9300-4f2c-a8b5-10bf41934eb7">

<img width="229" alt="Screenshot 2024-04-03 at 15 18 00" src="https://github.com/jesusrafaelchris/iOS-Tech-Task/assets/22798773/e061f016-acb1-479b-9659-60854a11bfa7">


## Accessibility
Accessibility considerations have been integrated for voiceover and rotor controls.
- Each UI element is equipped with an accessibility label and an appropriate trait to enhance user navigation.
- Grouped views are grouped together in accessibility for improved usability, such as the AccountCell representing one accessible element.
- For example, creating more natural and accessible labels for grouped elements:

```
isAccessibilityElement = true
accessibilityLabel = "\(viewData.friendlyName!), \(viewData.planValue), earning \(viewData.earningsAsPercentage)"
accessibilityHint = "Tap to view account"
```
  
<img src="https://github.com/jesusrafaelchris/iOS-Tech-Task/assets/22798773/7038f813-9ccf-4b82-a80d-d1b8b95768a1" height="500" /><img src="https://github.com/jesusrafaelchris/iOS-Tech-Task/assets/22798773/cb732565-d9c7-40a0-8c43-ec07895074fd" height="500" />
  
- Given more time, I would enhance accessibility by implementing support for dynamically adjusting text sizes.

## Future additions
- If I had more time I would have liked to add more to the UI of the individual accounts page.
- At the moment, the unit tests are focused alot on the logic ends, mostly the viewModels, I would have liked to test more of the viewControllers with unit tests and UI tests.
- A lot of the UI can probably be moved into subviews to break the views up a bit.
- I would have liked to have multiple sections on the `CompositionalLayout` to then load the data all inside the collectionView, this way I could take advantage of the `animatingDifferences = true` parameter to nicely fade in the data instead of showing a loading indicator.

## Thanks!
