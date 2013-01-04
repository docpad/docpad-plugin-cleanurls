# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class CleanUrlsPlugin extends BasePlugin
		# Plugin name
		name: 'cleanurls'

		# Path to URL
		pathToUrl: (path) ->
			slashRegex = /\\/g
			return path.replace(slashRegex, '/')

		# Clean URLs for Document
		cleanUrlsForDocument: (document) =>
			# Prepare
			pathUtil = require('path')
			documentUrl = document.get('url')

			# Environment Output
			if 'static' in @docpad.getEnvironments() and document.get('outFilename') isnt 'index.html' and document.get('outPath')
				outFilename = 'index.html'
				outPath = document.get('outPath').replace(/\.html$/,"/#{outFilename}")
				outDirPath = pathUtil.dirname(outPath)
				relativeOutPath = document.get('relativeOutPath').replace(/\.html$/,"/#{outFilename}")
				relativeOutDirPath = pathUtil.dirname(relativeOutPath)
				set = {outFilename,outPath,outDirPath,relativeOutPath,relativeOutDirPath}
				document.set(set)

			# Extensionless URL
			if /\.html$/i.test(documentUrl)
				relativeBaseUrl = '/' + @pathToUrl document.get('relativeBase')
				document.setUrl(relativeBaseUrl)

			# Index URL
			if /index\.html$/i.test(documentUrl)
				relativeDirUrl = '/' + @pathToUrl document.get('relativeDirPath')
				document.setUrl(relativeDirUrl)

			# Done
			document

		# Collections have been created, so listen for html files to update the urls
		extendCollections: (opts) ->
			# Prepare
			docpad = @docpad
			database = docpad.getCollection('html')
			docpad.log 'debug', 'Applying clean urls'

			# When we get a new document, update its url
			database.on('add change', @cleanUrlsForDocument)

			# All done
			docpad.log 'debug', 'Applied clean urls'
			true
