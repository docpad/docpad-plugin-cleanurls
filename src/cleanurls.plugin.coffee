# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class CleanUrlsPlugin extends BasePlugin
		# Plugin name
		name: 'cleanUrls'

		# Plugin configuration
		config:
			environments:
				static:
					enabled: false

		# Collections have been created, so listen for html files to update the urls
		extendCollections: (opts) ->
			# Prepare
			docpad = @docpad
			database = docpad.getCollection('html')
			docpad.log 'debug', 'Applying clean urls'

			# When we get a new document, update its url
			database.on 'add change', (document) ->
				# Prepare
				documentUrl = document.get('url')

				# Extnesionless URL
				if /\.html$/i.test(documentUrl)
					relativeBaseUrl = '/'+document.get('relativeBase')
					document.setUrl(relativeBaseUrl)

				# Index URL
				if /index\.html$/i.test(documentUrl)
					relativeDirUrl = '/'+document.get('relativeDirPath')
					document.setUrl(relativeDirUrl)

			# All done
			docpad.log 'debug', 'Applied clean urls'