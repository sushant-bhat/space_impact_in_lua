EnemyFactory = {}

function EnemyFactory:newEnemy(x,y)
  local enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.w = 80
  enemy.h = 20
  return enemy
end