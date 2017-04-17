# Test our plugin using DocPad's Testers
require('docpad').require('testers')
	.test(
		# Test Configuration
		{
			testerName: 'cleanurls development environment'
			pluginPath: __dirname+'/..'
			removeWhitespace: true
		},

		# DocPad Configuration
		{
			env: 'development'
		}
	)
	.test(
		# Test Configuration
		{
			testerName: 'cleanurls development environment with trailing slashes'
			pluginPath: __dirname+'/..'
			removeWhitespace: true
		},

		# DocPad Configuration
		{
			env: 'development'
			plugins:
				cleanurls:
					trailingSlashes: true
		}
	)
	.test(
		# Test Configuration
		{
			testerName: 'cleanurls static environment'
			pluginPath: __dirname+'/..'
			outExpectedPath: __dirname+'/../test/out-expected-static'
			removeWhitespace: true
		},

		# DocPad Configuration
		{
			env: 'static'
		}
	)