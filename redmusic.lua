peripheral.find("modem",rednet.open)
 
function receive_file()
    local id,data = rednet.receive()
    local file = fs.open("song.mp3", "w")
    file.write(data)
    file.close()
end
 
function play_file()
    local dfpwm = require("cc.audio.dfpwm")
    local speaker = peripheral.find("speaker")
    local decoder = dfpwm.make_decoder()
    for chunk in io.lines("song.mp3", 16 * 1024) do
        local buffer = decoder(chunk)
    
        while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end
    end
end
 
 
function receive_songs()
    while true do
        print("Waiting for the next song to be sent")
        receive_file()
        print("Playing Song..")
        play_file()
    end
end

function send_file(file_name,id)
    local file = fs.open(file_name,"r")
    local data = file.readAll()
    file.close()
    rednet.send(15,data)
end
 
function send_songs()
    term.clear()
    if not fs.exists("songs") then
        fs.makeDir("songs")
        print("Put your songs in the generated 'songs/' folder, then run the program again.")
    end
    
    song_list = fs.list("songs")
    
    for i,song in pairs(song_list) do
        print(song)
        send_file("songs/" .. song)
    end
end

print("Welcome to RedMusic!")
print("Would you like this computer to send songs to other computers or would you like to have this computer wait for other computers' signal to play a song?")

