class Tower extends GameObject
{
  float range;
  int ellapsed;
  GameObject creep;

  Tower()
  {
    super(width * 0.5f, height  * 0.5f, 50);
  }

  Tower(float x, float y, float radius, float range )
  {
    pos.x = x;
    pos.y = y;
    this.radius = radius;
    this.range = range;
    ellapsed = 30;
    c = #A403FC;
  }

  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    fill(c);
    stroke(c);
    //line(- radius, radius, 0, - radius);
    //line(0, - radius, radius, radius);
    //line(radius, radius, 0, 0);
    //line(- radius, radius, 0, 0);
    arc(0, 0, radius*2, radius*2, - QUARTER_PI, PI+QUARTER_PI);
    //ellipse(0, -radius, radius, radius/6);
    noFill();
    rect(-radius/6, - radius*1.2, radius/3, radius*2);

    if (mouseX > pos.x-radius && mouseX < pos.x+radius && mouseY> pos.y-radius && mouseY < pos.y+radius)
    {
      ellipse(0, 0, range, range);
    }
    popMatrix();
  }

  GameObject searchForCreep()
  {
    GameObject creep = null;
    float minDist = Float.MAX_VALUE;
    for (int i = gameObjects.size() - 1; i >= 0; i --)
    {
      GameObject go = gameObjects.get(i);
      if (go instanceof Creep)
      {

        float dist = PVector.dist(go.pos, pos);
        if (dist < range/2 && dist < minDist)
        {
          creep = go;
          minDist = dist;
        }
      }
    }
    return creep;
  }

  void update()
  {
    int proLife = 1;
    int proDamage = 1;
    if (creep == null)
    {
      creep = searchForCreep();
    } else
    {
      PVector toCreep = PVector.sub(pos, creep.pos);
      float dist = PVector.dist(creep.pos, pos);
      theta = atan2(toCreep.y, toCreep.x) - HALF_PI;
      forward.x = sin(theta);
      forward.y = -cos(theta);

      if (ellapsed > 50)
      {
        Projectile pro = new Projectile(pos.x, pos.y, proLife, proDamage, range, c);

        pro.pos.add(PVector.mult(forward, 15.0f));
        pro.forward = forward;
        pro.theta = theta;
        gameObjects.add(pro);
        ellapsed = 0;
      }

      if (dist < range || ((Creep)creep).life <=0)
      {
        creep = null;
      }
    }
    ellapsed++;
  }
}