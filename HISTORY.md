# History

## v2.8.1 July 30, 2015
- Fixed 404 pages having clean URLs applied

## v2.8.0 July 30, 2015
- Added the options `simpleRedirects`, `advancedRedirects` and `getRedirectScript`
	- These allow you to perform custom redirections on both dynamic and static environments
- We now use the encoding from the `redirectTemplateEncoding` option instead of the document's encoding
	- As the primary encoding is of the template, not of the possible document title
- `getRedirectTemplate` now accepts `url` and optional `title` arguments inside of a single `document` argument
- Simplified testing setup
- Updated dependencies

## v2.7.0 February 13, 2014
- Static mode is now a configuration option that is enabled by default in the static environment
	- Thanks to [Marcus Stong](https://github.com/stongo) and [Millicent Billette](https://github.com/GammaNu) for issues [#16](https://github.com/docpad/docpad-plugin-cleanurls/issues/16), [#14](https://github.com/docpad/docpad-plugin-cleanurls/pull/14), and [#5](https://github.com/docpad/docpad-plugin-cleanurls/issues/5)

## v2.6.2 January 10, 2014
- Updated dependencies

## v2.6.1 January 1, 2014
- Added canonical link relationship for redirect to reduce duplicate content in search engines (regression since always)
	- Thanks to [David Boyer](https://github.com/misterdai) for [pull request #11](https://github.com/docpad/docpad-plugin-cleanurls/pull/11)

## v2.6.0 November 30, 2013
- Can now specify your own collection to use

## v2.5.2 November 24, 2013
- Repackaged
- Updated dependencies

## v2.5.1 August 20, 2013
- Updated dependencies

## v2.5.0 June 12, 2013
- Optionally generate document urls with trailing slashes
	- Thanks to [Adam Hull](https://github.com/hurrymaplelad) for [pull request #4](https://github.com/docpad/docpad-plugin-cleanurls/pull/4)
- Updated dependencies

## v2.4.3 April 5, 2013
- Updated dependencies

## v2.4.2 April 1, 2013
- Updated dependencies

## v2.4.1 March 6, 2013
- Updated dependencies
	-  `bal-util` from ~1.15.3 to ~1.16.8
	-  `coffee-script` from 1.4.x to ~1.4.0

## v2.4.0 January 6, 2013
- Clean URLs for the static environment now operates more gracefully
	- No longer modifies the out path and corresponding attributes
	- Now work by outputting redirect file to the secondary url paths, and the result file to the primary url path

## v2.3.0 January 4, 2013
- Now supports static environments by changing the document's `outPath` to that of a directory with an `index.html` file inside.
- Updated tests to also check the directory output
- Updated coffeescript devDependency to v1.4.0

## v2.2.5 October 8, 2012
- Fixed plugin name (`cleanUrls` to `cleanurls`)

## v2.2.4 September 5, 2012
- Fixed windows support

## v2.2.3 August 10, 2012
- Re-added markdown files to npm distribution as they are required for the npm website

## v2.2.2 July 19, 2012
- Removed a `console.log` left from debugging

## v2.2.1 July 18, 2012
- Minor cleanup

## v2.2.0 July 18, 2012
- Updated for DocPad v6.3.0

## v2.1.0 July 8, 2012
- Updated for DocPad v6.1.1
- Fixed unit tests again

## v2.0.2 June 12, 2012
- Updated for DocPad v6.0.8
- Fixed clean urls not actually working

## v1.1.0
- Updated for DocPad v5.3
- Now uses the clean url as the default url for the document

## v1.0.0 April 14, 2012
- Updated for DocPad v5.0
