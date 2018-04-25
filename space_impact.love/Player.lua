player = {}
player.x = 400
player.y = 450
player.w = 80
player.h = 20
player.bullets = {}
player.cooldown = 10
player.fire = function()
  if player.cooldown <= 0 then
    player.cooldown = 10
    load_bullet()
  end
end
player.render = function()
  love.graphics.draw(player_img, player.x, player.y,  0, 0.4, 0.4)
end
function player:reset()
  player.x = 400
  player.y = 450
  player.bullets = {}
  player.cooldown = 10
end