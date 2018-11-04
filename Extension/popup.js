var serverID = "";
var state;

function updateID() {
    serverID = document.getElementById('id').value;
    chrome.runtime.sendMessage({"message": "updated_ID", "id": serverID});
}
document.getElementById("updateButton").onclick = updateID;

function togglePower() {
    var element = document.getElementById('powerButton');
    if (state) {
        element.textContent = "turn on";
        chrome.runtime.sendMessage({"message": "turnOff"});
    } else if (!state) {
        element.textContent = "turn off";
        chrome.runtime.sendMessage({"message": "turnOn"});
    }
    state = !state;
}
document.getElementById("powerButton").onclick = togglePower;

chrome.runtime.onMessage.addListener(function(request) {
    if (request.message === "returnStatus") {
        serverID = request.serverID;
        state = request.power;
        document.getElementById("id").value = serverID;
        if (state) {
            document.getElementById("powerButton").textContent = "turn off";
        } else if (!state) {
            document.getElementById("powerButton").textContent = "turn on";
        }
    }
})

chrome.runtime.sendMessage({"message": "getStatus"});