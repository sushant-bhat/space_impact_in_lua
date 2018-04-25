require 'Player'
require 'Bullet'
require 'Enemy'

PLAYER_SPEED = 300
GAME_OVER = false

function load_bullet()
  bullet = BulletFactory:newBullet()
  bullet.x = player.x + 58
  bullet.y = player.y
  table.insert(player.bullets, bullet)
  love.audio.play(bullet_sound)
end

function spawn_enemy(x,y)
  enemy = EnemyFactory:newEnemy(x,y)
  table.insert(enemy_set, enemy)
end


function check_collisions()
  for i,e in ipairs(enemy_set) do
    if e.y >= player.y then
      GAME_OVER = true
      love.audio.play(love.audio.newSource('sound/gameover.wav','static'))
      return
    end
    for j,b in pairs(player.bullets) do
      if b.y <= e.y + e.h and b.x >= e.x and b.x <= e.x + e.w then
        table.remove(enemy_set, i)
        table.remove(player.bullets,j)
        love.audio.play(explosion_sound)
        game_score = game_score + 1
      end
    end
  end
end

function loadRes()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  back_img = love.graphics.newImage('images/back.jpg')
  player_img = love.graphics.newImage('images/player.png')
  enemy_img = love.graphics.newImage('images/enemy.png')
  bullet_sound = love.audio.newSource('sound/shoot.wav', 'static')
  explosion_sound = love.audio.newSource('sound/explosion.wav','static')
end

function love.load()
  love.window.setTitle('Space Wars')
  love.window.setIcon(love.image.newImageData('images/player.png'))
  loadRes()
  math.randomseed(os.time())
  enemy_set = {}
  respawn = 1
  game_score = 0
  GAME_OVER = false
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
  if key == 's' then
    GAME_OVER = false
    game_score = 0
    respawn = 1
  end
  
end

function love.update(dt)
  if not GAME_OVER then
    player.cooldown = player.cooldown - 1
    respawn = respawn - 1
    if respawn == 0 then
      respawn = 30
      spawn_enemy(math.random(680), 0)
    end
    for _,v in pairs(enemy_set) do
      v.y = v.y + 3
    end
    if love.keyboard.isDown("left") then
      player.x = math.max(0, player.x - PLAYER_SPEED*dt)
    elseif love.keyboard.isDown("right") then
      player.x = math.min(680, player.x + PLAYER_SPEED*dt)
    end

    if love.keyboard.isDown("space") then
      player.fire()
    end
    
    check_collisions()
    for i,b in ipairs(player.bullets) do
      if b.y < -10 then
        table.remove(player.bullets, i)
      end
      b.y = b.y - 5
    end
  end
end

function love.draw()
  love.graphics.draw(back_img, 0, 0)
  love.graphics.print("Score: " .. tostring(game_score), 10, 10)
  if GAME_OVER then
    love.graphics.print('Game Over!\nPress \'s\' to start again', 350, 300)
    enemy_set = {}
    player.reset()
  else
    love.graphics.setColor(255,255,255)
    player:render()
    
    for _, v in pairs(enemy_set) do
      love.graphics.draw(enemy_img, v.x, v.y, 0, 0.3, 0.3)
    end
    
    for _,v in pairs(player.bullets) do
      love.graphics.rectangle("fill", v.x, v.y, v.w,v.h)
    end
  end
  
end
