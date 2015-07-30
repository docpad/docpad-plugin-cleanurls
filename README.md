# Clean URLs Plugin for [DocPad](https://docpad.org)

<!-- BADGES/ -->

[![Build Status](https://img.shields.io/travis/docpad/docpad-plugin-cleanurls/master.svg)](http://travis-ci.org/docpad/docpad-plugin-cleanurls "Check this project's build status on TravisCI")
[![NPM version](https://img.shields.io/npm/v/docpad-plugin-cleanurls.svg)](https://npmjs.org/package/docpad-plugin-cleanurls "View this project on NPM")
[![NPM downloads](https://img.shields.io/npm/dm/docpad-plugin-cleanurls.svg)](https://npmjs.org/package/docpad-plugin-cleanurls "View this project on NPM")
[![Dependency Status](https://img.shields.io/david/docpad/docpad-plugin-cleanurls.svg)](https://david-dm.org/docpad/docpad-plugin-cleanurls)
[![Dev Dependency Status](https://img.shields.io/david/dev/docpad/docpad-plugin-cleanurls.svg)](https://david-dm.org/docpad/docpad-plugin-cleanurls#info=devDependencies)<br/>
[![Gratipay donate button](https://img.shields.io/gratipay/docpad.svg)](https://www.gratipay.com/docpad/ "Donate weekly to this project using Gratipay")
[![Flattr donate button](https://img.shields.io/badge/flattr-donate-yellow.svg)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](https://img.shields.io/badge/paypal-donate-yellow.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")
[![BitCoin donate button](https://img.shields.io/badge/bitcoin-donate-yellow.svg)](https://coinbase.com/checkouts/9ef59f5479eec1d97d63382c9ebcb93a "Donate once-off to this project using BitCoin")
[![Wishlist browse button](https://img.shields.io/badge/wishlist-donate-yellow.svg)](http://amzn.com/w/2F8TXKSNAFG4V "Buy an item on our wishlist for us")

<!-- /BADGES -->


Adds support for clean URLs to [DocPad](https://docpad.org)


## Install

```
docpad install cleanurls
```


## Usage/Configure


### `static`

In non-static environments we work by setting the document's url to it's clean url. This means that redirection occurs on the dynamic server level.

For the `static` environment (i.e. when running DocPad with the `--env static` flag, e.g. running `docpad generate --env static`) we will set the `static` plugin configuration option to `true`. This will in addition to performing redirections via the built-in dynamic server within DocPad for speed, we will also write special static redirection HTML files to the output directory, that will redirect the user to the new clean location (e.g. the document `pages/welcome.html` will now be outputted to `pages/welcome/index.html`, with `pages/welcome.html` now being a special HTML redirect document to the clean location).

If you would like to always use the static mode, you can set the `static` plugin configuration option to true with:

``` coffee
plugins:
	cleanurls:
		static: true
```

If you would like to disable the static mode for the static environment, you can do so with:

``` coffee
environments:
	static:
		plugins:
			cleanurls:
				static: false
```

If you would like to disable clean urls completely (not just the static mode) in the static environment, you can do so with:


``` coffee
environments:
	static:
		plugins:
			cleanurls:
				enabled: false
```


### `trailingSlashes`
Enable this plugin configuration option to generate `document.url`s like `'/beep/'` instead of `/beep`.  Defaults to `false`.


### `collectionName`
You can use this plugin configuration option (defaults to `html`) to tell the cleanurls plugin to use your own custom collection for which documents to apply clean URLs to.

For instance, if you are wanting to remove all clean URLs for all documents that have `cleanurls: false` in the meta data, then you could do the following in your DocPad configuration file:

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


### `getRedirectTemplate`

You can customise the HTML template that is used for the redirect pages by specifying the `getRedirectTemplate` option which is a function that accepts `url` argument and an option `title` argument and returns a string.


### `simpleRedirects`

Simple redirects work via routes in dynamic environments, and on static environments work via generating redirect HTML pages at the location of the source relative URL. They can be defined like so:

``` coffee
plguins:
	cleanurls:
		simpleRedirects:
			'/relative-url': '/somewhere-else'
			'/other-relative-url': 'http://somehere.else'
```

### `advancedRedirects`

Advanced redirects work via routes in dynamic environments, and on static environments work via a client-side javascript injection into the Script Block on your 404 Page document. They can be defined like so:

``` coffee
plguins:
	cleanurls:
		advancedRedirects: [
			# Regular expressions redirects are possible too
			[/^\/github\/?(.*)$/, 'https://github.com/docpad/$1']
			[/^\/plugin\/(.+)$/, 'https://github.com/docpad/docpad-plugin-$1']

			# Absolute URL redirects are even possible
			['http://production.com/favourite-website', 'http://wikipedia.org']
			['http://localhost:9778/favourite-website', 'http://facebook.com']
		]
```

To ensure they work, you must make sure that your 404 Page document calls  `@getBlock('scripts').toHTML()` to output the Script Block, which we inject the client-side javascript into. Here is an example of such a document using eco and location at `src/documents/404.html.eco`:

``` html
<!DOCTYPE html>
<html>
<head>
	<!-- Standard Meta -->
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<!-- Site Properties -->
	<title>404 Page Not Found</title>

	<!-- DocPad Meta -->
	<%- @getBlock('meta').toHTML() %>

	<!-- DocPad Styles -->
	<%- @getBlock('styles').add('/vendor/404.css').toHTML() %>
</head>
<body>
	<!-- 404 Page Content -->
	<div class="container">
	    <h1>Not Found 😲</h1>
	    <p>Sorry, but the page you were trying to view does not exist.</p>
	    <p>It looks like this was the result of either:</p>
	    <ul>
	        <li>a mistyped address</li>
	        <li>an out-of-date link</li>
	    </ul>
	    <script>
	        var GOOG_FIXURL_LANG = (navigator.language || '').slice(0,2),GOOG_FIXURL_SITE = location.host;
	    </script>
	    <script src="http://linkhelp.clients.google.com/tbproxy/lh/wm/fixurl.js"></script>
	</div>

	<!-- DocPad Scripts -->
	<%- @getBlock('scripts').toHTML() %>
</body>
</html>
```

You can modify the client-side javascript by providing the option getRedirectScript` which is a function that accepts the advancedRedirects value as the first and only argument and returns a string which is the script to be injected.



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

[![Gratipay donate button](https://img.shields.io/gratipay/docpad.svg)](https://www.gratipay.com/docpad/ "Donate weekly to this project using Gratipay")
[![Flattr donate button](https://img.shields.io/badge/flattr-donate-yellow.svg)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](https://img.shields.io/badge/paypal-donate-yellow.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")
[![BitCoin donate button](https://img.shields.io/badge/bitcoin-donate-yellow.svg)](https://coinbase.com/checkouts/9ef59f5479eec1d97d63382c9ebcb93a "Donate once-off to this project using BitCoin")
[![Wishlist browse button](https://img.shields.io/badge/wishlist-donate-yellow.svg)](http://amzn.com/w/2F8TXKSNAFG4V "Buy an item on our wishlist for us")

### Contributors

These amazing people have contributed code to this project:

- [Benjamin Lupton](https://github.com/balupton) <b@lupton.cc> — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=balupton)
- [hurrymaplelad](https://github.com/hurrymaplelad) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=hurrymaplelad)
- [iSpyCreativity](https://github.com/iSpyCreativity) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=iSpyCreativity)
- [misterdai](https://github.com/misterdai) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=misterdai)
- [RobLoach](https://github.com/RobLoach) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=RobLoach)
- [stongo](https://github.com/stongo) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=stongo)
- [StormPooper](https://github.com/StormPooper) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=StormPooper)
- [StudioLE](https://github.com/StudioLE) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=StudioLE)
- [vsopvsop](https://github.com/vsopvsop) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=vsopvsop)
- [zenorocha](https://github.com/zenorocha) — [view contributions](https://github.com/docpad/docpad-plugin-cleanurls/commits?author=zenorocha)

[Become a contributor!](https://github.com/docpad/docpad-plugin-cleanurls/blob/master/CONTRIBUTING.md#files)

<!-- /BACKERS -->


<!-- LICENSE/ -->

## License

Unless stated otherwise all works are:

- Copyright &copy; 2012+ Bevry Pty Ltd <us@bevry.me> (http://bevry.me)
- Copyright &copy; 2011 Benjamin Lupton <b@lupton.cc> (http://balupton.com)

and licensed under:

- The incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT License](http://opensource.org/licenses/mit-license.php)

<!-- /LICENSE -->


