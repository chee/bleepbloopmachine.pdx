import "CoreLibs/object"
class('Block').extends(Object)

Block.BLOCK_TYPE_NOTE = 0

local snd <const> = playdate.sound

local notes <const> = { "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#" }

function Block:init()
	self.synth = snd.synth.new()
	self.synth:setWaveform(0)
	self.attack = 0.1
	self.release = 0.5
	self:updateEnvelope()
	self.note = "A"
	self.octave = 3
end

function Block:paste(them)
	--[[ TODO the page should actually share the synth!
	 	Synths are poly, so there is no need for each block to own one
		Except for drum, which should maybe just be its own thing
		With the same interface for the update loop ]]
	--[[ NEVERMIND actually nope i'm wrong. because the synths have
		a single amp envelope and i want each block to have its own ]]
	them.synth = self.synth:copy()
	them.attack = self.attack
	them.decay = self.decay
	them.sustain = self.sustain
	them.release = self.release
	them.note = self.note
	them.octave = self.octave
	them.active = true
end

function Block:copy()
	local them = Block()
	self:paste(them)
	return them
end

function Block:incAttack()
end

-- we're just doing AR
function Block:updateEnvelope()
	if self.attack < 0 then
		self.attack = 0.001
	end
	if self.release < 0 then
		self.release = 0.001
	end

	if self.attack > 2 then
		self.attack = 2
	end
	if self.release > 2 then
		self.release = 2
	end
	self.synth:setADSR(self.attack, self.release, 0, self.release)
end

function Block:activate()
	self.active = true
end

function Block:deactivate()
	self.active = false
end

function Block:incNote()
	local currentIndex = table.indexOfElement(notes, self.note)
	if self.note == "G#" then
		self:incOctave()
		self.note = "A"
	else
		self.note = notes[currentIndex + 1]
	end
end

function Block:decNote()
	local currentIndex = table.indexOfElement(notes, self.note)
	if self.note == "A" then
		self:decOctave()
		self.note = "G#"
	else
		self.note = notes[currentIndex - 1]
	end
end

function Block:incOctave()
	if self.octave < 8 then
		self.octave = self.octave + 1
	end
end

function Block:decOctave()
	if self.octave > 1 then
		self.octave = self.octave - 1
	end
end

function Block:notestring()
	return self.note .. tostring(self.octave)
end

function Block:play()
	if self.active then
		self.synth:playMIDINote(self:notestring())
	end
end
