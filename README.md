# Clean URLs Plugin for DocPad
Adds support for clean URLs to [DocPad](https://docpad.org)


## Install

```
npm install --save docpad-plugin-cleanurls
```


## Usage/Configure

For non-static environments we will set the document's url to it's clean url. This means that our document is still outputted to the same place on the file system as the clean url stuff is handled by the web server instead. This is the default.

For static environments we will set the document's `outPath` to that of a directory with a `index.html` file (e.g. `pages/welcome.html` will be outputted to `pages/welcome/index.html`). You can tell docpad to use the static environment by adding `--env static` to the end of your DocPad command, so to perform a one off generation for a static environment you'll run `docpad generate --env static`, to perform your usual generate, serve and watch it'll be `docpad run --env static`.

If you'd like to disable the static mode when working in the static environment you can add the following to your [docpad configuration file](http://docpad.org/docs/config).

``` coffee
environments:
	static:
		plugins:
			cleanurls:
				enabled: false
```


## History
You can discover the history inside the `History.md` file


## License
Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT License](http://creativecommons.org/licenses/MIT/)
<br/>Copyright &copy; 2012+ [Bevry Pty Ltd](http://bevry.me)
<br/>Copyright &copy; 2011 [Benjamin Lupton](http://balupton.com)