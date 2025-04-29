local sketchybar_path = "/usr/local/bin/sketchybar"

local hideDelay = 0.7
local hideTimer = nil

local function setSketchybarTopmost(state)
  hs.task.new(sketchybar_path, nil, { "--bar", "topmost=" .. state }):start()
end

local optionWatcher = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(ev)
  local flags = ev:getFlags()

  if flags.alt then
    if hideTimer then
      hideTimer:stop()
      hideTimer = nil
    end
    setSketchybarTopmost("on")
  else
    if not hideTimer then
      hideTimer = hs.timer.doAfter(hideDelay, function()
        setSketchybarTopmost("off")
        hideTimer = nil
      end)
    end
  end
end)

optionWatcher:start()
