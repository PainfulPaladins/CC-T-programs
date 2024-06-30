peripheral.find("modem", rednet.open)
 
function send_file(file_name,id)
    local file = fs.open(file_name,"r")
    local data = file.readAll()
    file.close()
    rednet.send(15,data)
end
 
-- start of program
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