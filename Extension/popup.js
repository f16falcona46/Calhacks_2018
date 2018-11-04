var serverURL = "";

function updateURL() {
    serverURL = document.getElementById('url').value;
    document.createTextNode("URL Updated");
    chrome.runtime.sendMessage({"message": "updated_URL", "url": serverURL});
}
document.getElementById("updateButton").onclick = updateURL;

