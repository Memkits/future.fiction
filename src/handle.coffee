
log = (args...) ->
  console?.log?.apply? console, args

query = (identity) -> document.querySelector identity
queryAll = (identity) -> document.querySelectorAll identity

spawn = (str) ->
  c = document.createElement "div"
  c.innerHTML = str
  c.firstChild

window.addEventListener "load", ->
  window.home = query "#home"
  window.entries = query "#entries"
  window.content = query "#content"

  load_content = (path) ->

    req = new XMLHttpRequest
    req.open "get", "../fictions/#{path}"
    req.send()
    req.onload = ->
      lines = req.response.split "\n"
      # log lines

      add_line = ->
        line = lines.shift()
        if line?
          line = "¬" if line.trim().length is 0
          elem = spawn "<div class='line'>#{line}</div>"
          elem.onclick = book_mark
          content.appendChild elem
          setTimeout add_line, 0

      do remove_line = ->
        if content.lastChild?
          # log content.lastChild
          content.removeChild content.lastChild
          setTimeout remove_line, 0
        else
          add_line()

  chapter_mark = (e) ->
    last = query ".chapter"
    if last? then last.className = "entry"
    elem = e.target
    elem.className = "entry chapter"

  book_mark = (e) ->
    last = query ".mark"
    if last? then last.className = "line"
    elem = e.target
    elem.className = "line mark"

  load_obj = (obj) ->
    entries.innerHTML = ""
    # log "obj", obj

    obj.dir.forEach (dir) ->
      elem = spawn "<div class='entry'>#{dir.name}/</div>"
      entries.appendChild elem
      entries.lastChild.onclick = ->
        # log "-----> click", dir
        load_obj dir.arr

    obj.arr.forEach (file) ->
      elem = spawn "<div class='entry'>#{file.name}</div>"
      entries.appendChild elem
      elem.onclick = (e) ->
        load_content file.path
        chapter_mark e

  req = new XMLHttpRequest
  req.open "get", "../fictions/index.json"
  req.send()
  req.onload = (res) ->
    json = JSON.parse req.response
    do home.onclick = -> load_obj json

  load_content "sight-of-题叶/12-10-21-飞.fic"