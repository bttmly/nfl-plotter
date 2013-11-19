window.debugLog = true

window._log = () ->
  if debugLog? and debugLog and window.console
    console.log.apply console, arguments

window.Plotter = do ($ = jQuery) ->

  settings = ->
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
      chart           : $("#d3-scatterplot")
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

    data :
      fullSet : {}
      graphingSet : {}

    vals:
      datasetURL   : "/data/dataset.08-12.json"
      namesURL     : "/data/names.08-12.json"
    
    storageKeys :
      current : "plotterDataTo2012"
      old     : []

      chartPadding : 120
      chartHeight  : 0
      chartWidth   : 0
      
      visibile : ":visible"
      checked : ":checked"

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

  s = settings()
    
  init = ->
    # initial settings that are ready to grab when the page loads
    # AJAX and DOM manipulation that need to start when page is ready
    pageSetup(s)
    
    bindUIActions(s)
    
    #@addSettings(s)



  bindUIActions = (s) ->
    
    $el = s.els
    
    $el.playerPosRadio.bind "change", ->
      playerPosSwitch $(@).val()
    
    $el.renderButton.bind "click", ->
      renderChart(s)
      
    $el.highlightButton.bind "click", ->
      highlightModeSwitch()
    
    $el.clearPlayersBtn.bind "click", ->
      clearSelectedPlayers()
    
    $el.body.on "mouseenter", "#scatterplot-wrapper circle", ->
      circleCursorIn "##{this.id}"
    
    $el.body.on "mouseleave", "#scatterplot-wrapper circle", ->
      circleCursorOut()

  pageSetup = (s) ->

    s.els.playerPosGroups.hide()
    
    if localStorage
      for key in s.storageKeys.old
        localStorage.removeItem( key )
      if localStorage[s.storageKeys.current]
        s.data.fullSet = JSON.parse( localStorage[s.storageKeys.current] )
    else
      $.getJSON s.vals.datasetURL, ( json ) ->
        s.data.fullSet = json
        if localStorage
          localStorage.setItem( s.storageKeys.current, JSON.stringify(json) )

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
    
  renderChart = (s) ->

    s.vals.selections = selected = getSelected(s.els)
    
    if validateSelections(selected)

      s.data.graphingSet = getGraphingData(selected, s.data.fullSet)
      
      scales = calculateScales(selected, s.data.graphingSet)
      
      drawChart(s.data.graphingSet, selected, scales)

  resetGraphingData = (s) ->
    s.data.graphingSet = {}
    s.vals.selections = {}

  getSelected = (el) ->
    
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


  validateSelections = (selections) ->
    
    # Need to add contextual help for users entering invalid selections
    
    validity = true
    missing = {}
    
    # Check if thre are seasons selected
    unless s.els.seasonCheck.filter(":checked").length
      validity = false
    
    # Check if there is a player/position selection
    if s.els.playerPosRadio.filter(":checked").length
      playerOrPosition = s.els.playerPosRadio.filter(":checked").val()
      
      # Check if player option is selected but no individual players selected
      if playerOrPosition is "player" and not s.els.selectedPlayersLi().length
        validity = false
      
      # Check if season option is selected but no positions selected  
      if playerOrPosition is "position" and not s.els.positionCheck.filter(":checked").length
        validity = false
  
    else
      validity = false
    
    # Check if x and y variables have been selected
    unless s.els.varSelects.filter("#x-select").find(":checked").val().length and s.els.varSelects.filter("#y-select").find(":checked").val().length
        validity = false
    
    # Check if there is a game/season selection
    unless s.els.gameSeasonRadio.filter(":checked").length
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
    
  getGraphingData = (sel, data) ->
  
    _log "getGraphingData started..."
    _log "sel:"
    _log sel
    _log "data:"
    _log data
    
    dataPoints = []
    
    if sel.sortType == "positions"
      for season in sel.seasons
        for position in sel.positions
          for player in data[season][position]
            dataPoints.push(player)
            
    else if sel.sortType == "players"
      for season in sel.seasons
        for position in data[season]
          for name in sel.players
            match = data[season][position].filter (player) ->
              player.Name == name
            if match.length 
              dataPoints.push(match)
    
    if sel.statType is "game"
      dataPoints = calculatePerGameData(dataPoints)
    
    return dataPoints
  
  calculatePerGameData = (data) ->
    
    for playerSeason in data
      
      # We're not going to graph this if the player-season doesn't meet the min games requirement
      if playerSeason.G < s.vals.perGameMinGames
        playerSeason = {}
        # move on to the next player season
        continue
        
      # run through each variable we've picked
      for key, val of s.vals.selections.variables
        # check if the variable is in the perGameStats array
        if val in s.vals.perGameStats
          # divide value by games played
          playerSeason[val] = ( playerSeason[val] / playerSeason.G )
    
    return data




  calculateScales = (sel, data) ->
  
    _log "calculateScales started..."
    _log sel
    _log data
    
    scales = {}
    
    chartPadding = s.vals.chartPadding
    chartWidth = s.vals.chartWidth = s.els.chartWrapper.width()
    chartHeight = s.vals.chartHeight = chartWidth * 0.5
      
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
  
  drawChart = (dataset, selected, scales) ->
    
    chartHeight  = s.vals.chartHeight
    chartWidth   = s.vals.chartWidth
    chartPadding = s.vals.chartPadding

    _log "drawChart started"
    _log dataset
    _log selected
    _log scales
    
    _log $("#scatterplot-wrapper svg")
    s.els.chart?.remove()
    _log $("#scatterplot-wrapper svg")
    
    posColors = s.vals.posColors
    
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
      
    
    s.els.chart = s.els.chartWrapper.find "svg"
    s.els.dots = s.els.chart.find "circle"
    
    # add custom attributes to circles. Useful for highlight mode later.
    for dot in s.els.dots
      pieces = dot.id.split("_")
      $(dot).attr "data-player-name", pieces[0].split("-").join(" ") 
      $(dot).attr "data-player-season", pieces[1]
      $(dot).attr "data-player-position", pieces[2]
  
    # need to use DOM element to set case-sentitive attributes
    svgDomElement = s.els.chartWrapper.find("svg")[0]
    svgDomElement.setAttribute('preserveAspectRatio', 'xMinYMin meet')
    svgDomElement.setAttribute("viewBox", "0 0 800 400")
  
  highlightModeSwitch = ->
    s.els.html.toggleClass "plotter-highlight-mode"
  
    highlighted =
      positions: []
      players  : []
      seasons  : []
      
    if s.els.html.is ".plotter-highlight-mode"
    
      _log 'highlightmodeswitch on' 
      
      s.els.allCheckInput.prop "disabled", true 
      
      s.els.allCheckLabels.bind "click.highlightMode", ->
        
        $(@).toggleClass "highlighted"
        hlStatus = $(@).is ".highlighted"
        inputElement = $ "##{$(@).attr('for')}" 

        highlightModeUpdate inputElement, hlStatus, highlighted
    
    else
      
      _log 'highlightModeSwitch off' 
      
      s.els.allCheckInput.prop "disabled", false
      
      s.els.allCheckLabels
        .removeClass("highlighted")
        .unbind("click.highlightMode")
        
      s.els.dots.attr "class", "" 
      
      for key, value of highlighted
        value = []

  
  
  highlightModeUpdate = ($el, status, highlighted) ->
    
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
        utils.removeVals(highlighted.positions, value)
        
      else if $el.is seasonChecked
        utils.removeVals(highlighted.seasons, value)
        
    
    # clear all highlightings
    s.els.dots.attr "class", ""
    
    # if there are values in both so we only want to highlight data points that are intersections
    if highlighted.seasons.length and highlighted.positions.length
      for season in highlighted.seasons
        for position in highlighted.positions
          s.els.dots
            .filter("[data-player-season='#{season}']")
            .filter("[data-player-position='#{position}']")
            .attr("class", "highlighted-dot")
            .each ->
              $(@).before $("#xAxis")

    # if we get here, there is/are value(s) in only one of these two arrays, so check each
    else
      if highlighted.seasons.length
        for season in highlighted.seasons
          s.els.dots
            .filter("[data-player-season='#{season}']")
            .attr("class", "highlighted-dot")
            # probably ditch this next expression
            .each ->
              $(@).before $("#xAxis")

      else if highlighted.positions.length
        for position in highlighted.positions
          s.els.dots
            .filter("[data-player-position='#{position}']")
            .attr("class", "highlighted-dot")
            # probably ditch this next expression
            .each ->
              $(@).before $("#xAxis")
  
  playerPosSwitch = (val) ->
    
    toShow = s.els.playerPosGroups.filter("[data-input-group='#{val}']").show()
    toShow.siblings("[data-input-group]").hide()
    
    # toShow = @s.els.playerPosGroups.filter("[data-input-group='#{val}']")
    # toHide = toShow.siblings("[data-input-group]")
    
    # if toHide.is ":visible"
    #  toHide.fadeOut 600, ->
    #    toShow.fadeIn 600
    # else
    #   toShow.fadeIn 600
    
  circleCursorIn = (selector) ->
    _log selector
    _log d3.select(selector)
    props = d3.select(selector)[0][0].__data__
    v = s.vals.selections.variables
    
    s.els.$playerNameYr.html("#{props.Name} – #{props.Season} (#{props.FantPos}, #{props.Tm})")
    
    s.els.$xVar.html " #{v.xAxis} " 
    s.els.$yVar.html " #{v.yAxis} "
    s.els.$rVar.html " #{v.rAxis} "
    s.els.$cVar.html " #{v.cAxis} "
    
    s.els.$xVal.html props[v.xAxis]
    s.els.$yVal.html props[v.yAxis]
    s.els.$rVal.html props[v.rAxis]
    s.els.$cVal.html props[v.cAxis]
    
  circleCursorOut = ->
    s.els.$allHoverSpans.html "&nbsp;"
  
  clearSelectedPlayers = ->
    s.els.selectedPlayersLi().remove()
    
  utils =
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

  init : init
  utils : utils

window.Plotter.init()