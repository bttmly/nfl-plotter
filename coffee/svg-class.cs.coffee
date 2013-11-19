do (jQuery) ->

  $ = jQuery

  # http://dreaminginjavascript.wordpress.com/2008/08/22/eliminating-duplicates/
  eliminiateDupes = (arr) ->
    out = []
    obj = {}
    for v in arr
      obj[v] = 0
    for own key of obj
      out.push key
    return out

  $.fn.svgAddClass = (value) ->
    classList = []
    classesToAdd = eliminateDupes value.split " "
    return @.each ->
      if $(@).is "[class]"
        classList = $(@).attr("class").split(" ")
      for cl in classesToAdd
        # if classList.indexOf(cl) is -1
        # if cl not in classList
        unless cl in classList
          classList.push cl
      $(@).attr "class", classList.join " "

  $.fn.svgRemoveClass = (value) ->
    classList = []
    classesToRemove = eliminateDupes value.split " "
    return @.each ->
      if $(@).is "[class]"
        classList = $(@).attr("class").split(" ")
      for cl in classesToRemove
        # if classList.indexOf(cl) isnt -1
        if cl in classList
          classList.splice classList.indexOf(cl), 1
      $(@).attr "class", classList.join " "

  $.fn.svgToggleClass = (value) ->
    classList = []
    classesToToggle = eliminateDupes value.split " "
    return @.each ->
      if $(@).is "[class]"
        classList = $(@).attr("class").split(" ")
      for cl in classesToToggle
        # if classList.indexOf(cl) is -1
        # if cl not in classList
        unless cl in classList
          classList.push cl
        else
          classList.splice classList.indexOf(cl), 1
      $(@).attr "class", classList.join " "

  # Return true if any one element is all of the classes given to the function
  $.fn.svgIsAllClasses = (value) ->
    isClasses = eliminateDupes value.split " "
    anyIsAll = false
    @.each ->
      if $(@).is "[class]"
        classList = $(@).attr("class").split(" ")
        thisIsAll = true
        for cl in isClasses
          # if classList.indexOf(cl) is -1
          # if not cl in classList
          unless cl in classList
            thisIsAll = false
            break
        if thisIsAll is true
          anyIsAll = true
          return false
    return anyIsAll
 
  # Return true if any one element is at least one of the classes given to the function
  $.fn.svgIsAnyClasses = (value) ->
    isClasses = eliminateDupes value.split " "
    anyIsAny = false
    @.each ->
      if $(@).is "[class]"
        classList = $(@).attr("class").split(" ")
        thisIsAny = false
        for cl in isClasses
          if cl in classList
            thisIsAny = true
            break
        if thisIsAny is true
          anyIsAny = true
          return false
    return anyIsAny  
  
  return