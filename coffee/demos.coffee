demos = []

demos.push [
    delay : 750
    fn : ->
      els.body.animate
        scrollTop: $("#pp-controls").offset().top
  ,
    delay : 750
    fn : ->
      $( "#positions-label" ).fauxClick()
  ,
    delay : 750
    fn : ->
      $("[for='input-QB']").fauxClick()
  ,
    delay : 750
    fn : ->
      $("[for='input-2012']").fauxClick()
  ,
    delay : 750
    fn : ->
      $("[for='input-2011']").fauxClick()
  ,
    delay : 750
    fn : ->
      $("[for='input-2010']").fauxClick()
  ,
    delay : 750
    fn : ->
      $("[for='input-2009']").fauxClick()
  ,
    delay : 750
    fn : ->
      $("[for='input-2008']").fauxClick()
  ,
    delay : 750
    fn : ->
      els.body.animate
        scrollTop : $(".control-row").eq(1).offset().top
  ,
    delay : 1000
    fn : ->
      $("#x-select").trigger("liszt:open")
      $("#x_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#x_select_chzn input").typeOut "fantasy position rank", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#y-select").trigger("liszt:open")
      $("#y_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#y_select_chzn input").typeOut "fantasy points", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#r-select").trigger("liszt:open")
      $("#r_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#r_select_chzn input").typeOut "pass yards", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#c-select").trigger("liszt:open")
      $("#c_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#c_select_chzn input").typeOut "season", ->
        $.noop
  ,
    delay : 1500
    fn : ->
      els.body.animate 
        scrollTop : $("#avg-total-pair-holder").prev("p").offset().top
  ,
    delay : 750
    fn : ->
      $("#season-label").fauxClick()
  ,
    delay : 750
    fn : ->
      els.body.animate
        scrollTop : $("#render-button").offset().top
  ,
    delay : 750
    fn : ->
      $("#render-button").fauxClick()
  ,
    delay : 500
    fn : ->
      els.body.animate
        scrollTop : $("#d3-scatterplot").offset().top
]

demos.push [
    delay : 750
    fn : ->
      els.body.animate
        scrollTop: $("#pp-controls").offset().top
  ,
    delay : 750
    fn : ->
      $( "#positions-label" ).fauxClick()
  ,
    delay : 750
    fn : ->
      $("[for='input-RB']").fauxClick()
  ,
    delay : 750
    fn : ->
      $("[for='input-WR']").fauxClick()
  ,
    delay : 750
    fn : ->
      $("[for='input-2012']").fauxClick()
  ,
    delay : 750
    fn : ->
      $("[for='input-2011']").fauxClick()
  ,
    delay : 750
    fn : ->
      $("[for='input-2010']").fauxClick()
  ,
    delay : 750
    fn : ->
      els.body.animate
        scrollTop : $(".control-row").eq(1).offset().top
  ,
    delay : 1000
    fn : ->
      $("#x-select").trigger("liszt:open")
      $("#x_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#x_select_chzn input").typeOut "fantasy position rank", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#y-select").trigger("liszt:open")
      $("#y_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#y_select_chzn input").typeOut "fantasy points", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#r-select").trigger("liszt:open")
      $("#r_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#r_select_chzn input").typeOut "total scrimmage yards", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#c-select").trigger("liszt:open")
      $("#c_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#c_select_chzn input").typeOut "total touchdowns", ->
        $.noop
  ,
    delay : 1500
    fn : ->
      els.body.animate 
        scrollTop : $("#avg-total-pair-holder").prev("p").offset().top
  ,
    delay : 750
    fn : ->
      $("#season-label").fauxClick()
  ,
    delay : 750
    fn : ->
      els.body.animate
        scrollTop : $("#render-button").offset().top
  ,
    delay : 750
    fn : ->
      $("#render-button").fauxClick()
  ,
    delay : 500
    fn : ->
      els.body.animate
        scrollTop : $("#d3-scatterplot").offset().top
]

demos.push [
    delay : 750
    fn : ->
      els.body.animate
        scrollTop: $("#pp-controls").offset().top
  ,
    delay : 2000
    fn : ->
      $("#player-select").trigger("liszt:open")
      $("#player_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#player_select_chzn input").typeOut "Calvin Johnson", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#player_select_chzn input").typeOut "Julio Jones", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#player_select_chzn input").typeOut "a.j. green", ->
        $.noop
  ,
    delay : 500
    fn : ->
      $("#player_select_chzn input").typeOut "Brandon Marshall", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#player_select_chzn input").typeOut "Mike Wallace", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#player_select_chzn input").typeOut "Jordy Nelson", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#player_select_chzn input").typeOut "Dez Bryant", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#player_select_chzn input").typeOut "Victor Cruz", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      scrollTop : $(".control-row").eq(1).offset().top
  ,
    delay : 2000
    fn : ->
      $("#x-select").trigger("liszt:open")
      $("#x_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#x_select_chzn input").typeOut "receiving yards", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#y-select").trigger("liszt:open")
      $("#y_select_chzn").fauxClick()
  ,
    fn : ->
      $("#y_select_chzn input").typeOut "receiving touchdowns", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#r-select").trigger("liszt:open")
      $("#r_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#r_select_chzn input").typeOut "receptions", ->
        $.noop
  ,
    delay : 2000
    fn : ->
      $("#c-select").trigger("liszt:open")
      $("#c_select_chzn").fauxClick()
  ,
    delay : 500
    fn : ->
      $("#c_select_chzn input").typeOut "season", ->
        $.noop
  ,
      delay : 1500
    fn : ->
      els.body.animate 
        scrollTop : $("#avg-total-pair-holder").prev("p").offset().top
  ,
    delay : 750
    fn : ->
      $("#season-label").fauxClick()
  ,
    delay : 750
    fn : ->
      els.body.animate
        scrollTop : $("#render-button").offset().top
  ,
    delay : 750
    fn : ->
      $("#render-button").fauxClick()
  ,
    delay : 500
    fn : ->
      els.body.animate
        scrollTop : $("#d3-scatterplot").offset().top
]