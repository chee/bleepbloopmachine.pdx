class('Block').extends(Object)

Block.BLOCK_TYPE_NOTE = 0

local snd <const> = playdate.sound

local notes <const> = {"A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"}

function Block:init()	
	self.synth = snd.synth.new()
	self.synth:setWaveform(0)
	self.attack = 0.05
	self.sustain = 0.1
	self.decay = 0.0
	self.release = 0.5

	self.note = "A"
	self.octave = 3
end

function Block:incAttack()
end

function Block:setADSR()
	self.synth:setADSR(self.attack, self.sustain, self.decay, self.release)
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
	return self.note..tostring(self.octave)
end

function Block:play()
	if self.active then
		self.synth:playMIDINote(self:notestring())
	end
end