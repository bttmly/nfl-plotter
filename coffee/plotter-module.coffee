window.debugLog = true

window._log = () ->
  if debugLog? and debugLog and window.console
    console.log.apply console, arguments

window.Plotter =

  s : {}
    
  settings : ->
    els :
      html            : $("html")
      body            : $("body")
      renderButton    : $("#render-button")
      highlightButton : $("#highlight-button")
      allCheckLabels  : $(".check-label")
      allCheckInput   : $("input[type='checkbox']")
      seasonCheck     : $(".yr-input")
      positionCheck   : $(".pos-input")
      playerPosRadio  : $("input[name='pp-type']")
      playerPosGroups : $("[data-input-group]")
      gameSeasonRadio : $("input[name='stat-type']")
      clearPlayersBtn : $("#clear-player-select")
      chartWrapper    : $("#scatterplot-wrapper")
      origVarSelect   : $("select#original")
      varSelects      : $("select.variable")
      playerSelect    : $("#player-select")
      container       : $(".container")
      column          : $(".column")
      
      $log            : $("#hover-data")
      $allHoverSpans  : $(".hover-data span")
      $playerNameYr   : $("#player-name-year")
      $xVar           : $("#x-axis-data-name")
      $yVar           : $("#y-axis-data-name")
      $rVar           : $("#r-axis-data-name")
      $cVar           : $("#c-axis-data-name")
      $xVal           : $("#x-axis-data-value")
      $yVal           : $("#y-axis-data-value")
      $rVal           : $("#r-axis-data-value")
      $cVal           : $("#c-axis-data-value")
      
      selectedPlayersLi   : ->
        return $("#player_select_chzn li.search-choice")
      
      selectedPlayersSpan : -> 
        return $("#player_select_chzn li.search-choice span")

    vals:
      datasetURL   : "/data/dataset.08-12.json"
      namesURL     : "/data/names.08-12.json"
      
      chartPadding : 100
      chartHeight  : 0
      chartWidth   : 0
      
      selections : {}
      
      perGameMinGames : 4
      
      posColors :
        QB : "#3498db"
        RB : "#2ecc71"
        TE : "#f1c40f"
        WR : "#e67e22"

      statAbbr :
        PassComp  : "Pass Completions"
        PassAtt   : "Pass Attempts"
        PassYds   : "Pass Yards"
        PassTD    : "Pass Touchdowns"
        PassINT   : "Interceptions"
        RushAtt   : "Rushing Attempts"
        RushYds   : "Rushing Yards"
        RushTD    : "Rushing Touchdowns"
        RushYPA   : "Yards Per Rush"
        Recs      : "Receptions"
        RecYards  : "Receiving Yards"
        RecYPR    : "Yards Per Reception"
        RecTD     : "Receiving Touchdowns"
        ScrimYds  : "Total Scrimmage Yards"
        TotalTD   : "Total Touchdowns"
        FantPt    : "Fantasy Points"
        PosRank   : "Fantasy Position Rank"
        VBD       : "VBD Points"
        OvRank    : "Overall VBD Rank"
        Season    : "Season"
        Age       : "Age"
        G         : "Games Played"
        GS        : "Games Started"

      perGameStats : [
        'PassComp',
        'PassAtt',
        'PassYds',
        'PassTD',
        'PassINT',
        'RushAtt',
        'RushYds',
        'RushTD',
        'RecYards',
        'RecTD',
        'FantPt',
        'VBD', 
        'ScrimYds', 
        'TotalTD'
      ]
      
      teams : 
          ARI :
            name : "Cardinals"
            location : "Arizona"
          STL :
            name : "Rams"
            location : "St. Louis"
          SFO :
            name : "49ers"
            location : "San Francisco"
          SEA :
            name : "Seahawks"
            location : "Seattle"
          GNB :
            name : "Packers"
            location : "Green Bay"
          CHI :
            name : "Bears"
            location : "Chicago"
          DET :
            name : "Lions"
            location : "Detroit"
          MIN :
            name : "Vikings"
            location : "Minnesota"
          ATL :
            name : "Falcons"
            location : "Atlanta"
          NOR :
            name : "Saints"
            location : "New Orleans"
          TAM :
            name : "Buccaneers"
            location : "Tampa Bay"
          CAR :
            name : "Panthers"
            location : "Carolina"
          DAL :
            name : "Cowboys"
            location : "Dallas"
          NYG :
            name : "Giants"
            location : "New York"
          PHI :
            name : "Eagles"
            location : "Philadelphia"
          WAS :
            name : "Redskins"
            location : "Washington"
          SDG :
            name : "Chargers"
            location : "San Diego"
          OAK :
            name : "Raiders"
            location : "Oakland"
          KAN :
            name : "Chiefs"
            location : "Kansas City"
          DEN :
            name : "Broncos"
            location : "Denver"
          PIT :
            name : "Steelers"
            location : "Pittsburgh"
          BAL :
            name : "Ravens"
            location: "Baltimore"
          CIN :
            name : "Bengals"
            location: "Cincinnati"
          CLE :
            name : "Browns"
            location: "Cleveland"
          HOU :
            name : "Texans"
            location : "Houston"
          IND : 
            name : "Colts"
            location: "Indianapolis"
          JAX :
            name : "Jaguars"
            location : "Jacksonville"
          TEN :
            name : "Titans"
            location : "Tennessee"
          NWE :
            name : "Patriots"
            location : "New England"
          NYJ :
            name : "Jets"
            location : "New York"
          MIA :
            name : "Dolphins"
            location: "Miami"
          BUF :
            name : "Bills"
            location: "Buffalo"

    
  init: ->
    # initial settings that are ready to grab when the page loads
    @s = @settings()
    s = @s
    
    # AJAX and DOM manipulation that need to start when page is ready
    @pageSetup(s)
    
    @bindUIActions(s)
    
    #@addSettings(s)



  bindUIActions : (s) ->

    $.event.props.push( "dataTransfer" )

    $el = s.els
    plotter = @
    
    $el.playerPosRadio.bind "change", ->
      plotter.playerPosSwitch $(@).val()
    
    $el.renderButton.bind "click", ->
      plotter.renderChart(s)
      
    $el.highlightButton.bind "click", ->
      plotter.highlightModeSwitch()
    
    $el.clearPlayersBtn.bind "click", ->
      plotter.clearSelectedPlayers()
    
    $el.body.on "mouseenter", "#scatterplot-wrapper circle", ->
      plotter.circleCursorIn "##{this.id}"
    
    $el.body.on "mouseleave", "#scatterplot-wrapper circle", ->
      plotter.circleCursorOut()

    $el.body.on "dragstart", "#hover-data", (event) ->
      plotter.hoverLogDragStart(event, this)

    $el.body.on "dragover", (event) ->
      plotter.hoverLogDragOver(event, this)

    $el.body.on "drop", (event) ->
      plotter.hoverLogDrop(event, this)

    $el.body.on "click", "#show-me", (event) ->
      event.preventDefault()
      plotter.demoStart()


  pageSetup : (s) ->
    
    Plotter = this
    data    = Plotter.data
    
    @s.els.playerPosGroups.hide()
    
    $.getJSON Plotter.s.vals.datasetURL, (json) ->
        data.fullSet = json

    $.getJSON s.vals.namesURL, (json) ->
      html = ""
      for player in json
        html += "<option>#{player}</option>"
      s.els.playerSelect.append(html).chosen({width: "100%"})
    
    selectHTML = s.els.origVarSelect.html()
    
    s.els.varSelects.html(selectHTML).chosen({
      allow_single_deselect: true,
      width: "75%"
    })
    
  renderChart : (s) ->
    
    Plotter = this
    data    = Plotter.data
    
    @resetGraphingData(s)
    
    newSettings = @settings()
    
    @s.vals.selections = selected = @getSelected(s.els)
    
    if @validateSelections(selected)

      @data.graphingSet = @getGraphingData(selected, data.fullSet)
      
      scales = @calculateScales(selected, @data.graphingSet)
      
      @drawChart(@data.graphingSet, selected, scales)

  resetGraphingData : (s) ->
    @data.graphingSet = {}
    s.vals.selections = {}

  getSelected : (el) ->
    
    seasons : do ->
      for season in el.seasonCheck.filter(":checked")
        $(season).val()
        
    positions : do ->
      for position in el.positionCheck.filter(":checked")
        $(position).val()
        
    players : do ->
      for player in el.selectedPlayersSpan()
        $(player).val()
        
    variables : do ->
      values = {}
      for variable in el.varSelects
        values[$(variable).attr("data-axis")] = $(variable).find(":selected").attr("data-stat")
      return values
      
    sortType : do ->
      el.playerPosRadio.filter(":checked").val()
      
    statType : do -> 
      el.gameSeasonRadio.filter(":checked").val()


  validateSelections : (selections) ->
    
    # Need to add contextual help for users entering invalid selections
    
    validity = true
    missing = {}
    
    # Check if thre are seasons selected
    unless @s.els.seasonCheck.filter(":checked").length
      validity = false
    
    # Check if there is a player/position selection
    if @s.els.playerPosRadio.filter(":checked").length
      playerOrPosition = @s.els.playerPosRadio.filter(":checked").val()
      
      # Check if player option is selected but no individual players selected
      if playerOrPosition is "player" and not @s.els.selectedPlayersLi().length
        validity = false
      
      # Check if season option is selected but no positions selected  
      if playerOrPosition is "position" and not @s.els.positionCheck.filter(":checked").length
        validity = false
  
    else
      validity = false
    
    # Check if x and y variables have been selected
    unless @s.els.varSelects.filter("#x-select").find(":checked").val().length and @s.els.varSelects.filter("#y-select").find(":checked").val().length
        validity = false
    
    # Check if there is a game/season selection
    unless @s.els.gameSeasonRadio.filter(":checked").length
      validity = false
      
    ###
    
    for key, val of selections when key isnt "players" or "positions"
      _log "key:"
      _log key
      _log "val:"
      _log val
      _log "val.length:"
      _log val.length
      validity = false if not val.length
    
    if (selections.sortType is "players" and not selections.players.length) or (selections.sortType is "positions" and not selections.positions.length)
      validity = false
    
    ###
    
    _log "validity: #{validity}"
    
    return validity
    
  getGraphingData : (sel, data) ->
  
    _log "getGraphingData started..."
    _log "sel:"
    _log sel
    _log "data:"
    _log data
    
    dataPoints = []
    
    if sel.sortType is "positions"
      for season in sel.seasons
        for position in sel.positions
          for player in data[season][position]
            dataPoints.push(player)
            
    else if sel.sortType is "players"
      for season in sel.seasons
        for position in data[season]
          for name in sel.players
            match = data[season][position].filter (player) ->
              player.Name is name
            if match.length 
              dataPoints.push(match)
    
    if sel.statType is "game"
      dataPoints = @calculatePerGameData(dataPoints)
    
    return dataPoints
  
  calculatePerGameData : (data) ->
    
    for playerSeason in data
      
      # We're not going to graph this if the player-season doesn't meet the min games requirement
      if playerSeason.G < @s.vals.perGameMinGames
        playerSeason = {}
        # move on to the next player season
        continue
        
      # run through each variable we've picked
      for key, val of @s.vals.selections.variables
        # check if the variable is in the perGameStats array
        if val in @s.vals.perGameStats
          # divide value by games played
          playerSeason[val] = ( playerSeason[val] / playerSeason.G )
    
    return data




  calculateScales : (sel, data) ->
  
    _log "calculateScales started..."
    _log sel
    _log data
    
    scales = {}
    
    chartPadding = @s.vals.chartPadding
    chartWidth = @s.vals.chartWidth = @s.els.chartWrapper.width()
    chartHeight = @s.vals.chartHeight = chartWidth * 0.5
      
    scaleVals = 
      x :
        min : 1000000
        max : 0
      y :
        min: 1000000
        max: 0
      r :
        min: 1000000
        max: 0
      c : 
        min: 1000000
        max: 0        
  
    for datum in data
      v = sel.variables
      
      scaleVals.x.max = datum[v.xAxis] if datum[v.xAxis] > scaleVals.x.max
      scaleVals.x.min = datum[v.xAxis] if datum[v.xAxis] < scaleVals.x.min
      
      scaleVals.y.max = datum[v.yAxis] if datum[v.yAxis] > scaleVals.y.max
      scaleVals.y.min = datum[v.yAxis] if datum[v.yAxis] < scaleVals.y.min
      
      scaleVals.r.max = datum[v.rAxis] if datum[v.rAxis] > scaleVals.r.max
      scaleVals.r.min = datum[v.rAxis] if datum[v.rAxis] < scaleVals.r.min
      
      scaleVals.c.max = datum[v.cAxis] if datum[v.cAxis] > scaleVals.c.max
      scaleVals.c.min = datum[v.cAxis] if datum[v.cAxis] < scaleVals.c.min
    
    scales.x = d3.scale.linear()
      .domain( [ scaleVals.x.min, scaleVals.x.max ] )
      .range( [ chartPadding, chartWidth - chartPadding ] )
    
    scales.y = d3.scale.linear()
      .domain( [ scaleVals.y.max, scaleVals.y.min ] )
      .range( [ chartPadding, chartHeight - chartPadding ] )
    
    # [2, 10] are min, max for dot radius in pixels
    scales.r = d3.scale.linear()
      .domain( [ scaleVals.r.min, scaleVals.r.max ] )
      .range( [2, 10])
    
    # [-.15, .15] are min, max for color brightness coefficients
    scales.c = d3.scale.linear()
      .domain( [ scaleVals.c.min, scaleVals.c.max ] )
      .range( [-0.15, 0.15] )
    
    return scales
  
  drawChart : (dataset, selected, scales) ->

    chartHeight  = @s.vals.chartHeight
    chartWidth   = @s.vals.chartWidth
    chartPadding = @s.vals.chartPadding

    _log "drawChart started"
    _log dataset
    _log selected
    _log scales
    
    @s.els.chart?.remove()
    posColors = @s.vals.posColors
    
    x = selected.variables.xAxis
    y = selected.variables.yAxis
    c = selected.variables.cAxis
    r = selected.variables.rAxis
    
    scatterplot = d3.select('#scatterplot-wrapper')
      .append('svg')
      .attr('id', 'd3-scatterplot')
    
    # here's where the magic happens...
    
    scatterplotPoints = scatterplot.selectAll("circle")
      .data(dataset)
      .enter()
      .append("circle")
      .attr("cx", (d) ->
        scales.x(d[x])
      ).attr("cy", (d) ->
        scales.y(d[y])
      ).attr("r", (d) ->
        if scales.r and d[r]
          return scales.r(d[r])
        else
          # 4px is fallback radius is no r var is defined
          return 4
      ).attr("fill", (d) ->
        base = posColors[d.FantPos]
        if scales.c and d[c]
          if scales.c(d[c]) > 0
            return Color(base)
              .lightenByAmount( scales.c(d[c]) )
              .desaturateByAmount( scales.c(d[c]) )
              .toCSS() 
          else
            return Color(base)
              .darkenByAmount( 0 - scales.c(d[c]) )
              .saturateByAmount( 0 - scales.c(d[c]) )
              .toCSS() 
        else
          return base
      ).attr("id", (d) ->
        id = ""
        id += d.Name.split(" ").join("-") + "_"
        id += d.Season + "_"
        id += d.FantPos
        return id
        # id format "FirstName-LastName_Season_Position"
      )

    xAxis = d3.svg.axis()
      .scale(scales.x)
      .orient("bottom")
    
    yAxis = d3.svg.axis()
      .scale(scales.y)
      .orient("left")
    
    scatterplot.append("g")
      .attr("class", "axis")
      .attr("id", "xAxis")
      .attr("transform", "translate(0," + (chartHeight - chartPadding) + ")")
      .call(xAxis)
    
    scatterplot.append("text")
      .attr("class", "xAxis-label")
      .attr("transform", "translate(0," + (chartHeight - chartPadding) + ")")
      .text(x)
    
    scatterplot.append("g")
      .attr("class", "axis")
      .attr("id", "yAxis")
      .attr("transform", "translate(" + chartPadding + ",0)")
      .call(yAxis)
    
    scatterplot.append("text")
      .attr("class", "yAxis-label")
      .attr("transform", "translate(" + chartPadding + ",0) rotate(-90)")
      .text(y)
      
    
    
    @s.els.chart = @s.els.chartWrapper.find "svg"
    @s.els.dots = @s.els.chart.find "circle"
    
    # add custom attributes to circles. Useful for highlight mode later.
    for dot in @s.els.dots
      pieces = dot.id.split("_")
      $(dot).attr "data-player-name", pieces[0].split("-").join(" ") 
      $(dot).attr "data-player-season", pieces[1]
      $(dot).attr "data-player-position", pieces[2]
  
    # need to use DOM element to set case-sentitive attributes
    svgDomElement = @s.els.chartWrapper.find("svg")[0]
    svgDomElement.setAttribute('preserveAspectRatio', 'xMinYMin meet')
    svgDomElement.setAttribute("viewBox", "0 0 800 400")
  
  highlightModeSwitch : ->
    Plotter = this
    highlightModeUpdate = @highlightModeUpdate
    
    @s.els.html.toggleClass "plotter-highlight-mode"
  
    highlighted =
      positions: []
      players  : []
      seasons  : []
      
    if @s.els.html.is ".plotter-highlight-mode"
    
      _log 'highlightmodeswitch if' 
      
      @s.els.allCheckInput
        .prop("disabled", true)
      
      @s.els.allCheckLabels.bind "click.highlightMode", ->
        $(@).toggleClass "highlighted"
        hlStatus = $(@).is ".highlighted"
        inputElement = $ "##{$(@).attr('for')}" 

        Plotter.highlightModeUpdate inputElement, hlStatus, highlighted
    
    else
      
      _log 'highlightModeSwitch else' 
      
      @s.els.allCheckInput.prop("disabled", false)
      
      @s.els.allCheckLabels
        .removeClass("highlighted")
        .unbind("click.highlightMode")
        
      @s.els.dots.attr "class", "" 
      
      for key, value of highlighted
        value = []

  highlightModeUpdate : ($el, status, highlighted) ->
    
    value = $el.val()
    
    # status is the boolean returned from $(this).is(".highlighted") AFTER the class has been toggled on or off
    
    posChecked = ".pos-input:checked"
    seasonChecked = ".yr-input:checked"
    
    if status is on
      if $el.is posChecked
        highlighted.positions.push(value)
        
      else if $el.is seasonChecked
        highlighted.seasons.push(value)
      
    else if status is off
      if $el.is posChecked
        Plotter.utils.removeVals(highlighted.positions, value)
        
      else if $el.is seasonChecked
        Plotter.utils.removeVals(highlighted.seasons, value)
        
    
    # clear all highlightings
    Plotter.s.els.dots.attr "class", ""
    
    # if there are values in both so we only want to highlight data points that are intersections
    if highlighted.seasons.length and highlighted.positions.length
      for season in highlighted.seasons
        for position in highlighted.positions
          Plotter.s.els.dots
            .filter("[data-player-season='#{season}']")
            .filter("[data-player-position='#{position}']")
            .attr("class", "highlighted-dot")
            .each ->
              $(@).before $("#xAxis")

    # if we get here, there is/are value(s) in only one of these two arrays, so check each
    else
      if highlighted.seasons.length
        for season in highlighted.seasons
          Plotter.s.els.dots
            .filter("[data-player-season='#{season}']")
            .attr("class", "highlighted-dot")
            # probably ditch this next expression
            .each ->
              $(@).before $("#xAxis")

      else if highlighted.positions.length
        for position in highlighted.positions
          Plotter.s.els.dots
            .filter("[data-player-position='#{position}']")
            .attr("class", "highlighted-dot")
            # probably ditch this next expression
            .each ->
              $(@).before $("#xAxis")
  
  playerPosSwitch : (val) ->
    
    toShow = @s.els.playerPosGroups.filter("[data-input-group='#{val}']").show()
    toShow.siblings("[data-input-group]").hide()
    
    # toShow = @s.els.playerPosGroups.filter("[data-input-group='#{val}']")
    # toHide = toShow.siblings("[data-input-group]")
    
    # if toHide.is ":visible"
    #  toHide.fadeOut 600, ->
    #    toShow.fadeIn 600
    # else
    #   toShow.fadeIn 600
    
  circleCursorIn : (selector) ->
    _log selector
    _log d3.select(selector)
    props = d3.select(selector)[0][0].__data__
    v = @s.vals.selections.variables
    
    @s.els.$playerNameYr.html("#{props.Name} &mdash; #{props.Season} (#{props.FantPos}, #{props.Tm})")
    
    @s.els.$xVar.html " #{@s.vals.statAbbr[v.xAxis]} " 
    @s.els.$yVar.html " #{@s.vals.statAbbr[v.yAxis]} "
    @s.els.$rVar.html " #{@s.vals.statAbbr[v.rAxis]} "
    @s.els.$cVar.html " #{@s.vals.statAbbr[v.cAxis]} "
    
    @s.els.$xVal.html props[v.xAxis]
    @s.els.$yVal.html props[v.yAxis]
    @s.els.$rVal.html props[v.rAxis]
    @s.els.$cVal.html props[v.cAxis]
    
  circleCursorOut : ->
    @s.els.$allHoverSpans.html "&nbsp;"
  
  clearSelectedPlayers : ->
    @s.els.selectedPlayersLi().remove()
  
  # these three drag & drop functions appropriated from http://stackoverflow.com/a/6239882/2942909
  hoverLogDragStart : (event) ->
    console.log "drag start"
    event.dataTransfer.setData("text/plain",
    (parseInt( @s.els.$log.css( "left" ), 10) - event.originalEvent.clientX ) + ',' + (parseInt(@s.els.$log.css("top"),10) - event.originalEvent.clientY ) )

  hoverLogDragOver : (event) -> 
    console.log "drag over"
    event.preventDefault()
    return false

  hoverLogDrop : (event) -> 
    console.log (event.originalEvent.clientX + parseInt(offset[0],10)) + 'px'
    console.log (event.originalEvent.clientY + parseInt(offset[1],10)) + 'px'

    offset = event.dataTransfer.getData("text/plain").split(',')
    @s.els.$log.css("left", (event.originalEvent.clientX + parseInt(offset[0],10)) + 'px' )
    @s.els.$log.css("top", (event.originalEvent.clientY + parseInt(offset[1],10)) + 'px' )
    event.preventDefault()
    return false

  demoStart : ->

    els = this.s.els

    $("input:checked").prop("checked", false)

    totalTime = 0  
    allTimeouts = []
    sequencedTimeouts = (i, obj) ->
      delay = obj.delay or 1000
      totalTime += delay
      to = setTimeout ->
        obj.fn()
        return
      , totalTime
      allTimeouts.push(to)

    $.fn.extend
      fauxClick : ->
        fromTop = @.offset().top + 25
        fromLeft = @.offset().left + 25
        click = $( "<div class='faux-click'>" ).appendTo( $("body"))
        
        click.css
          top : fromTop
          left : fromLeft

        setTimeout ->
          click.remove()
          return
        , 2000

        return this

      typeOut : (str, callback) ->
        letters = str.split('')
        $this = $(this)

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
                $this.trigger("blur")
            , 75 * i
          unless cb
            cb = $.noop

        for letter, i in letters
          setDelay(i, letter, callback)

        return this

    actions = 
      1 : 
        delay : 400
        fn : ->
          els.body.animate
            scrollTop: $("#pp-controls").offset().top
      2 : 
        delay : 400
        fn : ->
          $( "#positions-label" ).trigger( "click" ).fauxClick()
      3 :
        delay : 400
        fn : ->
          $("[for='input-RB']").trigger( "click" ).fauxClick()
      4 :
        delay : 400
        fn : ->
          $("[for='input-WR']").trigger( "click" ).fauxClick()
      5 :
        delay : 400
        fn : ->
          $("[for='input-2012']").trigger( "click" ).fauxClick()
      6 :
        delay : 400
        fn : ->
          $("[for='input-2011']").trigger( "click" ).fauxClick()
      7 :
        delay : 400
        fn : ->
          $("[for='input-2010']").trigger( "click" ).fauxClick()
      8 :
        delay : 400
        fn : ->
          els.body.animate
            scrollTop : $(".control-row").eq(1).offset().top
      9 :
        delay : 1000
        fn : ->
          $("#x-select").trigger("liszt:open")
          $("#x_select_chzn").fauxClick()
      10 :
        delay : 1000
        fn : ->
          $("#x_select_chzn input").typeOut "fantasy position rank", ->
            $.noop
      11 :
        delay : 2000
        fn : ->
          $("#y-select").trigger("liszt:open")
          $("#y_select_chzn").fauxClick()
      12 :
        delay : 1000
        fn : ->
          $("#y_select_chzn input").typeOut "fantasy points", ->
            $.noop
      13 :
        delay : 2000
        fn : ->
          $("#r-select").trigger("liszt:open")
          $("#r_select_chzn").fauxClick()
      14 :
        delay : 1000
        fn : ->
          $("#r_select_chzn input").typeOut "total scrimmage yards", ->
            $.noop
      15 :
        delay : 2000
        fn : ->
          $("#c-select").trigger("liszt:open")
          $("#c_select_chzn").fauxClick()
      16 :
        delay : 1000
        fn : ->
          $("#c_select_chzn input").typeOut "total touchdowns", ->
            $.noop
      17 :
        delay : 2000
        fn : ->
          els.body.animate 
            scrollTop : $("#avg-total-pair-holder").prev("p").offset().top
      18 :
        delay : 1000
        fn : ->
          $("#season-label").trigger("click").fauxClick()
      19 :
        delay : 1000
        fn : ->
          els.body.animate
            scrollTop : $("#render-button").offset().top
      20 :
        delay : 2000
        fn : ->
          $("#render-button").fauxClick().trigger("click")

    i = 0
    for key, val of actions
      console.log key
      sequencedTimeouts(key, val)
      i++




  demoStop : ->
    console.log ("hi")

  data : {}
    
  utils :

    removeDupes : (arr) ->
      out = []
      obj = {}
      for v in arr
        obj[v] = 0
      for own key of obj
        out.push key
      return out
      
    removeVals : (arr, vals...) ->
      for val in vals
        if (spot = arr.indexOf(val)) isnt -1
          arr.splice(spot, 1)
      return arr
    
    # nthLast(arr, 0) returns last item
    nthLast : (arr, n) ->
      l = arr.length
      arr[l - (n + 1)]

window.Plotter.init()
