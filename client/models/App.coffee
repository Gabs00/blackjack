#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    player = @get 'playerHand'
    
    player.on 'bust', =>
      console.log 'received bust'
      @disableHit()
    ,@
    

  disableHit: ->
    @disable('hit')

  disable: (button) ->
    button ||= 'all'
    @trigger 'disable', button
