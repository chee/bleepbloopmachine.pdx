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

local pages = {{
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
},
{
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
},
{
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
},
{
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
}}

for page_index, blocks in ipairs(pages) do
    for index, block in ipairs(blocks) do
        block.position = index
        block.synth:setWaveform(page_index)
    end
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

local selected_page = 1
local selected_block = 1
local clipboard = Block()

blockWidth = 32
space = 8

-- HMM maybe we update a variable selectedBlock in the loop and callbacks (rename selected_block to selectedBlockIndex)
function getSelectedBlock()
    return pages[selected_page][selected_block]
end

function playdate.upButtonDown()
    if playdate.buttonIsPressed("a") and playdate.buttonIsPressed("b") then
    elseif playdate.buttonIsPressed("a") then
        getSelectedBlock():activate()
        getSelectedBlock():incOctave()
    elseif playdate.buttonIsPressed("b") then
    else
        selected_block = selected_block - 4
    end
    if selected_block < 1 then
        selected_block = 1
    end
end

function playdate.downButtonDown()
    if playdate.buttonIsPressed("a") and playdate.buttonIsPressed("b") then
    elseif playdate.buttonIsPressed("a") then
        getSelectedBlock():activate()
        getSelectedBlock():decOctave()
    elseif playdate.buttonIsPressed("b") then

    else
        selected_block = selected_block + 4
    end
    if selected_block > 16 then
        selected_block = 16
    end
end

function playdate.leftButtonDown()
    if playdate.buttonIsPressed("a") and playdate.buttonIsPressed("b") then
        if selected_page > 1 then
            selected_page -= 1
        end
    elseif playdate.buttonIsPressed("a") then
        getSelectedBlock():activate()
        getSelectedBlock():decNote()
    elseif playdate.buttonIsPressed("b") then
        clipboard = getSelectedBlock()
        getSelectedBlock():deactivate()
    else
        selected_block = selected_block - 1
    end
    if selected_block < 1 then
        selected_block = 1
    end
end

function playdate.rightButtonDown()
    if playdate.buttonIsPressed("a") and playdate.buttonIsPressed("b") then
        if selected_page < 4 then
            selected_page += 1
        end
    elseif playdate.buttonIsPressed("a") then
        getSelectedBlock():activate()
        getSelectedBlock():incNote()
    elseif playdate.buttonIsPressed("b") then
        clipboard:paste(getSelectedBlock())
        getSelectedBlock().synth:setWaveform(selected_page)
    else
        selected_block = selected_block + 1
    end
    if selected_block > 16 then
        selected_block = 16
    end
end 

-- this is called every frame
function playdate.update()
    gfx.clear()
    gfx.drawText(tostring(selected_page), 0, 0)
    for page_index, blocks in ipairs(pages) do
        for index, block in ipairs(blocks) do
            local w = (index - 1) % 4
            local h = math.ceil((index) / 4)
            local left = (w * blockWidth + space * w) + 120
            local top = h * blockWidth + space * h
            gfx.drawRect(left, top, blockWidth, blockWidth)
            if selected_block == index then
                gfx.drawRect(left - 1, top - 1, blockWidth + 2, blockWidth + 2)
            end
            if block.active and page_index == selected_page then
                gfx.drawText(block:notestring(), left, top + 8)
            end
            if beat == index then
                gfx.fillCircleAtPoint(left + 4, top + 4, 4)
                block:play()
            end
        end
    end
    playdate.timer.updateTimers()
end
