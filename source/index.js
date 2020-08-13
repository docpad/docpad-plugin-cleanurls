/* eslint-disable no-cond-assign */
/* eslint-disable class-methods-use-this */
// @ts-nocheck
'use strict'

// Import
const { TaskGroup } = require('taskgroup')
const safefs = require('safefs')
const pathUtil = require('path')

// Prepare
const codeRedirectPermanent = 301
// codeRedirectTemporary = 302

// Export Plugin
module.exports = function (BasePlugin) {
	// Define Plugin
	return class CleanUrlsPlugin extends BasePlugin {
		// Name
		get name() {
			return 'cleanurls'
		}

		// Config
		get initialConfig() {
			return {
				redirectTemplateEncoding: 'utf8',
				trailingSlashes: false,
				collectionName: 'html',
				static: false,
				environments: {
					static: {
						static: true,
					},
				},
				simpleRedirects: null,
				advancedRedirects: null,
				getRedirectScript(advancedRedirects) {
					// Serialise the redirects from a complicated array to a string
					const serializedRedirects =
						'[' +
						advancedRedirects
							.map(([pattern, replacement]) => {
								return (
									'[' +
									(typeof pattern === 'string'
										? '"' + pattern + '"'
										: pattern.toString()) +
									', "' +
									replacement +
									'"]'
								)
							})
							.join(', ') +
						']'

					// Return
					return `(function(){
						var advancedRedirects = ${serializedRedirects};
						var relativeURL = location.pathname + (location.search || '');
						var absoluteURL = location.href;
						advancedRedirects.forEach(function(value){
							var pattern = value[0], replacement = value[1], sourceURL, targetURL;
							if ( typeof pattern === 'string' ) {
								if ( pattern === relativeURL || pattern === absoluteURL ) {
									document.location.href = replacement;
								}
							}
							else {
								if ( pattern.test(sourceURL = relativeURL) || pattern.test(sourceURL = absoluteURL) ) {
									targetURL = sourceURL.replace(pattern, replacement);
									document.location.href = targetURL;
								}
							}
						})
					})()`
				},
				getRedirectTemplate(url, title) {
					return `<!DOCTYPE html>
					<html>
						<head>
							<title>${title || 'Redirect'}</title>
							<meta http-equiv="REFRESH" content="0; url=${url}">
							<link rel="canonical" href="${url}" />
						</head>
						<body>
							This page has moved. You will be automatically redirected to its new location. If you aren't forwarded to the new page, <a href="${url}">click here</a>.
							<script>document.location.href = "${url}"</script>
						</body>
					</html>`
				},
			}
		}

		// Clean URLs for Document
		cleanUrlsForDocument(document) {
			// Prepare
			const url = document.get('url')
			const trailingSlashes = this.getConfig().trailingSlashes

			// Index URL
			if (/index\.html$/i.test(url)) {
				let relativeDirUrl = pathUtil.dirname(url)
				if (trailingSlashes && relativeDirUrl !== '/') {
					relativeDirUrl += '/'
				}
				document.setUrl(relativeDirUrl)
			}

			// Create Extensionless URL
			else if (/\.html$/i.test(url)) {
				const relativeBaseUrl = url.replace(/\.html$/, '')
				document.setUrl(relativeBaseUrl + (trailingSlashes ? '/' : ''))
				document.addUrl(relativeBaseUrl + (trailingSlashes ? '' : '/'))
			}

			// Done
			return document
		}

		// Collections have been created, so listen for html files to update the urls
		renderBefore(opts) {
			// Prepare
			const { docpad } = this
			const config = this.getConfig()
			const collection = docpad.getCollection(config.collectionName)

			// When we get a new document, update its url
			docpad.log('debug', 'Applying clean urls')
			for (const document of collection) {
				this.cleanUrlsForDocument(document)
			}
			docpad.log('debug', 'Applied clean urls')
		}

		// Check Configuration
		docpadReady(opts, next) {
			// Prepare
			const config = this.getConfig()

			// Check simple redirects are only relative URLs
			if (config.simpleRedirects) {
				for (const sourceURL of Object.keys(config.simpleRedirects)) {
					if (sourceURL.includes('://')) {
						const err = new Error(`
							Simple redirections via the Clean URLs plugin requires the source URLs to be relative URLs.
							You must change [${sourceURL}] into a relative URL to continue.
							This can be done via your DocPad configuration file under the cleanurls plugin section.`)
						return next(err)
					}
				}
			}

			// Chain
			next()
		}

		// Write After
		writeAfter(opts, next) {
			// Prepare
			const plugin = this
			const { docpad } = this
			const outPath = docpad.getPath('out')
			const config = this.getConfig()
			const docpadConfig = docpad.getConfig()
			const siteURL = (docpadConfig.site && docpadConfig.site.url) || ''
			const collection = docpad.getCollection(config.collectionName)

			// Helper
			function getCleanOutPathFromUrl(url) {
				url = url.replace(/\/+$/, '') // trim trailing slashes
				if (/index.html$/.test(url)) {
					return pathUtil.join(outPath, url)
				} else {
					return pathUtil.join(
						outPath,
						url.replace(/\.html$/, '') + '/index.html'
					)
				}
			}

			// Static
			if (config.static === true) {
				// Tasks
				docpad.log('debug', 'Writing static clean url files')
				const tasks = new TaskGroup({ concurrency: 0 }).done(function (err) {
					docpad.log('debug', 'Wrote static clean url files')
					return next(err)
				})
				// eslint-disable-next-line no-inner-declarations
				function addWriteTask(outPath, outContent, encoding) {
					tasks.addTask(function (complete) {
						return safefs.writeFile(
							outPath,
							outContent,
							encoding || config.redirectTemplateEncoding,
							complete
						)
					})
				}

				// Cycle redirects
				if (config.simpleRedirects) {
					for (const [sourceURL, destinationURL] of Object.entries(
						config.simpleRedirects
					)) {
						const sourceURLPath = getCleanOutPathFromUrl(sourceURL)
						let destinationFullUrl = destinationURL
						if (destinationURL[0] === '/') {
							destinationFullUrl = siteURL + destinationURL
						}
						const redirectContent = config.getRedirectTemplate.call(
							plugin,
							destinationFullUrl
						)
						addWriteTask(sourceURLPath, redirectContent)
					}
				}

				// Cycle documents
				for (const document of collection) {
					// Check
					if (
						document.get('write') === false ||
						document.get('ignore') === true ||
						document.get('render') === false ||
						document.get('url') === '/404'
					) {
						continue
					}

					// Prepare
					const encoding = document.get('encoding')
					const primaryUrl = document.get('url')
					const primaryUrlOutPath = getCleanOutPathFromUrl(primaryUrl)
					const primaryOutPath = document.get('outPath')
					const urls = document.get('urls')
					const destinationFullUrl = siteURL + document.get('url')
					const redirectContent = config.getRedirectTemplate.call(
						plugin,
						destinationFullUrl,
						document.get('title')
					)
					const redirectOutPaths = []

					// If the primary out path is not our desired primary url out path
					// then update it with the redirect template
					// and update our primaru url out path with the actual content
					if (primaryUrlOutPath === primaryOutPath) {
						addWriteTask(primaryUrlOutPath, document.getOutContent(), encoding)
						redirectOutPaths.push(primaryOutPath)
					}

					// Cycle through the other urls
					for (const url of urls) {
						const redirectOutPath = getCleanOutPathFromUrl(url)
						if (
							redirectOutPaths.includes(redirectOutPath) === false &&
							redirectOutPath !== primaryUrlOutPath
						) {
							redirectOutPaths.push(redirectOutPath)
						}
					}
					for (const redirectOutPath of redirectOutPaths) {
						addWriteTask(redirectOutPath, redirectContent, encoding)
					}
				}

				// Fire
				tasks.run()

				// Development
			} else {
				next()
			}
		}

		populateCollections(opts) {
			// Prepare
			const { docpad } = this
			const config = this.getConfig()

			// Add a script block that will handle and regex
			if (config.static === true && config.advancedRedirects) {
				docpad.log('info', 'Adding clean URLs regex redirect script block')
				docpad
					.getBlock('scripts')
					.add(config.getRedirectScript.call(this, config.advancedRedirects), {
						defer: false,
					})
			}
		}

		serverExtend(opts) {
			const me = this
			// Add redirect route
			opts.server.use(function (req, res, next) {
				const config = me.getConfig()
				if (config.static === false) {
					const docpadConfig = me.docpad.getConfig()
					const siteURL = (docpadConfig.site && docpadConfig.site.url) || ''

					// Check if the simple redirect exists
					// Simple redirections only support relative URLs
					const destinationURL =
						config.simpleRedirects && config.simpleRedirects[req.url]
					if (destinationURL) {
						return res.redirect(codeRedirectPermanent, destinationURL)
					}

					// Cycle through our advanced redirects
					if (config.advancedRedirects) {
						for (const [pattern, replacement] of Object.entries(
							config.advancedRedirects
						)) {
							if (typeof pattern === 'string') {
								if (pattern === req.url || pattern === siteURL + req.url) {
									return res.redirect(codeRedirectPermanent, replacement)
								}
							} else {
								let sourceURL
								if (
									pattern.test((sourceURL = req.url)) ||
									pattern.test((sourceURL = siteURL + req.url))
								) {
									const destinationURL = sourceURL.replace(pattern, replacement)
									return res.redirect(codeRedirectPermanent, destinationURL)
								}
							}
						}
					}
				}

				// Continue
				next()
			})
		}
	}
}
