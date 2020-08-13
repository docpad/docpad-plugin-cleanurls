// @ts-nocheck
'use strict'

const PluginTester = require('docpad-plugintester')
const { equal, deepEqual } = require('assert-helpers')
const fetch = require('node-fetch')

class CustomTester extends PluginTester {
	testCustom() {
		const tester = this
		this.suite('cleanurls', function (suite, test) {
			// Prepare
			const siteURL = tester.docpad.getPlugin('serve').url
			const plugin = tester.docpad.getPlugin('cleanurls')
			const pluginConfig = plugin.getConfig()

			suite('cleanurls for documents suite', function (suite, test) {
				test('server should serve URLs without an extension', function (done) {
					const fullURL = siteURL + '/welcome/'
					fetch(fullURL)
						.then((r) => r.text())
						.then(function (content) {
							const actual = content.toString().trim()
							const expected = 'Welcome Page!'
							equal(
								actual,
								expected,
								'result from welcome URL contains expected content'
							)
							done()
						})
						.catch(done)
				})

				test('documents should have urls without extensions', function (done) {
					const actualUrls = tester.docpad
						.getCollection('documents')
						.map(function (doc) {
							return doc.get('url')
						})

					const expectedUrls = pluginConfig.trailingSlashes
						? ['/', '/404/', '/hi', '/welcome/']
						: ['/', '/404', '/hi', '/welcome']

					deepEqual(actualUrls.sort(), expectedUrls, 'URLs are as expected')
					done()
				})
			})

			suite('redirect configuration suite', function (suite, test) {
				if (tester.docpadConfig.environment === 'development') {
					test('test redirect middleware', function (done) {
						const fullURL = siteURL + '/open'
						fetch(fullURL)
							.then((r) => r.text())
							.then(function (content) {
								const actual = content.toString().trim()
								const expected = pluginConfig.getRedirectTemplate('/sesame')
								equal(
									actual,
									expected,
									'result from a simple redirect URL contains the expected content'
								)
								done()
							})
							.catch(done)
					})

					test('test advanced redirect middleware', function (done) {
						const fullURL = siteURL + '/gh/website'
						fetch(fullURL)
							.then((r) => r.text())
							.then(function (content) {
								const actual = content.toString().trim()
								const expected = pluginConfig.getRedirectTemplate(
									'https://github.com/bevry/website'
								)
								equal(
									actual,
									expected,
									'result from an advanced redirect URL contains the expected content'
								)
								done()
							})
							.catch(done)
					})
				}

				if (tester.docpadConfig.environment === 'static') {
					test('test redirect file', function (done) {
						const fullURL = siteURL + '/open/index.html'
						fetch(fullURL)
							.then((r) => r.text())
							.then(function (content) {
								const actual = content.toString().trim()
								const expected = pluginConfig.getRedirectTemplate('/sesame')
								equal(
									actual,
									expected,
									'result from a simple redirect URL contains the expected content'
								)
								done()
							})
							.catch(done)
					})
				}
			})
		})
	}
}

module.exports = CustomTester
