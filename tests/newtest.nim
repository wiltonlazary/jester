import jester, asyncdispatch, strutils, math

var settings = newSettings()

when false:
  proc match(request: PRequest, response: PResponse): PFuture[bool] {.async.} =
    setDefaultResp()
    case request.reqMeth
    of HttpGet:
      let ret = parsePattern("/test/@blah").match(request.path)
      if ret.matched:
        copyParams(request, ret.params)
        resp "Hello World"
        if checkAction(response): return true
    of HttpPost:
      discard

routes:
  get "/":
    resp "Hello World"

  get "/guess/@who":
    if @"who" != "Frank": pass()
    resp "You've found me!"

  get "/guess/@_":
    resp "Haha. You will never find me!"

  get "/redirect/@url/?":
    redirect(uri(@"url"))

  get "/win":
    cond random(5) < 3
    resp "<b>You won!</b>"

  get "/win":
    resp "<b>Try your luck again, loser.</b>"

  get "/profile/@id/@value?/?":
    var html = ""
    html.add "<b>Msg: </b>" & @"id" &
             "<br/><b>Name: </b>" & @"value"
    html.add "<br/>"
    html.add "<b>Params: </b>" & $request.params

    resp html

jester.serve(settings, match)
runForever()