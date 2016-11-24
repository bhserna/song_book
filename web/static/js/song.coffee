$ = require("jquery")

selectorForAction = (actionName) ->
  "[data-action='#{actionName}']"

$findAction = ($el, actionName) ->
  $el.find(selectorForAction(actionName))

show = ($el) ->
  $el.removeClass("is-hidden")

hide = ($el) ->
  $el.addClass("is-hidden")

onAction = (actionName, fun) ->
  $(document).on "click", selectorForAction(actionName), fun

selectors =
  song: ".js-song"
  controls: ".js-song-controls"

render = (page, opts) ->
  song = Parser.parseString(page.source)
  page.$el.html(Content.render(song, opts))
  page.$el.removeClass("is-hidden")
  renderControls(page, song, opts)

renderControls = (page, song, opts) ->
  return unless song.count.chords
  if opts.showChords
    show $controlFor(page, "hide-chords")
    hide $controlFor(page, "show-chords")
  else
    show $controlFor(page, "show-chords")
    hide $controlFor(page, "hide-chords")

$controlFor = (page, name) ->
  $findAction(page.$controls, name)

init = (page) ->
  render(page, showChords: false)
  onAction "show-chords", -> render(page, showChords: true)
  onAction "hide-chords", -> render(page, showChords: false)

$ ->
  $song = $(selectors.song)
  init page =
    $el: $song
    $controls: $(selectors.controls)
    source: $song.text()
