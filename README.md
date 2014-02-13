# Clean URLs Plugin for [DocPad](https://docpad.org)

<!-- BADGES/ -->

[![Build Status](http://img.shields.io/travis-ci/docpad/docpad-plugin-cleanurls.png?branch=master)](http://travis-ci.org/docpad/docpad-plugin-cleanurls "Check this project's build status on TravisCI")
[![NPM version](http://badge.fury.io/js/docpad-plugin-cleanurls.png)](https://npmjs.org/package/docpad-plugin-cleanurls "View this project on NPM")
[![Dependency Status](https://david-dm.org/docpad/docpad-plugin-cleanurls.png?theme=shields.io)](https://david-dm.org/docpad/docpad-plugin-cleanurls)
[![Development Dependency Status](https://david-dm.org/docpad/docpad-plugin-cleanurls/dev-status.png?theme=shields.io)](https://david-dm.org/docpad/docpad-plugin-cleanurls#info=devDependencies)<br/>
[![Gittip donate button](http://img.shields.io/gittip/docpad.png)](https://www.gittip.com/docpad/ "Donate weekly to this project using Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")
[![BitCoin donate button](http://img.shields.io/bitcoin/donate.png?color=yellow)](https://coinbase.com/checkouts/9ef59f5479eec1d97d63382c9ebcb93a "Donate once-off to this project using BitCoin")
[![Wishlist browse button](http://img.shields.io/wishlist/browse.png?color=yellow)](http://amzn.com/w/2F8TXKSNAFG4V "Buy an item on our wishlist for us")

<!-- /BADGES -->


Adds support for clean URLs to [DocPad](https://docpad.org)


## Install

```
docpad install cleanurls
```


## Usage/Configure


### `static`

In non-static environments we work by setting the document's url to it's clean url. This means that redirection occurs on the dynamic server level.

For the `static` environment (i.e. when running docpad with the `--env static` flag, e.g. running `docpad generate --env static`) we will set the `static` plugin configuration option to `true`. This will in addition to performing redirections via the built-in dynamic server within DocPad for speed, we will also write special static redirection HTML files to the output directory, that will redirect the user to the new clean location (e.g. the document `pages/welcome.html` will not we outputted to `pages/welcome/index.html`, with `pages/welcome.html` now being a special HTML redirect document to the clean location).

If you would like to always use the static mode, you can set the `static` plugin configuration option to true by doing:

``` coffee
plugins:
	cleanurls:
		static: true
```

If you would like to disable the static mode for the static environment, you can do so by doing:

``` coffee
environments:
	static:
		plugins:
			cleanurls:
				static: false
```


### `trailingSlashes`
Enable this plugin configuration option to generate `document.url`s like `'/beep/'` instead of `/beep`.  Defaults to `false`.


### `collectionName`
You can use this plugin configuration option (defaults to `html`) to tell the cleanurls plugin to use your own custom collection for which documents to apply cleanurls to.

For insstance, if you are wanting to remove all cleanurls for all documents that have `cleanurls: false` in the meta data, then you could do the following in your docpad configuration file:

``` coffee
# Define a custom collection for cleanurls that ignores the documents we don't want
collections:
	cleanurls: ->
		@getCollection('html').findAllLive(cleanurls: $ne: false)

# Tell our clean urls plugin to use this collection
plugins:
	cleanurls:
		collectionName: 'cleanurls'
```


<!-- HISTORY/ -->

## History
[Discover the change history by heading on over to the `HISTORY.md` file.](https://github.com/docpad/docpad-plugin-cleanurls/blob/master/HISTORY.md#files)

<!-- /HISTORY -->


<!-- CONTRIBUTE/ -->

## Contribute

[Discover how you can contribute by heading on over to the `CONTRIBUTING.md` file.](https://github.com/docpad/docpad-plugin-cleanurls/blob/master/CONTRIBUTING.md#files)

<!-- /CONTRIBUTE -->


<!-- BACKERS/ -->

## Backers

### Maintainers

These amazing people are maintaining this project:

- Benjamin Lupton <b@lupton.cc> (https://github.com/balupton)

### Sponsors

No sponsors yet! Will you be the first?

[![Gittip donate button](http://img.shields.io/gittip/docpad.png)](https://www.gittip.com/docpad/ "Donate weekly to this project using Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")
[![BitCoin donate button](http://img.shields.io/bitcoin/donate.png?color=yellow)](https://coinbase.com/checkouts/9ef59f5479eec1d97d63382c9ebcb93a "Donate once-off to this project using BitCoin")
[![Wishlist browse button](http://img.shields.io/wishlist/browse.png?color=yellow)](http://amzn.com/w/2F8TXKSNAFG4V "Buy an item on our wishlist for us")

### Contributors

These amazing people have contributed code to this project:

- [Benjamin Lupton](https://github.com/balupton) <b@lupton.cc> — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=balupton)
- [hurrymaplelad](https://github.com/hurrymaplelad) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=hurrymaplelad)
- [misterdai](https://github.com/misterdai) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=misterdai)
- [RobLoach](https://github.com/RobLoach) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=RobLoach)
- [stongo](https://github.com/stongo) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=stongo)
- [zenorocha](https://github.com/zenorocha) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=zenorocha)

[Become a contributor!](https://github.com/docpad/docpad-plugin-cleanurls/blob/master/CONTRIBUTING.md#files)

<!-- /BACKERS -->


<!-- LICENSE/ -->

## License

Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT license](http://creativecommons.org/licenses/MIT/)

Copyright &copy; 2012+ Bevry Pty Ltd <us@bevry.me> (http://bevry.me)
<br/>Copyright &copy; 2011 Benjamin Lupton <b@lupton.cc> (http://balupton.com)

<!-- /LICENSE -->


