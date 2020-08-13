// @ts-nocheck
'use strict'

// Import
const { join } = require('path')

// Test our plugin using DocPad's Testers
require('./tester.js')
	.test(
		{
			// Test Configuration
			testerName: 'cleanurls development environment',
			removeWhitespace: true,
		},
		{
			// DocPad Configuration
			env: 'development',
			logLevel: 6,
		}
	)
	.test(
		{
			// Test Configuration
			testerName: 'cleanurls development environment with trailing slashes',
			removeWhitespace: true,
		},
		{
			// DocPad Configuration
			env: 'development',
			plugins: {
				cleanurls: {
					trailingSlashes: true,
				},
			},
		}
	)
	.test(
		{
			// Test Configuration
			testerName: 'cleanurls static environment',
			outExpectedPath: join(__dirname, '..', 'test', 'out-expected-static'),
			removeWhitespace: true,
		},
		{
			// DocPad Configuration
			env: 'static',
		}
	)
