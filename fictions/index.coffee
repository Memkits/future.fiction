
fs = require "fs"
path = require "path"

log = console.log

valid = (obj) -> yes

add_file = (name, obj, location) ->
  # log "add file", name, obj
  if (path.extname name) in [".fic", ".fict", ".fiction"]
    obj.arr.push {path: location,name}

add_dir = (dir_name, obj, location) ->
  # log "add_dir", location

  obj.dir = []
  obj.arr = []


  list = fs.readdirSync dir_name
  list.sort().forEach (file_name) ->
    child_location = path.join location, file_name
    stat = fs.statSync child_location
    if stat.isDirectory()
      child_obj = add_dir child_location, {}, child_location

      if valid child_obj
        obj.dir.push name: file_name, arr: child_obj

    else
      add_file file_name, obj, child_location
  obj

data = add_dir ".", {}, "."

content = JSON.stringify data, null, 2
fs.writeFile "index.json", content