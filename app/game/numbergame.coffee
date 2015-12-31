numify = (char)-> char.charCodeAt()
stringify = (num)-> String.fromCharCode(num)

module.exports=->
  @level = 2
  @truth = ""
  @challenge = ()->
    @truth = (stringify Math.floor Math.random() * 10 + numify "0" for num in [0..level-1]).join("")
    console.log @truth
    return @truth
  @check = (data)->
    new Promise (fulfill, reject)->
      if data is @truth
        fulfill {status: 200, message:"Correct."}
        @level += 1
      else
        reject {status: 400, message:"Incorrect. Answer was #{@truth}"}
  this
