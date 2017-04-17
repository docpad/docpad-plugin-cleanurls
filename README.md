<!-- TITLE/ -->

<h1>Clean URLs Plugin for DocPad</h1>

<!-- /TITLE -->


<!-- BADGES/ -->

<span class="badge-travisci"><a href="http://travis-ci.org/docpad/docpad-plugin-cleanurls" title="Check this project's build status on TravisCI"><img src="https://img.shields.io/travis/docpad/docpad-plugin-cleanurls/master.svg" alt="Travis CI Build Status" /></a></span>
<span class="badge-npmversion"><a href="https://npmjs.org/package/docpad-plugin-cleanurls" title="View this project on NPM"><img src="https://img.shields.io/npm/v/docpad-plugin-cleanurls.svg" alt="NPM version" /></a></span>
<span class="badge-npmdownloads"><a href="https://npmjs.org/package/docpad-plugin-cleanurls" title="View this project on NPM"><img src="https://img.shields.io/npm/dm/docpad-plugin-cleanurls.svg" alt="NPM downloads" /></a></span>
<span class="badge-daviddm"><a href="https://david-dm.org/docpad/docpad-plugin-cleanurls" title="View the status of this project's dependencies on DavidDM"><img src="https://img.shields.io/david/docpad/docpad-plugin-cleanurls.svg" alt="Dependency Status" /></a></span>
<span class="badge-daviddmdev"><a href="https://david-dm.org/docpad/docpad-plugin-cleanurls#info=devDependencies" title="View the status of this project's development dependencies on DavidDM"><img src="https://img.shields.io/david/dev/docpad/docpad-plugin-cleanurls.svg" alt="Dev Dependency Status" /></a></span>
<br class="badge-separator" />
<span class="badge-patreon"><a href="https://patreon.com/bevry" title="Donate to this project using Patreon"><img src="https://img.shields.io/badge/patreon-donate-yellow.svg" alt="Patreon donate button" /></a></span>
<span class="badge-opencollective"><a href="https://opencollective.com/bevry" title="Donate to this project using Open Collective"><img src="https://img.shields.io/badge/open%20collective-donate-yellow.svg" alt="Open Collective donate button" /></a></span>
<span class="badge-gratipay"><a href="https://www.gratipay.com/bevry" title="Donate weekly to this project using Gratipay"><img src="https://img.shields.io/badge/gratipay-donate-yellow.svg" alt="Gratipay donate button" /></a></span>
<span class="badge-flattr"><a href="https://flattr.com/profile/balupton" title="Donate to this project using Flattr"><img src="https://img.shields.io/badge/flattr-donate-yellow.svg" alt="Flattr donate button" /></a></span>
<span class="badge-paypal"><a href="https://bevry.me/paypal" title="Donate to this project using Paypal"><img src="https://img.shields.io/badge/paypal-donate-yellow.svg" alt="PayPal donate button" /></a></span>
<span class="badge-bitcoin"><a href="https://bevry.me/bitcoin" title="Donate once-off to this project using Bitcoin"><img src="https://img.shields.io/badge/bitcoin-donate-yellow.svg" alt="Bitcoin donate button" /></a></span>
<span class="badge-wishlist"><a href="https://bevry.me/wishlist" title="Buy an item on our wishlist for us"><img src="https://img.shields.io/badge/wishlist-donate-yellow.svg" alt="Wishlist browse button" /></a></span>
<br class="badge-separator" />
<span class="badge-slackin"><a href="https://slack.bevry.me" title="Join this project's slack community"><img src="https://slack.bevry.me/badge.svg" alt="Slack community badge" /></a></span>

<!-- /BADGES -->


<!-- DESCRIPTION/ -->

Adds support for clean URLs to DocPad

<!-- /DESCRIPTION -->


<!-- INSTALL/ -->

<h2>Install</h2>

Install this DocPad plugin by entering <code>docpad install cleanurls</code> into your terminal.

<!-- /INSTALL -->


## Usage


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

<h2>History</h2>

<a href="https://github.com/docpad/docpad-plugin-cleanurls/blob/master/HISTORY.md#files">Discover the release history by heading on over to the <code>HISTORY.md</code> file.</a>

<!-- /HISTORY -->


<!-- CONTRIBUTE/ -->

<h2>Contribute</h2>

<a href="https://github.com/docpad/docpad-plugin-cleanurls/blob/master/CONTRIBUTING.md#files">Discover how you can contribute by heading on over to the <code>CONTRIBUTING.md</code> file.</a>

<!-- /CONTRIBUTE -->


<!-- BACKERS/ -->

<h2>Backers</h2>

<h3>Maintainers</h3>

These amazing people are maintaining this project:

<ul><li><a href="http://balupton.com">Benjamin Lupton</a> — <a href="https://github.com/docpad/docpad-plugin-cleanurls/commits?author=balupton" title="View the GitHub contributions of Benjamin Lupton on repository docpad/docpad-plugin-cleanurls">view contributions</a></li></ul>

<h3>Sponsors</h3>

No sponsors yet! Will you be the first?

<span class="badge-patreon"><a href="https://patreon.com/bevry" title="Donate to this project using Patreon"><img src="https://img.shields.io/badge/patreon-donate-yellow.svg" alt="Patreon donate button" /></a></span>
<span class="badge-opencollective"><a href="https://opencollective.com/bevry" title="Donate to this project using Open Collective"><img src="https://img.shields.io/badge/open%20collective-donate-yellow.svg" alt="Open Collective donate button" /></a></span>
<span class="badge-gratipay"><a href="https://www.gratipay.com/bevry" title="Donate weekly to this project using Gratipay"><img src="https://img.shields.io/badge/gratipay-donate-yellow.svg" alt="Gratipay donate button" /></a></span>
<span class="badge-flattr"><a href="https://flattr.com/profile/balupton" title="Donate to this project using Flattr"><img src="https://img.shields.io/badge/flattr-donate-yellow.svg" alt="Flattr donate button" /></a></span>
<span class="badge-paypal"><a href="https://bevry.me/paypal" title="Donate to this project using Paypal"><img src="https://img.shields.io/badge/paypal-donate-yellow.svg" alt="PayPal donate button" /></a></span>
<span class="badge-bitcoin"><a href="https://bevry.me/bitcoin" title="Donate once-off to this project using Bitcoin"><img src="https://img.shields.io/badge/bitcoin-donate-yellow.svg" alt="Bitcoin donate button" /></a></span>
<span class="badge-wishlist"><a href="https://bevry.me/wishlist" title="Buy an item on our wishlist for us"><img src="https://img.shields.io/badge/wishlist-donate-yellow.svg" alt="Wishlist browse button" /></a></span>

<h3>Contributors</h3>

These amazing people have contributed code to this project:

<ul><li><a href="http://balupton.com">Benjamin Lupton</a> — <a href="https://github.com/docpad/docpad-plugin-cleanurls/commits?author=balupton" title="View the GitHub contributions of Benjamin Lupton on repository docpad/docpad-plugin-cleanurls">view contributions</a></li>
<li><a href="hurrymaplelad.com">Adam Hull</a> — <a href="https://github.com/docpad/docpad-plugin-cleanurls/commits?author=hurrymaplelad" title="View the GitHub contributions of Adam Hull on repository docpad/docpad-plugin-cleanurls">view contributions</a></li>
<li><a href="https://github.com/iSpyCreativity">iSpyCreativity</a> — <a href="https://github.com/docpad/docpad-plugin-cleanurls/commits?author=iSpyCreativity" title="View the GitHub contributions of iSpyCreativity on repository docpad/docpad-plugin-cleanurls">view contributions</a></li>
<li><a href="http://misterdai.yougeezer.co.uk/">David Boyer</a> — <a href="https://github.com/docpad/docpad-plugin-cleanurls/commits?author=misterdai" title="View the GitHub contributions of David Boyer on repository docpad/docpad-plugin-cleanurls">view contributions</a></li>
<li><a href="http://robloach.net">Rob Loach</a> — <a href="https://github.com/docpad/docpad-plugin-cleanurls/commits?author=RobLoach" title="View the GitHub contributions of Rob Loach on repository docpad/docpad-plugin-cleanurls">view contributions</a></li>
<li><a href="http://circleci.com">Marcus Stong</a> — <a href="https://github.com/docpad/docpad-plugin-cleanurls/commits?author=stongo" title="View the GitHub contributions of Marcus Stong on repository docpad/docpad-plugin-cleanurls">view contributions</a></li>
<li><a href="http://www.stormpoopersmith.com">Daniel Smith</a> — <a href="https://github.com/docpad/docpad-plugin-cleanurls/commits?author=StormPooper" title="View the GitHub contributions of Daniel Smith on repository docpad/docpad-plugin-cleanurls">view contributions</a></li>
<li><a href="http://studiole.uk">Laurence Elsdon</a> — <a href="https://github.com/docpad/docpad-plugin-cleanurls/commits?author=StudioLE" title="View the GitHub contributions of Laurence Elsdon on repository docpad/docpad-plugin-cleanurls">view contributions</a></li>
<li><a href="https://github.com/vsopvsop">vsopvsop</a> — <a href="https://github.com/docpad/docpad-plugin-cleanurls/commits?author=vsopvsop" title="View the GitHub contributions of vsopvsop on repository docpad/docpad-plugin-cleanurls">view contributions</a></li>
<li><a href="http://zenorocha.com">Zeno Rocha</a> — <a href="https://github.com/docpad/docpad-plugin-cleanurls/commits?author=zenorocha" title="View the GitHub contributions of Zeno Rocha on repository docpad/docpad-plugin-cleanurls">view contributions</a></li></ul>

<a href="https://github.com/docpad/docpad-plugin-cleanurls/blob/master/CONTRIBUTING.md#files">Discover how you can contribute by heading on over to the <code>CONTRIBUTING.md</code> file.</a>

<!-- /BACKERS -->


<!-- LICENSE/ -->

<h2>License</h2>

Unless stated otherwise all works are:

<ul><li>Copyright &copy; 2012+ <a href="http://bevry.me">Bevry Pty Ltd</a></li>
<li>Copyright &copy; 2011 <a href="http://balupton.com">Benjamin Lupton</a></li></ul>

and licensed under:

<ul><li><a href="http://spdx.org/licenses/MIT.html">MIT License</a></li></ul>

<!-- /LICENSE -->
