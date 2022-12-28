Config = Config or {}

Config.Command = {
    Name = "claim",
    Description = "start the claiming minigame"
}

Config.Ped = {
    Model = "u_m_m_jesus_01", -- Ped model  https://wiki.rage.mp/index.php?title=Peds
    Hash = 0xCE2CB751 -- Hash numbers for ped model
} -- Hash numbers for ped model

Config.Zones = {
    Debug = true,
    Coords = {
        vec3(733.99, 1283.96, 360.3),
        vec3(731.1, 1299.64, 360.3)
    },
    Radius = {
        BigCircle = 25.0,
        SmallCircle = 1.5
    }
}

Config.Blips = {
    Blip = {
        Name = "Claim",
        Sprite = 437,
        Scale = 0.9,
        Color = 0
    },
    Radius = {
        Alpha = 100,
        Color = 1
    }
}

Config.Notify = {
    Win = {
        Event = 'QBCore:Notify',
        Text = "You claimed the Land.",
        Type = 'success',
        Time = 500
    },
    Error = {
        Event = 'QBCore:Notify',
        Text = "a Zone already exists.",
        Type = 'error',
        Time = 500
    }
}

Config.FloatingMessage = {
    Show = true,
    Label = "This is a funny test message!"
    --Label = '~g~Press  ~INPUT_CONTEXT~~g~to claim the Land!'
}
