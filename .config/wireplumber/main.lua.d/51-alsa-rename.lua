rule = {
  matches = {
    {
      { "node.description", "equals", "Cannon Point-LP High Definition Audio Controller Speaker + Headphones" },
    },
  },
  apply_properties = {
    ["node.description"] = "Speakers",
  },
}
table.insert(alsa_monitor.rules, rule)

rule = {
  matches = {
    {
      { "node.description", "equals", "Cannon Point-LP High Definition Audio Controller Headphones Stereo Microphone" },
    },
  },
  apply_properties = {
    ["node.description"] = "Microphone",
  },
}
table.insert(alsa_monitor.rules, rule)

rule = {
  matches = {
    {
      { "node.description", "equals", "Cannon Point-LP High Definition Audio Controller Digital Microphone" },
    },
  },
  apply_properties = {
    ["node.description"] = "Microphone (builtin)",
  },
}
table.insert(alsa_monitor.rules, rule)

rule = {
  matches = {
    {
      { "node.description", "equals", "Cannon Point-LP High Definition Audio Controller HDMI / DisplayPort 1 Output" },
    },
  },
  apply_properties = {
    ["node.description"] = "HDMI 1",
  },
}
table.insert(alsa_monitor.rules, rule)

rule = {
  matches = {
    {
      { "node.description", "equals", "Cannon Point-LP High Definition Audio Controller HDMI / DisplayPort 2 Output" },
    },
  },
  apply_properties = {
    ["node.description"] = "HDMI 2",
    ["node.disabled"] = true,
  },
}
table.insert(alsa_monitor.rules, rule)

rule = {
  matches = {
    {
      { "node.description", "equals", "Cannon Point-LP High Definition Audio Controller HDMI / DisplayPort 3 Output" },
    },
  },
  apply_properties = {
    ["node.description"] = "HDMI 3",
    ["node.disabled"] = true,
  },
}
table.insert(alsa_monitor.rules, rule)
