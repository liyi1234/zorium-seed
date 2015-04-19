z = require 'zorium'
paperColors = require 'zorium-paper/colors.json'
Rx = require 'rx-lite'

config = require './config'
HomePage = require './pages/home'
FourOhFourPage = require './pages/404'
PreloadSerivce = require './services/preload'

isInliningSource = config.ENV is config.ENVS.PROD

styles = if not window? and isInliningSource
  # Avoid webpack include
  _fs = 'fs'
  fs = require _fs
  fs.readFileSync './dist/bundle.css', 'utf-8'
else
  null

scripts = if not window? and isInliningSource
  # Avoid webpack include
  _fs = 'fs'
  fs = require _fs
  fs.readFileSync './dist/bundle.js', 'utf-8'
else
  null

class RootComponent
  constructor: ({cookies}) ->
    @$currentPage = new Rx.ReplaySubject(1)
    @state = z.state {
      lastRenderedPath: null
      status: 200
      $currentPage: @$currentPage
    }

  render: ({path}) ->
    {lastRenderedPath, $currentPage, status} = @state.getValue()

    if path isnt lastRenderedPath
      @state.set lastRenderedPath: path
      if path is '/'
        $currentPage = new HomePage()
      else
        @state.set status: 404
        $currentPage = new FourOhFourPage()
      @$currentPage.onNext $currentPage

    webpackDevHostname = config.WEBPACK_DEV_HOSTNAME
    title = 'Zorium Seed'
    description = 'Zorium Seed - (╯°□°）╯︵ ┻━┻)'
    keywords = 'Zorium'
    name = 'Zorium Seed'
    twitterHandle = '@ZoriumJS'
    themeColor = paperColors.$teal700
    favicon = '/images/zorium_icon_32.png'
    icon1024 = '/images/zorium_icon_1024.png'
    icon256 = '/images/zorium_icon_256.png'
    url = 'http://zorium.org'

    tree = z 'html',
      z 'head',
        z 'title', "#{title}"
        z 'meta', {name: 'description', content: "#{description}"}
        z 'meta', {name: 'keywords', content: "#{keywords}"}

        # mobile
        z 'meta',
          name: 'viewport'
          content: 'initial-scale=1.0, width=device-width, minimum-scale=1.0,
                    maximum-scale=1.0, user-scalable=0, minimal-ui'
        z 'meta', {name: 'msapplication-tap-highlight', content: 'no'}
        z 'meta', {name: 'apple-mobile-web-app-capable', content: 'yes'}

        # Schema.org markup for Google+
        z 'meta', {itemprop: 'name', content: "#{name}"}
        z 'meta', {itemprop: 'description', content: "#{description}"}
        z 'meta', {itemprop: 'image', content: "#{icon256}"}

        # Twitter card
        z 'meta', {name: 'twitter:card', content: 'summary_large_image'}
        z 'meta', {name: 'twitter:site', content: "#{twitterHandle}"}
        z 'meta', {name: 'twitter:creator', content: "#{twitterHandle}"}
        z 'meta', {name: 'twitter:title', content: "#{title}"}
        z 'meta', {name: 'twitter:description', content: "#{description}"}
        z 'meta', {name: 'twitter:image:src', content: "#{icon1024}"}

        # Open Graph
        z 'meta', {property: 'og:title', content: "#{name}"}
        z 'meta', {property: 'og:type', content: 'website'}
        z 'meta', {property: 'og:url', content: "#{url}"}
        z 'meta', {property: 'og:image', content: "#{icon1024}"}
        z 'meta', {property: 'og:description', content: "#{description}"}
        z 'meta', {property: 'og:site_name', content: "#{name}"}

        # iOS
        z 'link', {rel: 'apple-touch-icon', href: "#{icon256}"}

        # misc
        z 'meta', {name: 'theme-color', content: "#{themeColor}"}
        z 'link', {rel: 'shortcut icon', href: "#{favicon}"}

        # fonts
        z 'style',
          innerHTML: '
            @font-face {
              font-family: "Roboto";
              font-style: normal;
              font-weight: 300;
              src:
                local("Roboto Light"),
                local("Roboto-Light"),
                url(https://fonts.gstatic.com/s/roboto/v15/Hgo13k-tfSpn0qi1S' +
                'FdUfZBw1xU1rKptJj_0jans920.woff2) format("woff2"),
                url(https://fonts.gstatic.com/s/roboto/v15/Hgo13k-tfSpn0qi1S' +
                'FdUfbO3LdcAZYWl9Si6vvxL-qU.woff) format("woff"),
                url(https://fonts.gstatic.com/s/roboto/v15/Hgo13k-tfSpn0qi1S' +
                'FdUfSZ2oysoEQEeKwjgmXLRnTc.ttf) format("truetype");
            }
            @font-face {
              font-family: "Roboto";
              font-style: normal;
              font-weight: 400;
              src:
                local("Roboto"),
                local("Roboto-Regular"),
                url(https://fonts.gstatic.com/s/roboto/v15/oMMgfZMQthOryQo9n' +
                '22dcuvvDin1pK8aKteLpeZ5c0A.woff2) format("woff2"),
                url(https://fonts.gstatic.com/s/roboto/v15/CrYjSnGjrRCn0pd9V' +
                'QsnFOvvDin1pK8aKteLpeZ5c0A.woff) format("woff"),
                url(https://fonts.gstatic.com/s/roboto/v15/QHD8zigcbDB8aPfIo' +
                'aupKOvvDin1pK8aKteLpeZ5c0A.ttf) format("truetype");
            }
            @font-face {
              font-family: "Roboto";
              font-style: normal;
              font-weight: 500;
              src:
                local("Roboto Medium"),
                local("Roboto-Medium"),
                url(https://fonts.gstatic.com/s/roboto/v15/RxZJdnzeo3R5zSexg' +
                'e8UUZBw1xU1rKptJj_0jans920.woff2) format("woff2"),
                url(https://fonts.gstatic.com/s/roboto/v15/RxZJdnzeo3R5zSexg' +
                'e8UUbO3LdcAZYWl9Si6vvxL-qU.woff) format("woff"),
                url(https://fonts.gstatic.com/s/roboto/v15/RxZJdnzeo3R5zSexg' +
                'e8UUSZ2oysoEQEeKwjgmXLRnTc.ttf) format("truetype");
            }
          '

        # styles
        if isInliningSource
          z 'style',
            innerHTML: styles
        else
          null

        # preloaded data
        PreloadSerivce.serializeToComponent()

      z 'body',
        z '#zorium-root',
          $currentPage
        z 'div',
          if isInliningSource
            z 'script',
              innerHTML: scripts
          else
            z 'script', {src: "//#{webpackDevHostname}:3004/bundle.js"}

    if status is 404
      throw new z.server.Error {tree, status}
    else
      return tree

module.exports = ({cookies}) ->
  new RootComponent({cookies})