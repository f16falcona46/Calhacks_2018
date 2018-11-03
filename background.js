// background.js

// called when the user clicks on the browser action
chrome.browserAction.onClicked.addListener(function(tab) {
    // send a message to the active tab
    chrome.tabs.query({active: true, currentWindow:true}, function(tabs) {
        // var activeTab = tabs[0];
        // var xhr = new XMLHttpRequest();
        // xhr.open("GET", "http://10.142.130.79/cgi-bin/getpage.cgi?action=is_door_open&id=108069", false);
        // xhr.send();
        // var id = xhr.response;
        chrome.windows.getAll(function(windows) {
            // var incognitoWindows = [];
            for (i = 0; i < windows.length; i++) {
                if (windows[i].incognito) {
                    chrome.windows.remove(windows[i].id);
                }
            }
            // console.log(id);
        })
        // chrome.tabs.sendMessage(activeTab.id, {"message": "clicked_browser_action", "id": id, "incognitos": incognitoWindows});
    })
})

chrome.runtime.onMessage.addListener(
    function(request, sender, sendResponse) {
        if (request.message === "open_new_tab") {
            chrome.tabs.create({"url": request.url});
        }
    }
)

function retreiveID() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "http://10.142.130.79/cgi-bin/getpage.cgi?action=is_door_open&id=108069", false);
    xhr.send();
    return xhr.response;
}

setInterval(function(){
    // var id = retreiveID();
    chrome.windows.getAll(function(windows) {
        for (i = 0; i < windows.length; i++) {
            if (windows[i].incognito) {
                chrome.windows.remove(windows[i].id);
            }
        }
    })
}, 1000)




