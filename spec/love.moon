lfs = require "lfs"

return {
    getVersion: ->
        0, 10, 1, "Super Toast"
    filesystem:
        getDirectoryItems: (path) ->
            ok, results = pcall ->
                results = {}
                for file in lfs.dir lfs.currentdir! .. "/" .. path
                    table.insert results, file
                return results
            if ok
                return results
            else
                return {}
    graphics:
        getWidth: ->
            return 1280
        getHeight: ->
            return 720
}
