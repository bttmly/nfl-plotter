$.fn.extend
  demoClick : ( options ) ->

    defaults =
      duration : 2000
      className : "demo-click"
      top : 25
      left : 25
      triggerClick : true

    settings = $.extend( true, {}, defaults, options or {} )

    if settings.triggerClick then $(this).click()

    click = $( "<div class='#{settings.class}'>" ).appendTo( $("body") ).css
      top : this.offset().top + settings.top
      left : this.offset().left + settings.left

    setTimeout ->
      click.remove()
      return
    , settings.duration

    return this

  typeOut : (str, callback) ->
    letters = str.split( '' )
    $this = $( this )

    setDelay = (i, letter, cb) ->
      do ->
        setTimeout ->
          evtDown = jQuery.Event 'keydown', { which: letter.charCodeAt(0) }
          evtUp = jQuery.Event 'keyup', { which: letter.charCodeAt(0) }
          $this.trigger(evtDown)
          $this.val( $this.val() + letter )
          $this.trigger(evtUp)

          if cb
            cb(i, letter)

          if i is letters.length - 1
            enter = jQuery.Event 'keyup', { which: 13 }
            $this.trigger(enter)
            # $this.trigger("blur")
        , 75 * i

    unless callback
      callback = $.noop

    for letter, i in letters
      setDelay(i, letter, callback)

    return this

###
  * debouncedresize: special jQuery event that happens once after a window resize
  *
  * latest version and complete README available on Github:
  * https://github.com/louisremi/jquery-smartresize
  *
  * Copyright 2012 @louis_remi
  * Licensed under the MIT license.
  *
  * This saved you an hour of work? 
  * Send me music http://www.amazon.co.uk/wishlist/HNTU0468LQON
  * ........
  * (rewritten in coffeescript)
###
do ( $ = jQuery ) ->
  $event = $.event
  $special = undefined
  resizeTimeout = undefined

  $special = $event.special.debouncedresize =
    setup : ->
      $( this ).on "resize", $special.handler
    teardown : ->
      $( this ).off "resize", $special.handler
    handler : ( event, execAsap ) ->
      context = this
      args = arguments
      dispatch = ->
        event.type = "debouncedresize"
        $event.dispatch.apply context, args
      if resizeTimeout then clearTimeout resizeTimeout
      if execAsap then dispatch() else resizeTimeout = setTimeout dispatch, $special.threshold
    threshold : 150
