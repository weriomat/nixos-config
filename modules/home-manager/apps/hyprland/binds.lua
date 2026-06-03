-- mouse movements
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- compositor commands
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + D", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())

-- hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("pkill Hyprland"))
-- hl.bind(mod .. " + G", hl.dsp.group.toggle())
-- hl.bind(mod .. " + SHIFT + N", hl.dsp.group.next())
-- hl.bind(mod .. " + SHIFT + P", hl.dsp.group.prev())

-- utility
hl.bind(mod .. " + T", hl.dsp.exec_cmd("thunderbird"))

-- switchching focus with vim keys
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))

-- switchching focus with arrow keys
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Switch workspaces with mod + [0-9], Move active window to a workspace with mod + SHIFT + [0-9] 
for i = 1, 10 do
  local key = i % 10
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
  -- FIXME: hl.bind(mod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Special workspaces (scratchpad)
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special", follow = false }))
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("special"))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- to switch between windows in a floating workspace
hl.bind(mod .. " + Tab", hl.dsp.window.cycle_next())
hl.bind(mod .. " + Tab", hl.dsp.exec_cmd("hyprctl dispatch bringactivetotop"))

-- -- Resize windows
-- hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 30, y = 0 }), { repeating = true })
-- hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -30, y = 0 }), { repeating = true })
-- hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -30 }), { repeating = true })
-- hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 30 }), { repeating = true })

-- -- Resize windows with hjkl keys
-- hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 30, y = 0 }), { repeating = true })
-- hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -30, y = 0 }), { repeating = true })
-- hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -30 }), { repeating = true })
-- hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 30 }), { repeating = true })

-- move to the first empty workspace instantly with mod + CTRL + [↓]
hl.bind(mod .. " + CTRL + down", hl.dsp.focus({ workspace = "empty" }))

-- Lidswitch
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms off"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"), { locked = true })
