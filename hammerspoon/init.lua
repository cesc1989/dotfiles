-- A global variable for the Hyper Mode
hyper = hs.hotkey.modal.new({}, 'F17')

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
function enterHyperMode()
  hyper.triggered = false
  hyper:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
function exitHyperMode()
  hyper:exit()
  if not hyper.triggered then
    -- See Hammerspoon keymap https://www.hammerspoon.org/docs/hs.keycodes.html#map
    hs.eventtap.keyStroke({}, 'shift') -- Prefiero no usar ESCAPE para que no me cierre modales o ventanas.
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', enterHyperMode, exitHyperMode)

hyper:bind({}, "B", function()
  hs.application.launchOrFocus("Brave Browser")
end)

hyper:bind({}, "F", function()
  hs.application.launchOrFocus("Firefox")
end)

hyper:bind({}, "O", function()
  hs.application.launchOrFocus("Obsidian")
end)

hyper:bind({}, "S", function()
  hs.application.launchOrFocus("Sublime Text")
end)

hyper:bind({}, "T", function()
  hs.application.launchOrFocus("Terminal")
end)

hyper:bind({}, "D", function()
  hs.application.launchOrFocus("DBeaver")
end)

hyper:bind({}, "P", function()
  hs.application.launchOrFocus("Postman")
end)

hyper:bind({}, "Z", function()
  hs.application.launchOrFocus("Zed")
end)

hyper:bind({}, "E", function()
  hs.application.launchOrFocus("Finder")
end)

hyper:bind({}, "H", function()
  hs.application.launchOrFocus("Dash")
end)

hyper:bind({}, "C", function()
  hs.application.launchOrFocus("Cursor")
end)
