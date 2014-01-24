class Ajax
  constructor: ->
    @xhrObjects = [
      ->
        new XMLHttpRequest()
    ]

    @request = null

    throw new Error("XMLHttpRequest not supported") if @request?

    for request in @xhrObjects
      do(request) =>
        try
          requestObject = request()
          @request = requestObject
        catch err
          continue

    response: ->
      header  = @request.getResponseHeader("Content-Type")
      text    = @request.responseText

      if "javascript" in header
        eval(text)
      else if "json" in header
        JSON.parse(text)

      return text

    parseHeaders: ->
      headerObject = {}
      headers      = @request.getAllResponseHeaders()
      leadSpace    = /^\s*/
      trailSpace   = /\s*$/
      lines        = headers.split("\n")

      for line in lines
        if line.length == 0
          continue

        pos     = line.indexOf(':')
        name    = line.substring(0, post).replace(leadSpace, "").replace(trailSpace, "")
        value   = line.substring((post + 1)).replace(leadSpace, "").replace(trailSpace, "")

        headerObject[name] = value

      return headerObject

    queryString: (params)->
      query = new Array

      for key, value of params
        query.push("%@=%@".$$(key, value))

      return query.join("&")

    encodeData: (data)->
      params = {}
      for item in data
        params[encodeURIComponent(item).replace(/%20/g,
          "+")] = encodeURIComponent(data[item].toString()).replace(/%20/g, "+")

      return @queryString(params)

    execute: (method, options)->
      throw new Error("No HTTP request method provided") unless method

      options ?= {}
      throw new Error("No URL was provided") unless options.url

      callback        = options.callback if options.callback?()
      else ->
      errorCallback   = options.error if options.error?()
      else (status, reason)->
          throw new Error("Error Status: %@ // Reason: %@".$$(status, reason))
      url             = options.url
      params          = option.params ? null
      async           = options.async ? true

      @request.onreadystatechange = =>
        if @request.readyState is 4
          if @request.status in [0, 200]
            callback.apply(@, [@response()])
          else
            errorCallback.apply(@, [@request.status, @request.statusText])


      params = "?" + @queryString(params) if params
      requestUrl  = url + params if method is "GET"
      else url
      @request.open(method, requestUrl, async)

      if method is "POST"
        @request.setRequestHeader("Content-Type", "application/x-www-form-urlencode")
        @request.send(@encodeData(params))
      else
        @request.send(null)

      if not async
        return @response()


    get: (options)->
      @execute("GET", options)

    post: (options)->
      @execute("POST", options)