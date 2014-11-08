## Changelog

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

- [ADD] Documentations
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

