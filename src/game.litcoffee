# Game
The game model.
Generates a random number string, and compares it to
whatever the user responds with.

> Game <--> Server <--> Client

  (Helper functions - because I'm still not used to these js names.)

    numify = (char)-> char.charCodeAt()
    stringify = (num)-> String.fromCharCode(num)

Regarding (-> @)():
We're creating a function, and calling it immediately - returning an object.
@ is the python equivalent of self in coffeescript.

    module.exports=(->
      @level = 2  # cheaply starting with two numbers
      @truth = ""

  Currently not implemented is multiple user sessions.
  Since this is an electron app, we're currently assuming that
  there is only one person to track. Otherwise, these games would
  run in sessions, and get looked up by the event sender id.

      @challenge = ()->
        @truth = (stringify Math.floor Math.random() * 10 + numify "0" for num in [0..level-1]).join("")
        console.log @truth
        return @truth

  We'll get data passed in from the user, and verify it against
  the truth. The promise will be sent to the user from server.js.

      @check = (data)->
        new Promise (fulfill, reject)->
          if data is @truth
            fulfill {status: 200, message: "Correct."}
            @level += 1
          else
            reject {status: 400, message: "Incorrect. Answer was #{@truth}"}
      @)()
