import consumer from "./consumer";
document.addEventListener("turbolink:load", () => {
    alert("www")
    consumer.subscriptions.create("NotifyJobStatusChannel", {
        connected() {
            alert("Connected with notify job status channel")
            console.log("Connected with notify job")
        },
        disconnected() {
    
        },
    
        received(data) {
            
        }
    
    })
})