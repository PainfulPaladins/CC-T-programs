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
    rednet.broadcast(data)
end
 
function send_songs(songs)
    term.clear()
    
    
    for i,song in pairs(songs) do
        print(song)
        send_file("songs/" .. song)
    end
end

print("Welcome to RedMusic!")

response = ...
if response == nil then
    print("You need to pass an argument, either 'receive' if you want the computer to wait for songs to be trasmitted or the path of the song to transmit the chosen song.")
elseif response == "receive" then
    receive_songs()
elseif fs.exists(response) then
    send_songs()
else
    print("Invalid arguments.")
end