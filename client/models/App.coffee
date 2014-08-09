#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @set 'gameState', 'Player Turn'
    player = @get 'playerHand'
    
    player.on 'score', (score, length, hand) =>
      state = @checkScore score, length, player
    ,@

    player.on 'stand', =>
      @disable()
    ,@

    @on 'change:gameState', @alertState, @

  disableHit: ->
    @disable('hit')

  disable: (button) ->
    button ||= 'all'
    @trigger 'disable', button

  alertState: ->
    @trigger 'state', @get 'gameState'

  checkScore: (score, length, hand) -> 
    if score[0] >= 21
      @disable()
      if score[0] > 21
        'bust'
      else
        if length is 2 then 'blackjack' else 'win'
    else
      'continue'
