<br>
<img align='center' src='https://cdn.discordapp.com/attachments/882573745913479228/1009950600227729459/unknown.png?size=4096'>

<h4 align='center'>Prevents cheaters from exploiting server events</h4>
<p align='center'><b><a href='https://github.com/xariesnull'>xaries</a> - <a href='https://github.com/tekkenkkk'>tekken</a></b></p>

<h1>Important Notice</h1>
If you rename a script, it will no longer work properly

<h1>Important Notice</h1>
If you rename a script, it will no longer work properly

<h1>Features</h1>
<ul>
  <li>Player bans for all identifiers and `Player Tokens`</li>
  <li>Discord Webhook logs when a player tries to trigger an event with no arguments / or with an invalid token</li>
  <li>Using State Bags for storing data</li>
  <li>Fully standalone</li>
  <li>Well optimized ~0.00ms</li>
</ul>

<h1>Usage</h1>

<h2>Client</h2>

```lua
exports["secured"]:call(eventName, [, ...])
```

<h4>Required arguments</h4>
eventName: A string representing the event name to call on the server.

<h4>Optional arguments</h4>
...: Any additional data that should be passed along.

<h3>Example</h3>

```lua
exports["secured"]:call("Test", "test1")
```

<h2>Server</h2>

```lua
exports["secured"]:handler(eventName, callback)
```

<h4>Required arguments</h4>
<b>eventName</b>: The name of the event you want to listen to.
<br>
<b>callback</b>: The function to run when the event is called.

<h3>Example</h3>

```lua
exports["secured"]:handler("Test", function(arg)
    local player = source
    if arg ~= "test" then
        return false
    end
    return true
end)
```
