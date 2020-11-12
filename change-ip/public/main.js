(function($) {

  /* busy flag, one ajax call at a time */
  var busy = false

  /* ajax error codes */
  var statusCodes = {
    404: function() {
      afterAjax("Page not found", 1000)
    },
    401: function() {
      afterAjax("Forbidden", 1000);
    },
    500: function() {
      afterAjax("Internal error", 1000);
    }
  }

  /* before starting ajax call */
  function beforeAjax() {
    busy = true
    $("#output").html("")
    $("#loader").show()
    $("#modem-control a").addClass("disabled")
  }

  /* get logged in user and continue with original call */
  function me(callback) {
    $.ajax({
      url: "/api/me",
      statusCode: statusCodes
    }).done(function(username) {
      $("#username").html(username)
      callback()
    })
  }

  /* print ajax result */
  function afterAjax(text, sleep) {
    setTimeout(function() {
      var s = "<pre>{text}</pre>".replace("{text}", text)
      $("#loader").hide()
      $("#output").html(s)
      $("#modem-control a").removeClass("disabled")
      busy = false
    }, sleep || 5000)
  }

  /* call backend */
  function call_modem(url, sleep) {
    if (busy) return
    beforeAjax()
    me(function() {
      $.ajax({
        url: "/api"+url+"&pin="+$("#pin").val(),
        statusCode: statusCodes
      }).done(function(output) {
        afterAjax(output, sleep)
      })
    })
  }

  /* modem status */
  $("#modem-control .modem-status").click(function(event) {
    event.preventDefault()
    call_modem("/modem?a=status", 2000)
  })

  /* model IP */
  $("#modem-control .modem-ip").click(function(event) {
    event.preventDefault()
    call_modem("/modem?a=ip", 2000)
  })

  /* reboot modem */
  $("#modem-control .modem-reboot").click(function(event) {
    event.preventDefault()
    call_modem("/modem?a=reboot", 20000)
  })

  /* reconnect modem */
  $("#modem-control .modem-reconnect").click(function(event) {
    event.preventDefault()
    call_modem("/modem?a=reconnect", 5000)
  })

  /* reboot proxy */
  $("#modem-control .modem-proxy").click(function(event) {
    event.preventDefault()
    call_modem("/modem?a=proxy", 5000)
  })

  /* backend test */
  $("#modem-control .echo-test").click(function(event) {
    event.preventDefault()
    if (busy) return
    beforeAjax()
    me(function() {
      $.ajax({
        url: "/api/echo",
        statusCode: statusCodes
      }).done(function(output) {
        afterAjax(output, 2000)
      })
    })
  })

  /* prevent form submission */
  $("#pin-form").submit(function(event) {
    event.preventDefault()
  })

  /* logout */
  $("#logout").click(function() {
    if (busy) return
    beforeAjax()
    $("#username").html("")
    $.ajax({
      url: "/api/logout",
      statusCode: statusCodes
    }).done(function() {})
  })

})(jQuery);
