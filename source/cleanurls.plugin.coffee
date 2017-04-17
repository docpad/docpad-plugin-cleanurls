# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class CleanUrlsPlugin extends BasePlugin
		# Name
		name: 'cleanurls'

		# Config
		config:
			redirectTemplateEncoding: 'utf8'

			getRedirectScript: (advancedRedirects) ->
				# Serialise the redirects from a complicated array to a string
				serializedRedirects = '[' + (
					('['+(if typeof pattern is 'string' then '"'+pattern+'"' else pattern.toString())+', "'+replacement+'"]')  for [pattern, replacement] in advancedRedirects
				).join(', ') + ']'

				# Return
				"""
				(function(){
					var advancedRedirects = #{serializedRedirects};
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
				})()
				"""

			getRedirectTemplate: (url, title) ->
				"""
				<!DOCTYPE html>
				<html>
					<head>
						<title>#{title or 'Redirect'}</title>
						<meta http-equiv="REFRESH" content="0; url=#{url}">
						<link rel="canonical" href="#{url}" />
					</head>
					<body>
						This page has moved. You will be automatically redirected to its new location. If you aren't forwarded to the new page, <a href="#{url}">click here</a>.
						<script>document.location.href = "#{url}"</script>
					</body>
				</html>
				"""

			trailingSlashes: false

			collectionName: 'html'

			static: false

			environments:
				static:
					static: true

			simpleRedirects: null
			advancedRedirects: null


		# Clean URLs for Document
		cleanUrlsForDocument: (document) =>
			# Prepare
			url = document.get('url')
			pathUtil = require('path')
			trailingSlashes = @config.trailingSlashes

			# Index URL
			if /index\.html$/i.test(url)
				relativeDirUrl = pathUtil.dirname(url)
				if trailingSlashes and relativeDirUrl isnt '/'
					relativeDirUrl += '/'
				document.setUrl(relativeDirUrl)

			# Create Extensionless URL
			else if /\.html$/i.test(url)
				relativeBaseUrl = url.replace(/\.html$/, '')
				document.setUrl(relativeBaseUrl + if trailingSlashes then '/' else '')
				document.addUrl(relativeBaseUrl + if trailingSlashes then '' else '/')

			# Done
			document

		# Collections have been created, so listen for html files to update the urls
		renderBefore: (opts) ->
			# Prepare
			docpad = @docpad
			config = @getConfig()
			collection = docpad.getCollection(config.collectionName)

			# When we get a new document, update its url
			docpad.log 'debug', 'Applying clean urls'
			collection.forEach(@cleanUrlsForDocument)
			docpad.log 'debug', 'Applied clean urls'

			# All done
			@

		# Check Configuration
		docpadReady: (opts, next) ->
			# Prepare
			config = @getConfig()

			# Check simple redirects are only relative URLs
			if config.simpleRedirects
				for own sourceURL, targetURL of config.simpleRedirects
					if sourceURL.indexOf('://') isnt -1
						err = new Error("""
							Simple redirections via the Clean URLs plugin requires the source URLs to be relative URLs.
							You must change [#{sourceURL}] into a relative URL to continue.
							This can be done via your DocPad configuration file under the cleanurls plugin section.
							""")
						return next(err)

			# Chain
			next()
			@

		# Write After
		writeAfter: (opts,next) ->
			# Prepare
			plugin = @
			docpad = @docpad
			config = @getConfig()
			docpadConfig = docpad.getConfig()
			siteURL = docpadConfig.site?.url or ''
			collection = docpad.getCollection(config.collectionName)

			# Import
			{TaskGroup} = require('taskgroup')
			safefs = require('safefs')
			pathUtil = require('path')

			# Helper
			getCleanOutPathFromUrl = (url) ->
				url = url.replace(/\/+$/,'')  # trim trailing slashes
				if /index.html$/.test(url)
					pathUtil.join(docpadConfig.outPath, url)
				else
					pathUtil.join(docpadConfig.outPath, url.replace(/\.html$/,'')+'/index.html')

			# Static
			if config.static is true
				# Tasks
				docpad.log 'debug', 'Writing static clean url files'
				tasks = new TaskGroup().setConfig(concurrency:0).done (err) ->
					docpad.log 'debug', 'Wrote static clean url files'
					return next(err)
				addWriteTask = (outPath, outContent) ->
					tasks.addTask (complete) ->
						return safefs.writeFile(outPath, outContent, config.redirectTemplateEncoding, complete)

				# Cycle redirects
				if config.simpleRedirects
					for own sourceURL,destinationURL of config.simpleRedirects
						sourceURLPath = getCleanOutPathFromUrl(sourceURL)
						destinationFullUrl = destinationURL
						if destinationURL[0] = '/'
							destinationFullUrl = siteURL + destinationURL
						redirectContent = config.getRedirectTemplate.call(plugin, destinationFullUrl)
						addWriteTask(sourceURLPath, redirectContent)

				# Cycle documents
				collection.forEach (document) ->
					# Check
					return  if document.get('write') is false or document.get('ignore') is true or document.get('render') is false or document.get('url') is '/404'

					# Prepare
					encoding = document.get('encoding')
					primaryUrl = document.get('url')
					primaryUrlOutPath = getCleanOutPathFromUrl(primaryUrl)
					primaryOutPath = document.get('outPath')
					urls = document.get('urls')
					destinationFullUrl = siteURL + document.get('url')
					redirectContent = config.getRedirectTemplate.call(plugin, destinationFullUrl, document.get('title'))
					redirectOutPaths = []

					# If the primary out path is not our desired primary url out path
					# then update it with the redirect template
					# and update our primaru url out path with the actual content
					if primaryUrlOutPath isnt primaryOutPath
						addWriteTask(primaryUrlOutPath, document.getOutContent(), encoding)
						redirectOutPaths.push(primaryOutPath)

					# Cycle through the other urls
					for url in urls
						redirectOutPath = getCleanOutPathFromUrl(url)
						if (redirectOutPath in redirectOutPaths) is false and redirectOutPath isnt primaryUrlOutPath
							redirectOutPaths.push(redirectOutPath)
					for redirectOutPath in redirectOutPaths
						addWriteTask(redirectOutPath, redirectContent, encoding)

				# Fire
				tasks.run()

			# Development
			else
				next()

			# Chain
			@

		populateCollections: (opts) ->
			# Prepare
			docpad = @docpad
			config = @getConfig()

			# Add a script block that will handle and regex
			if config.static is true and config.advancedRedirects
				docpad.log 'info', 'Adding clean URLs regex redirect script block'
				docpad.getBlock('scripts').add(@config.getRedirectScript.call(@, config.advancedRedirects), {defer:false})

			# Chain
			@

		serverExtend: (opts) ->
			# Prepare
			codeRedirectPermanent = 301
			# codeRedirectTemporary = 302

			# Add redirect route
			opts.server.use (req,res,next) =>
				config = @getConfig()
				if config.static is false
					docpadConfig = @docpad.getConfig()
					siteURL = docpadConfig.site?.url or ''

					# Check if the simple redirect exists
					# Simple redirections only support relative URLs
					if destinationURL = config.simpleRedirects?[req.url]
						res.redirect(codeRedirectPermanent, destinationURL)
						return @

					# Cycle through our advanced redirects
					if config.advancedRedirects
						for [pattern, replacement] in config.advancedRedirects
							if typeof pattern is 'string'
								if pattern is req.url or pattern is siteURL+req.url
									res.redirect(codeRedirectPermanent, replacement)
									return @
							else
								if pattern.test(sourceURL = req.url) or pattern.test(sourceURL = siteURL + req.url)
									destinationURL = sourceURL.replace(pattern, replacement)
									res.redirect(codeRedirectPermanent, destinationURL)
									return @

				# Continue
				next()

			# Chain
			@