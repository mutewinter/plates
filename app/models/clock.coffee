module.exports = App.Clock = Ember.Object.extend
  seconds: 0
  tick:(->
    clock = this
    Ember.run.later (->
      seconds = clock.get("seconds")
      clock.set "seconds", seconds + 1  if typeof seconds is "number"
    ), 5000
  ).observes("seconds").on("init")
