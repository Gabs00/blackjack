class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->

  canHit: (status)->
    @set 'canHit', status

  hit: ->
    @add(@deck.pop()).last()
    @sendScore @scores(true)

  stand: ->
    @trigger 'stand'

  scores: (app)->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      app ||= card.get 'revealed'
      score + if app then card.get 'value' else 0
    , 0
    if hasAce and score+10 <= 21 then [score+10, score] else [score]

  sendScore: (score)->
    @trigger 'score', score, @length, JSON.stringify @

  scoreRequest: ->
    score = @scores(true)


