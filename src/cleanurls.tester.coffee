# Export Plugin Tester
module.exports = (testers) ->
	# PRepare
	{expect} = require('chai')
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
				baseUrl = "http://localhost:#{tester.docpad.config.port}"
				outExpectedPath = tester.config.outExpectedPath
				fileUrl = "#{baseUrl}/welcome/"

				test 'server should serve URLs without an extension', (done) ->
					request fileUrl, (err,response,actual) ->
						return done(err)  if err
						actualStr = actual.toString()
						expectedStr = 'Welcome'
						expect(actualStr).to.equal(expectedStr)
						done()

				test 'documents should have urls without extensions', (done) ->
					actualUrls = tester.docpad.getCollection('documents').map (doc) -> doc.get('url')

					if tester.docpad.getPlugin('cleanurls').getConfig().trailingSlashes
						expectedUrls = ['/', '/hi', '/welcome/']
					else
						expectedUrls = ['/', '/hi', '/welcome']

					expect(actualUrls.sort()).to.deep.equal(expectedUrls)
					done()