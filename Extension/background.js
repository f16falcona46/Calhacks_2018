var serverID = "";

setInterval(function(){
    var id = retreiveID();
    if (id === "1") {
        abort();
    }
}, 100)

function retreiveID() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "https://jasonli.us/cgi-bin/webapp.cgi?action=is_door_open&id=" + serverID, false);
    xhr.send();
    return xhr.response;
}

function abort() {
    chrome.windows.getAll(function(windows) {
        for (i = 0; i < windows.length; i++) {
            if (windows[i].incognito) {
                chrome.windows.remove(windows[i].id, function() {
                    if (chrome.runtime.lastError) {
                        console.warn("warning: bread was almost not gotten");
                    }                    
                });
            }
        }
    })
}

chrome.runtime.onMessage.addListener(
    function(request) {
        if (request.message === "updated_ID") {
            serverID = request.id;
        }
    }
)





