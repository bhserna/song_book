_ = require 'underscore'
S = require 'string'

props =
  playback: true
  currentChordId: null

switches =
  showChords: false
  showLyrics: true
  showFade: true
  showSections: true
  showAlternates: true

classNames = (config) ->
  (className for className, isActive of config when isActive).join " "

renderSectionHeader = (section) ->
  if switches.showSections
    """<div class="song-section-header">#{section.section}</div>"""

renderLine = (song, line) ->
  """<div id="line_#{line.lineId}">#{_.map(line, (phrase) -> renderPhrase(song, phrase)).join("")}</div>"""

renderLyric = (phrase) ->
  lyric = S(phrase.lyric).trim().s

  if (lyric or switches.showChords) and switches.showLyrics
    """<div class="song-lyric">#{lyric or ' '}</div>"""

renderChord = (song, phrase) ->
  hasAlts = song.alts[phrase.chord]? and phrase.exception and switches.showAlternates
  chord = phrase.chord

  classes = classNames
    'song-chord': true
    'song-mute': switches.showFade and not phrase.exception
    'song-clickable-color': hasAlts
    'song-clickable': props.playback
    'song-playback-active': props.playback and props.currentChordId is phrase.chordId

  if chord and switches.showChords
    """<div class="#{classes}">#{chord}</div>"""
  else
    ""

renderPhrase = (song, phrase) ->
  lyric = renderLyric phrase
  chord = renderChord song, phrase

  return unless lyric or chord

  classes = classNames
    "song-phrase": true,
    "song-join": phrase.wordExtension and lyric
    "song-no-lyric": not S(phrase.lyric).trim().s or not switches.showLyrics

  """<div class="#{classes}">#{chord}#{lyric}</div>"""

renderContent = (song) ->
  _.map(song.content, (section) =>
    """
    <div>
      #{renderSectionHeader(section)}
      <div class="song-section">#{_.map(section.lines, (line) -> renderLine(song, line)).join("")}</div>
    </div>
    """
    ).join("")

render = (song) ->
  """<div>#{renderContent(song)}</div>"""

window.Content = module.exports = {render}
