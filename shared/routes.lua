-- Predefined patrol routes for NPCs with a job = "patrol"
-- Each route is a list of waypoints the NPC will walk through in order

PatrolRoutes = {
    downtown_loop = {
        label = "Downtown loop",
        loop  = true,
        waypoints = {
            vector3(-270.0, -970.0, 31.2),
            vector3(-220.0, -960.0, 31.2),
            vector3(-200.0, -1000.0, 29.8),
            vector3(-250.0, -1030.0, 29.5),
            vector3(-280.0, -1010.0, 29.7),
        },
    },
    grove_patrol = {
        label = "Grove Street patrol",
        loop  = true,
        waypoints = {
            vector3(82.0, -1950.0, 21.0),
            vector3(100.0, -1930.0, 21.0),
            vector3(115.0, -1960.0, 21.0),
            vector3(90.0, -1980.0, 21.0),
        },
    },
    airport_security = {
        label = "Airport perimeter",
        loop  = true,
        waypoints = {
            vector3(-1060.0, -2710.0, 20.0),
            vector3(-1000.0, -2700.0, 20.0),
            vector3(-980.0,  -2750.0, 20.0),
            vector3(-1040.0, -2760.0, 20.0),
        },
    },
}

-- Returns a route table by id, or nil
function GetRoute(routeId)
    return PatrolRoutes[routeId]
end

-- Returns the next waypoint index for a route (loops if loop=true)
function NextWaypointIndex(route, currentIndex)
    local next = currentIndex + 1
    if next > #route.waypoints then
        if route.loop then
            return 1
        else
            return nil
        end
    end
    return next
end
