$ = require("jquery")

Lyrics =
  renderHtml: (text = "", opts = {chords: true}) ->
    return "" unless text
    @renderChords @renderBlocks(text, opts), opts

  hasChords: (text = "") ->
    !!(text.match @chordRegexp)

  renderBlocks: (text, opts) ->
    (for block in @blocksIn(text)
      @wrapBlock(@blockWithLineBreaks(block), opts)).join ""

  chordRegexp: ///
    (\[)      # first bracket
    ([\w|#]*) # chord
    (\])      # closing bracket
    ///g

  wrapBlock: (block, opts) ->
    if opts.chords and block.match(@chordRegexp)
      "<p class='lyric__block--with-chords'>#{block}</p>"
    else
      "<p>#{block}</p>"

  blocksIn: (text) ->
    text.split "\n\n"

  blockWithLineBreaks: (block) ->
    (for line, index in lines = block.split "\n"
      @addBreak(line, index, lines.length)).join ""

  addBreak: (line, index, linesCount) ->
    if index + 1 is linesCount then line else "#{line}<br/>"

  renderChords: (block, opts) ->
    replacer = if opts.chords then @replaceChord else ""
    block.replace @chordRegexp, replacer

  replaceChord: (match, _openBracket, chord, _closingBracked, offset, _string) ->
    "<span class='lyric__chord'>#{chord}</span>"

App =
  init: (@$el, @$controls, @source = @$el.text()) ->

  render: (opts) ->
    @$el.html Lyrics.renderHtml(@source, opts)

    if Lyrics.hasChords(@source)
      @$controls.removeClass("is-hidden")

      if opts.chords
        @showControl "hide-chords"
        @hideControl "show-chords"

      else
        @showControl "show-chords"
        @hideControl "hide-chords"

  showControl: (control) ->
    @$controls.find("[data-action='#{control}']").removeClass("is-hidden")

  hideControl: (control) ->
    @$controls.find("[data-action='#{control}']").addClass("is-hidden")

  onAction: (name, fun) ->
    $(document).on "click", ".js-lyric-controls [data-action='#{name}']", fun

App.onAction "show-chords", -> App.render chords: true
App.onAction "hide-chords", -> App.render chords: false

$ ->
  $el = $(".js-lyric")
  $el.html(Content.render(Parser.parseString($el.text())))
