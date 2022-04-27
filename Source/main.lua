import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "block"

local ceil = math.ceil
local gfx <const> = playdate.graphics
local snd <const> = playdate.sound
gfx.setColor(gfx.kColorBlack)

local UP <const> = 0
local DOWN <const> = 1
local LEFT <const> = 2
local RIGHT <const> = 3

local blocks = {
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
    Block(),
}

for index, block in ipairs(blocks) do
    block.position = index
end

local beat = 0
-- 120bpm, the only bpm the body needs
timer = playdate.timer.new(125, function()
    beat += 1
    if beat > 16 then
        beat = 1
    end
end)
timer.repeats = true

local selected = 1

blockWidth = 32
space = 8

function playdate.upButtonDown()
    if playdate.buttonIsPressed("a") and playdate.buttonIsPressed("b") then
    elseif playdate.buttonIsPressed("a") then
        blocks[selected]:activate()
        blocks[selected]:incNote()
    elseif playdate.buttonIsPressed("b") then
        
    else
        selected = selected - 4
    end
    if selected < 1 then
        selected = 1
    end
end

function playdate.downButtonDown()
    if playdate.buttonIsPressed("a") and playdate.buttonIsPressed("b") then
    elseif playdate.buttonIsPressed("a") then
        blocks[selected]:activate()
        blocks[selected]:decNote()
    elseif playdate.buttonIsPressed("b") then

    else
        selected = selected + 4
    end
    if selected > 16 then
        selected = 16
    end
end

function playdate.leftButtonDown()
    if playdate.buttonIsPressed("a") and playdate.buttonIsPressed("b") then
        blocks[selected]:deactivate()
    elseif playdate.buttonIsPressed("a") then
        blocks[selected]:activate()
        blocks[selected]:decOctave()
    elseif playdate.buttonIsPressed("b") then
    else
        selected = selected - 1
    end
    if selected < 1 then
        selected = 1
    end
end

function playdate.rightButtonDown()
    if playdate.buttonIsPressed("a") and playdate.buttonIsPressed("b") then
    elseif playdate.buttonIsPressed("a") then
        blocks[selected]:activate()
        blocks[selected]:incOctave()
    elseif playdate.buttonIsPressed("b") then
    else
        selected = selected + 1
    end
    if selected > 16 then
        selected = 16
    end
end 

-- this is called every frame
function playdate.update()
    gfx.clear()
    for index, block in ipairs(blocks) do
        local w = (index - 1) % 4
        local h = math.ceil((index) / 4)
        local left = (w * blockWidth + space * w) + 120
        local top = h * blockWidth + space * h
        gfx.drawRect(left, top, blockWidth, blockWidth)
        if selected == index then
            gfx.drawRect(left - 1, top - 1, blockWidth + 2, blockWidth + 2)
        end
        if block.active then
            gfx.drawText(block:notestring(), left, top + 8)
        end
        if beat == index then
            gfx.fillCircleAtPoint(left + 4, top + 4, 4)
            block:play()
        end
    end
    playdate.timer.updateTimers()
end
