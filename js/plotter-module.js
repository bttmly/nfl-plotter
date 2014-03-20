// Generated by CoffeeScript 1.7.1
var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
  __hasProp = {}.hasOwnProperty,
  __slice = [].slice;

window.debugLog = true;

window._log = function() {
  if ((typeof debugLog !== "undefined" && debugLog !== null) && debugLog && window.console) {
    return console.log.apply(console, arguments);
  }
};

window.Plotter = {
  s: {},
  settings: function() {
    return {
      els: {
        window: $(window),
        html: $("html"),
        body: $("body"),
        controls: $("#controls"),
        renderButton: $("#render-button"),
        highlightButton: $("#highlight-button"),
        allCheckLabels: $(".check-label"),
        allCheckInput: $("input[type='checkbox']"),
        seasonCheck: $(".yr-input"),
        positionCheck: $(".pos-input"),
        playerPosRadio: $("input[name='pp-type']"),
        playerPosGroups: $("[data-input-group]"),
        gameSeasonRadio: $("input[name='stat-type']"),
        clearPlayersBtn: $("#clear-player-select"),
        chartWrapper: $("#scatterplot-wrapper"),
        origVarSelect: $("select#original"),
        varSelects: $("select.variable"),
        playerSelect: $("#player-select"),
        container: $(".container"),
        column: $(".column"),
        $log: $("#hover-data"),
        $allHoverSpans: $(".hover-data span"),
        $playerNameYr: $("#player-name-year"),
        $xVar: $("#x-axis-data-name"),
        $yVar: $("#y-axis-data-name"),
        $rVar: $("#r-axis-data-name"),
        $cVar: $("#c-axis-data-name"),
        $xVal: $("#x-axis-data-value"),
        $yVal: $("#y-axis-data-value"),
        $rVal: $("#r-axis-data-value"),
        $cVal: $("#c-axis-data-value"),
        selectedPlayersLi: function() {
          return $("#player_select_chzn li.search-choice");
        },
        selectedPlayersSpan: function() {
          return $("#player_select_chzn li.search-choice span");
        }
      },
      vals: {
        datasetURL: "/data/dataset.08-12.json",
        namesURL: "/data/names.08-12.json",
        chartPadding: 60,
        chartHeight: 450,
        chartWidth: 900,
        selections: {},
        perGameMinGames: 4,
        posColors: {
          QB: "#3498db",
          RB: "#2ecc71",
          TE: "#f1c40f",
          WR: "#e67e22"
        },
        statAbbr: {
          PassComp: "Pass Completions",
          PassAtt: "Pass Attempts",
          PassYds: "Pass Yards",
          PassTD: "Pass Touchdowns",
          PassINT: "Interceptions",
          RushAtt: "Rushing Attempts",
          RushYds: "Rushing Yards",
          RushTD: "Rushing Touchdowns",
          RushYPA: "Yards Per Rush",
          Recs: "Receptions",
          RecYards: "Receiving Yards",
          RecYPR: "Yards Per Reception",
          RecTD: "Receiving Touchdowns",
          ScrimYds: "Total Scrimmage Yards",
          TotalTD: "Total Touchdowns",
          FantPt: "Fantasy Points",
          PosRank: "Fantasy Position Rank",
          VBD: "VBD Points",
          OvRank: "Overall VBD Rank",
          Season: "Season",
          Age: "Age",
          G: "Games Played",
          GS: "Games Started"
        },
        perGameStats: ['PassComp', 'PassAtt', 'PassYds', 'PassTD', 'PassINT', 'RushAtt', 'RushYds', 'RushTD', 'RecYards', 'RecTD', 'FantPt', 'VBD', 'ScrimYds', 'TotalTD'],
        teams: {
          ARI: {
            name: "Cardinals",
            location: "Arizona"
          },
          STL: {
            name: "Rams",
            location: "St. Louis"
          },
          SFO: {
            name: "49ers",
            location: "San Francisco"
          },
          SEA: {
            name: "Seahawks",
            location: "Seattle"
          },
          GNB: {
            name: "Packers",
            location: "Green Bay"
          },
          CHI: {
            name: "Bears",
            location: "Chicago"
          },
          DET: {
            name: "Lions",
            location: "Detroit"
          },
          MIN: {
            name: "Vikings",
            location: "Minnesota"
          },
          ATL: {
            name: "Falcons",
            location: "Atlanta"
          },
          NOR: {
            name: "Saints",
            location: "New Orleans"
          },
          TAM: {
            name: "Buccaneers",
            location: "Tampa Bay"
          },
          CAR: {
            name: "Panthers",
            location: "Carolina"
          },
          DAL: {
            name: "Cowboys",
            location: "Dallas"
          },
          NYG: {
            name: "Giants",
            location: "New York"
          },
          PHI: {
            name: "Eagles",
            location: "Philadelphia"
          },
          WAS: {
            name: "Redskins",
            location: "Washington"
          },
          SDG: {
            name: "Chargers",
            location: "San Diego"
          },
          OAK: {
            name: "Raiders",
            location: "Oakland"
          },
          KAN: {
            name: "Chiefs",
            location: "Kansas City"
          },
          DEN: {
            name: "Broncos",
            location: "Denver"
          },
          PIT: {
            name: "Steelers",
            location: "Pittsburgh"
          },
          BAL: {
            name: "Ravens",
            location: "Baltimore"
          },
          CIN: {
            name: "Bengals",
            location: "Cincinnati"
          },
          CLE: {
            name: "Browns",
            location: "Cleveland"
          },
          HOU: {
            name: "Texans",
            location: "Houston"
          },
          IND: {
            name: "Colts",
            location: "Indianapolis"
          },
          JAX: {
            name: "Jaguars",
            location: "Jacksonville"
          },
          TEN: {
            name: "Titans",
            location: "Tennessee"
          },
          NWE: {
            name: "Patriots",
            location: "New England"
          },
          NYJ: {
            name: "Jets",
            location: "New York"
          },
          MIA: {
            name: "Dolphins",
            location: "Miami"
          },
          BUF: {
            name: "Bills",
            location: "Buffalo"
          }
        }
      }
    };
  },
  init: function() {
    var s;
    this.s = this.settings();
    s = this.s;
    this.pageSetup(s);
    return this.bindUIActions(s);
  },
  bindUIActions: function(s) {
    var $el, plotter;
    $.event.props.push("dataTransfer");
    $el = s.els;
    plotter = this;
    $el.playerPosRadio.bind("change", function() {
      return plotter.playerPosSwitch($(this).val());
    });
    $el.renderButton.bind("click", function() {
      return plotter.renderChart(s);
    });
    $el.highlightButton.bind("click", function() {
      return plotter.highlightModeSwitch();
    });
    $el.clearPlayersBtn.bind("click", function() {
      return plotter.clearSelectedPlayers();
    });
    $el.body.on("mouseenter", "#scatterplot-wrapper circle", function() {
      return plotter.circleCursorIn("#" + this.id);
    });
    $el.body.on("mouseleave", "#scatterplot-wrapper circle", function() {
      return plotter.circleCursorOut($(this));
    });
    $el.body.on("dragstart", "#hover-data", function(event) {
      return plotter.hoverLogDragStart(event, this);
    });
    $el.body.on("dragover", function(event) {
      return plotter.hoverLogDragOver(event, this);
    });
    $el.body.on("drop", function(event) {
      return plotter.hoverLogDrop(event, this);
    });
    $el.body.on("click", "#show-me", function(event) {
      event.preventDefault();
      return plotter.demoStart(false);
    });
    $el.body.on("click", "#stop-demo, #dismiss-reset", function(event) {
      return plotter.demoStop();
    });
    return $el.window.on("resize", function(event) {
      return plotter.fixPlotHeight();
    });
  },
  pageSetup: function(s) {
    var Plotter, data, selectHTML;
    Plotter = this;
    data = Plotter.data;
    Plotter.env = (function() {
      if (location.hostname === "localhost") {
        return "development";
      } else {
        return "production";
      }
    })();
    this.s.els.body.animate({
      scrollTop: 0
    });
    this.s.els.html.addClass("plotter-" + Plotter.env);
    this.s.els.playerPosGroups.hide();
    $.getJSON(Plotter.s.vals.datasetURL, function(json) {
      return data.fullSet = json;
    });
    $.getJSON(s.vals.namesURL, function(json) {
      var html, player, _i, _len;
      html = "";
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        player = json[_i];
        html += "<option>" + player + "</option>";
      }
      return s.els.playerSelect.append(html).chosen({
        width: "100%"
      });
    });
    selectHTML = s.els.origVarSelect.html();
    return s.els.varSelects.html(selectHTML).chosen({
      allow_single_deselect: true,
      width: "75%"
    });
  },
  renderChart: function(s) {
    var Plotter, data, newSettings, scales, selected;
    Plotter = this;
    data = Plotter.data;
    this.resetGraphingData(s);
    newSettings = this.settings();
    this.s.vals.selections = selected = this.getSelected(s.els);
    if (this.validateSelections(selected)) {
      this.data.graphingSet = this.getGraphingData(selected, data.fullSet);
      scales = this.calculateScales(selected, this.data.graphingSet);
      return this.drawChart(this.data.graphingSet, selected, scales);
    }
  },
  resetGraphingData: function(s) {
    this.data.graphingSet = {};
    return s.vals.selections = {};
  },
  getSelected: function(el) {
    return {
      seasons: (function() {
        var season, _i, _len, _ref, _results;
        _ref = el.seasonCheck.filter(":checked");
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          season = _ref[_i];
          _results.push($(season).val());
        }
        return _results;
      })(),
      positions: (function() {
        var position, _i, _len, _ref, _results;
        _ref = el.positionCheck.filter(":checked");
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          position = _ref[_i];
          _results.push($(position).val());
        }
        return _results;
      })(),
      players: (function() {
        var player, _i, _len, _ref, _results;
        _ref = el.selectedPlayersSpan();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          player = _ref[_i];
          _results.push($(player).html());
        }
        return _results;
      })(),
      variables: (function() {
        var values, variable, _i, _len, _ref;
        values = {};
        _ref = el.varSelects;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          variable = _ref[_i];
          values[$(variable).attr("data-axis")] = $(variable).find(":selected").attr("data-stat");
        }
        return values;
      })(),
      sortType: (function() {
        return el.playerPosRadio.filter(":checked").val();
      })(),
      statType: (function() {
        return el.gameSeasonRadio.filter(":checked").val();
      })()
    };
  },
  validateSelections: function(selections) {
    var missing, playerOrPosition, validity;
    validity = true;
    missing = {};
    if (!this.s.els.seasonCheck.filter(":checked").length) {
      validity = false;
    }
    if (this.s.els.playerPosRadio.filter(":checked").length) {
      playerOrPosition = this.s.els.playerPosRadio.filter(":checked").val();
      if (playerOrPosition === "player" && !this.s.els.selectedPlayersLi().length) {
        validity = false;
      }
      if (playerOrPosition === "position" && !this.s.els.positionCheck.filter(":checked").length) {
        validity = false;
      }
    } else {
      validity = false;
    }
    if (!(this.s.els.varSelects.filter("#x-select").find(":checked").val().length && this.s.els.varSelects.filter("#y-select").find(":checked").val().length)) {
      validity = false;
    }
    if (!this.s.els.gameSeasonRadio.filter(":checked").length) {
      validity = false;
    }

    /*
    
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
     */
    _log("validity: " + validity);
    return validity;
  },
  getGraphingData: function(sel, data) {
    var dataPoints, match, player, position, season, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _m, _ref, _ref1, _ref2, _ref3, _ref4;
    _log("getGraphingData started...");
    _log("sel:");
    _log(sel);
    _log("data:");
    _log(data);
    dataPoints = [];
    if (sel.sortType === "positions") {
      _ref = sel.seasons;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        season = _ref[_i];
        _ref1 = sel.positions;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          position = _ref1[_j];
          _ref2 = data[season][position];
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            player = _ref2[_k];
            dataPoints.push(player);
          }
        }
      }
    } else if (sel.sortType === "players") {
      _log("sort type players");
      _log(sel.seasons);
      _ref3 = sel.seasons;
      for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
        season = _ref3[_l];
        _log("season");
        _log(season);
        _log("data[season]");
        _log(data[season]);
        for (position in data[season]) {
          _log("position");
          _log(position);
          _ref4 = sel.players;
          for (_m = 0, _len4 = _ref4.length; _m < _len4; _m++) {
            player = _ref4[_m];
            _log("player");
            _log(player);
            match = data[season][position].filter(function(thisPlayer) {
              return thisPlayer.Name === player;
            });
            _log("match");
            _log(match);
            if (match.length) {
              dataPoints.push(match[0]);
            }
          }
        }
      }
      _log(dataPoints);
    }
    if (sel.statType === "game") {
      dataPoints = this.calculatePerGameData($.extend(true, [], dataPoints));
    }
    return dataPoints;
  },
  calculatePerGameData: function(dataPoints) {
    var i, key, playerSeason, val, _i, _len, _ref;
    for (i = _i = 0, _len = dataPoints.length; _i < _len; i = ++_i) {
      playerSeason = dataPoints[i];
      if (playerSeason.G < this.s.vals.perGameMinGames) {
        dataPoints[i] = {};
        continue;
      }
      _ref = this.s.vals.selections.variables;
      for (key in _ref) {
        val = _ref[key];
        if (__indexOf.call(this.s.vals.perGameStats, val) >= 0) {
          playerSeason[val] = this.utils.roundTwoPlaces(playerSeason[val] / playerSeason.G);
        }
      }
    }
    return this.utils.removeEmptyObjects(dataPoints);
  },
  calculateScales: function(sel, data) {
    var chartHeight, chartPadding, chartWidth, datum, scaleVals, scales, v, _i, _len;
    this.s.els.chartWrapper.css("visibility", "hidden").empty().height("400px").width("800px");
    _log("calculateScales started...");
    _log(sel);
    _log(data);
    scales = {};
    chartPadding = this.s.vals.chartPadding;
    chartWidth = this.s.vals.chartWidth;
    chartHeight = this.s.vals.chartHeight;
    _log("CHART WIDTH");
    _log(chartWidth);
    _log("CHART HEIGHT");
    _log(chartHeight);
    scaleVals = {
      x: {
        min: 1000000,
        max: 0
      },
      y: {
        min: 1000000,
        max: 0
      },
      r: {
        min: 1000000,
        max: 0
      },
      c: {
        min: 1000000,
        max: 0
      }
    };
    for (_i = 0, _len = data.length; _i < _len; _i++) {
      datum = data[_i];
      v = sel.variables;
      if (datum[v.xAxis] > scaleVals.x.max) {
        scaleVals.x.max = datum[v.xAxis];
      }
      if (datum[v.xAxis] < scaleVals.x.min) {
        scaleVals.x.min = datum[v.xAxis];
      }
      if (datum[v.yAxis] > scaleVals.y.max) {
        scaleVals.y.max = datum[v.yAxis];
      }
      if (datum[v.yAxis] < scaleVals.y.min) {
        scaleVals.y.min = datum[v.yAxis];
      }
      if (datum[v.rAxis] > scaleVals.r.max) {
        scaleVals.r.max = datum[v.rAxis];
      }
      if (datum[v.rAxis] < scaleVals.r.min) {
        scaleVals.r.min = datum[v.rAxis];
      }
      if (datum[v.cAxis] > scaleVals.c.max) {
        scaleVals.c.max = datum[v.cAxis];
      }
      if (datum[v.cAxis] < scaleVals.c.min) {
        scaleVals.c.min = datum[v.cAxis];
      }
    }
    scales.x = d3.scale.linear().domain([scaleVals.x.min, scaleVals.x.max]).range([chartPadding, chartWidth - chartPadding * 3]);
    scales.y = d3.scale.linear().domain([scaleVals.y.max, scaleVals.y.min]).range([chartPadding / 4, chartHeight - chartPadding * 2]);
    scales.r = d3.scale.linear().domain([scaleVals.r.min, scaleVals.r.max]).range([2, 10]);
    scales.c = d3.scale.linear().domain([scaleVals.c.min, scaleVals.c.max]).range([-0.15, 0.15]);
    return scales;
  },
  drawChart: function(dataset, selected, scales) {
    var $plot, c, chartHeight, chartPadding, chartWidth, dot, dotHolder, pieces, posColors, r, scatterplot, scatterplotPoints, svgDomElement, x, xAxis, y, yAxis, _i, _len, _ref;
    chartHeight = this.s.vals.chartHeight;
    chartWidth = this.s.vals.chartWidth;
    chartPadding = this.s.vals.chartPadding;
    _log("drawChart started");
    _log(dataset);
    _log(selected);
    _log(scales);
    posColors = this.s.vals.posColors;
    x = selected.variables.xAxis;
    y = selected.variables.yAxis;
    c = selected.variables.cAxis;
    r = selected.variables.rAxis;
    scatterplot = d3.select('#scatterplot-wrapper').append('svg').attr('id', 'd3-scatterplot');
    dotHolder = d3.select('#d3-scatterplot').append('g').attr('id', 'dot-holder');
    scatterplotPoints = dotHolder.selectAll("circle").data(dataset).enter().append("circle").attr("cx", function(d) {
      return scales.x(d[x]);
    }).attr("cy", function(d) {
      return scales.y(d[y]);
    }).attr("r", function(d) {
      if (scales.r && d[r]) {
        return scales.r(d[r]);
      } else {
        return 4;
      }
    }).attr("fill", function(d) {
      var base;
      base = posColors[d.FantPos];
      if (scales.c && d[c]) {
        if (scales.c(d[c]) > 0) {
          return Color(base).lightenByAmount(scales.c(d[c])).desaturateByAmount(scales.c(d[c])).toCSS();
        } else {
          return Color(base).darkenByAmount(0 - scales.c(d[c])).saturateByAmount(0 - scales.c(d[c])).toCSS();
        }
      } else {
        return base;
      }
    }).attr("id", function(d) {
      var id;
      id = "";
      id += d.Name.split(" ").join("-").replace(/\./g, "").replace(/'/g, "") + "_";
      id += d.Season + "_";
      id += d.FantPos;
      return id;
    });
    xAxis = d3.svg.axis().scale(scales.x).orient("bottom");
    yAxis = d3.svg.axis().scale(scales.y).orient("left");
    scatterplot.append("g").attr("class", "axis").attr("id", "xAxis").attr("transform", "translate( 0, " + (chartHeight - chartPadding * 2) + " )").call(xAxis);
    scatterplot.append("text").attr("class", "xAxis-label").attr("transform", "translate( " + chartPadding + ", " + (chartHeight + 30 - chartPadding * 2) + " )").text(x);
    scatterplot.append("g").attr("class", "axis").attr("id", "yAxis").attr("transform", "translate( " + chartPadding + ", 0 )").call(yAxis);
    scatterplot.append("text").attr("class", "yAxis-label").attr("transform", "translate( " + chartPadding + ", 0) rotate(-90)").text(y);
    this.s.els.chart = this.s.els.chartWrapper.find("svg");
    this.s.els.dots = this.s.els.chart.find("circle");
    _ref = this.s.els.dots;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      dot = _ref[_i];
      pieces = dot.id.split("_");
      $(dot).attr("data-player-name", pieces[0].split("-").join(" "));
      $(dot).attr("data-player-season", pieces[1]);
      $(dot).attr("data-player-position", pieces[2]);
    }
    svgDomElement = this.s.els.chartWrapper.find("svg")[0];
    svgDomElement.setAttribute('preserveAspectRatio', 'xMinYMin meet');
    svgDomElement.setAttribute("viewBox", "0 0 800 400");
    this.s.els.chartWrapper.css("visibility", "visible").css("width", "");
    this.fixPlotHeight();
    $plot = this.s.els.chartWrapper.find("svg").eq(0);
    return this.s.els.$log.fadeIn().css({
      top: $plot.offset().top,
      left: $plot.offset().left + $plot.width() - this.s.els.$log.width()
    });
  },
  fixPlotHeight: function() {
    var $plot, ratio;
    $plot = this.s.els.chartWrapper.find("svg").eq(0);
    ratio = $plot.prop("viewBox").baseVal.height / $plot.prop("viewBox").baseVal.width;
    return $plot.parent().height(ratio * $plot.parent().width());
  },
  highlightModeSwitch: function() {
    var Plotter, highlightModeUpdate, highlighted, key, value, _results;
    Plotter = this;
    highlightModeUpdate = this.highlightModeUpdate;
    this.s.els.html.toggleClass("plotter-highlight-mode");
    highlighted = {
      positions: [],
      players: [],
      seasons: []
    };
    if (this.s.els.html.is(".plotter-highlight-mode")) {
      _log('highlightmodeswitch if');
      this.s.els.allCheckInput.prop("disabled", true);
      return this.s.els.allCheckLabels.bind("click.highlightMode", function() {
        var hlStatus, inputElement;
        $(this).toggleClass("highlighted");
        hlStatus = $(this).is(".highlighted");
        inputElement = $("#" + ($(this).attr('for')));
        return Plotter.highlightModeUpdate(inputElement, hlStatus, highlighted);
      });
    } else {
      _log('highlightModeSwitch else');
      this.s.els.allCheckInput.prop("disabled", false);
      this.s.els.allCheckLabels.removeClass("highlighted").unbind("click.highlightMode");
      this.s.els.dots.attr("class", "");
      _results = [];
      for (key in highlighted) {
        value = highlighted[key];
        _results.push(value = []);
      }
      return _results;
    }
  },
  highlightModeUpdate: function($el, status, highlighted) {
    var posChecked, position, season, seasonChecked, value, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _results, _results1, _results2;
    value = $el.val();
    posChecked = ".pos-input:checked";
    seasonChecked = ".yr-input:checked";
    if (status === true) {
      if ($el.is(posChecked)) {
        highlighted.positions.push(value);
      } else if ($el.is(seasonChecked)) {
        highlighted.seasons.push(value);
      }
    } else if (status === false) {
      if ($el.is(posChecked)) {
        Plotter.utils.removeVals(highlighted.positions, value);
      } else if ($el.is(seasonChecked)) {
        Plotter.utils.removeVals(highlighted.seasons, value);
      }
    }
    Plotter.s.els.dots.attr("class", "");
    if (highlighted.seasons.length && highlighted.positions.length) {
      _ref = highlighted.seasons;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        season = _ref[_i];
        _results.push((function() {
          var _j, _len1, _ref1, _results1;
          _ref1 = highlighted.positions;
          _results1 = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            position = _ref1[_j];
            _results1.push(Plotter.s.els.dots.filter("[data-player-season='" + season + "']").filter("[data-player-position='" + position + "']").attr("class", "highlighted-dot").each(function() {
              return $(this).appendTo($("#dot-holder"));
            }));
          }
          return _results1;
        })());
      }
      return _results;
    } else {
      if (highlighted.seasons.length) {
        _ref1 = highlighted.seasons;
        _results1 = [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          season = _ref1[_j];
          _results1.push(Plotter.s.els.dots.filter("[data-player-season='" + season + "']").attr("class", "highlighted-dot").each(function() {
            return $(this).appendTo($("#dot-holder"));
          }));
        }
        return _results1;
      } else if (highlighted.positions.length) {
        _ref2 = highlighted.positions;
        _results2 = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          position = _ref2[_k];
          _results2.push(Plotter.s.els.dots.filter("[data-player-position='" + position + "']").attr("class", "highlighted-dot").each(function() {
            return $(this).appendTo($("#dot-holder"));
          }));
        }
        return _results2;
      }
    }
  },
  playerPosSwitch: function(val) {
    var toShow;
    toShow = this.s.els.playerPosGroups.filter("[data-input-group='" + val + "']").show();
    return toShow.siblings("[data-input-group]").hide();
  },
  circleCursorIn: function(selector) {
    var classes, props, v, _ref;
    if (this.s.els.html.is(".plotter-highlight-mode")) {
      classes = ((_ref = $(selector).attr("class")) != null ? _ref.split(" ") : void 0) || [];
      if (classes.indexOf("highlighted-dot") === -1) {
        return;
      }
    }
    $(selector).appendTo($("#dot-holder"));
    _log(selector);
    _log(d3.select(selector));
    props = d3.select(selector)[0][0].__data__;
    v = this.s.vals.selections.variables;
    this.s.els.$playerNameYr.html("" + props.Name + " &mdash; " + props.Season + " (" + props.FantPos + ", " + props.Tm + ")");
    this.s.els.$xVar.html(" " + this.s.vals.statAbbr[v.xAxis] + " ");
    this.s.els.$yVar.html(" " + this.s.vals.statAbbr[v.yAxis] + " ");
    this.s.els.$rVar.html(" " + this.s.vals.statAbbr[v.rAxis] + " ");
    this.s.els.$cVar.html(" " + this.s.vals.statAbbr[v.cAxis] + " ");
    this.s.els.$xVal.html(props[v.xAxis]);
    this.s.els.$yVal.html(props[v.yAxis]);
    this.s.els.$rVal.html(props[v.rAxis]);
    return this.s.els.$cVal.html(props[v.cAxis]);
  },
  circleCursorOut: function(el) {
    return this.s.els.$allHoverSpans.html("&nbsp;");
  },
  clearSelectedPlayers: function() {
    return this.s.els.selectedPlayersLi().remove();
  },
  hoverLogDragStart: function(event) {
    return event.dataTransfer.setData("text/plain", (parseInt(this.s.els.$log.css("left"), 10) - event.originalEvent.clientX) + ',' + (parseInt(this.s.els.$log.css("top"), 10) - event.originalEvent.clientY));
  },
  hoverLogDragOver: function(event) {
    event.preventDefault();
    return false;
  },
  hoverLogDrop: function(event) {
    var offset;
    offset = event.dataTransfer.getData("text/plain").split(',');
    this.s.els.$log.css("left", (event.originalEvent.clientX + parseInt(offset[0], 10)) + 'px');
    this.s.els.$log.css("top", (event.originalEvent.clientY + parseInt(offset[1], 10)) + 'px');
    event.preventDefault();
    return false;
  },
  demoStart: function(dev) {
    var Plotter, action, els, i, index, key, lastTimeout, sequencedTimeouts, totalTime, _i, _len, _ref;
    index = this.utils.getRandomInt(0, this.demos.length - 1);
    Plotter = this;
    els = this.s.els;
    this.resetPage();
    this.s.els.html.addClass("demo-active");
    totalTime = 0;
    this.allTimeouts = [];
    sequencedTimeouts = (function(_this) {
      return function(action, i) {
        var delay, to;
        console.log(action);
        delay = action.delay || 1000;
        totalTime += delay;
        to = setTimeout(function() {
          action.fn();
        }, totalTime);
        return _this.allTimeouts.push(to);
      };
    })(this);
    $.fn.extend({
      fauxClick: function(options) {
        var click, defaults, fromLeft, fromTop, settings;
        defaults = {
          duration: 2000,
          className: "faux-click",
          top: 15,
          left: 15,
          triggerClick: true
        };
        settings = $.extend(defaults, options || {});
        if (settings.triggerClick) {
          $(this).click();
        }
        fromTop = this.offset().top + settings.top;
        fromLeft = this.offset().left + settings.left;
        click = $("<div class='" + settings.className + "'>").appendTo($("body"));
        click.css({
          top: fromTop,
          left: fromLeft
        });
        setTimeout(function() {
          click.remove();
        }, settings.duration);
        return this;
      },
      typeOut: function(str, callback) {
        var $this, i, letter, letters, setDelay, _i, _len;
        letters = str.split('');
        $this = $(this);
        setDelay = function(i, letter, cb) {
          (function() {
            return setTimeout(function() {
              var enter, evtDown, evtUp;
              evtDown = jQuery.Event('keydown', {
                which: letter.charCodeAt(0)
              });
              evtUp = jQuery.Event('keyup', {
                which: letter.charCodeAt(0)
              });
              $this.trigger(evtDown);
              $this.val($this.val() + letter);
              $this.trigger(evtUp);
              if (cb) {
                cb(i, letter);
              }
              if (i === letters.length - 1) {
                enter = jQuery.Event('keyup', {
                  which: 13
                });
                return $this.trigger(enter);
              }
            }, 75 * i);
          })();
          if (!cb) {
            return cb = $.noop;
          }
        };
        for (i = _i = 0, _len = letters.length; _i < _len; i = ++_i) {
          letter = letters[i];
          setDelay(i, letter, callback);
        }
        return this;
      }
    });
    if (dev) {
      for (key in actions) {
        actions[key].delay = 100;
      }
    }
    _ref = this.demos[index];
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      action = _ref[i];
      console.log(key);
      sequencedTimeouts(action, i);
    }
    lastTimeout = setTimeout(function() {
      return Plotter.demoComplete();
    }, totalTime + 2000);
    return this.allTimeouts.push(lastTimeout);
  },
  demoComplete: function() {
    els.html.removeClass("demo-active");
    els.html.addClass("demo-complete");
    return $("#stop-demo").html("Dismiss");
  },
  demoStop: function() {
    var timeout, _i, _len, _ref, _results;
    _ref = this.allTimeouts;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      timeout = _ref[_i];
      _results.push(clearTimeout(timeout));
    }
    return _results;
  },
  resetPage: function() {
    if (this.s.els.html.is(".plotter-highlight-mode")) {
      this.highlightModeSwitch();
    }
    this.s.els.html.removeClass("demo-active demo-complete");
    $("input:checked").prop("checked", false);
    return $("select.variable").each(function() {
      return $(this).find("option:checked").prop("checked", false).end().trigger("liszt:updated");
    });
  },
  data: {},
  utils: {
    removeDupes: function(arr) {
      var key, obj, out, v, _i, _len;
      out = [];
      obj = {};
      for (_i = 0, _len = arr.length; _i < _len; _i++) {
        v = arr[_i];
        obj[v] = 0;
      }
      for (key in obj) {
        if (!__hasProp.call(obj, key)) continue;
        out.push(key);
      }
      return out;
    },
    removeVals: function() {
      var arr, spot, val, vals, _i, _len;
      arr = arguments[0], vals = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      for (_i = 0, _len = vals.length; _i < _len; _i++) {
        val = vals[_i];
        if ((spot = arr.indexOf(val)) !== -1) {
          arr.splice(spot, 1);
        }
      }
      return arr;
    },
    nthLast: function(arr, n) {
      var l;
      l = arr.length;
      return arr[l - (n + 1)];
    },
    getRandomInt: function(min, max) {
      return Math.floor(Math.random() * (max - min + 1) + min);
    },
    removeEmptyObjects: function(arr) {
      var cleanedArr, obj, _i, _len;
      cleanedArr = [];
      for (_i = 0, _len = arr.length; _i < _len; _i++) {
        obj = arr[_i];
        if ($.isEmptyObject(obj)) {
          continue;
        } else {
          cleanedArr.push(obj);
        }
      }
      return cleanedArr;
    },
    roundTwoPlaces: function(num) {
      return Math.round(num * 100) / 100;
    }
  }
};

window.Plotter.init();

if ($("html").is(".plotter-development")) {
  Plotter.demoStart(false);
}
