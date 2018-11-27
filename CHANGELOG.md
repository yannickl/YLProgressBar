## Changelog

### Version 3.11.0

- [ADD] `hideInnerWhiteShadow` property to hide the inner white shadow on rounded type (#62).

### Version 3.10.0

- [ADD] `uniformTintColor` property

### Version 3.9.0

- [UPDATE] Supports Xcode 7.3
- [ADD] `YLProgressBarIndicatorTextDisplayModeFixedRight` for the `indicatorTextDisplayMode`.

### Version 3.8.0

- [ADD] Expose the `cornerRadius` property

### Version 3.7.0

- [ADD] `progressStretch` property to change the gradient display behaviour (stretched or not)

### Version 3.6.0

- [ADD] IBDesignable/IBInspectable macros to work with interface builder more easily
- [ADD] `progressBarInset` property to determines the inset between the track and the track for the rounded progress bar type
- [ADD] Test project
- [FIX] Cleaning deprecated apis
- [FIX] Text not updating sometimes

### Version 3.5.2

- [UPDATE] Label display behavior

### Version 3.5.1

- [FIX] Minor glitches with the gloss display

### Version 3.5.0

- [ADD] The `hideTrack` property to display/hide the background of the progress bar
- [FIX] The `hideGloss` property now affects the inner gloss

### Version 3.4.0

- [ADD] `stripesDelta` property to customise the distance between the top and the bottom point

### Version 3.3.0

- [ADD] `stripesDirection` property to change the stripes direction of their movement
- [ADD] `stripesAnimationVelocity` property to update the velocity of the stripe animation

### Version 3.2.0

- [ADD] `hideGloss` property to manage the display of the gloss effect

### Version 3.1.1

- [FIX] Stop the stripes animation when hidden #13

### Version 3.1.0

- [FIX] Gloss effect on the stripes
- [ADD] `indicatorTextLabel` property to display the value inside the progress
- [ADD] `indicatorTextDisplayMode` property to change the indicator text display
- [ADD] `type` property to display the progress as flat or rounded
- [FIX] `setProgress:Animated:` not animated

### Version 3.0.0

- [UPDATE] Makes the YLProgressBar inherits from `UIView` instead of `UIProgressView` to work with iOS7
- [ADD] `hideStripes` property to remove the stripes
- [ADD] `stripesColor` property to change the stripes color
- [ADD] `behavior` property to define the behaviour of the progress bar in certain case.
- [ADD] `progressTintColors` property to define a gradient of colours
- [ADD] `setProgress:animated:` method
- [ADD] `YLProgressBarStripesOrientationVertical` orientation
- [UPDATE] `progressStripeAnimated` property => `stripesAnimated`
- [UPDATE] `progressStripeOrientation` property => `stripesOrientation`
- [UPDATE] `progressStripeWidth` property => `stripesWidth`

### Version 2.0.0

- [ADD] Documentation with appledoc
- [ADD] `progressStripeOrientation` property for the stripes orientation
- [ADD] `progressStripeWidth` property for the stripes width
- [UPDATE] `animated` property => `progressStripeAnimated`

### Version 1.0.1

- [REFACTORING] Put the YLProgressBar files to a separate folder and update the sample project for iOS6/Xcode4.6
- [FIX] progress bar clipping
- [ADD] MIT Licence

### Version 1.0.0 (Initial Commit)

- ARC compatible
- [CocoaPods](http://cocoapods.org/) integration
- `progressTintColor` property to change the progress color
- `animated` property to enable/disable the stripes animation
