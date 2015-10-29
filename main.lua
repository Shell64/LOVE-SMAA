local Image = love.graphics.newImage("image.png", {linear = true})

love.window.setMode(1280, 720)

local AreaTexture = love.graphics.newImage("AreaTexDX10.png", {mipmaps = false, linear = true})
local SearchTexture = love.graphics.newImage("SearchTex.png", {mipmaps = false, linear = true})
SearchTexture:setFilter("nearest", "nearest", 0)

local EdgeShader = love.graphics.newShader("edge.c")
local BlendShader = love.graphics.newShader("blend.c")
local NeighborhoodShader = love.graphics.newShader("neigh.c")

local width, height = love.graphics.getDimensions()
local EdgeCanvas = love.graphics.newCanvas(width, height, "rg8")
local BlendCanvas = love.graphics.newCanvas(width, height, "rgba8")
local WholeRender = love.graphics.newCanvas(width, height, "rgba8")

function love.draw()
	love.graphics.setBlendMode("replace", false)
	
	if love.keyboard.isDown("b") then
		love.graphics.setCanvas(WholeRender)
		love.graphics.clear(0, 0, 0, 0)
		love.graphics.draw(Image)
		
		love.graphics.setShader(EdgeShader)
		love.graphics.setCanvas(EdgeCanvas)
		love.graphics.clear(0, 0, 0, 0)
		love.graphics.draw(WholeRender)
		
		--love.graphics.setShader()
		--love.graphics.setCanvas()
		--love.graphics.draw(EdgeCanvas)
		
		love.graphics.setShader(BlendShader)
		BlendShader:send("area_tex", AreaTexture)
		BlendShader:send("search_tex", SearchTexture)
		
		love.graphics.setCanvas(BlendCanvas)
		love.graphics.clear(0, 0, 0, 0)
		love.graphics.draw(EdgeCanvas)
		
		love.graphics.setShader(NeighborhoodShader)
		love.graphics.setCanvas()
		NeighborhoodShader:send("blend_tex", BlendCanvas)
		love.graphics.draw(WholeRender)
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
	
	love.graphics.setBlendMode("alpha", true)
	love.graphics.print("Press B for activating SMAA (Neighborhood pass).\nPress B + Q for drawing edge pass\nPress B + W for drawing blend pass")
end