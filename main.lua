local Image = love.graphics.newImage("image.png")

love.window.setMode(1920, 1080)

local AreaTexture = love.graphics.newImage("AreaTexDX10.png")
local SearchTexture = love.graphics.newImage("SearchTex.png")

local EdgeShader = love.graphics.newShader("edge.c")
local BlendShader = love.graphics.newShader("blend.c")
local NeighborhoodShader = love.graphics.newShader("neigh.c")

local width, height = love.graphics.getDimensions()
local EdgeCanvas = love.graphics.newCanvas(width, height, "srgb")
local BlendCanvas = love.graphics.newCanvas(width, height, "srgb")
function love.draw()
	love.graphics.setBlendMode("replace", false)
	
	if love.keyboard.isDown("b") then
		love.graphics.setShader(EdgeShader)
		love.graphics.setCanvas(EdgeCanvas)
		
		love.graphics.draw(Image)
		
		--love.graphics.setShader()
		--love.graphics.setCanvas()
		--love.graphics.draw(EdgeCanvas)
		
		love.graphics.setShader(BlendShader)
		BlendShader:send("edge_tex", EdgeCanvas)
		BlendShader:send("area_tex", AreaTexture)
		BlendShader:send("search_tex", SearchTexture)
		
		love.graphics.setCanvas(BlendCanvas)
		love.graphics.draw(Image)
		
		love.graphics.setShader(NeighborhoodShader)
		love.graphics.setCanvas()
		NeighborhoodShader:send("blend_tex", BlendCanvas)
		love.graphics.draw(Image)
		love.graphics.setShader()
		
		
		if love.keyboard.isDown("q") or love.keyboard.isDown("w") then
			love.graphics.setShader()
			love.graphics.setCanvas()
			if love.keyboard.isDown("q") then
				love.graphics.draw(EdgeCanvas)
			end
			if love.keyboard.isDown("w") then
				love.graphics.draw(BlendCanvas)
			end
		end
		
	else
		love.graphics.setShader()
		love.graphics.setCanvas()
		love.graphics.draw(Image)
	end
end