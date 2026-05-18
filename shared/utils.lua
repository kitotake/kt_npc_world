-- shared/utils.lua

function Clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

function Lerp(a, b, t)
    return a + (b - a) * Clamp(t, 0.0, 1.0)
end

function IsInRange(coordsA, coordsB, radius)
    return #(coordsA - coordsB) < radius
end

function RandomChoice(tbl)
    if not tbl or #tbl == 0 then return nil end
    return tbl[math.random(#tbl)]
end

function TableCount(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

function MergeTable(dst, src)
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end

function IsNPCAlive(npc)
    return npc and DoesEntityExist(npc.ped)
        and not IsEntityDead(npc.ped)
end

function VecStr(v)
    return string.format("(%.1f, %.1f, %.1f)", v.x, v.y, v.z)
end