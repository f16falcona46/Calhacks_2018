var serverID = "";

function updateURL() {
    serverID = document.getElementById('id').value;
    document.createTextNode("URL Updated");
    chrome.runtime.sendMessage({"message": "updated_ID", "id": serverID});
}
document.getElementById("updateButton").onclick = updateURL;

