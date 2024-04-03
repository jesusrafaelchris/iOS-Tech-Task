### Moneybox iOS Technical Challenge Submission

## Overview
Below is my submission for the Moneybox iOS technical challenge.



## Technologies
The app is built using UIKit and programmatic UI with AutoLayout for creating its screens.
- It is unit tested to ensure reliability and robustness.
- Protocols are employed for dependency injection, facilitating easier testing and mocking.

## Architecture
The app adopts an MVVM architecture, complemented by Coordinators for specialized tasks. Communication between the view model and view controller primarily occurs through closures.

## Testing
Extensive unit testing is conducted on the ViewModels to ensure their functionality.
- Mocks of the DataProvider are utilized to inject simulated network responses into views.
- Expectations are employed for asynchronous calls via closures.

## Accessibility
Accessibility considerations have been integrated for voiceover and rotor controls.
- Each UI element is equipped with an accessibility label and an appropriate trait to enhance user navigation.
- Grouped views are grouped together in accessibility for improved usability, such as the AccountCell representing one accessible element.
- For example:
- Given more time, I would enhance accessibility by implementing support for dynamically adjusting text sizes.
