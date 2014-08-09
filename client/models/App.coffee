#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', player = deck.dealPlayer()
    @set 'dealerHand', dealer = deck.dealDealer()
    @set 'dealerScore', if dscore = dealer.scoreRequest() is 21 then 'blackjack' else dscore
    @set 'playerScore', if pscore = player.scoreRequest() is 21 then 'blackjack' else pscore
    if pscore is 21 then @checkState()
    if dscore is 21 then @checkState()


    player.on 'score', (score, length, hand) =>
      state = @checkScore score, length, player
      @set 'playerScore', score[0]
      if state is 'bust'
        @checkState()
      else if state is 'stay'
        dealer.at(0).flip()
        @dealerLogic(dealer)

    ,@

    player.on 'stand', =>
      dealer.at(0).flip()
      @dealerLogic(dealer)
      @disable()
    ,@

    dealer.on 'score', (score, length, hand) =>
      state = @checkScore score, length, dealer
      @set 'dealerScore', score[0]
      if @dealerLogic(dealer) is false then @checkState()
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
        if length is 2 then 'blackjack' else 'stay'
    else
      'continue'
  dealerLogic: (hand) ->
    score = @get 'dealerScore'
    if score < 17
      hand.hit()
      true
    else
      false

  checkState: ->
    player = @get 'playerScore'
    dealer = @get 'dealerScore'
    state = switch
      when player > 21 then 'Player Bust'
      when dealer > 21 then 'Dealer Bust' 
      when dealer is player then 'Push'
      when dealer > player then 'Dealer Win'
      when player > dealer then 'Player Win'
      when player is 'blackjack' then 'Player Blackjack'
      when dealer is 'blackjack' then 'Dealer Blackjack'
    
    @set 'gameState', state
