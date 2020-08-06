# Test our plugin using DocPad's Testers
require('docpad-plugintester')
	.test(
		{
			# Test Configuration
			testerName: 'cleanurls development environment'
			removeWhitespace: true
		},
		{
			# DocPad Configuration
			env: 'development'
		}
	)
	.test(
		{
			# Test Configuration
			testerName: 'cleanurls development environment with trailing slashes'
			removeWhitespace: true
		},
		{
			# DocPad Configuration
			env: 'development'
			plugins:
				cleanurls:
					trailingSlashes: true
		}
	)
	.test(
		{
			# Test Configuration
			testerName: 'cleanurls static environment'
			outExpectedPath: __dirname+'/../test/out-expected-static'
			removeWhitespace: true
		},
		{
			# DocPad Configuration
			env: 'static'
		}
	)
