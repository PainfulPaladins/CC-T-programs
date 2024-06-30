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
 
 
 
while true do
    print("Waiting for the next song to be sent")
    receive_file()
    print("Playing Song..")
    play_file()
end