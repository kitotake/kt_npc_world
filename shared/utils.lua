-- Shared utility functions

-- Clamps a value between min and max
function Clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

-- Linear interpolation between a and b by factor t (0..1)
function Lerp(a, b, t)
    return a + (b - a) * Clamp(t, 0.0, 1.0)
end

-- Returns true if dist between two vector3 is less than radius
function IsInRange(coordsA, coordsB, radius)
    return #(coordsA - coordsB) < radius
end

-- Returns a random element from a table
function RandomChoice(tbl)
    if not tbl or #tbl == 0 then return nil end
    return tbl[math.random(#tbl)]
end

-- Safe table count (works with non-sequential keys)
function TableCount(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

-- Shallow-merges src into dst (in place)
function MergeTable(dst, src)
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end

-- Returns true if entity exists and is not dead
function IsNPCAlive(npc)
    return npc and DoesEntityExist(npc.ped)
        and not IsEntityDead(npc.ped)
end

-- Formats a vector3 to a readable string
function VecStr(v)
    return string.format("(%.1f, %.1f, %.1f)", v.x, v.y, v.z)
end
