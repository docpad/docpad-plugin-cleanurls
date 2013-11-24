# Test our plugin using DocPad's Testers
require('docpad').require('testers')
	.test(
			testerName: 'cleanurls development environment'
			pluginPath: __dirname+'/..'
			testPath: __dirname+'/../test/development'
			autoExit: 'safe'
		,
			env: 'development'
	)
	.test(
			testerName: 'cleanurls development environment'
			pluginPath: __dirname+'/..'
			testPath: __dirname+'/../test/development'
			autoExit: 'safe'
		,
			plugins:
				cleanurls:
					trailingSlashes: true
	)
	.test(
			testerName: 'cleanurls static environment'
			pluginPath: __dirname+'/..',
			testPath: __dirname+'/../test/static'
		,
			env: 'static'
	)