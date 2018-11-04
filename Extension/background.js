// background.js

// called when the user clicks on the browser action
chrome.browserAction.onClicked.addListener(function(tab) {
    // send a message to the active tab
    // chrome.tabs.query({active: true, currentWindow:true}, function(tabs) {
    //     var activeTab = tabs[0];
    //     var xhr = new XMLHttpRequest();
    //     xhr.open("GET", "http://10.142.130.79/cgi-bin/getpage.cgi?action=is_door_open&id=108069", false);
    //     xhr.send();
    //     var id = xhr.response;
    //     chrome.windows.getAll(function(windows) {
    //         // var incognitoWindows = [];
    //         for (i = 0; i < windows.length; i++) {
    //             if (windows[i].incognito) {
    //                 chrome.windows.remove(windows[i].id);
    //             }
    //         }
    //         console.log(0);
    //     })
    //     chrome.tabs.sendMessage(activeTab.id, {"message": "clicked_browser_action", "id": id, "incognitos": incognitoWindows});
    // })
})
var serverURL = "";

setInterval(function(){
    var id = retreiveID();
    console.log(id);
    if (id === "1") {
        abort();
    }
}, 100)

function retreiveID() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", serverURL, false);
    xhr.send();
    console.log(xhr.response);
    return xhr.response;
}

function abort() {
    chrome.windows.getAll(function(windows) {
        for (i = 0; i < windows.length; i++) {
            if (windows[i].incognito) {
                chrome.windows.remove(windows[i].id);
            }
        }
    })
}

chrome.runtime.onMessage.addListener(
    function(request) {
        if (request.message === "updated_URL") {
            serverURL = request.url;
            console.log("success");
        }
    }
)




