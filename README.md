<p align="center">
  <img src="https://github.com/YannickL/YLProgressBar/raw/master/web/ylprogressbar_header.png" alt="YLProgressBar" />
</p>

<p align="center">
  <a href="http://cocoadocs.org/docsets/YLProgressBar/"><img alt="Supported Platforms" src="https://cocoapod-badges.herokuapp.com/p/YLProgressBar/badge.svg"/></a>
  <a href="http://cocoadocs.org/docsets/YLProgressBar/"><img alt="Version" src="https://cocoapod-badges.herokuapp.com/v/YLProgressBar/badge.svg"/></a>
</p>

The **YLProgressBar** is an UIProgressView replacement with an highly and fully customizable animated progress bar in pure Core Graphics

![](https://github.com/YannickL/YLProgressBar/raw/master/web/YLProgressBar.gif)

It has been implemented using the Core Graphics framework without any images. So it can be customize freely and independently the platform.

<p align="center">
    <a href="#usage">Usage</a> • <a href="#installation">Installation</a> • <a href="#contribution">Contribution</a> • <a href="#contact">Contact</a> • <a href="#license-mit">License</a>
</p>

## Usage

Here are some examples to show you how the `YLProgressBar` can be configured:

```objc
// Blue flat progress, with no stripes
_progressBar.type               = YLProgressBarTypeFlat;
_progressBar.progressTintColor  = [UIColor blueColor];
_progressBar.hideStripes        = YES;

// Green rounded/gloss progress, with vertical animated stripes in the left direction
_progressBar.type               = YLProgressBarTypeRounded;
_progressBar.progressTintColor  = [UIColor greenColor];
_progressBar.stripesOrientation = YLProgressBarStripesOrientationVertical;
_progressBar.stripesDirection   = YLProgressBarStripesDirectionLeft;

// Rainbow flat progress, with the indicator text displayed over the progress bar
NSArray *rainbowColors = @[[UIColor colorWithRed:33/255.0f green:180/255.0f blue:162/255.0f alpha:1.0f],
                           [UIColor colorWithRed:3/255.0f green:137/255.0f blue:166/255.0f alpha:1.0f],
                           [UIColor colorWithRed:91/255.0f green:63/255.0f blue:150/255.0f alpha:1.0f],
                           [UIColor colorWithRed:87/255.0f green:26/255.0f blue:70/255.0f alpha:1.0f],
                           [UIColor colorWithRed:126/255.0f green:26/255.0f blue:36/255.0f alpha:1.0f],
                           [UIColor colorWithRed:149/255.0f green:37/255.0f blue:36/255.0f alpha:1.0f],
                           [UIColor colorWithRed:228/255.0f green:69/255.0f blue:39/255.0f alpha:1.0f],
                           [UIColor colorWithRed:245/255.0f green:166/255.0f blue:35/255.0f alpha:1.0f],
                           [UIColor colorWithRed:165/255.0f green:202/255.0f blue:60/255.0f alpha:1.0f],
                           [UIColor colorWithRed:202/255.0f green:217/255.0f blue:54/255.0f alpha:1.0f],
                           [UIColor colorWithRed:111/255.0f green:188/255.0f blue:84/255.0f alpha:1.0f]];

_progressBar.type                     = YLProgressBarTypeFlat;
_progressBar.hideStripes              = YES;
_progressBar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeProgress;
_progressBar.progressTintColors       = rainbowColors;

// To allow the gradient colors to fit the progress width
_progressBar.progressStretch          = YES;
```

You can also use the `UIAppearence` protocol to configure all the progress bar at once:

```objc
[[YLProgressBar appearance] setType:YLProgressBarTypeFlat];
[[YLProgressBar appearance] setProgressTintColor:[UIColor blueColor]];
```

## Installation

The recommended approach to use the _YLProgressBar_ in your project is using the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.

#### CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
Go to the directory of your Xcode project, and Create and Edit your Podfile and add YLProgressBar:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios
pod 'YLProgressBar', '~> 3.10.2'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

#### Manually

[Download](https://github.com/YannickL/YLProgressBar/archive/master.zip) the project and copy the `YLProgressBar` folder into your project and then simply `#import "YLProgressBar.h"` in the file(s) you would like to use it in.

## Contribution

Contributions are welcomed and encouraged *♡*.

## Contact

Yannick Loriot
 - [https://21.co/yannickl/](https://21.co/yannickl/)
 - [https://twitter.com/yannickloriot](https://twitter.com/yannickloriot)

## License (MIT)
Copyright 2012 - present, Yannick Loriot.
http://yannickloriot.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
