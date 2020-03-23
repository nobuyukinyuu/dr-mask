#  ![icon](https://user-images.githubusercontent.com/1023003/77360451-5f61a200-6d1b-11ea-9ace-eeaf54523d2f.png) DR-Mask
Dr-mask is a 3-way image masking utility used to produce difference maps from source images that can be used to create target images on the client-end.

## Screenshot
![](https://user-images.githubusercontent.com/1023003/77353412-e9efd480-6d0e-11ea-810a-05569fc36c86.png)


## Purpose
Some platforms have become increasingly hostile towards artists recently.  In order to comply with their terms of service, dr-mask allows an artist to post a safe image (the *source* image) to the host platform, and host another image elsewhere containing encoded data which can be used on the source image to produce the *target* image. The encoded data is in `*.png` format, allowing the artist many alternative hosting options. The original target image never leaves the artist's computer;  it is recreated on the client end using what data is provided.  

## How it Works
Most users only need to recreate a target image, so dr-mask starts in decoding mode by default.  Loading the source image with an overlay (in this case a difference map using plain settings) will produce the target image.  


![image](https://user-images.githubusercontent.com/1023003/77360911-37bf0980-6d1c-11ea-83dc-b7eb26d77cd6.png)

Because the intent is easily recognizable from a difference map even without the source or target information available to reference, dr-mask also provides an obfuscation process for the user encoding a diff.  This process is similar to older masking techniques, such as those provided by [gMask](http://gmask.awardspace.info/).  Images may be password-protected.

![image](https://user-images.githubusercontent.com/1023003/77360780-f9294f00-6d1b-11ea-9032-5037ed42204b.png)

Once obfuscated, configuration is saved to a string, which may be distributed by the artist on their platform of choice. Settings can be configured automatically when the correct string is input by the end-user. 

The currently available obfuscation techniques are an inverted block mask and 2-pass glass block masking with 8 possible permutations per block, per pass.  A passphrase can be used to change the configurations of each block individually.  All obfuscation passes are optional.  If a passphrase isn't provided, a standard pattern is used on each glass block pass.

## Tips
* Right-clicking an image preview is a quick way to bring up the load dialog.
* MouseX2 (aka Mouse5) will clear an image.
* Using *only* a source image in either encode or decode mode lets users play with default settings.  
  * However, don't forget to use the proper mode, as multiple shader passes need to be processed in stack order.
* For each pass, try using some numbers that permutate at irregular intervals;  this produces a more scrambled pattern.
  * Sometimes it's better to use numbers easily divisible by each other, though, to make it more difficult to guess the setting.
* Longer passwords increase entropy in the image and are more difficult to reverse-engineer. Each character encodes 2 blocks and is repeated throughout the image.

## How it *really* works (Technical information)
Dr-mask was created with [Godot Engine](https://godotengine.org/).

Difference maps are created by taking an image of pure gray, determining the distance from the source pixel to the destination pixel, and mapping this to a normalized value (Currently half of the maximum difference).  This is done internally using fragment shaders;  output images are saved in 24-bpp format and has not been tested with alpha values.  

Glass block shaders perform flip and swizzle operations on each block of pixels specified by the user.  Blocks can be encoded using a passphrase.  Each character is converted to 6 bits of information;  two for each operation (x-flip, y-flip, and swizzle, respectively).  the top two MSBs are discarded.  These are converted into a 16-color texture which is passed to the block shader and used to configure the orientation of the respective block.  The pattern is repeated throughout the image.

Inversion shaders operate on a similar principle, but in a checkerboard pattern, and can't be configured by passphrase.

## Limitations
* Diff images saved as `*.png` can only hold 8 bits per channel by default.  To produce diffs, dr-mask must reduce the target image's color fidelity to 21-bit color.  This is a mostly-unnoticable lossy process and may be improved in the future.
* The masking method is intended for digital artwork.  Difference maps for photographs won't compress well.
* Current obfuscation process may not be enough to hide the nature of the target image if a user has access to both source and diff images, regardless of their knowledge of the obfuscation settings.  Partial success can recover much of the original color information.
* Usage of Godot's low-processor mode may cause "lazy" image updates. Dr-mask attempts to work around this by temporarily disabling this mode whenever heavy processing needs to be performed.

## Planned Features
* Ability to specify rectangles of specific interest to undergo the encoding process
* Archive format which can contain multiple diff images as well as processing configuration metadata.
* Arbitary multiple shader passes
* Salting via color-modulation texture
* Optional individual password per image pass.
* Improved color fidelity for target image
* More obfuscation techniques

## Special Thanks
A thank you to all artists who found this program useful and shared it with others.  

## Contact
[Twitter](https://twitter.com/nobuyukinyuu)
