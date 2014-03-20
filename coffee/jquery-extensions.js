// Generated by CoffeeScript 1.7.1
(function() {
  $.fn.extend({
    demoClick: function(options) {
      var click, defaults, settings;
      defaults = {
        duration: 2000,
        className: "demo-click",
        top: 25,
        left: 25,
        triggerClick: true
      };
      settings = $.extend(true, {}, defaults, options || {});
      if (settings.triggerClick) {
        $(this).click();
      }
      click = $("<div class='" + settings["class"] + "'>").appendTo($("body")).css({
        top: this.offset().top + settings.top,
        left: this.offset().left + settings.left
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
        return (function() {
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
      };
      if (!callback) {
        callback = $.noop;
      }
      for (i = _i = 0, _len = letters.length; _i < _len; i = ++_i) {
        letter = letters[i];
        setDelay(i, letter, callback);
      }
      return this;
    }
  });


  /*
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
   */

  (function($) {
    var $event, $special, resizeTimeout;
    $event = $.event;
    $special = void 0;
    resizeTimeout = void 0;
    return $special = $event.special.debouncedresize = {
      setup: function() {
        return $(this).on("resize", $special.handler);
      },
      teardown: function() {
        return $(this).off("resize", $special.handler);
      },
      handler: function(event, execAsap) {
        var args, context, dispatch;
        context = this;
        args = arguments;
        dispatch = function() {
          event.type = "debouncedresize";
          return $event.dispatch.apply(context, args);
        };
        if (resizeTimeout) {
          clearTimeout(resizeTimeout);
        }
        if (execAsap) {
          return dispatch();
        } else {
          return resizeTimeout = setTimeout(dispatch, $special.threshold);
        }
      },
      threshold: 150
    };
  })(jQuery);

}).call(this);
