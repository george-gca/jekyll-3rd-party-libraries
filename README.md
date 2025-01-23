# jekyll-3rd-party-libraries

[![Gem Version](https://badge.fury.io/rb/jekyll-3rd-party-libraries.svg)](http://badge.fury.io/rb/jekyll-3rd-party-libraries)

A better way to handle 3rd party css and js libraries in Jekyll.

Whenever you are creating your site, you might want to use some 3rd party libraries like Bootstrap, jQuery, etc. You can download them and put them in your assets folder, but it is usually recommended to use them via [CDNs](https://www.cloudflare.com/learning/cdn/what-is-a-cdn/). This plugin allows you to use CDNs for your 3rd party libraries and also provides a way to use them offline.

## Installation

1. Add `gem 'jekyll-3rd-party-libraries'` to your site's Gemfile
2. Add the following to your site's `_config.yml`:

```yml
plugins:
  - jekyll-3rd-party-libraries
```

## Usage

Add the following to your site's `_config.yml`:

```yml
# Add the url, version and integrity hash of the libraries you use in your site.
# The integrity hash is used to ensure that the library is not tampered with.
# Integrity hashes not provided by the libraries can be generated using https://www.srihash.org/
third_party_libraries:
  download: false # if true, download the versions of the libraries specified below and use the downloaded files
  library:
    integrity:
      css: "sha..."
      js: "sha..."
    url:
      css: "https://..." # replace the version in the url by {{version}}
      js: "https://..." # replace the version in the url by {{version}}
    version: "0.0.1"
```

There are 2 advantages of using this plugin:

1. You can easily change the version of the library you are using by changing the version in the `_config.yml` file and also its integrity, when provided;
2. You can use the `download` option to download the libraries and use them offline.

### Example usage

For example, to use [Bootstrap](https://www.bootstrapcdn.com/), the recommended way to use via CDN is:

```html
<link
  rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
  integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
  crossorigin="anonymous"
>
```

You need to modify it to be used in your site's `_config.yml`, like this:

```yml
third_party_libraries:
  download: false # if true, download the versions of the libraries specified below and use the downloaded files
  bootstrap:
    integrity:
      css: "sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
    url:
      css: "https://cdn.jsdelivr.net/npm/bootstrap@{{version}}/dist/css/bootstrap.min.css" # note that the version was replaced by {{version}}
    version: "5.3.3"
```

Then, you can use the following in your site's layout file:

```html
<link
  rel="stylesheet"
  href="{{ site.third_party_libraries.bootstrap.url.css }}"
  integrity="{{ site.third_party_libraries.bootstrap.integrity.css }}"
  crossorigin="anonymous"
>
```

### Offline Usage

There are [multiple benefits](https://www.cdnetworks.com/blog/web-performance/cdn-benefits/) of [using CDNs](https://www.cloudflare.com/learning/cdn/cdn-benefits/), but you might want to have the possibility to run the website without relying on external servers. Not only for privacy, but also for offline usage. Also, hosting all files together reduces external calls and that can improve performance (depending on where the site is hosted). If this is the case, you'll want to download the libraries. This plugin provides an easy way to achieve this. Simply set:

```yml
third_party_libraries:
  download: true
```

When activated, this option should automatically download all required libraries (those that are defined in your `_config.yml`) and put them in an appropriate assets folder under `assets/libs/`. This download will only happen if the file is not already downloaded. If you want to override the downloaded file, you can delete it from the assets folder and run the build again. This option will also update the link to the file in the built site, not in the source files. For instance, if you have the following in your `_config.yml`:

```yml
third_party_libraries:
  download: true
  mdb:
    integrity:
      css: "sha256-jpjYvU3G3N6nrrBwXJoVEYI/0zw8htfFnhT9ljN3JJw="
    url:
      css: "https://cdn.jsdelivr.net/npm/mdbootstrap@{{version}}/css/mdb.min.css"
    version: "4.20.0"
```

And the following in your layout file:

```html
<link
  rel="stylesheet"
  href="{{ site.third_party_libraries.mdb.url.css }}"
  integrity="{{ site.third_party_libraries.mdb.integrity.css }}"
  crossorigin="anonymous"
>
```

After you build your site, the plugin will download the file from the provided URL and put it in the `assets/libs/mdb/` folder. The link in the built site (in the `_site/` directory) will be updated to point to the downloaded file, like:

```html
<link
  rel="stylesheet"
  href="/assets/libs/mdb/mdb.min.css"
  integrity="sha256-jpjYvU3G3N6nrrBwXJoVEYI/0zw8htfFnhT9ljN3JJw="
  crossorigin="anonymous"
>
```

These steps will be printed in your terminal, so you can see what is happening.

```
Downloading https://cdn.jsdelivr.net/npm/mdbootstrap@4.20.0/css/mdb.min.css to /home/george-gca/my-site/assets/libs/mdb/mdb.min.css
```

### Advanced usage

By default, the plugin will look for any url under the `url` key inside the library definition. This means that you can organize your urls in a way that makes sense to you. For example, you can have a `css` and a `js` key for each library, like this:

```yml
third_party_libraries:
  download: false
  bootstrap:
    integrity:
      css: "sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
      js: "sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
    url:
      css: "https://cdn.jsdelivr.net/npm/bootstrap@{{version}}/dist/css/bootstrap.min.css" # note that the version was replaced by {{version}}
      js: "https://cdn.jsdelivr.net/npm/bootstrap@{{version}}/dist/js/bootstrap.min.js" # note that the version was replaced by {{version}}
    version: "5.3.3"
```

You can even have a `css` and a `js` key for each version of the library, like this:

```yml
third_party_libraries:
  download: false
  echarts:
    integrity:
      js:
        library: "sha256-QvgynZibb2U53SsVu98NggJXYqwRL7tg3FeyfXvPOUY="
        dark_theme: "sha256-sm6Ui9w41++ZCWmIWDLC18a6ki72FQpWDiYTDxEPXwU="
    url:
      js:
        library: "https://cdn.jsdelivr.net/npm/echarts@{{version}}/dist/echarts.min.js"
        dark_theme: "https://cdn.jsdelivr.net/npm/echarts@{{version}}/theme/dark-fresh-cut.js"
    version: "5.5.0"
```

and use it like this in your layout:

```html
<script
  src="{{ site.third_party_libraries.echarts.url.js.library }}"
  integrity="{{ site.third_party_libraries.echarts.integrity.js.library }}"
  crossorigin="anonymous"
></script>
{% if site.enable_darkmode %}
  <script
    src="{{ site.third_party_libraries.echarts.url.js.dark_theme }}"
    integrity="{{ site.third_party_libraries.echarts.integrity.js.dark_theme }}"
    crossorigin="anonymous"
  ></script>
{% endif %}
```

### Fonts

Fonts are a special case, as you have to download not only the css files, but the font files themselves. For this, you have to use the `fonts` key in the library definition. For example, to use it with the [Roboto](https://fonts.google.com/specimen/Roboto) font from Google Fonts and MathJax, you can do this:

```yml
third_party_libraries:
  download: true
  google_fonts:
    url:
      fonts: "https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Roboto+Slab:100,300,400,500,700|Material+Icons&display=swap"
  mathjax:
    integrity:
      js: "sha256-MASABpB4tYktI2Oitl4t+78w/lyA+D7b/s9GEP0JOGI="
    local:
      fonts: "output/chtml/fonts/woff-v2/"
    url:
      fonts: "https://cdn.jsdelivr.net/npm/mathjax@{{version}}/es5/output/chtml/fonts/woff-v2/"
      js: "https://cdn.jsdelivr.net/npm/mathjax@{{version}}/es5/tex-mml-chtml.js"
    version: "3.2.2"
```

Note that MathJax is a special use case, as it requires the fonts to be downloaded to a specific subdirectory. The plugin will download the fonts and update the css file to point to the downloaded fonts, as can be seen in the terminal prints below.
<details>
  <summary>Terminal prints</summary>

  ```
  Downloading fonts from https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Roboto+Slab:100,300,400,500,700|Material+Icons&display=swap to /home/george-gca/my-site/assets/libs/google_fonts
  Downloading https://fonts.gstatic.com/s/materialicons/v143/flUhRq6tzZclQEJ-Vdg-IuiaDsNc.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/flUhRq6tzZclQEJ-Vdg-IuiaDsNc.woff2
  Changed url(https://fonts.gstatic.com/s/materialicons/v143/flUhRq6tzZclQEJ-Vdg-IuiaDsNc.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/flUhRq6tzZclQEJ-Vdg-IuiaDsNc.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3GUBGEe.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3GUBGEe.woff2
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3GUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3GUBGEe.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3iUBGEe.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3iUBGEe.woff2
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3iUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3iUBGEe.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3CUBGEe.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3CUBGEe.woff2
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3CUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3CUBGEe.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3-UBGEe.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3-UBGEe.woff2
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3-UBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3-UBGEe.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMawCUBGEe.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMawCUBGEe.woff2
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMawCUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMawCUBGEe.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMaxKUBGEe.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMaxKUBGEe.woff2
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMaxKUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMaxKUBGEe.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3OUBGEe.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3OUBGEe.woff2
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3OUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3OUBGEe.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3KUBGEe.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3KUBGEe.woff2
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3KUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3KUBGEe.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3yUBA.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3yUBA.woff2
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3yUBA.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3yUBA.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3GUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3GUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3iUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3iUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3CUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3CUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3-UBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3-UBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMawCUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMawCUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMaxKUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMaxKUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3OUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3OUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3KUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3KUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3yUBA.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3yUBA.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3GUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3GUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3iUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3iUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3CUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3CUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3-UBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3-UBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMawCUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMawCUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMaxKUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMaxKUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3OUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3OUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3KUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3KUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3yUBA.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3yUBA.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3GUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3GUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3iUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3iUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3CUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3CUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3-UBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3-UBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMawCUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMawCUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMaxKUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMaxKUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3OUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3OUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3KUBGEe.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3KUBGEe.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/roboto/v47/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3yUBA.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/KFO7CnqEu92Fr1ME7kSn66aGLdTylUAMa3yUBA.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2) format('woff2');
  Downloading https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2 to /home/george-gca/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufA5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufJ5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufB5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufO5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufC5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufD5qW54A.woff2) format('woff2');
  Changed url(https://fonts.gstatic.com/s/robotoslab/v34/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2) format('woff2'); to url(/my-site/assets/libs/google_fonts/fonts/BngMUXZYTXPIvIBgJJSb6ufN5qU.woff2) format('woff2');
  Saving modified css file to /home/george-gca/my-site/assets/libs/google_fonts/google-fonts.css
  Downloading fonts from https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/ to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_AMS-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_AMS-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Calligraphic-Bold.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Calligraphic-Bold.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Calligraphic-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Calligraphic-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Fraktur-Bold.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Fraktur-Bold.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Fraktur-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Fraktur-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Main-Bold.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Main-Bold.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Main-Italic.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Main-Italic.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Main-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Main-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Math-BoldItalic.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Math-BoldItalic.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Math-Italic.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Math-Italic.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Math-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Math-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_SansSerif-Bold.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_SansSerif-Bold.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_SansSerif-Italic.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_SansSerif-Italic.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_SansSerif-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_SansSerif-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Script-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Script-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Size1-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Size1-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Size2-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Size2-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Size3-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Size3-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Size4-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Size4-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Typewriter-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Typewriter-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Vector-Bold.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Vector-Bold.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Vector-Regular.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Vector-Regular.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/output/chtml/fonts/woff-v2/MathJax_Zero.woff to /home/george-gca/my-site/assets/libs/mathjax/output/chtml/fonts/woff-v2/MathJax_Zero.woff
  Downloading https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/tex-mml-chtml.js to /home/george-gca/my-site/assets/libs/mathjax/tex-mml-chtml.js
  ```
</details>.

### Libraries with images

Some libraries have images that are used internally. For example, Leaflet uses images for some of its UI components, like markers. These images are usually stored in a subdirectory of the library's directory. To download these images, you can specify the `images` key in the `local` key of the library's configuration. The value of the `images` key should be the path to the directory where the images should be saved. For example, to save the images in the `images` directory of the library's directory, you can specify the following configuration:

```yml
third_party_libraries:
  download: true
  leaflet:
    integrity:
      css: "sha256-q9ba7o845pMPFU+zcAll8rv+gC+fSovKsOoNQ6cynuQ="
      js: "sha256-MgH13bFTTNqsnuEoqNPBLDaqxjGH+lCpqrukmXc8Ppg="
      js_map: "sha256-YAoQ3FzREN4GmVENMir8vgHHypC0xfSK3CAxTHCqx1M="
    local:
      images: "images/"
    url:
      css: "https://cdn.jsdelivr.net/npm/leaflet@{{version}}/dist/leaflet.min.css"
      images: "https://cdn.jsdelivr.net/npm/leaflet@{{version}}/dist/images/"
      js: "https://cdn.jsdelivr.net/npm/leaflet@{{version}}/dist/leaflet.min.js"
      js_map: "https://cdn.jsdelivr.net/npm/leaflet@{{version}}/dist/leaflet.js.map"
    version: "1.9.4"
```

Which will also be output to the terminal during the build process:

```
Downloading https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.min.css to /home/george-gca/my-site/assets/libs/leaflet/leaflet.min.css
Downloading images from https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/images/ to /home/george-gca/my-site/assets/libs/leaflet/images/
Downloading https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/images/layers.png to /home/george-gca/my-site/assets/libs/leaflet/images/layers.png
Downloading https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/images/layers-2x.png to /home/george-gca/my-site/assets/libs/leaflet/images/layers-2x.png
Downloading https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/images/marker-icon.png to /home/george-gca/my-site/assets/libs/leaflet/images/marker-icon.png
Downloading https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/images/marker-icon-2x.png to /home/george-gca/my-site/assets/libs/leaflet/images/marker-icon-2x.png
Downloading https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/images/marker-shadow.png to /home/george-gca/my-site/assets/libs/leaflet/images/marker-shadow.png
Downloading https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.min.js to /home/george-gca/my-site/assets/libs/leaflet/leaflet.min.js
Downloading https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js.map to /home/george-gca/my-site/assets/libs/leaflet/leaflet.js.map
```
