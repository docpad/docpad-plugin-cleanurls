# Clean URLs Plugin for [DocPad](https://docpad.org)

<!-- BADGES/ -->

[![Build Status](http://img.shields.io/travis-ci/docpad/docpad-plugin-cleanurls.png?branch=master)](http://travis-ci.org/docpad/docpad-plugin-cleanurls "Check this project's build status on TravisCI")
[![NPM version](http://badge.fury.io/js/docpad-plugin-cleanurls.png)](https://npmjs.org/package/docpad-plugin-cleanurls "View this project on NPM")
[![Gittip donate button](http://img.shields.io/gittip/bevry.png)](https://www.gittip.com/bevry/ "Donate weekly to this project using Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")

<!-- /BADGES -->


Adds support for clean URLs to [DocPad](https://docpad.org)


## Install

```
docpad install cleanurls
```


## Usage/Configure

For non-static environments the document's url is set to its clean url by docpad (The document is still rendered to the same location on the file system). 

For static environments the document's `outPath` is set to that of a directory with a `index.html` file (e.g. `pages/welcome.html` will be outputted to `pages/welcome/index.html`). You can tell docpad to use the static environment by adding `--env static` to the end of your DocPad command. 

To perform a one off generation for a static environment run `docpad generate --env static`.   To generate, serve and watch run `docpad run --env static`.

If you'd like to disable the static mode when working in the static environment you can add the following to your [docpad configuration file](http://docpad.org/docs/config).

``` coffee
environments:
	static:
		plugins:
			cleanurls:
				enabled: false
```

### trailingSlashes
Enable to generate `document.url`s like `'/beep/'` instead of `/beep`.  Defaults to `false`.

### collectionName
You can use this property (defaults to `html`) to apply cleanurls to a custom collection only.

For instance, if you are wanting to exclude all documents that have `cleanurls: false` in the meta data, then add the following to your docpad configuration file:

``` coffee
# Define a custom collection for cleanurls 
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

[![Gittip donate button](http://img.shields.io/gittip/bevry.png)](https://www.gittip.com/bevry/ "Donate weekly to this project using Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")

### Contributors

These amazing people have contributed code to this project:

- [Benjamin Lupton](https://github.com/balupton) <b@lupton.cc> — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=balupton)
- [hurrymaplelad](https://github.com/hurrymaplelad) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=hurrymaplelad)
- [misterdai](https://github.com/misterdai) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=misterdai)
- [zenorocha](https://github.com/zenorocha) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=zenorocha)

[Become a contributor!](https://github.com/docpad/docpad-plugin-cleanurls/blob/master/CONTRIBUTING.md#files)

<!-- /BACKERS -->


<!-- LICENSE/ -->

## License

Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT license](http://creativecommons.org/licenses/MIT/)

Copyright &copy; 2012+ Bevry Pty Ltd <us@bevry.me> (http://bevry.me)
<br/>Copyright &copy; 2011 Benjamin Lupton <b@lupton.cc> (http://balupton.com)

<!-- /LICENSE -->


