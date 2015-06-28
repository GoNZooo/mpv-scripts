--function on_start_file(event)
--    local playlist_count = mp.get_property_number("playlist-count", 1)
--    local playlist_current_pos = mp.get_property_number("playlist-pos")
--
--    local playlist_pos_file = io.open("playlist_position.txt", "r")
--    local playlist_stored_pos = playlist_pos_file:read("*number")
--    playlist_pos_file:close()
--
--    if playlist_count ~= 1 and playlist_stored_pos ~= playlist_current_pos then
--        mp.set_property_number("playlist-pos", playlist_stored_pos)
--    end
--
--end

function read_pos(filename)
    local pos_file = io.open(filename, "r")
    local stored_pos = -1
    if pos_file ~= nil then
        stored_pos = pos_file:read("*number")
        pos_file:close()
    end

    return stored_pos
end

function on_file_loaded(event)
    local playlist_count = mp.get_property_number("playlist-count", 1)
    local playlist_current_pos = mp.get_property_number("playlist-pos")

    if playlist_count ~= 1 then
        local playlist_stored_pos = read_pos("playlist_position.txt")
        if playlist_stored_pos ~= playlist_current_pos then 
            mp.set_property_number("playlist-pos", playlist_stored_pos)
        end
        mp.osd_message("Playing entry #" .. (playlist_current_pos + 1) .. " out of " .. playlist_count, 2)
    end

end

function write_playlist_pos(event)
    local playlist_count = mp.get_property_number("playlist-count", 1)

    if playlist_count ~= 1 then
        local playlist_pos_output = io.open("playlist_position.txt", "w")
        local playlist_position = mp.get_property_number("playlist-pos", 0)
        playlist_pos_output:write(playlist_position)
        playlist_pos_output:close()
    end
end

mp.register_event("file-loaded", on_file_loaded)
mp.register_event("shutdown", write_playlist_pos)
mp.register_event("end-file", write_playlist_pos)
