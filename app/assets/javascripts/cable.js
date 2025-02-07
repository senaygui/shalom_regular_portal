// alert('App.cable4556')

// import consumer from "../../javascript/channels/consumer";

// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self
//= require_tree ./channels
// alert('App.cable4556')
(function() {
  this.App || (this.App = {});

  consumer = ActionCable.createConsumer();
  // alert("www")

    consumer.subscriptions.create("NotifyJobStatusChannel", {
        connected() {
            // alert("Connected with notify job")
        },
        disconnected() {
    
        },
    
        received(data) {
            alert(data.message)
        }
    
    })
}).call(this);

