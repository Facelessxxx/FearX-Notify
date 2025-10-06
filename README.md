# fearx-notify — ESX & ox_lib Replacement Guide

**Overview**
- Replace ESX and ox_lib notification functions to use fearx-notify UI.
- Use either automatic overrides or direct edits as shown below.

**Install Resource**
- Place this folder in your resources and add `ensure fearx-notify` to `server.cfg`.

**Option 1: No Core Edits (Auto Override)**
- Ensure `fearx-notify` after your frameworks or at the end of your resources list.
- The resource hooks `ESX.ShowNotification` and `lib.notify` at runtime to display via fearx-notify.

**Option 2: Replace ESX Function**
- File: `es_extended/client/functions.lua`
- Find: `ESX.ShowNotification`
- Replace with:

```
function ESX.ShowNotification(message, type, length, custom_icon)
    local ntype = (type == 'inform') and 'info' or (type or 'info')
    exports['fearx-notify']:Send(ntype, '', message, length or 5000, nil, { icon = custom_icon })
end
```

**Option 2: Replace ox_lib Function**
- File: `ox_lib/resource/interface/client/notify.lua`
- Find: `lib.notify`
- Replace with:

```
function lib.notify(data)
    local sound = settings.notification_audio and data.sound
    data.sound = nil
    data.position = data.position or settings.notification_position

    local ntype = (data.type == 'inform') and 'info' or (data.type or 'info')

    exports['fearx-notify']:Send(ntype, data.title or '', data.description or data.message or '', data.duration or 5000, nil, {
        icon = data.icon,
        color = data.color,
        position = data.position
    })

    if not sound then return end

    if sound.bank then lib.requestAudioBank(sound.bank) end
    local soundId = GetSoundId()
    PlaySoundFrontend(soundId, sound.name, sound.set, true)
    ReleaseSoundId(soundId)
    if sound.bank then ReleaseNamedScriptAudioBank(sound.bank) end
end
```

**Verify Changes**
- In any client script:
  - `ESX.ShowNotification('Hello world', 'success', 5000)`
  - `lib.notify({ title = 'Title', description = 'Body', type = 'info', duration = 4000 })`

**Notes**
- Framework updates may overwrite edits; reapply after updating.
- If you use Option 1, no framework edits are required.

**Config**
- File: `config.lua`
- Keys:
  - `Config.DeaultNotify`: default type when none provided (e.g. `primary`).
  - `Config.Debug`: when `true`, enables `/notify <type> [message]`.
  - `Config.EsxNotifcation`: when `true`, forwards to original `ESX.ShowNotification`.
  - `Config.GlobalMute`: when `true`, suppresses all notifications.
  - `Config.Position`: `top-left|top-right|bottom-left|bottom-right|top-center|bottom-center|left|right`.
  - `Config.Notifications[type]`: `{ icon, title, sound, color, volume, mute }`.

**Sounds**
- Place audio files in `html/sounds/` and set the file name in `Config.Notifications[type].sound`.
- Supported: `.mp3`, `.ogg`.
