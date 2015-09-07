module.exports =
	poweredByDocPad: false
	plugins:
		cleanurls:
			simpleRedirects:
				'/open': '/sesame'
				'/gh': 'https://github.com'
			advancedRedirects: [
				[/^\/(?:g|gh|github|project)(?:\/(.*))?$/, 'https://github.com/bevry/$1']
			]
