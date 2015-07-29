# Export Plugin Tester
module.exports = (testers) ->
	# Prepare
	{assertEqual, assertDeepEqual} = require('assert-helpers')
	request = require('request')

	# Define My Tester
	class MyTester extends testers.ServerTester
		# Test Generate
		testGenerate: testers.RendererTester::testGenerate

		# Custom test for the server
		testServer: (next) ->
			# Prepare
			tester = @

			# Create the server
			super

			# Test
			@suite 'cleanurls', (suite,test) ->
				# Prepare
				siteURL = "http://localhost:#{tester.docpad.config.port}"
				outExpectedPath = tester.config.outExpectedPath
				plugin = tester.docpad.getPlugin('cleanurls')
				pluginConfig = plugin.getConfig()

				suite 'cleanurls for documents suite', (suite, test) ->
					test 'server should serve URLs without an extension', (done) ->
						fullURL = siteURL + '/welcome/'
						request fullURL, (err,response,actual) ->
							return done(err)  if err
							actualStr = actual.toString()
							expectedStr = 'Welcome Page!'
							assertEqual(actualStr, expectedStr, 'result from welcome URL contains expected content')
							done()

					test 'documents should have urls without extensions', (done) ->
						actualUrls = tester.docpad.getCollection('documents').map (doc) -> doc.get('url')

						if pluginConfig.trailingSlashes
							expectedUrls = ['/', '/404/', '/hi', '/welcome/']
						else
							expectedUrls = ['/', '/404', '/hi', '/welcome']

						assertDeepEqual(actualUrls.sort(), expectedUrls, 'URLs are as expected')
						done()

				suite 'redirect configuration suite', (suite, test) ->
					if tester.docpadConfig.environment is 'development'
						test 'test redirect middleware', (done) ->
							fullURL = siteURL + '/open'
							request fullURL, (err,response,actual) ->
								return done(err)  if err
								actualStr = actual.toString()
								expectedStr = pluginConfig.getRedirectTemplate('/sesame')
								assertEqual(actualStr, expectedStr, 'result from a simple redirect URL contains the expected content')
								done()

						test 'test advanced redirect middleware', (done) ->
							fullURL = siteURL + '/gh/website'
							request fullURL, (err,response,actual) ->
								return done(err)  if err
								actualStr = actual.toString()
								expectedStr = pluginConfig.getRedirectTemplate('https://github.com/bevry/website')
								assertEqual(actualStr, expectedStr, 'result from an advanced redirect URL contains the expected content')
								done()

					if tester.docpadConfig.environment is 'static'
						test 'test redirect file', (done) ->
							fullURL = siteURL + '/open' + '/index.html'
							request fullURL, (err,response,actual) ->
								return done(err)  if err
								actualStr = actual.toString()
								expectedStr = pluginConfig.getRedirectTemplate('/sesame')
								assertEqual(actualStr, expectedStr, 'result from a simple redirect URL contains the expected content')
								done()
