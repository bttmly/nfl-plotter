###
TO DO

- Log circle data on hover
  - Click & compare two values?

- Per game rate stats

- Set chart dimensions on each render

- Errors should appear next to the appropriate sections, not in a log box.

- LocalStorage

###

window.scatterplotter = plottr = {}

scales = {}
scaleVals = {}

$html = $('html')

statAbbr =
  PassComp :  "Pass Completions"
  PassAtt :   "Pass Attempts"
  PassYds :   "Pass Yards"
  PassTD :    "Pass Touchdowns"
  PassINT :   "Interceptions"
  RushAtt :   "Rushing Attempts"
  RushYds :   "Rushing Yards"
  RushTD :    "Rushing Touchdowns"
  RushYPA :   "Yards Per Rush"
  Recs :      "Receptions"
  RecYards :  "Receiving Yards"
  RecYPR :    "Yards Per Reception"
  RecTD :     "Receiving Touchdowns"
  ScrimYds :  "Total Scrimmage Yards"
  TotalTD :   "Total Touchdowns"
  FantPt :    "Fantasy Points"
  PosRank :   "Fantasy Position Rank"
  VBD :       "VBD Points"
  OvRank :    "Overall VBD Rank"
  Season :    "Season"
  Age :       "Age"
  G :         "Games Played"
  GS :        "Games Started"

perGameStats = ['PassComp','PassAtt','PassYds','PassTD','PassINT','RushAtt','RushYds','RushTD','RecYards','RecTD','FantPt','VBD', 'ScrimYds', 'TotalTD']

posColors =
  QB : "#3498db"
  RB : "#1abc9c"
  TE : "#f1c40f"
  WR : "#e67e22"
  
datasetURL = "/data/dataset.08-12.json"
namesURL = "/data/names.08-12.json"

selected = {}
fullDataset = {}


$.getJSON datasetURL, (json) ->
  fullDataset = json
  window.fantasyData = json
  return
  
$.getJSON namesURL, (json) ->
  
  html = ""
  for player in json
    html += "<option>#{player}</option>"
  
  # this selector should match the select element with player names.
  $("#player-select").append(html).chosen({width: "100%"})
  return
  
chartWidth = $('.column').width()
chartHeight = chartWidth * 0.5
chartPadding = 100

selectHTML = $('select#original').html()

$('select.variable').html(selectHTML).chosen({allow_single_deselect: true, width: "75%"})

$("#render-button").click ->
  unless $html.is(".plotter-highlight-mode")
    render()

$("#highlight-button").click ->
  if $("#scatterplot-wrapper").has("svg")
    $html.toggleClass "plotter-highlight-mode"
    highlightModeSwitch()

$ppInputs = $("input[name='pp-type']")
  
$("[data-input-group='players'], [data-input-group='positions']").hide()

$ppInputs.change ->
  playerPosSwitch $(this).val()

render = ->

  # gather selections into the "selected" object
  selected =
    seasons :   getSelected.seasons()
    positions : getSelected.positions()
    players :   getSelected.players()
    variables : getSelected.variables()
    sortType :  getSelected.sortType()
    stat :      getSelected.stat()
  
  plottr.vars = selected.variables
  
  if validateInput(selected)
    
    ###
    ###
    console.log "validateInput satified..."
    
    graphingData =  getGraphingData(selected, fullDataset)
    scales =        calculateScales(selected, graphingData)
    drawChart(graphingData, selected, scales)
  
  return
  
  # object of functions to gather input selections.
getSelected =
  seasons : ->
    for season in $('.yr-input:checked')
      $(season).val()
  positions : () ->
    for position in $('.pos-input:checked')
      $(position).val()
  players : ->
    for player in $(".search-choice span")
      $(player).html()
  variables : ->
    values = {}
    for variable in $("select.variable")
      values[$(variable).attr("data-axis")] = $(variable).find(":selected").attr("data-stat")
    values
  sortType : ->
    $("#pos-player-pair-holder input:checked").val()
  stat : () -> 
   $("#avg-total-pair-holder input:checked").val()
    
validateInput = (input) ->
  
  ###
  ###
  console.log "validateInput started..."
  console.log input
  
  #remove previous error entries
  $('.errors > :not(.error-close)').remove()
  
  html = ""
  
  if !input.sortType
    html += "<p>No sort type (players/positions) selected.</p>" # add this HTML if input.sort is missing
  else
    if input.sortType == "players" and !input.players.length 
      html += "<p>No players selected.</p>"
    else if input.sortType == "positions" and !input.positions.length
      html += "<p>No positions selected.</p>"
  if !input.seasons.length
    html += "<p>No seasons selected.</p>" # add this HTML if input.seasons is empty 
  if !input.stat
    html += "<p>No stat type (game/season) selected</p>" # add this HTML if input.stat is missing
  if !input.variables.xAxis
    html += "<p>No x-axis variable selected.</p>" # add this HTML if x-axis variable is missing
  if !input.variables.yAxis
    html += "<p>No y-axis variable selected.</p>" # add this HTML is y-axis variable is missing
    
  if html.length
    $(".errors").append("<h4>Uh oh, something went wrong</h4>" + html).slideDown() 
    
    
    ###
    ###
    console.log "validateInput() returning false"
    console.log html
    
    return false # input is not validated if html.length != 0
    
  else
    $(".errors").slideUp()
    
    ###
    ###
    console.log "validateInput() returning true"
    
    return true # input is validated if html is empty
    
getGraphingData = (sel, data) ->
  
  ###
  ###
  console.log "getGraphingData started..."
  console.log "sel:"
  console.log sel
  console.log "data:"
  console.log data
  
  dataPoints = []
  
  # Holy crap this is easy in CoffeeScript
  
  if sel.sortType == "positions"
    for season in sel.seasons
      for position in sel.positions
        for player in fullDataset[season][position]
          dataPoints.push(player)
          
  else if sel.sortType == "players"
    for season in sel.seasons
      for position in fullDataset[season]
        for name in sel.players
          console.log name
          match = fullDataset[season][position].filter (player) ->
            player.Name == name
          if match.length then dataPoints.push(match)
  
  return dataPoints

calculateScales = (sel, data) ->
  
  ###
  ###
  console.log "calculateScales started..."
  console.log sel
  console.log data
  
  scales = {}
  
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
  
  scales.r = d3.scale.linear()
    .domain( [ scaleVals.r.min, scaleVals.r.max ] )
    .range( [2, 10])
    
  scales.c = d3.scale.linear()
    .domain( [ scaleVals.c.min, scaleVals.c.max ] )
    .range( [-0.10, 0.10] )
  
  return scales
  
drawChart = (dataset, selected, scales) ->
  
  ###
  ###
  console.log "drawChart started"
  console.log dataset
  console.log selected
  console.log scales
  
  $("#scatterplot-wrapper svg").remove()
  
  x = selected.variables.xAxis
  y = selected.variables.yAxis
  c = selected.variables.cAxis
  r = selected.variables.rAxis
  
  scatterplot = d3.select('#scatterplot-wrapper')
    .append('svg')
    # .attr('width', chartWidth)
    # .attr('height', chartHeight)
    .attr('id', 'the-scatterplot')
  
  # here's where the magic happens...
  
  scatterplotPoints = scatterplot.selectAll("circle")
    .data(dataset) # do the following for every entry in the dataset
    .enter() # entry element placeholder for the incoming circle
    .append("circle") # add the circle
    # d in the anonymous function is the current datum as we progress through the dataset
    # in this case it's an object that represents a single player-season
    .attr("cx", (d) ->
      scales.x(d[x]) # apply the x scale to d[x] (which is the same as d[selected.variables.xAxis]) and return the value. 
    ).attr("cy", (d) ->
      scales.y(d[y]) # ditto above but with the y scale and d[y] 
    ).attr("r", (d) ->
      if scales.r and d[r] # this should fail if no radius variable was selected
        return scales.r(d[r])
      else
        return 4 # default radius for scatterplot points if a radius variable wasn't selected
    ).attr("fill", (d) ->
      base = posColors[d.FantPos] # get the appropriate base color from the posColors object
      if scales.c and d[c] # this should fail if no color variable was selected
        if scales.c(d[c]) > 0 # if this condition is satisfied we need to lighten the color
          return Color(base)
            .lightenByAmount( scales.c(d[c]) )
            .desaturateByAmount( scales.c(d[c]) )
            .toCSS() 
        else # otherwise, we need to darken it
          return Color(base)
            .darkenByAmount( 0 - scales.c(d[c]) )
            .saturateByAmount( 0 - scales.c(d[c]) )
            .toCSS() 
      else
        return base # if no color variable was selected, return the position's base color
    ).attr("id", (d) ->
      id = ""
      id += d.Name.split(" ").join("-") + "_"
      id += d.Season + "_"
      id += d.FantPos
      # id format "FirstName-LastName_Season_Position"
      return id
    )
  
  # define x-axis
  xAxis = d3.svg.axis()
    .scale(scales.x)
    .orient("bottom")
  
  # define y-axis
  yAxis = d3.svg.axis()
    .scale(scales.y)
    .orient("left")
  
  # draw x-axis
  scatterplot.append("g")
    .attr("class", "axis")
    .attr("id", "xAxis")
    .attr("transform", "translate(0," + (chartHeight - chartPadding) + ")")
    .call(xAxis)
  
  # draw y-axis
  scatterplot.append("g")
    .attr("class", "axis")
    .attr("id", "yAxis")
    .attr("transform", "translate(" + chartPadding + ",0)")
    .call(yAxis)
  
  # add custom attributes to circles. Useful for highlight mode later.
  for dot in $("svg circle")
    pieces = dot.id.split("_")
    $(dot).attr( "data-player-name", pieces[0].split("-").join(" ") )
    $(dot).attr( "data-player-season", pieces[1] )
    $(dot).attr( "data-player-position", pieces[2] )

  plottr.svgDomElement = $("#scatterplot-wrapper").find("svg")[0]
  plottr.svgDomElement.setAttribute('preserveAspectRatio', 'xMinYMin meet')
  plottr.svgDomElement.setAttribute("viewBox", "0 0 800 400")


removeValues = (array, values...) ->
  for value in values
    if (spot = array.indexOf(value)) isnt -1
      array.splice(spot, 1)
  return array  

highlightModeUpdate = ($el, status, highlighted) ->
  value = $el.val()
  
  # status is the boolean returned from $(this).is(".highlighted") AFTER the class has been toggled on or off
  
  if status is on
    if $el.is ".pos-input:checked"
      highlighted.positions.push(value)
      
    else if $el.is ".yr-input:checked"
      highlighted.seasons.push(value)
    
  else if status is off
    if $el.is ".pos-input:checked"
      removeValues(highlighted.positions, value)
      
    else if $el.is ".yr-input:checked"
      removeValues(highlighted.seasons, value)
      
  
  # clear all highlight-ings
  $("circle").attr "class", ""
  
  # if there are values in both so we only want to highlight data-points that are intersections
  if highlighted.seasons.length and highlighted.positions.length
    for season in highlighted.seasons
      for position in highlighted.positions
        $("circle[data-player-season='#{season}']").filter("[data-player-position='#{position}']").attr("class", "highlighted-dot").each ->
          $(this).before $("#xAxis")
  
  # if we get here, there is/are value(s) in only one of these two arrays, so check each
  else
    if highlighted.seasons.length
      for season in highlighted.seasons
        $("circle[data-player-season='#{season}']").attr("class", "highlighted-dot").each ->
          $(this).before $("#xAxis")
        
    else if highlighted.positions.length
      for position in highlighted.positions
        $("circle[data-player-position='#{position}']").attr("class", "highlighted-dot").each ->
          $(this).before $("#xAxis")
  
highlightModeSwitch = ->
  highlighted =
    positions: []
    players  : []
    seasons  : []
    
  if $html.is ".plotter-highlight-mode"
    console.log('highlightmodeswitch if')
    $("input[type='checkbox']").prop("disabled", true)
    $(".check-label").bind "click.highlightMode", ->
      $(this).toggleClass "highlighted"
      # grab the element that the label is for, since we're going to use it's value property
      $inputElement = $("#" + $(this).attr("for"))
      highlightModeUpdate $inputElement, $(this).is(".highlighted"), highlighted
  
  else
    console.log('highlightModeSwitch else')
    $("input[type='checkbox']").prop "disabled", false
    $(".check-label").removeClass "highlighted"
    $(".check-label").unbind "click.highlightMode"
    $("circle").attr "class", "" 
    for key, value of highlighted
      value = []
      
    return
  
playerPosSwitch = (val) ->
  $toShow = $("[data-input-group='#{val}']").eq(0)
  $toHide = $toShow.siblings("[data-input-group]").eq(0)
  
  if $toHide.is ":visible"
    $toHide.fadeOut 250, ->
      $toShow.fadeIn 250
      return
    return
  else
    $toShow.fadeIn 250
    return

$hoverSpans = $(".hover-data span")

$player = $("#player-name-year")

$xVar = $("#x-axis-data-name")
$yVar = $("#y-axis-data-name")
$rVar = $("#r-axis-data-name")
$cVar = $("#c-axis-data-name")

$xVal = $("#x-axis-data-value")
$yVal = $("#y-axis-data-value")
$rVal = $("#r-axis-data-value")
$cVal = $("#c-axis-data-value")


$("body").on "mouseenter", "#scatterplot-wrapper circle", ->
  circleCursorIn("#" + this.id)

$("body").on "mouseleave", "#scatterplot-wrapper circle", ->
  circleCursorOut()

circleCursorIn = (selector) ->
  props = d3.select(selector)[0][0].__data__
  v = plottr.vars
  
  $player.html("#{props.Name} – #{props.Season} (#{props.FantPos}, #{props.Tm})")
  
  $xVar.html(" #{v.xAxis} ")
  $yVar.html(" #{v.yAxis} ")
  $rVar.html(" #{v.rAxis} ")
  $cVar.html(" #{v.cAxis} ")
  
  $xVal.html(props[v.xAxis])
  $yVal.html(props[v.yAxis])
  $rVal.html(props[v.rAxis])
  $cVal.html(props[v.cAxis])
  
circleCursorOut = ->
  $hoverSpans.html("&nbsp;")
  
  
###
charter.xName.html(charter.selections.selectedVariables.xAxis)
    charter.yName.html(charter.selections.selectedVariables.yAxis)
    charter.rName.html(charter.selections.selectedVariables.rAxis)
    charter.cName.html(charter.selections.selectedVariables.cAxis)
    
    $('#the-scatterplot circle').mouseenter(function(e) {
        var d = charter.theChart.select('#' + this.id);
        
        var id = this.id.split("_");
        
        charter.nameSeason.html(id[0].split("-").join(" ") + " â€“ " + id[1] + " â€“ " + id[2]);
        charter.xVal.html(d[0][0].__data__[0]);
        charter.yVal.html(d[0][0].__data__[1]);
        charter.rVal.html(d[0][0].__data__[2]);
        charter.cVal.html(d[0][0].__data__[3]);
    });
###
