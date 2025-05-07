local map = {
  "########",
  "#......#",
  "#......#",
  "#......#",
  "#......#",
  "########"
}

local mapWidth = #map[1]
local mapHeight = #map

local playerX, playerY = 2.0, 2.0
local playerAngle = 0.0

local fov = math.pi / 4 -- 90 градусов
local depth = 8.0
local screenWidth = 60
local screenHeight = 20

-- Получить символ карты
local function getMap(x, y)
  if x < 1 or x > mapWidth or y < 1 or y > mapHeight then
    return "#"
  end
  return map[math.floor(y)]:sub(math.floor(x), math.floor(x))
end

-- Рисуем экран
while true do
  local output = {}

  for x = 0, screenWidth - 1 do
    local rayAngle = (playerAngle - fov / 2.0) + (x / screenWidth) * fov

    local eyeX = math.sin(rayAngle)
    local eyeY = math.cos(rayAngle)

    local distanceToWall = 0.0
    local hitWall = false

    while not hitWall and distanceToWall < depth do
      distanceToWall = distanceToWall + 0.1
      local testX = math.floor(playerX + eyeX * distanceToWall)
      local testY = math.floor(playerY + eyeY * distanceToWall)

      if getMap(testX + 1, testY + 1) == "#" then
        hitWall = true
      end
    end

    local ceiling = (screenHeight / 2.0) - screenHeight / distanceToWall
    local floor = screenHeight - ceiling

    for y = 0, screenHeight - 1 do
      if y < ceiling then
        output[#output+1] = " "
      elseif y >= ceiling and y <= floor then
        output[#output+1] = "#"
      else
        output[#output+1] = "."
      end

      if (x + 1) % screenWidth == 0 then
        output[#output+1] = "\n"
      end
    end
  end

  os.execute("clear") -- или "cls" для Windows
  io.write(table.concat(output))

  -- Управление: поворот
  io.write("\nA/D = поворот, W/S = движение: ")
  local input = io.read()
  if input == "a" then playerAngle = playerAngle - 0.1 end
  if input == "d" then playerAngle = playerAngle + 0.1 end
  if input == "w" then
    playerX = playerX + math.sin(playerAngle) * 0.5
    playerY = playerY + math.cos(playerAngle) * 0.5
  end
  if input == "s" then
    playerX = playerX - math.sin(playerAngle) * 0.5
    playerY = playerY - math.cos(playerAngle) * 0.5
  end
end
